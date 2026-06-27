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

pub struct Tri { pub p: [V3; 3], pub color: [u8; 3] }

pub struct Scene {
    pub tris: Vec<Tri>,
    pub lines: Vec<(V3, V3, [u8; 3])>,
}

impl Scene {
    pub fn new() -> Self { Scene { tris: Vec::new(), lines: Vec::new() } }

    // Axis-aligned box (8 corners) as 12 shaded triangles, centred at c with half-extents h.
    pub fn box_solid(&mut self, c: V3, h: V3, color: [u8; 3]) {
        let v = [
            [c[0]-h[0], c[1]-h[1], c[2]-h[2]], [c[0]+h[0], c[1]-h[1], c[2]-h[2]],
            [c[0]+h[0], c[1]-h[1], c[2]+h[2]], [c[0]-h[0], c[1]-h[1], c[2]+h[2]],
            [c[0]-h[0], c[1]+h[1], c[2]-h[2]], [c[0]+h[0], c[1]+h[1], c[2]-h[2]],
            [c[0]+h[0], c[1]+h[1], c[2]+h[2]], [c[0]-h[0], c[1]+h[1], c[2]+h[2]],
        ];
        let faces = [[0,1,2,3],[4,6,5,4],[4,5,1,0],[6,7,3,2],[5,6,2,1],[7,4,0,3]];
        for f in faces {
            self.tris.push(Tri { p: [v[f[0]], v[f[1]], v[f[2]]], color });
            self.tris.push(Tri { p: [v[f[0]], v[f[2]], v[f[3]]], color });
        }
    }
}

pub struct Raster {
    pub w: usize,
    pub h: usize,
    pub col: Vec<u8>,
    pub z: Vec<f32>,
}

impl Raster {
    pub fn new(w: usize, h: usize) -> Self {
        Raster { w, h, col: vec![0; w * h * 4], z: vec![f32::INFINITY; w * h] }
    }

    fn clear(&mut self, bg: [u8; 3]) {
        for px in self.col.chunks_exact_mut(4) { px[0] = bg[0]; px[1] = bg[1]; px[2] = bg[2]; px[3] = 255; }
        for d in self.z.iter_mut() { *d = f32::INFINITY; }
    }

    pub fn render(&mut self, scene: &Scene, vp: &M4, bg: [u8; 3]) {
        self.clear(bg);
        let light = norm([0.4, 0.85, 0.35]);
        let (fw, fh) = (self.w as f32, self.h as f32);
        // project a world point to (sx, sy, depth, w); None if behind near plane
        let project = |p: V3| -> Option<(f32, f32, f32, f32)> {
            let c = xform(vp, p);
            if c[3] <= 0.01 { return None; }
            let inv = 1.0 / c[3];
            let sx = (c[0] * inv * 0.5 + 0.5) * fw;
            let sy = (1.0 - (c[1] * inv * 0.5 + 0.5)) * fh;
            Some((sx, sy, c[2] * inv, c[3]))
        };
        for t in &scene.tris {
            let (a, b, cc) = (t.p[0], t.p[1], t.p[2]);
            let n = norm(cross(sub(b, a), sub(cc, a)));
            // hemisphere ambient (brighter from above) + a two-sided key light, so untextured
            // grey geometry still reads its form. Warm the lit side slightly.
            let key = dot(n, light).abs();
            let hemi = 0.5 + 0.5 * n[1].clamp(-1.0, 1.0);
            let shade = (0.20 + 0.46 * hemi + 0.40 * key).min(1.15);
            let warm = 1.0 + 0.06 * key;
            let col = [
                ((t.color[0] as f32 * shade * warm).min(255.0)) as u8,
                ((t.color[1] as f32 * shade).min(255.0)) as u8,
                ((t.color[2] as f32 * shade * (2.0 - warm)).min(255.0)) as u8,
            ];
            let (pa, pb, pc) = match (project(a), project(b), project(cc)) {
                (Some(x), Some(y), Some(z)) => (x, y, z),
                _ => continue,
            };
            self.triangle(pa, pb, pc, col);
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
                    self.col[o] = col[0]; self.col[o + 1] = col[1]; self.col[o + 2] = col[2]; self.col[o + 3] = 255;
                }
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
