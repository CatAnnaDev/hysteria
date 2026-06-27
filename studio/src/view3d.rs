// A tiny software 3D rasterizer (z-buffered, Lambert-shaded) — no GPU backend, in the same
// from-scratch spirit as the DXT/LZO code. It renders into an RGBA buffer that the egui app
// uploads as a texture. The same pipeline that draws actor blockout boxes today will draw
// real BSP/StaticMesh triangles once those parsers land.

pub type V3 = [f32; 3];
pub type M4 = [f32; 16]; // column-major

pub fn sub(a: V3, b: V3) -> V3 { [a[0] - b[0], a[1] - b[1], a[2] - b[2]] }
pub fn add(a: V3, b: V3) -> V3 { [a[0] + b[0], a[1] + b[1], a[2] + b[2]] }
pub fn scl(a: V3, s: f32) -> V3 { [a[0] * s, a[1] * s, a[2] * s] }
pub fn dot(a: V3, b: V3) -> f32 { a[0] * b[0] + a[1] * b[1] + a[2] * b[2] }
pub fn cross(a: V3, b: V3) -> V3 { [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]] }
pub fn norm(a: V3) -> V3 { let l = dot(a, a).sqrt(); if l > 1e-6 { scl(a, 1.0 / l) } else { a } }

pub fn mul(a: &M4, b: &M4) -> M4 {
    let mut r = [0.0f32; 16];
    for c in 0..4 { for row in 0..4 {
        let mut s = 0.0;
        for k in 0..4 { s += a[k * 4 + row] * b[c * 4 + k]; }
        r[c * 4 + row] = s;
    }}
    r
}

pub fn perspective(fovy: f32, aspect: f32, near: f32, far: f32) -> M4 {
    let f = 1.0 / (fovy * 0.5).tan();
    let mut m = [0.0f32; 16];
    m[0] = f / aspect; m[5] = f;
    m[10] = (far + near) / (near - far); m[11] = -1.0;
    m[14] = (2.0 * far * near) / (near - far);
    m
}

pub fn look_at(eye: V3, center: V3, up: V3) -> M4 {
    let f = norm(sub(center, eye));
    let s = norm(cross(f, up));
    let u = cross(s, f);
    [s[0], u[0], -f[0], 0.0,
     s[1], u[1], -f[1], 0.0,
     s[2], u[2], -f[2], 0.0,
     -dot(s, eye), -dot(u, eye), dot(f, eye), 1.0]
}

// world point -> clip space [x, y, z, w]
fn xform(m: &M4, p: V3) -> [f32; 4] {
    [m[0] * p[0] + m[4] * p[1] + m[8] * p[2] + m[12],
     m[1] * p[0] + m[5] * p[1] + m[9] * p[2] + m[13],
     m[2] * p[0] + m[6] * p[1] + m[10] * p[2] + m[14],
     m[3] * p[0] + m[7] * p[1] + m[11] * p[2] + m[15]]
}

// Project a world point to raster pixel coords (origin top-left), or None if behind camera.
pub fn project_screen(vp: &M4, p: V3, w: f32, h: f32) -> Option<(f32, f32)> {
    let c = xform(vp, p);
    if c[3] <= 0.01 { return None; }
    let inv = 1.0 / c[3];
    Some(((c[0] * inv * 0.5 + 0.5) * w, (1.0 - (c[1] * inv * 0.5 + 0.5)) * h))
}

// Orbit camera around a target. UE is Z-up; scene positions are pre-swizzled to Y-up.
pub struct Cam {
    pub target: V3,
    pub yaw: f32,
    pub pitch: f32,
    pub dist: f32,
}

impl Cam {
    pub fn eye(&self) -> V3 {
        let cp = self.pitch.cos();
        add(self.target, scl([self.yaw.cos() * cp, self.pitch.sin(), self.yaw.sin() * cp], self.dist))
    }
    pub fn view_proj(&self, aspect: f32) -> M4 {
        let v = look_at(self.eye(), self.target, [0.0, 1.0, 0.0]);
        let p = perspective(60f32.to_radians(), aspect.max(0.01), (self.dist * 0.005).max(0.05), self.dist * 20.0 + 1000.0);
        mul(&p, &v)
    }
}

