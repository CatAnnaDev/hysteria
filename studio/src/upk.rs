use crate::lzo::lzo1x_decompress;
use std::io::{Read, Seek, SeekFrom, Write};

// total readers: return 0 on out-of-range instead of panicking
fn ri(b: &[u8], o: usize) -> i32 { if o + 4 <= b.len() { i32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) } else { 0 } }
fn ru(b: &[u8], o: usize) -> u32 { if o + 4 <= b.len() { u32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) } else { 0 } }
fn rf(b: &[u8], o: usize) -> f32 { if o + 4 <= b.len() { f32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) } else { 0.0 } }

// Read a UE3 FString at o: [i32 len][body]. len>0 => ANSI (len bytes incl. null),
// len<0 => UTF-16LE (2*|len| bytes). Returns (decoded, total bytes consumed incl. the
// 4-byte count). Always reports the format's declared advance so the property walker
// stays in sync even when the body is truncated.
fn read_fstring(b: &[u8], o: usize) -> (String, usize) {
    let n = ri(b, o);
    if n == 0 { return (String::new(), 4); }
    let body = (o + 4).min(b.len());
    if n < 0 {
        let bytes = ((-n) as usize).saturating_mul(2);
        let end = (o + 4 + bytes).min(b.len());
        let u: Vec<u16> = b[body..end].chunks_exact(2).map(|c| u16::from_le_bytes([c[0], c[1]])).collect();
        (String::from_utf16_lossy(&u).trim_end_matches('\0').to_string(), 4 + bytes)
    } else {
        let bytes = n as usize;
        let end = (o + 4 + bytes).min(b.len());
        (String::from_utf8_lossy(&b[body..end]).trim_end_matches('\0').to_string(), 4 + bytes)
    }
}

fn tri_edge(a: [f32; 3], b: [f32; 3]) -> f32 {
    ((a[0] - b[0]).powi(2) + (a[1] - b[1]).powi(2) + (a[2] - b[2]).powi(2)).sqrt()
}

// Drop "spike" triangles — a mostly-correct decode has a few triangles referencing a stray
// vertex (run over/under-extension), giving edges far longer than the bulk. Returns the kept
// indices and the fraction kept (a near-garbage decode loses most triangles).
fn filter_spikes(verts: &[[f32; 3]], indices: &[u32]) -> (Vec<u32>, f32) {
    let tris: Vec<&[u32]> = indices.chunks_exact(3).collect();
    if tris.len() < 2 { return (indices.to_vec(), 1.0); }
    let nv = verts.len();
    let mut edges: Vec<f32> = Vec::new();
    for t in &tris {
        if (t[0] as usize) < nv && (t[1] as usize) < nv && (t[2] as usize) < nv {
            edges.push(tri_edge(verts[t[0] as usize], verts[t[1] as usize]));
        }
    }
    if edges.is_empty() { return (Vec::new(), 0.0); }
    let mut s = edges.clone();
    s.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));
    let med = s[s.len() / 2].max(1e-3);
    let limit = med * 8.0;
    let mut kept = Vec::with_capacity(indices.len());
    for t in &tris {
        if (t[0] as usize) >= nv || (t[1] as usize) >= nv || (t[2] as usize) >= nv { continue; }
        let (a, b, c) = (verts[t[0] as usize], verts[t[1] as usize], verts[t[2] as usize]);
        if tri_edge(a, b) <= limit && tri_edge(b, c) <= limit && tri_edge(c, a) <= limit {
            kept.extend_from_slice(t);
        }
    }
    let frac = (kept.len() / 3) as f32 / tris.len() as f32;
    (kept, frac)
}

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
        // FMatrix is row-major 4x4; the translation lives in row 3 (floats 12..14).
        // The cooked FMatrix struct body carries a 4-byte lead, so the 16 matrix floats sit at
        // body floats 1..16 and the translation row (matrix M[3]) lands at body floats 13..15.
        "Matrix" if d.len() >= 64 => format!("pos({:.1}, {:.1}, {:.1}) scale({:.2}, {:.2}, {:.2})",
            f(52), f(56), f(60),
            (f(4)*f(4)+f(8)*f(8)+f(12)*f(12)).sqrt(), (f(20)*f(20)+f(24)*f(24)+f(28)*f(28)).sqrt(), (f(36)*f(36)+f(40)*f(40)+f(44)*f(44)).sqrt()),
        _ => return None,
    })
}

pub struct Texture { pub w: usize, pub h: usize, pub rgba: Vec<u8>, pub format: String }

struct MipInfo { mhdr: usize, flags: u32, elem: usize, sod: i32, foff: i32, inline_off: usize, msx: usize, msy: usize }

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
    if bs == 0 || bs > (4 << 20) { return None; }
    let nblk = ((tu + bs - 1) / bs).min(1 << 20);
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
        if n == 0 { return String::new(); }
        if n < 0 {
            // UE3 wide (UTF-16LE) FString: |n| code units = 2*|n| bytes on disk.
            let bytes = ((-n) as usize).saturating_mul(2).min(self.b.len().saturating_sub(self.o));
            let u: Vec<u16> = self.b[self.o..self.o + bytes].chunks_exact(2).map(|c| u16::from_le_bytes([c[0], c[1]])).collect();
            self.o += bytes;
            return String::from_utf16_lossy(&u).trim_end_matches('\0').to_string();
        }
        let n = (n as usize).min(self.b.len().saturating_sub(self.o));
        let s = String::from_utf8_lossy(&self.b[self.o..self.o + n]).trim_end_matches('\0').to_string();
        self.o += n; s
    }
    fn skip(&mut self, n: usize) { self.o = (self.o + n).min(self.b.len()); }
}

pub struct Export {
    pub class_name: String,
    pub name: String,
    pub size: i32,
    pub off: i32,
    pub size_off: usize,
    pub outer: i32,      // OuterIndex: package-export index (1-based) of the owning object, 0 = top level
}

pub struct MapActor {
    pub idx: usize,
    pub name: String,
    pub class: String,
    pub pos: Option<(f32, f32, f32)>,
    pub components: Vec<usize>,
}

pub struct PropNode {
    pub name: String,
    pub typ: String,
    pub value: String,
    pub children: Vec<PropNode>,
}

pub struct Mesh {
    pub verts: Vec<[f32; 3]>,
    pub uvs: Vec<[f32; 2]>,
    pub indices: Vec<u32>,
}

