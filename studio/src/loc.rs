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

impl Loc {
    pub fn load(path: &Path) -> std::io::Result<Loc> {
        let bytes = std::fs::read(path)?;
        let bom = bytes.len() >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE;
        let nulls = bytes.iter().take(512).filter(|&&b| b == 0).count();
        let utf16 = bom || nulls > 8;
        let text = if utf16 {
            decode_utf16le(if bom { &bytes[2..] } else { &bytes[..] })
        } else {
            bytes.iter().map(|&b| b as char).collect()   // Latin-1: byte<->char 1:1, lossless
        };
        let crlf = text.contains("\r\n");
        let mut entries = Vec::new();
        let mut push = |line: &str, eol: &'static str, entries: &mut Vec<Entry>| {
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
        Ok(Loc { bom, crlf, utf16, entries })
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
            o
        } else {
            text.chars().map(|c| { let u = c as u32; if u <= 255 { u as u8 } else { b'?' } }).collect()
        };
        std::fs::write(path, out)
    }
}