pub struct Tri { pub p: [V3; 3], pub uv: [[f32; 2]; 3], pub tex: i32, pub color: [u8; 3], pub light: [f32; 3] }

pub struct Tex { pub w: usize, pub h: usize, pub rgba: Vec<u8> }

// A point light from the map (position pre-swizzled to render Y-up; colour linear).
pub struct Light { pub pos: V3, pub color: [f32; 3], pub brightness: f32, pub radius: f32 }

pub struct Scene {
    pub tris: Vec<Tri>,
    pub lines: Vec<(V3, V3, [u8; 3])>,
    pub textures: Vec<Tex>,
    pub lights: Vec<Light>,
}

impl Scene {
    pub fn new() -> Self { Scene { tris: Vec::new(), lines: Vec::new(), textures: Vec::new(), lights: Vec::new() } }

    // Bake per-triangle lighting once (cheap, at scene build): a small sky/ground ambient plus
    // every point light attenuated by distance and N·L. Stored in Tri.light as a linear
    // multiplier on the albedo — recreates Alice's localized, coloured, moody lighting.
    pub fn bake_lighting(&mut self) {
        for t in self.tris.iter_mut() {
            let (a, b, c) = (t.p[0], t.p[1], t.p[2]);
            let n = norm(cross(sub(b, a), sub(c, a)));
            let ctr = [(a[0] + b[0] + c[0]) / 3.0, (a[1] + b[1] + c[1]) / 3.0, (a[2] + b[2] + c[2]) / 3.0];
            let hemi = 0.5 + 0.5 * n[1].clamp(-1.0, 1.0);
            let mut acc = [0.16 + 0.12 * hemi; 3];          // cool sky/ground ambient
            acc[2] += 0.03;                                  // faint cool tint in shadow
            for l in &self.lights {
                let d = sub(l.pos, ctr);
                let dist = dot(d, d).sqrt().max(1.0);
                if dist > l.radius { continue; }
                let atten = (1.0 - (dist / l.radius)).clamp(0.0, 1.0);
                let atten = atten * atten;
                let ndl = (dot(n, scl(d, 1.0 / dist))).abs();
                let e = l.brightness * ndl * atten;
                for k in 0..3 { acc[k] += l.color[k] * e; }
            }
            t.light = acc;
        }
    }

    // Axis-aligned box (8 corners) as 12 shaded triangles, centred at c with half-extents h.
    pub fn box_solid(&mut self, c: V3, h: V3, color: [u8; 3]) {
        let v = [
            [c[0]-h[0], c[1]-h[1], c[2]-h[2]], [c[0]+h[0], c[1]-h[1], c[2]-h[2]],
            [c[0]+h[0], c[1]-h[1], c[2]+h[2]], [c[0]-h[0], c[1]-h[1], c[2]+h[2]],
            [c[0]-h[0], c[1]+h[1], c[2]-h[2]], [c[0]+h[0], c[1]+h[1], c[2]-h[2]],
            [c[0]+h[0], c[1]+h[1], c[2]+h[2]], [c[0]-h[0], c[1]+h[1], c[2]+h[2]],
        ];
        let faces = [[0,1,2,3],[4,6,5,4],[4,5,1,0],[6,7,3,2],[5,6,2,1],[7,4,0,3]];
        let z = [[0.0f32; 2]; 3];
        for f in faces {
            self.tris.push(Tri { p: [v[f[0]], v[f[1]], v[f[2]]], uv: z, tex: -1, color, light: [1.0; 3] });
            self.tris.push(Tri { p: [v[f[0]], v[f[2]], v[f[3]]], uv: z, tex: -1, color, light: [1.0; 3] });
        }
    }
}

const EXPOSURE: f32 = 1.5;

