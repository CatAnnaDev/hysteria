fn c565(c: u16) -> (u8, u8, u8) {
    let r = ((c >> 11) & 0x1f) as u32;
    let g = ((c >> 5) & 0x3f) as u32;
    let b = (c & 0x1f) as u32;
    (((r * 255 + 15) / 31) as u8, ((g * 255 + 31) / 63) as u8, ((b * 255 + 15) / 31) as u8)
}

fn u16le(d: &[u8], o: usize) -> u16 { d[o] as u16 | ((d[o + 1] as u16) << 8) }

fn enc565(r: u8, g: u8, b: u8) -> u16 {
    (((r as u16) >> 3) << 11) | (((g as u16) >> 2) << 5) | ((b as u16) >> 3)
}

pub fn encode_bc1(rgba: &[u8], w: usize, h: usize) -> Vec<u8> {
    let mut out = Vec::with_capacity((w / 4) * (h / 4) * 8);
    let mut blk = [[0u8; 3]; 16];
    for by in (0..h).step_by(4) {
        for bx in (0..w).step_by(4) {
            for py in 0..4 { for px in 0..4 {
                let x = (bx + px).min(w - 1); let y = (by + py).min(h - 1);
                let o = (y * w + x) * 4;
                blk[py * 4 + px] = [rgba[o], rgba[o + 1], rgba[o + 2]];
            }}
            let mut mn = [255u8; 3]; let mut mx = [0u8; 3];
            for c in &blk { for j in 0..3 { mn[j] = mn[j].min(c[j]); mx[j] = mx[j].max(c[j]); } }
            let mut c0 = enc565(mx[0], mx[1], mx[2]);
            let mut c1 = enc565(mn[0], mn[1], mn[2]);
            if c0 <= c1 { let t = c0; c0 = c1.max(1); c1 = if t > 0 { t - 1 } else { 0 }; if c0 <= c1 { c0 = c1 + 1; } }
            let (r0, g0, b0) = c565(c0); let (r1, g1, b1) = c565(c1);
            let pal = [
                [r0, g0, b0], [r1, g1, b1],
                [((2*r0 as u32 + r1 as u32)/3) as u8, ((2*g0 as u32 + g1 as u32)/3) as u8, ((2*b0 as u32 + b1 as u32)/3) as u8],
                [((r0 as u32 + 2*r1 as u32)/3) as u8, ((g0 as u32 + 2*g1 as u32)/3) as u8, ((b0 as u32 + 2*b1 as u32)/3) as u8],
            ];
            let mut cbits: u32 = 0;
            for i in 0..16 {
                let c = blk[i]; let mut best = 0; let mut bd = i64::MAX;
                for k in 0..4 {
                    let dr = c[0] as i64 - pal[k][0] as i64; let dg = c[1] as i64 - pal[k][1] as i64; let db = c[2] as i64 - pal[k][2] as i64;
                    let d = dr*dr + dg*dg + db*db; if d < bd { bd = d; best = k; }
                }
                cbits |= (best as u32) << (2 * i);
            }
            out.extend_from_slice(&c0.to_le_bytes());
            out.extend_from_slice(&c1.to_le_bytes());
            out.extend_from_slice(&cbits.to_le_bytes());
        }
    }
    out
}