fn half_to_f32(h: u16) -> f32 {
    let sign = (h >> 15) & 1;
    let exp = (h >> 10) & 0x1f;
    let mant = h & 0x3ff;
    let f = if exp == 0 {
        (mant as f32) * 2.0f32.powi(-24)
    } else if exp == 0x1f {
        if mant == 0 { f32::INFINITY } else { f32::NAN }
    } else {
        (1.0 + (mant as f32) / 1024.0) * 2.0f32.powi(exp as i32 - 15)
    };
    if sign == 1 { -f } else { f }
}

pub enum Ref {
    Local(usize),
    Import { package: String, object: String },
    None,
}

impl PropNode {
    fn leaf(name: String, typ: &str, value: String) -> PropNode {
        PropNode { name, typ: typ.to_string(), value, children: Vec::new() }
    }
}

pub struct Pkg {
    pub buf: Vec<u8>,
    pub ver: u16,
    pub names: Vec<String>,
    pub imports: Vec<String>,
    pub import_outers: Vec<i32>,   // OuterIndex per import — follow to the top to get the package name
    pub import_classes: Vec<String>,
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
    let total = chunks.iter().map(|x| x.0.saturating_add(x.1)).max().unwrap_or(0);
    if total > raw.len().saturating_mul(256) + (1 << 24) { return Err("implausible uncompressed size".into()); }
    let mut buf = vec![0u8; total];
    let first = chunks[0].0.min(total).min(raw.len());
    buf[0..first].copy_from_slice(&raw[0..first]);
    for (uoff, _usz, coff, _csz) in chunks {
        let bs = ru(raw, coff + 4) as usize;
        let tu = ru(raw, coff + 12) as usize;
        if bs == 0 { continue; }
        let nblk = (tu + bs - 1) / bs;
        let mut p = coff + 16;
        let mut binfo = Vec::with_capacity(nblk.min(1 << 20));
        for i in 0..nblk {
            if p + i * 8 + 8 > raw.len() { break; }
            binfo.push((ru(raw, p + i * 8) as usize, ru(raw, p + i * 8 + 4) as usize));
        }
        p += nblk * 8;
        let mut pos = uoff;
        for (cs2, us2) in binfo {
            if p + cs2 > raw.len() || pos >= buf.len() { break; }
            if cs2 == us2 {
                let n = us2.min(buf.len() - pos).min(cs2);
                buf[pos..pos + n].copy_from_slice(&raw[p..p + n]);
            } else {
                let dec = lzo1x_decompress(&raw[p..p + cs2]);
                let n = dec.len().min(buf.len() - pos);
                buf[pos..pos + n].copy_from_slice(&dec[..n]);
            }
            p += cs2;
            pos += us2;
        }
    }
    Ok(buf)
}

impl Pkg {
    // Investigation aid: at an export's serial start, try a few leading-skip hypotheses and
    // report whether each makes the first tag look like a real (name, KindProperty, size).
    pub fn probe(&self, e: &Export) -> String {
        let b = &self.buf;
        let off = e.off as usize;
        let mut s = format!("== {} ({}) @ {} size {} ==\n", e.name, e.class_name, off, e.size);
        let n = (e.size.max(0) as usize).min(64);
        for row in b.get(off..(off + n).min(b.len())).unwrap_or(&[]).chunks(16) {
            for byte in row { s.push_str(&format!("{:02x} ", byte)); }
            s.push_str("  ");
            for byte in row { let c = *byte; s.push(if (32..127).contains(&c) { c as char } else { '.' }); }
            s.push('\n');
        }
        for skip in [0usize, 4, 8, 12] {
            let o = off + skip;
            let name = self.fname_at(o);
            let typ = self.fname_at(o + 8);
            let size = ri(b, o + 16);
            s.push_str(&format!("  skip +{:<2}: name='{}' type='{}' size={}\n", skip, name, typ, size));
        }
        match self.find_prop_start(e) {
            Some(start) => s.push_str(&format!("  AUTO prop start: off+{} -> first '{}' '{}'\n", start - off, self.fname_at(start), self.fname_at(start + 8))),
            None => s.push_str("  AUTO prop start: none found\n"),
        }
        // full-serial scan: every offset whose +8 looks like a *Property tag
        let end = (e.off as i64 + e.size.max(0) as i64) as usize;
        s.push_str("  all *Property tags in serial:\n");
        let mut o = off;
        while o + 24 <= end && o + 24 <= b.len() {
            let nidx = ri(b, o);
            let typ = self.fname_at(o + 8);
            if nidx >= 0 && (nidx as usize) < self.names.len() && typ.ends_with("Property") {
                s.push_str(&format!("    +{:<3} {:<28} {:<16} size={}\n", o - off, self.fname_at(o), typ, ri(b, o + 16)));
            }
            o += 4;
        }
        s
    }

    // The leading data before the tagged-property list varies by object kind (4 bytes for
    // most objects, more for components/actors that serialize native object refs first).
    // Scan the first part of the serial for the first offset that looks like a real tag:
    // a resolvable name, a *Property type, and a sane size — then verify the run reaches a
    // clean "None" terminator. Returns the offset of the first tag, or None.
    fn find_prop_start(&self, e: &Export) -> Option<usize> {
        let b = &self.buf;
        let off = e.off as usize;
        let end = (e.off as i64 + e.size.max(0) as i64) as usize;
        let scan_end = (off + 96).min(end);
        for o in (off..scan_end).step_by(4) {
            if o + 24 > b.len() { break; }
            let nidx = ri(b, o);
            if nidx < 0 || nidx as usize >= self.names.len() { continue; }
            let typ = self.fname_at(o + 8);
            if !typ.ends_with("Property") { continue; }
            let size = ri(b, o + 16);
            if size < 0 || (o + 24 + size as usize) > end { continue; }
            if self.props_terminate(o, end) { return Some(o); }
        }
        None
    }

    // Walk tags from `start` using the same advance rules as parse_props; return true if the
    // run ends at a "None" terminator within `end` (i.e. `start` is a real tag-list head).
    fn props_terminate(&self, start: usize, end: usize) -> bool {
        let b = &self.buf;
        let mut o = start;
        for _ in 0..512 {
            if o + 8 > end || o + 8 > b.len() { return false; }
            let name = self.fname_at(o);
            if name == "None" { return true; }
            if name.starts_with('?') { return false; }
            o += 8;
            let typ = self.fname_at(o);
            if !typ.ends_with("Property") { return false; }
            o += 8;
            let size = ri(b, o) as usize; o += 8;
            o += self.prop_body_len(&typ, size);
            if o > end { return false; }
        }
        false
    }