fn lin_to_srgb(x: f32) -> u8 {
    let x = (x / (1.0 + x)).clamp(0.0, 1.0);                  // Reinhard tonemap then encode
    let s = if x <= 0.0031308 { x * 12.92 } else { 1.055 * x.powf(1.0 / 2.4) - 0.055 };
    (s * 255.0 + 0.5).clamp(0.0, 255.0) as u8
}

const FOG_COL: [f32; 3] = [40.0, 44.0, 58.0]; // matches the horizon sky, distant geometry fades into it

fn apply_fog(c: [u8; 3], invw: f32, density: f32) -> [u8; 3] {
    if density <= 0.0 { return c; }
    let vd = 1.0 / invw.max(1e-6);
    let f = (1.0 - (-density * vd).exp()).clamp(0.0, 0.9);
    [
        (c[0] as f32 * (1.0 - f) + FOG_COL[0] * f) as u8,
        (c[1] as f32 * (1.0 - f) + FOG_COL[1] * f) as u8,
        (c[2] as f32 * (1.0 - f) + FOG_COL[2] * f) as u8,
    ]
}

pub struct Raster {
    pub w: usize,
    pub h: usize,
    pub col: Vec<u8>,
    pub z: Vec<f32>,
    lut: [f32; 256], // sRGB byte -> linear, so light math happens in linear space
    fog: f32,
}

impl Raster {
    pub fn new(w: usize, h: usize) -> Self {
        let mut lut = [0.0f32; 256];
        for (i, e) in lut.iter_mut().enumerate() {
            let x = i as f32 / 255.0;
            *e = if x <= 0.04045 { x / 12.92 } else { ((x + 0.055) / 1.055).powf(2.4) };
        }
        Raster { w, h, col: vec![0; w * h * 4], z: vec![f32::INFINITY; w * h], lut, fog: 0.0 }
    }

    fn clear(&mut self, top: [u8; 3], bot: [u8; 3]) {
        for y in 0..self.h {
            let f = y as f32 / (self.h.max(1) - 1).max(1) as f32;
            let c = [
                (top[0] as f32 * (1.0 - f) + bot[0] as f32 * f) as u8,
                (top[1] as f32 * (1.0 - f) + bot[1] as f32 * f) as u8,
                (top[2] as f32 * (1.0 - f) + bot[2] as f32 * f) as u8,
            ];
            for x in 0..self.w {
                let o = (y * self.w + x) * 4;
                self.col[o] = c[0]; self.col[o + 1] = c[1]; self.col[o + 2] = c[2]; self.col[o + 3] = 255;
            }
        }
        for d in self.z.iter_mut() { *d = f32::INFINITY; }
    }

    pub fn render(&mut self, scene: &Scene, vp: &M4, fog_density: f32) {
        self.clear([54, 58, 74], [22, 22, 30]); // bluish Alice sky -> dark horizon
        self.fog = fog_density;
        let (fw, fh) = (self.w as f32, self.h as f32);
        let project = |p: V3| -> Option<(f32, f32, f32, f32)> {
            let c = xform(vp, p);
            if c[3] <= 0.01 { return None; }
            let inv = 1.0 / c[3];
            let sx = (c[0] * inv * 0.5 + 0.5) * fw;
            let sy = (1.0 - (c[1] * inv * 0.5 + 0.5)) * fh;
            Some((sx, sy, c[2] * inv, inv)) // 4th = 1/w for perspective-correct interpolation
        };
        for t in &scene.tris {
            let (pa, pb, pc) = match (project(t.p[0]), project(t.p[1]), project(t.p[2])) {
                (Some(x), Some(y), Some(z)) => (x, y, z),
                _ => continue,
            };
            let lit = [t.light[0] * EXPOSURE, t.light[1] * EXPOSURE, t.light[2] * EXPOSURE];
            if t.tex >= 0 && (t.tex as usize) < scene.textures.len() {
                self.triangle_tex(pa, pb, pc, &t.uv, &scene.textures[t.tex as usize], lit);
            } else {
                let l = self.lut;
                let col = [lin_to_srgb(l[t.color[0] as usize] * lit[0]), lin_to_srgb(l[t.color[1] as usize] * lit[1]), lin_to_srgb(l[t.color[2] as usize] * lit[2])];
                self.triangle(pa, pb, pc, col);
            }
        }
        for (a, b, col) in &scene.lines {
            if let (Some(pa), Some(pb)) = (project(*a), project(*b)) {
                self.line(pa.0, pa.1, pa.2, pb.0, pb.1, pb.2, *col);
            }
        }
    }

