// LZO1X decompressor, hardened: never panics on truncated/corrupt input.
// Out-of-range source reads return 0, literal copies are clamped, back-references
// are bounds-checked, and an iteration cap prevents infinite loops. For valid
// streams the behavior is identical to the unguarded version.
pub fn lzo1x_decompress(src: &[u8]) -> Vec<u8> {
    let mut out: Vec<u8> = Vec::with_capacity(src.len().saturating_mul(3));
    let mut ip: usize = 0;
    let mut t: usize = 0;
    let b = |s: &[u8], i: usize| -> usize { s.get(i).copied().map(|x| x as usize).unwrap_or(0) };

    #[derive(PartialEq)]
    enum L { Start, Top, FirstLit, Match, MatchDone }
    let mut label = L::Start;

    macro_rules! lit { ($c:expr) => {{
        let c = $c;
        let end = (ip + c).min(src.len());
        if ip < end { out.extend_from_slice(&src[ip..end]); }
        ip += c;
    }} }
    macro_rules! mtch { ($m:expr, $c:expr) => {{
        let mut m = $m;
        if m >= out.len() { break; }
        for _ in 0..$c { let bb = out[m]; out.push(bb); m += 1; }
    }} }

    let cap = src.len().saturating_mul(64) + 4096;
    let mut iters = 0usize;
    loop {
        iters += 1;
        if iters > cap || ip > src.len() { break; }
        match label {
            L::Start => {
                if b(src, ip) > 17 {
                    t = b(src, ip) - 17; ip += 1;
                    if t < 4 { lit!(t); t = b(src, ip); ip += 1; label = L::Match; }
                    else { lit!(t); label = L::FirstLit; }
                } else { label = L::Top; }
            }
            L::Top => {
                t = b(src, ip); ip += 1;
                if t >= 16 { label = L::Match; }
                else {
                    if t == 0 {
                        while ip < src.len() && b(src, ip) == 0 { t += 255; ip += 1; }
                        t += 15 + b(src, ip); ip += 1;
                    }
                    lit!(t + 3);
                    label = L::FirstLit;
                }
            }
            L::FirstLit => {
                t = b(src, ip); ip += 1;
                if t >= 16 { label = L::Match; }
                else {
                    let m = out.len().wrapping_sub(0x801).wrapping_sub(t >> 2).wrapping_sub(b(src, ip) << 2); ip += 1;
                    mtch!(m, 3);
                    label = L::MatchDone;
                }
            }
            L::Match => {
                let m: usize;
                let cnt: usize;
                if t >= 64 {
                    m = out.len().wrapping_sub(1).wrapping_sub((t >> 2) & 7).wrapping_sub(b(src, ip) << 3); ip += 1;
                    cnt = (t >> 5) - 1;
                } else if t >= 32 {
                    let mut c = t & 31;
                    if c == 0 {
                        while ip < src.len() && b(src, ip) == 0 { c += 255; ip += 1; }
                        c += 31 + b(src, ip); ip += 1;
                    }
                    m = out.len().wrapping_sub(1).wrapping_sub(b(src, ip) >> 2).wrapping_sub(b(src, ip + 1) << 6); ip += 2;
                    cnt = c;
                } else if t >= 16 {
                    let mut mm = out.len() as isize - (((t & 8) as isize) << 11);
                    let mut c = t & 7;
                    if c == 0 {
                        while ip < src.len() && b(src, ip) == 0 { c += 255; ip += 1; }
                        c += 7 + b(src, ip); ip += 1;
                    }
                    mm -= ((b(src, ip) as isize) >> 2) + ((b(src, ip + 1) as isize) << 6); ip += 2;
                    if mm as usize == out.len() { break; }
                    mm -= 0x4000;
                    m = mm as usize;
                    cnt = c;
                } else {
                    let mm = out.len().wrapping_sub(1).wrapping_sub(t >> 2).wrapping_sub(b(src, ip) << 2); ip += 1;
                    mtch!(mm, 2);
                    label = L::MatchDone;
                    continue;
                }
                mtch!(m, cnt + 2);
                label = L::MatchDone;
            }
            L::MatchDone => {
                let st = (b(src, ip.wrapping_sub(2)) & 3) as usize;
                if st == 0 { label = L::Top; }
                else { lit!(st); t = b(src, ip); ip += 1; label = L::Match; }
            }
        }
    }
    out
}