    // Bytes consumed by a property value of `typ` with declared `size`, starting at `o`
    // (the byte after the 16-byte name/type/size tag header has already been passed).
    fn prop_body_len(&self, typ: &str, size: usize) -> usize {
        match typ {
            "BoolProperty" => 1,
            "ByteProperty" => 8 + if size == 8 { 8 } else { size }, // enum name + (enum value | byte)
            "StructProperty" => 8 + size,                            // struct type name + body
            _ => size,
        }
    }

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

    // Upper bound for a property walk that starts at an export's serial offset: the
    // export's own end, so a desynced walk can never spill into the next export's bytes.
    fn export_end(&self, start: i32) -> usize {
        self.exports.iter()
            .filter(|e| e.off == start)
            .map(|e| (e.off as i64 + e.size.max(0) as i64) as usize)
            .max()
            .map(|v| v.min(self.buf.len()))
            .unwrap_or(self.buf.len())
    }

    // Where an export's tagged-property list begins. The leading native data varies by
    // object kind (textures +4, components/most objects +8, some none), so auto-detect by
    // scanning for the first terminating tag run; fall back to the +4 NetIndex skip.
    fn prop_start_at(&self, start: i32) -> usize {
        if let Some(e) = self.exports.iter().find(|e| e.off == start) {
            if let Some(o) = self.find_prop_start(e) { return o; }
        }
        start as usize + 4
    }

    pub fn props_editable(&self, start: i32) -> Vec<PropEdit> {
        let b = &self.buf; let bound = self.export_end(start);
        let mut o = self.prop_start_at(start); let mut out = Vec::new();
        while o + 16 <= b.len() && o < bound {
            let name = self.fname_at(o); o += 8;
            if name == "None" || name.starts_with('?') { break; }
            let typ = self.fname_at(o); o += 8;
            if !typ.ends_with("Property") { break; }
            let size = ri(b, o) as usize; o += 8;
            if o > b.len() { break; }
            let (kind, voff, value): (u8, usize, String) = match typ.as_str() {
                "IntProperty" => { let v = ri(b, o); let vo = o; o += 4; (1, vo, v.to_string()) }
                "FloatProperty" => { let v = rf(b, o); let vo = o; o += 4; (2, vo, format!("{}", v)) }
                "BoolProperty" => { let v = b.get(o).copied().unwrap_or(0) != 0; let vo = o; o += 1; (3, vo, format!("{}", v)) }
                "ByteProperty" => { let _e = self.fname_at(o); o += 8;
                    if size == 8 { let v = self.fname_at(o); o += 8; (0, 0, v) } else { let v = b.get(o).copied().unwrap_or(0).to_string(); let vo = o; o += size; (4, vo, v) } }
                "NameProperty" => { let v = self.fname_at(o); o += 8; (0, 0, v) }
                "StrProperty" => { let (s, adv) = read_fstring(b, o); o += adv; (0, 0, s) }
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" => { let v = ri(b, o); o += 4; (0, 0, self.idx_name(v)) }
                "StructProperty" => { let sn = self.fname_at(o); o += 8; let d = b.get(o..(o+size).min(b.len())).unwrap_or(&[]); let v = decode_struct(&sn, d).unwrap_or_else(|| format!("<{} {}B>", sn, size)); o += size; (0, 0, v) }
                _ => { o += size; (0, 0, format!("<{} {}B>", typ, size)) }
            };
            out.push(PropEdit { name, typ, kind, off: voff, value });
            if out.len() > 400 || o >= b.len() { break; }
        }
        out
    }

    // Locate a single tagged property by name in an export's serial and return its
    // (struct-or-property type, body offset, body length). The body offset already skips
    // the struct-type FName for StructProperty / the enum FName for ByteProperty.
    fn find_prop_raw(&self, start: i32, key: &str) -> Option<(String, usize, usize)> {
        let b = &self.buf; let bound = self.export_end(start);
        let mut o = self.prop_start_at(start);
        while o + 16 <= b.len() && o < bound {
            let name = self.fname_at(o); o += 8;
            if name == "None" || name.starts_with('?') { break; }
            let typ = self.fname_at(o); o += 8;
            if !typ.ends_with("Property") { break; }
            let size = ri(b, o) as usize; o += 8;
            let (body_off, body_len, label) = match typ.as_str() {
                "BoolProperty" => (o, 1usize, typ.clone()),
                "ByteProperty" => (o + 8, if size == 8 { 8 } else { size }, typ.clone()),
                "StructProperty" => { let sn = self.fname_at(o); (o + 8, size, sn) }
                _ => (o, size, typ.clone()),
            };
            if name == key { return Some((label, body_off, body_len)); }
            o += self.prop_body_len(&typ, size);
            if o > bound { break; }
        }
        None
    }

    // The f32 values inside a named (Struct) property's body — e.g. a Vector (3) or a
    // Matrix (16). Used to pull transforms out of actors/components.
    fn struct_floats(&self, start: i32, key: &str) -> Option<Vec<f32>> {
        let (_, off, len) = self.find_prop_raw(start, key)?;
        let b = &self.buf;
        let mut v = Vec::new();
        let mut o = off;
        while o + 4 <= off + len && o + 4 <= b.len() { v.push(rf(b, o)); o += 4; }
        Some(v)
    }

    pub fn level_export(&self) -> Option<usize> {
        self.exports.iter().position(|e| e.class_name == "Level")
    }

    // The component's 16-float world matrix (row-major) from CachedParentToWorld. The cooked
    // struct body has a 4-byte lead, so the matrix is body floats 1..17; translation lands at
    // m[12],m[13],m[14] in the returned array (standard indexing).
    pub fn world_matrix(&self, start: i32) -> Option<[f32; 16]> {
        let f = self.struct_floats(start, "CachedParentToWorld")?;
        if f.len() < 17 { return None; }
        let mut m = [0.0f32; 16];
        m.copy_from_slice(&f[1..17]);
        Some(m)
    }

