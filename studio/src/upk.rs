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
        "Matrix" if d.len() >= 64 => format!("pos({:.1}, {:.1}, {:.1}) scale({:.2}, {:.2}, {:.2})",
            f(48), f(52), f(56),
            (f(0)*f(0)+f(4)*f(4)+f(8)*f(8)).sqrt(), (f(16)*f(16)+f(20)*f(20)+f(24)*f(24)).sqrt(), (f(32)*f(32)+f(36)*f(36)+f(40)*f(40)).sqrt()),
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

    // Export indices whose Outer is the given export (its sub-objects / components).
    pub fn children(&self, idx: usize) -> Vec<usize> {
        let r = (idx + 1) as i32;
        self.exports.iter().enumerate().filter(|(_, c)| c.outer == r).map(|(i, _)| i).collect()
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
        out
    }

    fn actor_pos(&self, actor: usize, comps: &[usize]) -> Option<(f32, f32, f32)> {
        if let Some(v) = self.struct_floats(self.exports[actor].off, "Location") {
            if v.len() >= 3 { return Some((v[0], v[1], v[2])); }
        }
        for &c in comps {
            if let Some(m) = self.struct_floats(self.exports[c].off, "CachedParentToWorld") {
                if m.len() >= 15 { return Some((m[12], m[13], m[14])); }
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
        let mut o2 = import_off;
        for _ in 0..import_count {
            o2 += 8 + 8 + 4;
            imports.push(fname(&buf, o2)); o2 += 8;
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

        Ok(Pkg { buf, ver, names, imports, exports, cflags_off, name_off, compressed, summary_tail })
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
