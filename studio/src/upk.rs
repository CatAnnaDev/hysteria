use crate::lzo::lzo1x_decompress;
use std::io::{Read, Seek, SeekFrom, Write};

fn ri(b: &[u8], o: usize) -> i32 { i32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) }
fn ru(b: &[u8], o: usize) -> u32 { u32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) }
fn rf(b: &[u8], o: usize) -> f32 { f32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) }

fn decode_struct(sn: &str, d: &[u8]) -> Option<String> {
    let f = |i: usize| if i + 4 <= d.len() { rf(d, i) } else { 0.0 };
    let n = |i: usize| if i + 4 <= d.len() { ri(d, i) } else { 0 };
    Some(match sn {
        "Vector" if d.len() >= 12 => format!("({:.2}, {:.2}, {:.2})", f(0), f(4), f(8)),
        "Vector2D" if d.len() >= 8 => format!("({:.2}, {:.2})", f(0), f(4)),
        "Vector4" | "Quat" | "Plane" if d.len() >= 16 => format!("({:.2}, {:.2}, {:.2}, {:.2})", f(0), f(4), f(8), f(12)),
        "Rotator" if d.len() >= 12 => format!("(Pitch {}, Yaw {}, Roll {})", n(0), n(4), n(8)),
        "Color" if d.len() >= 4 => format!("BGRA({}, {}, {}, {})", d[0], d[1], d[2], d[3]),
        "LinearColor" if d.len() >= 16 => format!("RGBA({:.3}, {:.3}, {:.3}, {:.3})", f(0), f(4), f(8), f(12)),
        "Guid" if d.len() >= 16 => format!("{:08X}-{:08X}-{:08X}-{:08X}", ru(d, 0), ru(d, 4), ru(d, 8), ru(d, 12)),
        "IntPoint" if d.len() >= 8 => format!("({}, {})", n(0), n(4)),
        "Box" if d.len() >= 24 => format!("min({:.1}, {:.1}, {:.1}) max({:.1}, {:.1}, {:.1})", f(0), f(4), f(8), f(12), f(16), f(20)),
        "Vector_NetQuantize" if d.len() >= 12 => format!("({:.2}, {:.2}, {:.2})", f(0), f(4), f(8)),
        _ => return None,
    })
}

pub struct Texture { pub w: usize, pub h: usize, pub rgba: Vec<u8>, pub format: String }

pub struct PropEdit { pub name: String, pub typ: String, pub kind: u8, pub off: usize, pub value: String }

fn read_tfc_mip(tfc: &std::path::Path, off: i64, sod: usize, elem: usize) -> Option<Vec<u8>> {
    let mut f = std::fs::File::open(tfc).ok()?;
    let flen = f.metadata().ok()?.len() as i64;
    let win_start = (off - 0x20000).max(0);
    let win_len = (((off - win_start) as usize) + sod + 64).min((flen - win_start) as usize);
    f.seek(SeekFrom::Start(win_start as u64)).ok()?;
    let mut win = vec![0u8; win_len];
    f.read_exact(&mut win).ok()?;
    let target = (off - win_start) as usize;
    let mut hdr = None;
    let mut i = 0usize;
    while i + 16 <= win.len() {
        if win[i] == 0xC1 && win[i+1] == 0x83 && win[i+2] == 0x2a && win[i+3] == 0x9e {
            let ut = ru(&win, i + 12) as usize;
            if ut == elem && i <= target { hdr = Some(i); }
        }
        i += 1;
    }
    if std::env::var("MIPDBG").is_ok() {
        let sigs: Vec<(usize, u32)> = (0..win.len().saturating_sub(16)).filter(|&i| win[i]==0xC1&&win[i+1]==0x83&&win[i+2]==0x2a&&win[i+3]==0x9e).map(|i| (i, ru(&win, i+12))).collect();
        eprintln!("TFCDBG off={} target={} elem={} winlen={} sigs_found={} first10={:?} hdr={:?}", off, target, elem, win.len(), sigs.len(), &sigs[..sigs.len().min(10)], hdr);
    }
    let hdr = hdr?;
    let bs = ru(&win, hdr + 4) as usize;
    let tu = ru(&win, hdr + 12) as usize;
    if bs == 0 { return None; }
    let nblk = (tu + bs - 1) / bs;
    let mut p = hdr + 16;
    let mut binfo = Vec::with_capacity(nblk);
    for k in 0..nblk { binfo.push((ru(&win, p + k * 8) as usize, ru(&win, p + k * 8 + 4) as usize)); }
    p += nblk * 8;
    let mut out = Vec::with_capacity(tu);
    for (cs, us) in binfo {
        if p + cs > win.len() { break; }
        if cs == us { out.extend_from_slice(&win[p..p + cs]); }
        else { out.extend(lzo1x_decompress(&win[p..p + cs])); }
        p += cs;
    }
    Some(out)
}