    fn triangle(&mut self, a: (f32, f32, f32, f32), b: (f32, f32, f32, f32), c: (f32, f32, f32, f32), col: [u8; 3]) {
        let area = (b.0 - a.0) * (c.1 - a.1) - (b.1 - a.1) * (c.0 - a.0);
        if area.abs() < 1e-4 { return; }
        let inv = 1.0 / area;
        let minx = a.0.min(b.0).min(c.0).floor().max(0.0) as usize;
        let maxx = a.0.max(b.0).max(c.0).ceil().min(self.w as f32 - 1.0) as usize;
        let miny = a.1.min(b.1).min(c.1).floor().max(0.0) as usize;
        let maxy = a.1.max(b.1).max(c.1).ceil().min(self.h as f32 - 1.0) as usize;
        if minx > maxx || miny > maxy { return; }
        for y in miny..=maxy {
            for x in minx..=maxx {
                let px = x as f32 + 0.5; let py = y as f32 + 0.5;
                let w0 = ((b.0 - px) * (c.1 - py) - (b.1 - py) * (c.0 - px)) * inv;
                let w1 = ((c.0 - px) * (a.1 - py) - (c.1 - py) * (a.0 - px)) * inv;
                let w2 = 1.0 - w0 - w1;
                if w0 < 0.0 || w1 < 0.0 || w2 < 0.0 { continue; }
                let depth = w0 * a.2 + w1 * b.2 + w2 * c.2;
                let idx = y * self.w + x;
                if depth < self.z[idx] {
                    self.z[idx] = depth;
                    let o = idx * 4;
                    let iw = w0 * a.3 + w1 * b.3 + w2 * c.3;
                    let c = apply_fog(col, iw, self.fog);
                    self.col[o] = c[0]; self.col[o + 1] = c[1]; self.col[o + 2] = c[2]; self.col[o + 3] = 255;
                }
            }
        }
    }