    // All object indices referenced by an export's tagged properties (ObjectProperty values and
    // object arrays). Used to walk Material -> MaterialExpression -> Texture2D graphs.
    pub fn collect_refs(&self, start: i32) -> Vec<i32> {
        let b = &self.buf; let bound = self.export_end(start);
        let mut o = self.prop_start_at(start); let mut out = Vec::new();
        while o + 16 <= b.len() && o < bound {
            let name = self.fname_at(o); if name == "None" || name.starts_with('?') { break; } o += 8;
            let typ = self.fname_at(o); if !typ.ends_with("Property") { break; } o += 8;
            let size = ri(b, o) as usize; o += 8;
            match typ.as_str() {
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" | "InterfaceProperty" => { out.push(ri(b, o)); o += 4; }
                "ArrayProperty" => {
                    let count = if size >= 4 { ri(b, o).max(0) as usize } else { 0 };
                    if count > 0 && size.saturating_sub(4) == count * 4 {
                        for i in 0..count { out.push(ri(b, o + 4 + i * 4)); }
                    }
                    o += size;
                }
                "BoolProperty" => o += 1,
                "ByteProperty" => { let _ = self.fname_at(o); o += 8; o += if size == 8 { 8 } else { size }; }
                "StructProperty" => { let _ = self.fname_at(o); o += 8; o += size; }
                _ => o += size,
            }
            if out.len() > 600 || o > bound { break; }
        }
        out
    }

    // The first local Texture2D reachable from an object's material graph, decoded.
    pub fn diffuse_texture(&self, root: usize, cooked: &std::path::Path) -> Option<Texture> {
        let mut seen = std::collections::HashSet::new();
        let mut queue = std::collections::VecDeque::new();
        queue.push_back(root);
        let mut steps = 0;
        while let Some(ei) = queue.pop_front() {
            if !seen.insert(ei) || steps > 80 { steps += 1; continue; }
            steps += 1;
            let e = match self.exports.get(ei) { Some(e) => e, None => continue };
            if e.class_name.contains("Texture") {
                if let Some(t) = self.texture(e, cooked) { return Some(t); }
            }
            for re in self.collect_refs(e.off) { if re > 0 { queue.push_back((re - 1) as usize); } }
        }
        None
    }

    // Object refs (local or import) anywhere in an export's serial that resolve to a Material or
    // Texture class. Unlike collect_refs (tagged props only) this reaches refs in native data —
    // a StaticMesh's per-section materials live in its native Elements, not in tagged properties.
    pub fn relevant_refs(&self, e: &Export) -> Vec<i32> {
        let b = &self.buf;
        let (s, en) = (e.off as usize, ((e.off as i64 + e.size.max(0) as i64) as usize).min(b.len()));
        let mut out = Vec::new();
        let mut o = s;
        while o + 4 <= en {
            let v = ri(b, o);
            let cls = if v > 0 {
                self.exports.get((v - 1) as usize).map(|x| x.class_name.as_str())
            } else if v < 0 {
                self.import_classes.get((-v - 1) as usize).map(|x| x.as_str())
            } else { None };
            if let Some(c) = cls {
                if c.contains("Material") || c.contains("Texture") { out.push(v); }
            }
            o += 4;
        }
        out.sort_unstable(); out.dedup();
        out
    }

    // Average diffuse colour of an object's material: BFS its reference graph
    // (Material -> Expressions -> Texture2D), decode the first local Texture2D, average it.
    pub fn diffuse_color(&self, root: usize, cooked: &std::path::Path) -> Option<[u8; 3]> {
        let mut seen = std::collections::HashSet::new();
        let mut queue = std::collections::VecDeque::new();
        queue.push_back(root);
        let mut steps = 0;
        while let Some(ei) = queue.pop_front() {
            if !seen.insert(ei) || steps > 64 { steps += 1; continue; }
            steps += 1;
            let e = match self.exports.get(ei) { Some(e) => e, None => continue };
            if e.class_name.contains("Texture") {
                if let Some(t) = self.texture(e, cooked) {
                    let (mut r, mut g, mut bl, mut n) = (0u64, 0u64, 0u64, 0u64);
                    for px in t.rgba.chunks_exact(4) {
                        if px[3] < 16 { continue; }
                        r += px[0] as u64; g += px[1] as u64; bl += px[2] as u64; n += 1;
                    }
                    if n > 0 { return Some([(r / n) as u8, (g / n) as u8, (bl / n) as u8]); }
                }
            }
            for re in self.collect_refs(e.off) { if re > 0 { queue.push_back((re - 1) as usize); } }
        }
        None
    }

    // Resolve an object index: a local export, or an import with its source package + object
    // name (the outer chain is followed to the top-level package import).
    pub fn resolve_ref(&self, r: i32) -> Ref {
        if r > 0 { return Ref::Local((r - 1) as usize); }
        if r == 0 { return Ref::None; }
        let idx = (-r - 1) as usize;
        let object = self.imports.get(idx).cloned().unwrap_or_default();
        let mut cur = idx;
        let mut package = String::new();
        for _ in 0..16 {
            let outer = *self.import_outers.get(cur).unwrap_or(&0);
            if outer == 0 { package = self.imports.get(cur).cloned().unwrap_or_default(); break; }
            if outer < 0 { cur = (-outer - 1) as usize; } else { break; }
        }
        Ref::Import { package, object }
    }

    // Raw object index stored by a named ObjectProperty (>0 export 1-based, <0 import, 0 none).
    pub fn object_ref(&self, start: i32, key: &str) -> Option<i32> {
        let (_, off, len) = self.find_prop_raw(start, key)?;
        if len >= 4 { Some(ri(&self.buf, off)) } else { None }
    }