struct Cur<'a> { b: &'a [u8], o: usize }
impl<'a> Cur<'a> {
    fn i(&mut self) -> i32 { let v = ri(self.b, self.o); self.o += 4; v }
    fn u(&mut self) -> u32 { let v = ru(self.b, self.o); self.o += 4; v }
    fn s(&mut self) -> String {
        let n = self.i();
        if n <= 0 { return String::new(); }
        let n = n as usize;
        let s = String::from_utf8_lossy(&self.b[self.o..self.o + n]).trim_end_matches('\0').to_string();
        self.o += n; s
    }
    fn skip(&mut self, n: usize) { self.o += n; }
}

pub struct Export {
    pub class_name: String,
    pub name: String,
    pub size: i32,
    pub off: i32,
    pub size_off: usize,
}

pub struct Pkg {
    pub buf: Vec<u8>,
    pub ver: u16,
    pub names: Vec<String>,
    pub imports: Vec<String>,
    pub exports: Vec<Export>,
    pub cflags_off: usize,
    pub name_off: usize,
    pub compressed: bool,
    pub summary_tail: Vec<u8>,
}

fn decompress(raw: &[u8]) -> Result<Vec<u8>, String> {
    if raw.len() < 32 || ru(raw, 0) != 0x9E2A83C1 { return Err("not a UE3 package".into()); }
    let mut c = Cur { b: raw, o: 0 };
    c.u(); c.u(); c.i(); c.s(); c.u();
    for _ in 0..7 { c.i(); }
    for _ in 0..4 { c.i(); }
    c.skip(16);
    let g = c.i();
    c.skip(g as usize * 12);
    c.i(); c.i();
    let cflags = c.u();
    let nch = c.i();
    if cflags == 0 || nch <= 0 { return Ok(raw.to_vec()); }
    let mut chunks = Vec::new();
    for _ in 0..nch {
        chunks.push((c.i() as usize, c.i() as usize, c.i() as usize, c.i() as usize));
    }
    let total = chunks.iter().map(|x| x.0 + x.1).max().unwrap_or(0);
    let mut buf = vec![0u8; total];
    let first = chunks[0].0;
    buf[0..first].copy_from_slice(&raw[0..first]);
    for (uoff, _usz, coff, _csz) in chunks {
        let bs = ru(raw, coff + 4) as usize;
        let tu = ru(raw, coff + 12) as usize;
        let nblk = (tu + bs - 1) / bs;
        let mut p = coff + 16;
        let mut binfo = Vec::with_capacity(nblk);
        for i in 0..nblk { binfo.push((ru(raw, p + i * 8) as usize, ru(raw, p + i * 8 + 4) as usize)); }
        p += nblk * 8;
        let mut pos = uoff;
        for (cs2, us2) in binfo {
            if cs2 == us2 {
                buf[pos..pos + us2].copy_from_slice(&raw[p..p + cs2]);
            } else {
                let dec = lzo1x_decompress(&raw[p..p + cs2]);
                buf[pos..pos + dec.len()].copy_from_slice(&dec);
            }
            p += cs2;
            pos += us2;
        }
    }
    Ok(buf)
}