pub fn encode_bc3(rgba: &[u8], w: usize, h: usize) -> Vec<u8> {
    let mut out = Vec::with_capacity((w / 4) * (h / 4) * 16);
    let mut blk = [[0u8; 4]; 16];
    for by in (0..h).step_by(4) {
        for bx in (0..w).step_by(4) {
            for py in 0..4 { for px in 0..4 {
                let x = (bx + px).min(w - 1); let y = (by + py).min(h - 1);
                let o = (y * w + x) * 4;
                blk[py * 4 + px] = [rgba[o], rgba[o + 1], rgba[o + 2], rgba[o + 3]];
            }}
            let amin = blk.iter().map(|c| c[3]).min().unwrap();
            let amax = blk.iter().map(|c| c[3]).max().unwrap();
            let (a0, a1) = (amax, amin);
            let mut apal = [0u32; 8]; apal[0] = a0 as u32; apal[1] = a1 as u32;
            if a0 > a1 { for k in 1..7 { apal[k + 1] = ((7 - k as u32) * a0 as u32 + k as u32 * a1 as u32) / 7; } }
            else { for k in 1..5 { apal[k + 1] = ((5 - k as u32) * a0 as u32 + k as u32 * a1 as u32) / 5; } apal[6] = 0; apal[7] = 255; }
            let mut abits: u64 = 0;
            for i in 0..16 {
                let a = blk[i][3] as i32; let mut best = 0; let mut bd = i32::MAX;
                for k in 0..8 { let d = (a - apal[k] as i32).abs(); if d < bd { bd = d; best = k; } }
                abits |= (best as u64) << (3 * i);
            }
            out.push(a0); out.push(a1);
            for k in 0..6 { out.push(((abits >> (8 * k)) & 0xff) as u8); }
            let mut mn = [255u8; 3]; let mut mx = [0u8; 3];
            for c in &blk { for j in 0..3 { mn[j] = mn[j].min(c[j]); mx[j] = mx[j].max(c[j]); } }
            let mut c0 = enc565(mx[0], mx[1], mx[2]);
            let mut c1 = enc565(mn[0], mn[1], mn[2]);
            if c0 <= c1 { let t = c0; c0 = c1.max(1); c1 = if t > 0 { t - 1 } else { 0 }; if c0 <= c1 { c0 = c1 + 1; } }
            let (r0, g0, b0) = c565(c0); let (r1, g1, b1) = c565(c1);
            let pal = [
                [r0, g0, b0], [r1, g1, b1],
                [((2*r0 as u32 + r1 as u32)/3) as u8, ((2*g0 as u32 + g1 as u32)/3) as u8, ((2*b0 as u32 + b1 as u32)/3) as u8],
                [((r0 as u32 + 2*r1 as u32)/3) as u8, ((g0 as u32 + 2*g1 as u32)/3) as u8, ((b0 as u32 + 2*b1 as u32)/3) as u8],
            ];
            let mut cbits: u32 = 0;
            for i in 0..16 {
                let c = blk[i]; let mut best = 0; let mut bd = i64::MAX;
                for k in 0..4 {
                    let dr = c[0] as i64 - pal[k][0] as i64;
                    let dg = c[1] as i64 - pal[k][1] as i64;
                    let db = c[2] as i64 - pal[k][2] as i64;
                    let d = dr*dr + dg*dg + db*db;
                    if d < bd { bd = d; best = k; }
                }
                cbits |= (best as u32) << (2 * i);
            }
            out.extend_from_slice(&c0.to_le_bytes());
            out.extend_from_slice(&c1.to_le_bytes());
            out.extend_from_slice(&cbits.to_le_bytes());
        }
    }
    out
}

pub fn decode_bc1(data: &[u8], w: usize, h: usize) -> Vec<u8> {
    let mut out = vec![0u8; w * h * 4];
    let mut p = 0;
    for by in (0..h).step_by(4) {
        for bx in (0..w).step_by(4) {
            if p + 8 > data.len() { return out; }
            let c0 = u16le(data, p); let c1 = u16le(data, p + 2);
            let bits = u32::from_le_bytes([data[p+4], data[p+5], data[p+6], data[p+7]]);
            p += 8;
            let (r0, g0, b0) = c565(c0); let (r1, g1, b1) = c565(c1);
            let mut pal = [[r0, g0, b0, 255u8], [r1, g1, b1, 255], [0; 4], [0; 4]];
            if c0 > c1 {
                pal[2] = [((2*r0 as u32 + r1 as u32)/3) as u8, ((2*g0 as u32 + g1 as u32)/3) as u8, ((2*b0 as u32 + b1 as u32)/3) as u8, 255];
                pal[3] = [((r0 as u32 + 2*r1 as u32)/3) as u8, ((g0 as u32 + 2*g1 as u32)/3) as u8, ((b0 as u32 + 2*b1 as u32)/3) as u8, 255];
            } else {
                pal[2] = [((r0 as u32 + r1 as u32)/2) as u8, ((g0 as u32 + g1 as u32)/2) as u8, ((b0 as u32 + b1 as u32)/2) as u8, 255];
                pal[3] = [0, 0, 0, 0];
            }
            for py in 0..4 {
                for px in 0..4 {
                    let idx = ((bits >> (2 * (py * 4 + px))) & 3) as usize;
                    let (x, y) = (bx + px, by + py);
                    if x < w && y < h {
                        let o = (y * w + x) * 4;
                        out[o..o + 4].copy_from_slice(&pal[idx]);
                    }
                }
            }
        }
    }
    out
}