    // Decode a cooked StaticMesh LOD into positions + triangle indices by locating the
    // render buffers heuristically: a PositionVertexBuffer is [u32 stride=12][u32 numVerts]
    // [numVerts*FVector]; the IndexBuffer is [u32 stride=2][u32 numIdx][numIdx*u16]. We accept
    // the first stride-12 block whose vectors are finite/in-range AND that is followed by a
    // stride-2 block of triangle indices all < numVerts — that joint constraint rejects
    // coincidental matches.
    pub fn static_mesh(&self, e: &Export) -> Option<Mesh> {
        let b = &self.buf;
        let start = e.off as usize;
        let end = ((e.off as i64 + e.size.max(0) as i64) as usize).min(b.len());
        let fv = |o: usize| -> Option<[f32; 3]> {
            if o + 12 > end { return None; }
            let v = [rf(b, o), rf(b, o + 4), rf(b, o + 8)];
            if v.iter().all(|f| f.is_finite() && f.abs() < 1.0e5) { Some(v) } else { None }
        };
        // Anchor on the FStaticMeshVertexBuffer header [NumTexCoords 1..4][Stride 8..64][N]: it
        // gives the *exact* vertex count N, and the PositionVertexBuffer's N FVectors sit
        // immediately before it. Reading exactly N from that exact offset avoids the over/under-
        // extension that gave spiky surfaces. Validate with an index buffer (indices < N).
        let mut o = start;
        while o + 12 <= end {
            let ntc = ru(b, o); let stride = ru(b, o + 4); let n = ru(b, o + 8) as usize;
            if (1..=4).contains(&ntc) && (8..=64).contains(&stride) && n >= 12 && n < (1 << 21) {
                if let Some(ps) = o.checked_sub(n * 12) {
                    if ps >= start && (0..n).step_by((n / 24).max(1)).all(|i| fv(ps + i * 12).is_some()) {
                        let verts: Vec<[f32; 3]> = (0..n).map(|i| { let vo = ps + i * 12; [rf(b, vo), rf(b, vo + 4), rf(b, vo + 8)] }).collect();
                        let indices = self.find_indices(o, end, n);
                        if std::env::var("MESHDBG").is_ok() {
                            let frac = indices.as_ref().map(|ix| filter_spikes(&verts, ix).1).unwrap_or(-1.0);
                            eprintln!("MESHDBG hdr off+{} ntc={} stride={} n={} idx={:?} frac={:.2}", o - start, ntc, stride, n, indices.as_ref().map(|ix| ix.len() / 3), frac);
                        }
                        if let Some(indices) = indices {
                            let (kept, frac) = filter_spikes(&verts, &indices);
                            if frac > 0.6 && kept.len() >= 3 {
                                // UVs share the vertex order; the tangent/UV bulk starts after the
                                // 24-byte header, UV channel 0 sits after the 8-byte tangent basis.
                                let full = ru(b, o + 12) != 0;
                                let bulk = o + 24;
                                let uvs = (0..n).map(|i| {
                                    let vo = bulk + i * stride as usize + 8;
                                    if full && vo + 8 <= end {
                                        [rf(b, vo), rf(b, vo + 4)]
                                    } else if vo + 4 <= end {
                                        [half_to_f32(u16::from_le_bytes([b[vo], b[vo + 1]])), half_to_f32(u16::from_le_bytes([b[vo + 2], b[vo + 3]]))]
                                    } else { [0.0, 0.0] }
                                }).collect();
                                return Some(Mesh { verts, uvs, indices: kept });
                            }
                        }
                    }
                }
            }
            o += 1;
        }
        None
    }

    fn find_indices(&self, from: usize, end: usize, nverts: usize) -> Option<Vec<u32>> {
        let b = &self.buf;
        let mut o = from;
        while o + 8 < end {
            let stride = ru(b, o);
            let nidx = ru(b, o + 4) as usize;
            let idata = o + 8;
            if (stride == 2 || stride == 4) && nidx >= 3 && nidx % 3 == 0 && nidx < (1 << 22) && idata + nidx * stride as usize <= end {
                let rd = |i: usize| -> usize {
                    if stride == 2 { u16::from_le_bytes([b[idata + i * 2], b[idata + i * 2 + 1]]) as usize }
                    else { ru(b, idata + i * 4) as usize }
                };
                if (0..nidx.min(256)).all(|i| rd(i) < nverts) {
                    let idx: Vec<u32> = (0..nidx).map(|i| rd(i) as u32).collect();
                    // require the buffer to reference most of the run's vertices, else it is a
                    // coincidental stride-2 block before the real index buffer — keep scanning.
                    let maxi = idx.iter().copied().max().unwrap_or(0) as usize;
                    if maxi + 1 >= nverts / 2 { return Some(idx); }
                }
            }
            o += 1;
        }
        None
    }

    // Export indices whose Outer is the given export (its sub-objects / components).
    pub fn children(&self, idx: usize) -> Vec<usize> {
        let r = (idx + 1) as i32;
        self.exports.iter().enumerate().filter(|(_, c)| c.outer == r).map(|(i, _)| i).collect()
    }

    // Full recursive property tree for an export: scalars are leaves, non-atomic structs
    // recurse into their tagged sub-properties, and ArrayProperty bodies are decoded
    // (object/name arrays expand into entries; other element layouts are summarized).
    pub fn prop_tree(&self, start: i32) -> Vec<PropNode> {
        let o = self.prop_start_at(start);
        self.walk_tree(o, self.export_end(start), 0)
    }

    fn walk_tree(&self, start: usize, end: usize, depth: usize) -> Vec<PropNode> {
        let b = &self.buf;
        let mut o = start;
        let mut out = Vec::new();
        while o + 16 <= b.len() && o < end {
            let name = self.fname_at(o);
            if name == "None" || name.starts_with('?') { break; }
            o += 8;
            let typ = self.fname_at(o); o += 8;
            if !typ.ends_with("Property") { break; }
            let size = ri(b, o) as usize; o += 8;
            if o > b.len() { break; }
            let node = match typ.as_str() {
                "IntProperty" => { let v = ri(b, o); o += 4; PropNode::leaf(name, &typ, v.to_string()) }
                "FloatProperty" => { let v = rf(b, o); o += 4; PropNode::leaf(name, &typ, format!("{}", v)) }
                "BoolProperty" => { let v = b.get(o).copied().unwrap_or(0) != 0; o += 1; PropNode::leaf(name, &typ, v.to_string()) }
                "ByteProperty" => { let _en = self.fname_at(o); o += 8;
                    if size == 8 { let v = self.fname_at(o); o += 8; PropNode::leaf(name, "Enum", v) }
                    else { let v = b.get(o).copied().unwrap_or(0); o += size; PropNode::leaf(name, &typ, v.to_string()) } }
                "NameProperty" => { let v = self.fname_at(o); o += 8; PropNode::leaf(name, &typ, v) }
                "StrProperty" => { let (s, adv) = read_fstring(b, o); o += adv; PropNode::leaf(name, &typ, s) }
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" | "InterfaceProperty" => { let v = ri(b, o); o += 4; PropNode::leaf(name, &typ, self.idx_name(v)) }
                "StructProperty" => {
                    let sn = self.fname_at(o); o += 8;
                    let bodyend = (o + size).min(end);
                    let node = match decode_struct(&sn, b.get(o..bodyend.min(b.len())).unwrap_or(&[])) {
                        Some(v) => PropNode::leaf(name, &sn, v),
                        None => {
                            let kids = if depth < 8 { self.walk_tree(o, bodyend, depth + 1) } else { Vec::new() };
                            if kids.is_empty() { PropNode::leaf(name, &sn, format!("<{} {}B>", sn, size)) }
                            else { PropNode { name, typ: sn, value: format!("{} fields", kids.len()), children: kids } }
                        }
                    };
                    o += size; node
                }
                "ArrayProperty" => {
                    let count = if size >= 4 { ri(b, o).max(0) as usize } else { 0 };
                    let (val, kids) = self.decode_array(o + 4, count, size.saturating_sub(4));
                    o += size;
                    PropNode { name, typ: format!("Array[{}]", count), value: val, children: kids }
                }
                _ => { o += size; PropNode::leaf(name, &typ, format!("<{} {}B>", typ, size)) }
            };
            out.push(node);
            if o > end || out.len() > 600 { break; }
        }
        out
    }