impl Pkg {
    fn fname_at(&self, o: usize) -> String {
        let idx = ri(&self.buf, o); let num = ri(&self.buf, o + 4);
        let base = self.names.get(idx as usize).cloned().unwrap_or_else(|| format!("?{}", idx));
        if num > 0 { format!("{}_{}", base, num - 1) } else { base }
    }
    fn idx_name(&self, i: i32) -> String {
        if i == 0 { "None".into() }
        else if i < 0 { self.imports.get((-i - 1) as usize).cloned().unwrap_or_else(|| "?imp".into()) }
        else { self.exports.get((i - 1) as usize).map(|e| e.name.clone()).unwrap_or_else(|| "?exp".into()) }
    }
    pub fn read_props(&self, start: i32) -> Vec<(String, String, String)> {
        self.parse_props(start).0
    }

    pub fn prop_value(&self, start: i32, key: &str) -> Option<String> {
        self.read_props(start).into_iter().find(|(n, _, _)| n == key).map(|x| x.2)
    }

    pub fn serial(&self, e: &Export) -> &[u8] {
        let s = e.off as usize; let end = (e.off + e.size) as usize;
        if end <= self.buf.len() { &self.buf[s..end] } else { &[] }
    }

    pub fn props_editable(&self, start: i32) -> Vec<PropEdit> {
        let b = &self.buf; let mut o = start as usize + 4; let mut out = Vec::new();
        while o + 16 <= b.len() {
            let name = self.fname_at(o); o += 8;
            if name == "None" || name.starts_with('?') { break; }
            let typ = self.fname_at(o); o += 8;
            let size = ri(b, o) as usize; o += 8;
            if o > b.len() { break; }
            let (kind, voff, value): (u8, usize, String) = match typ.as_str() {
                "IntProperty" => { let v = ri(b, o); let vo = o; o += 4; (1, vo, v.to_string()) }
                "FloatProperty" => { let v = f32::from_le_bytes([b[o],b[o+1],b[o+2],b[o+3]]); let vo = o; o += 4; (2, vo, format!("{}", v)) }
                "BoolProperty" => { let v = b[o] != 0; let vo = o; o += 1; (3, vo, format!("{}", v)) }
                "ByteProperty" => { let _e = self.fname_at(o); o += 8;
                    if size == 8 { let v = self.fname_at(o); o += 8; (0, 0, v) } else { let v = b[o].to_string(); let vo = o; o += size; (4, vo, v) } }
                "NameProperty" => { let v = self.fname_at(o); o += 8; (0, 0, v) }
                "StrProperty" => { let n = ri(b, o).max(0) as usize; o += 4; let s = String::from_utf8_lossy(&b[o..(o+n).min(b.len())]).trim_end_matches('\0').to_string(); o += n; (0, 0, s) }
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" => { let v = ri(b, o); o += 4; (0, 0, self.idx_name(v)) }
                "StructProperty" => { let sn = self.fname_at(o); o += 8; let d = &b[o..(o+size).min(b.len())]; let v = decode_struct(&sn, d).unwrap_or_else(|| format!("<{} {}B>", sn, size)); o += size; (0, 0, v) }
                _ => { o += size; (0, 0, format!("<{} {}B>", typ, size)) }
            };
            out.push(PropEdit { name, typ, kind, off: voff, value });
            if out.len() > 400 || o >= b.len() { break; }
        }
        out
    }
    fn parse_props(&self, start: i32) -> (Vec<(String, String, String)>, usize) {
        let b = &self.buf; let mut o = start as usize + 4; let mut out = Vec::new();
        while o + 16 <= b.len() {
            let name = self.fname_at(o); o += 8;
            if name == "None" || name.starts_with('?') { break; }
            let typ = self.fname_at(o); o += 8;
            let size = ri(b, o) as usize; o += 8;
            if o > b.len() { break; }
            let val = match typ.as_str() {
                "IntProperty" => { let v = ri(b, o); o += 4; v.to_string() }
                "FloatProperty" => { let v = f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]); o += 4; format!("{:.3}", v) }
                "ByteProperty" => { let _en = self.fname_at(o); o += 8;
                    if size == 8 { let v = self.fname_at(o); o += 8; v } else { let v = b[o].to_string(); o += size; v } }
                "NameProperty" => { let v = self.fname_at(o); o += 8; v }
                "BoolProperty" => { let v = b[o] != 0; o += 1; format!("{}", v) }
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" => { let v = ri(b, o); o += 4; self.idx_name(v) }
                "StrProperty" => { let n = ri(b, o); o += 4; let n = n.max(0) as usize;
                    let s = String::from_utf8_lossy(&b[o..(o + n).min(b.len())]).trim_end_matches('\0').to_string(); o += n; s }
                "StructProperty" => { let sn = self.fname_at(o); o += 8; let d = &b[o..(o+size).min(b.len())]; let v = decode_struct(&sn, d).unwrap_or_else(|| format!("<{}>", sn)); o += size; v }
                _ => { o += size; format!("<{} {}B>", typ, size) }
            };
            out.push((name, typ, val));
            if out.len() > 400 || o >= b.len() { break; }
        }
        (out, o)
    }

    pub fn texture(&self, e: &Export, cooked_dir: &std::path::Path) -> Option<Texture> {
        let (props, end) = self.parse_props(e.off);
        let get = |k: &str| props.iter().find(|(n, _, _)| n == k).map(|x| x.2.clone());
        let fmt = get("Format")?;
        let sx = get("SizeX")?.parse::<usize>().ok()?;
        let sy = get("SizeY")?.parse::<usize>().ok()?;
        let tfcname = get("TextureFileCacheName");
        let b = &self.buf;
        let mut o = end;
        let sa_flags = ru(b, o); let sa_sod = ri(b, o + 8) as usize; o += 16;
        if sa_flags & 0x01 == 0 { o += sa_sod; }
        let mipcount = ri(b, o); o += 4;
        if mipcount <= 0 { return None; }
        let tfc = cooked_dir.join(format!("{}.tfc", tfcname.clone().unwrap_or_default()));
        let dbg = std::env::var("MIPDBG").is_ok();
        // mips are largest-first; the top ones can be streaming placeholders (foff=-1) — find the first real one.
        let mut chosen: Option<(Vec<u8>, usize, usize)> = None;
        for mi in 0..mipcount {
            let flags = ru(b, o); let elem = ri(b, o + 4) as usize; let sod = ri(b, o + 8); let foff = ri(b, o + 12); o += 16;
            let mut inline: Option<Vec<u8>> = None;
            if flags & 0x01 == 0 {
                let sodu = sod.max(0) as usize;
                if o + sodu <= b.len() { inline = Some(b[o..o + sodu].to_vec()); }
                o += sodu;
            }
            if o + 8 > b.len() { break; }
            let msx = ri(b, o) as usize; let msy = ri(b, o + 4) as usize; o += 8;
            if dbg { eprintln!("MIPDBG mip{} {}x{} flags={:#x} elem={} sod={} foff={}", mi, msx, msy, flags, elem, sod, foff); }
            if chosen.is_some() { continue; }
            let data: Option<Vec<u8>> = if flags & 0x01 != 0 {
                if foff < 0 || sod <= 0 { None } else { read_tfc_mip(&tfc, foff as i64, sod as usize, elem) }
            } else { inline };
            if let (Some(d), true) = (data, msx > 0 && msy > 0) { chosen = Some((d, msx, msy)); }
        }
        let (data, sx, sy) = chosen?;
        let rgba = if fmt.contains("DXT1") {
            crate::dxt::decode_bc1(&data, sx, sy)
        } else if fmt.contains("DXT3") {
            crate::dxt::decode_bc2(&data, sx, sy)
        } else if fmt.contains("DXT5") {
            crate::dxt::decode_bc3(&data, sx, sy)
        } else if fmt.contains("A8R8G8B8") {
            let mut v = vec![0u8; sx * sy * 4];
            for i in 0..(sx * sy).min(data.len() / 4) {
                v[i*4] = data[i*4+2]; v[i*4+1] = data[i*4+1]; v[i*4+2] = data[i*4]; v[i*4+3] = data[i*4+3];
            }
            v
        } else if fmt.contains("G8") {
            let mut v = vec![0u8; sx * sy * 4];
            for i in 0..(sx * sy).min(data.len()) {
                v[i*4] = data[i]; v[i*4+1] = data[i]; v[i*4+2] = data[i]; v[i*4+3] = 255;
            }
            v
        } else { return None };
        Some(Texture { w: sx, h: sy, rgba, format: fmt })
    }

    pub fn load(path: &std::path::Path) -> Result<Pkg, String> {
        let raw = std::fs::read(path).map_err(|e| e.to_string())?;
        let buf = decompress(&raw)?;
        let ver = u16::from_le_bytes([buf[4], buf[5]]);
        let (cflags_off, compressed) = {
            let mut c = Cur { b: &buf, o: 0 };
            c.u(); c.u(); c.i(); c.s(); c.u();
            for _ in 0..7 { c.i(); }
            for _ in 0..4 { c.i(); }
            c.skip(16);
            let g = c.i();
            c.skip(g as usize * 12);
            c.i(); c.i();
            let off = c.o;
            (off, ru(&buf, off) != 0)
        };
        let mut o = 0x0c;
        let flen = ri(&buf, o); o += 4;
        if flen > 0 { o += flen as usize; }
        o += 4;
        let name_count = ri(&buf, o); let name_off = ri(&buf, o + 4) as usize;
        let export_count = ri(&buf, o + 8); let export_off = ri(&buf, o + 12) as usize;
        let import_count = ri(&buf, o + 16); let import_off = ri(&buf, o + 20) as usize;

        let mut names = Vec::new();
        let mut c = Cur { b: &buf, o: name_off };
        for _ in 0..name_count { let s = c.s(); c.skip(8); names.push(s); }

        let fname = |b: &[u8], o: usize| -> String {
            let idx = ri(b, o); let num = ri(b, o + 4);
            let base = names.get(idx as usize).cloned().unwrap_or_else(|| format!("?{}", idx));
            if num > 0 { format!("{}_{}", base, num - 1) } else { base }
        };

        let mut imports = Vec::new();
        let mut o2 = import_off;
        for _ in 0..import_count {
            o2 += 8 + 8 + 4;
            imports.push(fname(&buf, o2)); o2 += 8;
        }

        let mut raw_exports = Vec::new();
        let mut o3 = export_off;
        for _ in 0..export_count {
            let ci = ri(&buf, o3); o3 += 12;
            let nm = fname(&buf, o3); o3 += 8;
            o3 += 4 + 8;
            let size_off = o3;
            let sz = ri(&buf, o3); let off = ri(&buf, o3 + 4); o3 += 8;
            o3 += 4;
            let nc = ri(&buf, o3); o3 += 4 + nc as usize * 4;
            o3 += 16 + 4;
            raw_exports.push((ci, nm, sz, off, size_off));
        }
        let class_of = |ci: i32| -> String {
            if ci == 0 { "Class".into() }
            else if ci < 0 { imports.get((-ci - 1) as usize).cloned().unwrap_or_else(|| "?imp".into()) }
            else { raw_exports.get((ci - 1) as usize).map(|e| e.1.clone()).unwrap_or_else(|| "?exp".into()) }
        };
        let exports = raw_exports.iter()
            .map(|(ci, nm, sz, off, so)| Export { class_name: class_of(*ci), name: nm.clone(), size: *sz, off: *off, size_off: *so })
            .collect();

        // For a compressed package the real uncompressed summary tail (PackageSource +
        // AdditionalPackagesToCook + ...) lives in raw right after the compressed-chunk table,
        // and must occupy the gap [cflags_off+8 .. name_off] in the uncompressed output.
        let summary_tail = if compressed {
            let gs = cflags_off + 8;
            let nch = ri(&buf, cflags_off + 4).max(0) as usize;
            let cte = gs + nch * 16;
            let tl = name_off.saturating_sub(gs);
            if tl > 0 && cte + tl <= raw.len() { raw[cte..cte + tl].to_vec() } else { vec![] }
        } else { vec![] };

        Ok(Pkg { buf, ver, names, imports, exports, cflags_off, name_off, compressed, summary_tail })
    }

    pub fn replace_texture(&mut self, e_idx: usize, rgba: &[u8], w: usize, h: usize, cooked_dir: &std::path::Path) -> Result<String, String> {
        let off = self.exports[e_idx].off;
        let (props, end) = self.parse_props(off);
        let get = |k: &str| props.iter().find(|(n, _, _)| n == k).map(|x| x.2.clone());
        let fmt = get("Format").ok_or("no Format")?;
        let tfcname = get("TextureFileCacheName").ok_or("texture has no .tfc (inline replace not supported yet)")?;
        let b = &self.buf;
        let mut o = end;
        let sa_flags = ru(b, o); let sa_sod = ri(b, o + 8) as usize; o += 16;
        if sa_flags & 0x01 == 0 { o += sa_sod; }
        let mipcount = ri(b, o); o += 4;
        if mipcount <= 0 { return Err("no mips".into()); }
        // find the first replaceable mip (skip streaming placeholders with foff=-1), matching dims
        let mut target = None;
        for _ in 0..mipcount {
            let mhdr = o;
            let flags = ru(b, o); let sod = ri(b, o + 8); let foff = ri(b, o + 12); o += 16;
            if flags & 0x01 == 0 { o += sod.max(0) as usize; }
            if o + 8 > b.len() { break; }
            let msx = ri(b, o) as usize; let msy = ri(b, o + 4) as usize; o += 8;
            if target.is_none() {
                let valid = if flags & 0x01 != 0 { foff >= 0 && sod > 0 } else { sod > 0 };
                if valid && msx > 0 && msy > 0 { target = Some((mhdr, msx, msy)); }
            }
        }
        let (mhdr, sx, sy) = target.ok_or("no replaceable mip")?;
        if w != sx || h != sy { return Err(format!("image must be {}x{} (got {}x{})", sx, sy, w, h)); }
        let dxt = if fmt.contains("DXT1") { crate::dxt::encode_bc1(rgba, w, h) }
            else { crate::dxt::encode_bc3(rgba, w, h) };
        let tfc = cooked_dir.join(format!("{}.tfc", tfcname));
        let mut f = std::fs::OpenOptions::new().read(true).append(true).open(&tfc).map_err(|e| e.to_string())?;
        let appoff = f.metadata().map_err(|e| e.to_string())?.len();
        f.write_all(&dxt).map_err(|e| e.to_string())?;
        let buf = &mut self.buf;
        buf[mhdr..mhdr + 4].copy_from_slice(&1u32.to_le_bytes());
        buf[mhdr + 4..mhdr + 8].copy_from_slice(&(dxt.len() as i32).to_le_bytes());
        buf[mhdr + 8..mhdr + 12].copy_from_slice(&(dxt.len() as i32).to_le_bytes());
        buf[mhdr + 12..mhdr + 16].copy_from_slice(&(appoff as i32).to_le_bytes());
        Ok(format!("replaced mip ({}x{} {}) -> {} bytes appended to {}.tfc @ {}", w, h, fmt, dxt.len(), tfcname, appoff))
    }

    pub fn resize_export(&mut self, idx: usize, new_serial: &[u8]) {
        let off = self.exports[idx].off as usize;
        let old = self.exports[idx].size as usize;
        let delta = new_serial.len() as i64 - old as i64;
        let mut nb = Vec::with_capacity(self.buf.len().saturating_add(new_serial.len()));
        nb.extend_from_slice(&self.buf[..off]);
        nb.extend_from_slice(new_serial);
        nb.extend_from_slice(&self.buf[off + old..]);
        let so = self.exports[idx].size_off;
        nb[so..so + 4].copy_from_slice(&(new_serial.len() as i32).to_le_bytes());
        for e in &self.exports {
            if (e.off as usize) > off {
                let f = e.size_off + 4;
                let cur = i32::from_le_bytes([nb[f], nb[f + 1], nb[f + 2], nb[f + 3]]) as i64;
                nb[f..f + 4].copy_from_slice(&((cur + delta) as i32).to_le_bytes());
            }
        }
        self.buf = nb;
        self.exports[idx].size = new_serial.len() as i32;
        for e in &mut self.exports {
            if (e.off as usize) > off { e.off = (e.off as i64 + delta) as i32; }
        }
    }

    pub fn replace_sound(&mut self, idx: usize, new_audio: &[u8]) -> Result<String, String> {
        let off = self.exports[idx].off as usize; let sz = self.exports[idx].size as usize;
        if off + sz > self.buf.len() { return Err("bad serial".into()); }
        let serial = self.buf[off..off + sz].to_vec();
        let oggpos = serial.windows(4).position(|w| w == b"OggS" || w == b"RIFF").ok_or("no embedded audio")?;
        if oggpos < 16 { return Err("unexpected sound layout".into()); }
        let mut ns = serial[..oggpos].to_vec();
        ns.extend_from_slice(new_audio);
        let nl = new_audio.len() as i32;
        ns[oggpos - 12..oggpos - 8].copy_from_slice(&nl.to_le_bytes());
        ns[oggpos - 8..oggpos - 4].copy_from_slice(&nl.to_le_bytes());
        self.resize_export(idx, &ns);
        Ok(format!("replaced audio ({} bytes); package resized", new_audio.len()))
    }

    pub fn sound_data(&self, e: &Export) -> Option<(Vec<u8>, &'static str)> {
        let s = e.off as usize; let end = (e.off + e.size) as usize;
        if end > self.buf.len() { return None; }
        let d = &self.buf[s..end];
        for i in 0..d.len().saturating_sub(4) {
            if &d[i..i + 4] == b"OggS" { return Some((d[i..].to_vec(), "ogg")); }
            if &d[i..i + 4] == b"RIFF" { return Some((d[i..].to_vec(), "wav")); }
        }
        None
    }

    pub fn to_uncompressed(&self) -> Vec<u8> {
        let mut v = self.buf.clone();
        if self.compressed && self.cflags_off + 8 <= v.len() && self.name_off <= v.len() {
            // clear PKG_StoreCompressed (0x02000000) in PackageFlags, else the engine still
            // tries to decompress the now-uncompressed body and crashes
            let mut c = Cur { b: &v, o: 0 };
            c.u(); c.u(); c.i(); c.s();
            let pf_off = c.o;
            if pf_off + 4 <= v.len() {
                let pf = ru(&v, pf_off) & !0x02000000u32;
                v[pf_off..pf_off + 4].copy_from_slice(&pf.to_le_bytes());
            }
            let gs = self.cflags_off + 8;
            for i in self.cflags_off..gs { v[i] = 0; }   // CompressionFlags = 0, NumCompressedChunks = 0
            // restore the real trailing summary into the chunk-table gap; pad with zeros if short
            for i in gs..self.name_off { v[i] = 0; }
            let n = self.summary_tail.len().min(self.name_off.saturating_sub(gs));
            v[gs..gs + n].copy_from_slice(&self.summary_tail[..n]);
        }
        v
    }
}
