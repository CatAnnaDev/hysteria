use std::path::Path;

pub struct Entry {
    pub key: Option<String>,
    pub raw: String,
    pub eol: &'static str,
}

pub struct Loc {
    pub bom: bool,
    pub crlf: bool,
    pub utf16: bool,
    pub trailing: Option<u8>,
    pub entries: Vec<Entry>,
}

fn decode_utf16le(b: &[u8]) -> String {
    let u: Vec<u16> = b.chunks_exact(2).map(|c| u16::from_le_bytes([c[0], c[1]])).collect();
    String::from_utf16_lossy(&u)
}

fn encode_utf16le(s: &str) -> Vec<u8> {
    let mut out = Vec::with_capacity(s.len() * 2);
    for u in s.encode_utf16() { out.extend_from_slice(&u.to_le_bytes()); }
    out
}

// Windows-1252 byte for a char, or None if unrepresentable. The Latin-1 range round-trips
// 1:1 (matching how a non-UTF16 file is loaded); the 0x80-0x9F band maps the CP1252
// punctuation a translator is likely to paste (curly quotes, dashes, euro, ...).
fn cp1252_byte(c: char) -> Option<u8> {
    let u = c as u32;
    if u <= 0xFF { return Some(u as u8); }
    Some(match u {
        0x20AC => 0x80, 0x201A => 0x82, 0x0192 => 0x83, 0x201E => 0x84, 0x2026 => 0x85,
        0x2020 => 0x86, 0x2021 => 0x87, 0x02C6 => 0x88, 0x2030 => 0x89, 0x0160 => 0x8A,
        0x2039 => 0x8B, 0x0152 => 0x8C, 0x017D => 0x8E, 0x2018 => 0x91, 0x2019 => 0x92,
        0x201C => 0x93, 0x201D => 0x94, 0x2022 => 0x95, 0x2013 => 0x96, 0x2014 => 0x97,
        0x02DC => 0x98, 0x2122 => 0x99, 0x0161 => 0x9A, 0x203A => 0x9B, 0x0153 => 0x9C,
        0x017E => 0x9E, 0x0178 => 0x9F,
        _ => return None,
    })
}

impl Loc {
    pub fn load(path: &Path) -> std::io::Result<Loc> {
        let bytes = std::fs::read(path)?;
        let bom = bytes.len() >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE;
        let nulls = bytes.iter().take(512).filter(|&&b| b == 0).count();
        let utf16 = bom || nulls > 8;
        let body = if bom { &bytes[2..] } else { &bytes[..] };
        // A stray final byte in an odd-length UTF-16 file is dropped by chunks_exact; keep it
        // so save() can re-append it and the file round-trips byte-for-byte.
        let trailing = if utf16 && body.len() % 2 == 1 { body.last().copied() } else { None };
        let text = if utf16 {
            decode_utf16le(body)
        } else {
            bytes.iter().map(|&b| b as char).collect()   // Latin-1: byte<->char 1:1, lossless
        };
        let crlf = text.contains("\r\n");
        let mut entries = Vec::new();
        let push = |line: &str, eol: &'static str, entries: &mut Vec<Entry>| {
            let t = line.trim_start();
            if !t.starts_with('[') && !t.starts_with(';') && line.contains('=') {
                let eq = line.find('=').unwrap();
                entries.push(Entry { key: Some(line[..=eq].to_string()), raw: line[eq + 1..].to_string(), eol });
            } else {
                entries.push(Entry { key: None, raw: line.to_string(), eol });
            }
        };
        let mut rest = text.as_str();
        loop {
            match rest.find('\n') {
                Some(pos) => {
                    let seg = &rest[..pos];
                    let (line, eol) = if let Some(s) = seg.strip_suffix('\r') { (s, "\r\n") } else { (seg, "\n") };
                    push(line, eol, &mut entries);
                    rest = &rest[pos + 1..];
                }
                None => { push(rest, "", &mut entries); break; }
            }
        }
        Ok(Loc { bom, crlf, utf16, trailing, entries })
    }

    pub fn save(&self, path: &Path) -> std::io::Result<()> {
        let mut text = String::new();
        for e in &self.entries {
            if let Some(k) = &e.key { text.push_str(k); }
            text.push_str(&e.raw);
            text.push_str(e.eol);
        }
        let out = if self.utf16 {
            let mut o = Vec::new();
            if self.bom { o.extend_from_slice(&[0xFF, 0xFE]); }
            o.extend_from_slice(&encode_utf16le(&text));
            if let Some(b) = self.trailing { o.push(b); }
            o
        } else {
            // Encode to Windows-1252; if anything is out of range, upgrade the whole file to
            // UTF-16LE (with BOM) rather than silently destroying characters with '?'.
            let mut bytes = Vec::with_capacity(text.len());
            let mut lossy = false;
            for c in text.chars() {
                match cp1252_byte(c) { Some(b) => bytes.push(b), None => { lossy = true; break; } }
            }
            if lossy {
                let mut o = vec![0xFF, 0xFE];
                o.extend_from_slice(&encode_utf16le(&text));
                o
            } else { bytes }
        };
        std::fs::write(path, out)
    }
}