    fn decode_array(&self, off: usize, count: usize, rem: usize) -> (String, Vec<PropNode>) {
        let b = &self.buf;
        if count == 0 { return ("(empty)".into(), Vec::new()); }
        if rem == count.saturating_mul(4) {
            // object-ref array (Components, Materials, Expressions, ...) or a numeric array
            let mut kids = Vec::new();
            for i in 0..count.min(256) {
                let v = ri(b, off + i * 4);
                let nm = self.idx_name(v);
                let val = if nm.starts_with('?') { v.to_string() } else { nm };
                kids.push(PropNode::leaf(format!("[{}]", i), "", val));
            }
            return (format!("{} entries", count), kids);
        }
        if rem == count.saturating_mul(8) {
            let mut kids = Vec::new();
            for i in 0..count.min(256) { kids.push(PropNode::leaf(format!("[{}]", i), "Name", self.fname_at(off + i * 8))); }
            return (format!("{} names", count), kids);
        }
        let per = rem / count.max(1);
        (format!("{} x {}B (raw)", count, per), Vec::new())
    }

    // The actors placed in this map, via the export OuterIndex hierarchy: an actor's Outer is
    // the PersistentLevel; a component's Outer is its actor. Position comes from the actor's
    // own Location, else a child primitive component's CachedParentToWorld / Translation.
    pub fn actors(&self) -> Vec<MapActor> {
        let level = match self.level_export() { Some(l) => l, None => return Vec::new() };
        let level_ref = (level + 1) as i32;
        let mut out = Vec::new();
        for (i, e) in self.exports.iter().enumerate() {
            if e.outer != level_ref { continue; }
            let components: Vec<usize> = self.exports.iter().enumerate()
                .filter(|(_, c)| c.outer == (i + 1) as i32).map(|(ci, _)| ci).collect();
            let pos = self.actor_pos(i, &components);
            out.push(MapActor { idx: i, name: e.name.clone(), class: e.class_name.clone(), pos, components });
        }
        // Second pass: actors whose transform lives in native serial bytes (StaticMeshActor,
        // Brush, ...) have no tagged Location. Use the region established by the actors we did
        // place (lights/KActors) to scan each unplaced actor's serial for an FVector inside the
        // level bounds — the large, specific level coordinates make false matches near-impossible.
        let placed: Vec<(f32, f32, f32)> = out.iter().filter_map(|a| a.pos).collect();
        if placed.len() >= 3 {
            let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
            for p in &placed { let v = [p.0, p.1, p.2]; for k in 0..3 { mn[k] = mn[k].min(v[k]); mx[k] = mx[k].max(v[k]); } }
            let ext = (mx[0] - mn[0]).max(mx[1] - mn[1]).max(mx[2] - mn[2]).max(1000.0);
            let lo = [mn[0] - ext, mn[1] - ext, mn[2] - ext];
            let hi = [mx[0] + ext, mx[1] + ext, mx[2] + ext];
            for a in out.iter_mut() {
                if a.pos.is_none() { a.pos = self.scan_location(a.idx, lo, hi); }
            }
        }
        out
    }

    // Find a tagged property by name anywhere in an actor's serial (robust against the leading
    // native data that defeats find_prop_start). Returns the value offset: a StructProperty's
    // value sits 32 bytes after the name (name8+type8+size4+arrayidx4+structname8), a scalar's 24.
    fn find_actor_tag(&self, e: &Export, name: &str) -> Option<usize> {
        let nidx = self.names.iter().position(|n| n == name)? as i32;
        let b = &self.buf;
        let (s, en) = (e.off as usize, ((e.off as i64 + e.size.max(0) as i64) as usize).min(b.len()));
        let mut o = s;
        while o + 16 <= en {
            if ri(b, o) == nidx && ri(b, o + 4) == 0 {
                let typ = self.fname_at(o + 8);
                if typ.ends_with("Property") {
                    return Some(if typ == "StructProperty" { o + 32 } else { o + 24 });
                }
            }
            o += 4;
        }
        None
    }

    // Full world matrix for an actor from its tagged Location / Rotation / DrawScale(3D).
    pub fn actor_matrix(&self, idx: usize) -> Option<[f32; 16]> {
        let e = &self.exports[idx];
        let b = &self.buf;
        let loc = self.find_actor_tag(e, "Location").map(|o| [rf(b, o), rf(b, o + 4), rf(b, o + 8)]);
        let rot = self.find_actor_tag(e, "Rotation").map(|o| [ri(b, o), ri(b, o + 4), ri(b, o + 8)]);
        let s3 = self.find_actor_tag(e, "DrawScale3D").map(|o| [rf(b, o), rf(b, o + 4), rf(b, o + 8)]);
        let s1 = self.find_actor_tag(e, "DrawScale").map(|o| rf(b, o)).unwrap_or(1.0);
        if loc.is_none() && rot.is_none() && s3.is_none() { return None; }
        let t = loc.unwrap_or([0.0; 3]);
        let s = s3.unwrap_or([1.0; 3]);
        let sc = [s[0] * s1, s[1] * s1, s[2] * s1];
        let u = std::f32::consts::TAU / 65536.0;
        let (p, y, r) = match rot { Some(rr) => (rr[0] as f32 * u, rr[1] as f32 * u, rr[2] as f32 * u), None => (0.0, 0.0, 0.0) };
        let (cp, sp, cy, sy, cr, sr) = (p.cos(), p.sin(), y.cos(), y.sin(), r.cos(), r.sin());
        // UE3 FRotationMatrix (row-major basis), each basis row scaled; translation in row 3.
        let mut m = [0.0f32; 16];
        m[0] = cp * cy * sc[0]; m[1] = cp * sy * sc[0]; m[2] = sp * sc[0];
        m[4] = (sr * sp * cy - cr * sy) * sc[1]; m[5] = (sr * sp * sy + cr * cy) * sc[1]; m[6] = -sr * cp * sc[1];
        m[8] = -(cr * sp * cy + sr * sy) * sc[2]; m[9] = (cy * sr - cr * sp * sy) * sc[2]; m[10] = cr * cp * sc[2];
        m[12] = t[0]; m[13] = t[1]; m[14] = t[2]; m[15] = 1.0;
        Some(m)
    }