    // Perspective-correct textured triangle: bilinear-sample the texture (wrapping), alpha-test,
    // then light in linear space (texel sRGB->linear * lit, tonemap+encode).
    fn triangle_tex(&mut self, a: (f32, f32, f32, f32), b: (f32, f32, f32, f32), c: (f32, f32, f32, f32), uv: &[[f32; 2]; 3], tex: &Tex, lit: [f32; 3]) {
        if tex.w == 0 || tex.h == 0 { return; }
        let area = (b.0 - a.0) * (c.1 - a.1) - (b.1 - a.1) * (c.0 - a.0);
        if area.abs() < 1e-4 { return; }
        let inv = 1.0 / area;
        let minx = a.0.min(b.0).min(c.0).floor().max(0.0) as usize;
        let maxx = a.0.max(b.0).max(c.0).ceil().min(self.w as f32 - 1.0) as usize;
        let miny = a.1.min(b.1).min(c.1).floor().max(0.0) as usize;
        let maxy = a.1.max(b.1).max(c.1).ceil().min(self.h as f32 - 1.0) as usize;
        if minx > maxx || miny > maxy { return; }
        let (uwa, vwa) = (uv[0][0] * a.3, uv[0][1] * a.3);
        let (uwb, vwb) = (uv[1][0] * b.3, uv[1][1] * b.3);
        let (uwc, vwc) = (uv[2][0] * c.3, uv[2][1] * c.3);
        for y in miny..=maxy {
            for x in minx..=maxx {
                let px = x as f32 + 0.5; let py = y as f32 + 0.5;
                let w0 = ((b.0 - px) * (c.1 - py) - (b.1 - py) * (c.0 - px)) * inv;
                let w1 = ((c.0 - px) * (a.1 - py) - (c.1 - py) * (a.0 - px)) * inv;
                let w2 = 1.0 - w0 - w1;
                if w0 < 0.0 || w1 < 0.0 || w2 < 0.0 { continue; }
                let depth = w0 * a.2 + w1 * b.2 + w2 * c.2;
                let idx = y * self.w + x;
                if depth >= self.z[idx] { continue; }
                let iw = w0 * a.3 + w1 * b.3 + w2 * c.3;
                if iw.abs() < 1e-12 { continue; }
                let u = (w0 * uwa + w1 * uwb + w2 * uwc) / iw;
                let v = (w0 * vwa + w1 * vwb + w2 * vwc) / iw;
                // bilinear fetch with wrap, in linear space
                let fu = (u - u.floor()) * tex.w as f32 - 0.5;
                let fv = (v - v.floor()) * tex.h as f32 - 0.5;
                let (x0t, y0t) = (fu.floor(), fv.floor());
                let (du, dv) = (fu - x0t, fv - y0t);
                let wrap = |i: i32, n: usize| ((i % n as i32 + n as i32) % n as i32) as usize;
                let (ix0, ix1) = (wrap(x0t as i32, tex.w), wrap(x0t as i32 + 1, tex.w));
                let (iy0, iy1) = (wrap(y0t as i32, tex.h), wrap(y0t as i32 + 1, tex.h));
                let texel = |tx: usize, ty: usize| -> [f32; 4] {
                    let o = (ty * tex.w + tx) * 4;
                    [self.lut[tex.rgba[o] as usize], self.lut[tex.rgba[o + 1] as usize], self.lut[tex.rgba[o + 2] as usize], tex.rgba[o + 3] as f32]
                };
                let (t00, t10, t01, t11) = (texel(ix0, iy0), texel(ix1, iy0), texel(ix0, iy1), texel(ix1, iy1));
                let mut s = [0.0f32; 4];
                for k in 0..4 {
                    s[k] = (t00[k] * (1.0 - du) + t10[k] * du) * (1.0 - dv) + (t01[k] * (1.0 - du) + t11[k] * du) * dv;
                }
                if s[3] < 110.0 { continue; }            // masked-material alpha test
                self.z[idx] = depth;
                let o = idx * 4;
                let c = apply_fog([lin_to_srgb(s[0] * lit[0]), lin_to_srgb(s[1] * lit[1]), lin_to_srgb(s[2] * lit[2])], iw, self.fog);
                self.col[o] = c[0]; self.col[o + 1] = c[1]; self.col[o + 2] = c[2]; self.col[o + 3] = 255;
            }
        }
    }

    fn line(&mut self, x0: f32, y0: f32, z0: f32, x1: f32, y1: f32, z1: f32, col: [u8; 3]) {
        let steps = (x1 - x0).abs().max((y1 - y0).abs()).ceil().max(1.0);
        let n = (steps as usize).min(4096);
        for i in 0..=n {
            let t = i as f32 / steps;
            let x = (x0 + (x1 - x0) * t).round();
            let y = (y0 + (y1 - y0) * t).round();
            if x < 0.0 || y < 0.0 || x >= self.w as f32 || y >= self.h as f32 { continue; }
            let (xi, yi) = (x as usize, y as usize);
            let idx = yi * self.w + xi;
            let depth = z0 + (z1 - z0) * t - 0.0008; // small bias so lines sit over faces
            if depth <= self.z[idx] {
                let o = idx * 4;
                self.col[o] = col[0]; self.col[o + 1] = col[1]; self.col[o + 2] = col[2]; self.col[o + 3] = 255;
            }
        }
    }
}