pub fn decode_bc2(data: &[u8], w: usize, h: usize) -> Vec<u8> {
    let mut out = vec![0u8; w * h * 4];
    let mut p = 0;
    for by in (0..h).step_by(4) {
        for bx in (0..w).step_by(4) {
            if p + 16 > data.len() { return out; }
            let alpha = [data[p],data[p+1],data[p+2],data[p+3],data[p+4],data[p+5],data[p+6],data[p+7]];
            let c0 = u16le(data, p + 8); let c1 = u16le(data, p + 10);
            let bits = u32::from_le_bytes([data[p+12], data[p+13], data[p+14], data[p+15]]);
            p += 16;
            let (r0, g0, b0) = c565(c0); let (r1, g1, b1) = c565(c1);
            let pal = [
                [r0, g0, b0], [r1, g1, b1],
                [((2*r0 as u32 + r1 as u32)/3) as u8, ((2*g0 as u32 + g1 as u32)/3) as u8, ((2*b0 as u32 + b1 as u32)/3) as u8],
                [((r0 as u32 + 2*r1 as u32)/3) as u8, ((g0 as u32 + 2*g1 as u32)/3) as u8, ((b0 as u32 + 2*b1 as u32)/3) as u8],
            ];
            for py in 0..4 { for px in 0..4 {
                let i = py * 4 + px;
                let ci = ((bits >> (2 * i)) & 3) as usize;
                let nib = if i % 2 == 0 { alpha[i/2] & 0x0f } else { alpha[i/2] >> 4 };
                let a = (nib as u32 * 255 / 15) as u8;
                let (x, y) = (bx + px, by + py);
                if x < w && y < h { let o = (y*w+x)*4; out[o]=pal[ci][0]; out[o+1]=pal[ci][1]; out[o+2]=pal[ci][2]; out[o+3]=a; }
            }}
        }
    }
    out
}

pub fn decode_bc3(data: &[u8], w: usize, h: usize) -> Vec<u8> {
    let mut out = vec![0u8; w * h * 4];
    let mut p = 0;
    for by in (0..h).step_by(4) {
        for bx in (0..w).step_by(4) {
            if p + 16 > data.len() { return out; }
            let a0 = data[p] as u32; let a1 = data[p + 1] as u32;
            let mut abits: u64 = 0;
            for k in 0..6 { abits |= (data[p + 2 + k] as u64) << (8 * k); }
            let mut apal = [0u32; 8];
            apal[0] = a0; apal[1] = a1;
            if a0 > a1 {
                for k in 1..7 { apal[k + 1] = ((7 - k as u32) * a0 + k as u32 * a1) / 7; }
            } else {
                for k in 1..5 { apal[k + 1] = ((5 - k as u32) * a0 + k as u32 * a1) / 5; }
                apal[6] = 0; apal[7] = 255;
            }
            let c0 = u16le(data, p + 8); let c1 = u16le(data, p + 10);
            let bits = u32::from_le_bytes([data[p+12], data[p+13], data[p+14], data[p+15]]);
            p += 16;
            let (r0, g0, b0) = c565(c0); let (r1, g1, b1) = c565(c1);
            let pal = [
                [r0, g0, b0], [r1, g1, b1],
                [((2*r0 as u32 + r1 as u32)/3) as u8, ((2*g0 as u32 + g1 as u32)/3) as u8, ((2*b0 as u32 + b1 as u32)/3) as u8],
                [((r0 as u32 + 2*r1 as u32)/3) as u8, ((g0 as u32 + 2*g1 as u32)/3) as u8, ((b0 as u32 + 2*b1 as u32)/3) as u8],
            ];
            for py in 0..4 {
                for px in 0..4 {
                    let ci = ((bits >> (2 * (py * 4 + px))) & 3) as usize;
                    let ai = ((abits >> (3 * (py * 4 + px))) & 7) as usize;
                    let (x, y) = (bx + px, by + py);
                    if x < w && y < h {
                        let o = (y * w + x) * 4;
                        out[o] = pal[ci][0]; out[o+1] = pal[ci][1]; out[o+2] = pal[ci][2];
                        out[o+3] = apal[ai] as u8;
                    }
                }
            }
        }
    }
    out
}