    fn scan_location(&self, idx: usize, lo: [f32; 3], hi: [f32; 3]) -> Option<(f32, f32, f32)> {
        let e = &self.exports[idx];
        let b = &self.buf;
        let start = e.off as usize;
        let end = ((e.off as i64 + e.size.max(0) as i64) as usize).min(b.len());
        let mut o = start;
        while o + 12 <= end {
            let v = [rf(b, o), rf(b, o + 4), rf(b, o + 8)];
            if (0..3).all(|k| v[k] >= lo[k] && v[k] <= hi[k]) {
                // require a non-trivial position (not all near a boundary corner / zeros)
                if v.iter().any(|f| f.abs() > 1.0) { return Some((v[0], v[1], v[2])); }
            }
            o += 1;
        }
        None
    }

    fn actor_pos(&self, actor: usize, comps: &[usize]) -> Option<(f32, f32, f32)> {
        if let Some(v) = self.struct_floats(self.exports[actor].off, "Location") {
            if v.len() >= 3 { return Some((v[0], v[1], v[2])); }
        }
        for &c in comps {
            if let Some(m) = self.struct_floats(self.exports[c].off, "CachedParentToWorld") {
                if m.len() >= 16 { return Some((m[13], m[14], m[15])); }
            }
            if let Some(v) = self.struct_floats(self.exports[c].off, "Translation") {
                if v.len() >= 3 { return Some((v[0], v[1], v[2])); }
            }
        }
        None
    }

    fn parse_props(&self, start: i32) -> (Vec<(String, String, String)>, usize) {
        let b = &self.buf; let bound = self.export_end(start);
        let mut o = self.prop_start_at(start); let mut out = Vec::new();
        while o + 16 <= b.len() && o < bound {
            let name = self.fname_at(o); o += 8;
            if name == "None" || name.starts_with('?') { break; }
            let typ = self.fname_at(o); o += 8;
            if !typ.ends_with("Property") { break; }
            let size = ri(b, o) as usize; o += 8;
            if o > b.len() { break; }
            let val = match typ.as_str() {
                "IntProperty" => { let v = ri(b, o); o += 4; v.to_string() }
                "FloatProperty" => { let v = rf(b, o); o += 4; format!("{:.3}", v) }
                "ByteProperty" => { let _en = self.fname_at(o); o += 8;
                    if size == 8 { let v = self.fname_at(o); o += 8; v } else { let v = b.get(o).copied().unwrap_or(0).to_string(); o += size; v } }
                "NameProperty" => { let v = self.fname_at(o); o += 8; v }
                "BoolProperty" => { let v = b.get(o).copied().unwrap_or(0) != 0; o += 1; format!("{}", v) }
                "ObjectProperty" | "ClassProperty" | "ComponentProperty" => { let v = ri(b, o); o += 4; self.idx_name(v) }
                "StrProperty" => { let (s, adv) = read_fstring(b, o); o += adv; s }
                "StructProperty" => { let sn = self.fname_at(o); o += 8; let d = b.get(o..(o+size).min(b.len())).unwrap_or(&[]); let v = decode_struct(&sn, d).unwrap_or_else(|| format!("<{}>", sn)); o += size; v }
                _ => { o += size; format!("<{} {}B>", typ, size) }
            };
            out.push((name, typ, val));
            if out.len() > 400 || o >= b.len() { break; }
        }
        (out, o)
    }

    // The mip chain (largest-first); the top entries can be streaming placeholders
    // (foff=-1, flags bit0 set with no inline data). Shared by texture() and replace_texture()
    // so preview and edit always agree on which mip they target.
    fn mip_table(&self, props_end: usize) -> Vec<MipInfo> {
        let b = &self.buf;
        let mut o = props_end;
        if o + 16 > b.len() { return Vec::new(); }
        let sa_flags = ru(b, o); let sa_sod = ri(b, o + 8).max(0) as usize; o += 16;
        if sa_flags & 0x01 == 0 { o += sa_sod; }
        if o + 4 > b.len() || o > b.len() { return Vec::new(); }
        let mipcount = ri(b, o); o += 4;
        if mipcount <= 0 { return Vec::new(); }
        let mut mips = Vec::new();
        for _ in 0..mipcount {
            if o + 16 > b.len() { break; }
            let mhdr = o;
            let flags = ru(b, o); let elem = ri(b, o + 4) as usize; let sod = ri(b, o + 8); let foff = ri(b, o + 12); o += 16;
            let mut inline_off = 0;
            if flags & 0x01 == 0 { inline_off = o; o += sod.max(0) as usize; }
            if o + 8 > b.len() { break; }
            let msx = ri(b, o) as usize; let msy = ri(b, o + 4) as usize; o += 8;
            mips.push(MipInfo { mhdr, flags, elem, sod, foff, inline_off, msx, msy });
        }
        mips
    }

    fn choose_mip(mips: &[MipInfo]) -> Option<usize> {
        mips.iter().position(|m| {
            let valid = if m.flags & 0x01 != 0 { m.foff >= 0 && m.sod > 0 } else { m.sod > 0 };
            valid && m.msx > 0 && m.msy > 0
        })
    }

