pub fn lzo1x_decompress(src: &[u8]) -> Vec<u8> {
    let mut out: Vec<u8> = Vec::with_capacity(src.len() * 3);
    let mut ip: usize = 0;
    let mut t: usize = 0;

    #[derive(PartialEq)]
    enum L { Start, Top, FirstLit, Match, MatchDone }
    let mut label = L::Start;

    macro_rules! lit { ($c:expr) => {{ let c = $c; out.extend_from_slice(&src[ip..ip + c]); ip += c; }} }
    macro_rules! mtch { ($m:expr, $c:expr) => {{ let mut m = $m; for _ in 0..$c { let b = out[m]; out.push(b); m += 1; } }} }

    loop {
        match label {
            L::Start => {
                if src[ip] as usize > 17 {
                    t = src[ip] as usize - 17; ip += 1; lit!(t);
                    label = L::FirstLit;
                } else { label = L::Top; }
            }
            L::Top => {
                t = src[ip] as usize; ip += 1;
                if t >= 16 { label = L::Match; }
                else {
                    if t == 0 {
                        while src[ip] == 0 { t += 255; ip += 1; }
                        t += 15 + src[ip] as usize; ip += 1;
                    }
                    lit!(t + 3);
                    label = L::FirstLit;
                }
            }
            L::FirstLit => {
                t = src[ip] as usize; ip += 1;
                if t >= 16 { label = L::Match; }
                else {
                    let m = out.len() - 0x801 - (t >> 2) - ((src[ip] as usize) << 2); ip += 1;
                    mtch!(m, 3);
                    label = L::MatchDone;
                }
            }
            L::Match => {
                let m: usize;
                let cnt: usize;
                if t >= 64 {
                    m = out.len() - 1 - ((t >> 2) & 7) - ((src[ip] as usize) << 3); ip += 1;
                    cnt = (t >> 5) - 1;
                } else if t >= 32 {
                    let mut c = t & 31;
                    if c == 0 {
                        while src[ip] == 0 { c += 255; ip += 1; }
                        c += 31 + src[ip] as usize; ip += 1;
                    }
                    m = out.len() - 1 - ((src[ip] as usize) >> 2) - ((src[ip + 1] as usize) << 6); ip += 2;
                    cnt = c;
                } else if t >= 16 {
                    let mut mm = out.len() as isize - (((t & 8) as isize) << 11);
                    let mut c = t & 7;
                    if c == 0 {
                        while src[ip] == 0 { c += 255; ip += 1; }
                        c += 7 + src[ip] as usize; ip += 1;
                    }
                    mm -= ((src[ip] as isize) >> 2) + ((src[ip + 1] as isize) << 6); ip += 2;
                    if mm as usize == out.len() { break; }
                    mm -= 0x4000;
                    m = mm as usize;
                    cnt = c;
                } else {
                    let mm = out.len() - 1 - (t >> 2) - ((src[ip] as usize) << 2); ip += 1;
                    mtch!(mm, 2);
                    label = L::MatchDone;
                    continue;
                }
                mtch!(m, cnt + 2);
                label = L::MatchDone;
            }
            L::MatchDone => {
                let st = (src[ip - 2] & 3) as usize;
                if st == 0 { label = L::Top; }
                else { lit!(st); t = src[ip] as usize; ip += 1; label = L::Match; }
            }
        }
    }
    out
}