    pub fn texture(&self, e: &Export, cooked_dir: &std::path::Path) -> Option<Texture> {
        let (props, end) = self.parse_props(e.off);
        let get = |k: &str| props.iter().find(|(n, _, _)| n == k).map(|x| x.2.clone());
        let fmt = get("Format")?;
        let tfcname = get("TextureFileCacheName");
        let b = &self.buf;
        let mips = self.mip_table(end);
        if std::env::var("MIPDBG").is_ok() {
            for (mi, m) in mips.iter().enumerate() {
                eprintln!("MIPDBG mip{} {}x{} flags={:#x} elem={} sod={} foff={}", mi, m.msx, m.msy, m.flags, m.elem, m.sod, m.foff);
            }
        }
        let ci = Self::choose_mip(&mips)?;
        let m = &mips[ci];
        let data: Vec<u8> = if m.flags & 0x01 != 0 {
            let tfc = cooked_dir.join(format!("{}.tfc", tfcname.clone().unwrap_or_default()));
            read_tfc_mip(&tfc, m.foff as i64, m.sod as usize, m.elem)?
        } else {
            b.get(m.inline_off..m.inline_off + m.sod.max(0) as usize)?.to_vec()
        };
        let (sx, sy) = (m.msx, m.msy);
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
        let mut import_outers = Vec::new();
        let mut import_classes = Vec::new();
        let mut o2 = import_off;
        for _ in 0..import_count {
            o2 += 8;                              // ClassPackage(FName)
            import_classes.push(fname(&buf, o2)); o2 += 8;  // ClassName(FName)
            import_outers.push(ri(&buf, o2)); o2 += 4;  // OuterIndex
            imports.push(fname(&buf, o2)); o2 += 8;      // ObjectName
        }

        let mut raw_exports = Vec::new();
        let mut o3 = export_off;
        for _ in 0..export_count {
            let ci = ri(&buf, o3);          // ClassIndex
            let outer = ri(&buf, o3 + 8);   // OuterIndex (SuperIndex at +4 skipped)
            o3 += 12;
            let nm = fname(&buf, o3); o3 += 8;
            o3 += 4 + 8;
            let size_off = o3;
            let sz = ri(&buf, o3); let off = ri(&buf, o3 + 4); o3 += 8;
            o3 += 4;
            let nc = ri(&buf, o3); o3 += 4 + nc as usize * 4;
            o3 += 16 + 4;
            raw_exports.push((ci, nm, sz, off, size_off, outer));
        }
        let class_of = |ci: i32| -> String {
            if ci == 0 { "Class".into() }
            else if ci < 0 { imports.get((-ci - 1) as usize).cloned().unwrap_or_else(|| "?imp".into()) }
            else { raw_exports.get((ci - 1) as usize).map(|e| e.1.clone()).unwrap_or_else(|| "?exp".into()) }
        };
        let exports = raw_exports.iter()
            .map(|(ci, nm, sz, off, so, outer)| Export { class_name: class_of(*ci), name: nm.clone(), size: *sz, off: *off, size_off: *so, outer: *outer })
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

        Ok(Pkg { buf, ver, names, imports, import_outers, import_classes, exports, cflags_off, name_off, compressed, summary_tail })
    }

    pub fn replace_texture(&mut self, e_idx: usize, rgba: &[u8], w: usize, h: usize, cooked_dir: &std::path::Path) -> Result<String, String> {
        let off = self.exports[e_idx].off;
        let (props, end) = self.parse_props(off);
        let get = |k: &str| props.iter().find(|(n, _, _)| n == k).map(|x| x.2.clone());
        let fmt = get("Format").ok_or("no Format")?;
        let tfcname = get("TextureFileCacheName").ok_or("texture has no .tfc (inline replace not supported yet)")?;
        let mips = self.mip_table(end);
        let ci = Self::choose_mip(&mips).ok_or("no replaceable mip")?;
        let m = &mips[ci];
        let (mhdr, sx, sy, was_tfc) = (m.mhdr, m.msx, m.msy, m.flags & 0x01 != 0);
        if w != sx || h != sy { return Err(format!("image must be {}x{} (got {}x{})", sx, sy, w, h)); }
        if !was_tfc { return Err("chosen mip is inline (not .tfc-backed); converting it in place would orphan its bytes and desync the mip chain — not supported".into()); }
        let dxt = if fmt.contains("DXT1") { crate::dxt::encode_bc1(rgba, w, h) }
            else if fmt.contains("DXT3") { crate::dxt::encode_bc2(rgba, w, h) }
            else if fmt.contains("DXT5") { crate::dxt::encode_bc3(rgba, w, h) }
            else if fmt.contains("A8R8G8B8") {
                let mut v = Vec::with_capacity(w * h * 4);
                for px in rgba.chunks_exact(4) { v.push(px[2]); v.push(px[1]); v.push(px[0]); v.push(px[3]); }
                v
            } else if fmt.contains("G8") {
                rgba.chunks_exact(4).map(|px| ((px[0] as u32 + px[1] as u32 + px[2] as u32) / 3) as u8).collect()
            } else { return Err(format!("unsupported texture format for replace: {}", fmt)); };
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
        // The FByteBulkData header before the audio holds SizeOnDisk at oggpos-8; the bytes
        // after the old payload are the trailing platform bulk headers (Xbox360/PS3) the PC
        // cook still serializes — they must survive the splice or the serial is truncated.
        let old_len = ri(&serial, oggpos - 8).max(0) as usize;
        let tail_start = (oggpos + old_len).min(serial.len());
        let mut ns = serial[..oggpos].to_vec();
        ns.extend_from_slice(new_audio);
        ns.extend_from_slice(&serial[tail_start..]);
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
            let ext = match &d[i..i + 4] { b"OggS" => "ogg", b"RIFF" => "wav", _ => continue };
            // Bound the payload to SizeOnDisk (FByteBulkData header at i-8) so the trailing
            // platform bulk headers are not appended to the exported/played audio.
            let len = if i >= 8 { ri(d, i - 8).max(0) as usize } else { 0 };
            let fin = if len > 0 && i + len <= d.len() { i + len } else { d.len() };
            return Some((d[i..fin].to_vec(), ext));
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
            // restore the real trailing summary into the chunk-table gap; pad with zeros if
            // short. Only touch the gap when a tail was actually recovered in load() — zeroing
            // it on an extraction miss would blank PackageSource/AdditionalPackagesToCook.
            if !self.summary_tail.is_empty() {
                for i in gs..self.name_off { v[i] = 0; }
                let n = self.summary_tail.len().min(self.name_off.saturating_sub(gs));
                v[gs..gs + n].copy_from_slice(&self.summary_tail[..n]);
            }
        }
        v
    }
}
