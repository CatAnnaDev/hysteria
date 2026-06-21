#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
mod lzo;
mod upk;
mod dxt;

use std::path::PathBuf;
use upk::Pkg;

const DEFAULT_DIR: &str = "/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/AliceGame/CookedPC";

struct App {
    game_dir: Option<PathBuf>,
    packages: Vec<PathBuf>,
    pkg_filter: String,
    sel_pkg: Option<usize>,
    pkg: Option<Pkg>,
    obj_filter: String,
    sel_obj: Option<usize>,
    status: String,
    tex_handle: Option<egui::TextureHandle>,
    tex_for: Option<(usize, usize)>,
    tex_px: Option<(usize, usize, Vec<u8>)>,
    props: Vec<upk::PropEdit>,
    props_for: Option<(usize, usize)>,
    dirty: bool,
    audio: Option<(rodio::OutputStream, rodio::OutputStreamHandle)>,
    sink: Option<rodio::Sink>,
}

impl Default for App {
    fn default() -> Self {
        let mut a = App {
            game_dir: None, packages: vec![], pkg_filter: String::new(),
            sel_pkg: None, pkg: None, obj_filter: String::new(), sel_obj: None,
            status: "Open a game CookedPC folder to begin.".into(),
            tex_handle: None, tex_for: None, tex_px: None,
            props: vec![], props_for: None, dirty: false,
            audio: None, sink: None,
        };
        let d = PathBuf::from(DEFAULT_DIR);
        if d.is_dir() { a.scan(d); }
        a
    }
}

impl App {
    fn scan(&mut self, dir: PathBuf) {
        let mut out = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) {
                for e in rd.flatten() {
                        let p = e.path();
                        if p.is_dir() { walk(&p, out); }
                    else if let Some(x) = p.extension() {
                        let x = x.to_string_lossy().to_lowercase();
                        if x == "upk" || x == "xxx" || x == "umap" { out.push(p); }
                    }
                }
            }
        }
        walk(&dir, &mut out);
        out.sort();
        self.status = format!("{} packages found in {}", out.len(), dir.display());
        self.packages = out;
        self.game_dir = Some(dir);
        self.sel_pkg = None; self.pkg = None; self.sel_obj = None;
    }

    fn load_pkg(&mut self, idx: usize) {
        let path = self.packages[idx].clone();
        let res = std::panic::catch_unwind(|| Pkg::load(&path))
            .unwrap_or_else(|_| Err("parser panicked (unsupported package layout)".into()));
        match res {
            Ok(p) => {
                self.status = format!("{}: ver {} | {} names, {} imports, {} exports ({} KB decompressed)",
                    path.file_name().unwrap().to_string_lossy(), p.ver, p.names.len(),
                    p.imports.len(), p.exports.len(), p.buf.len() / 1024);
                self.pkg = Some(p); self.sel_pkg = Some(idx); self.sel_obj = None;
            }
            Err(e) => { self.status = format!("ERROR loading {}: {}", path.display(), e); }
        }
    }
}

impl eframe::App for App {
    fn update(&mut self, ctx: &egui::Context, _f: &mut eframe::Frame) {
        let need = match (&self.pkg, self.sel_pkg, self.sel_obj) {
            (Some(p), Some(pi), Some(oi)) if p.exports[oi].class_name == "Texture2D" => Some((pi, oi)),
            _ => None,
        };
        if need != self.tex_for {
            self.tex_for = need; self.tex_handle = None; self.tex_px = None;
            if let (Some(p), Some(oi), Some(dir)) = (&self.pkg, self.sel_obj, &self.game_dir) {
                let decoded = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| p.texture(&p.exports[oi], dir))).ok().flatten();
                if let Some(t) = decoded {
                    let img = egui::ColorImage::from_rgba_unmultiplied([t.w, t.h], &t.rgba);
                    self.tex_handle = Some(ctx.load_texture("preview", img, egui::TextureOptions::LINEAR));
                    self.tex_px = Some((t.w, t.h, t.rgba));
                }
            }
        }
        let pneed = match (self.sel_pkg, self.sel_obj) { (Some(pi), Some(oi)) => Some((pi, oi)), _ => None };
        if pneed != self.props_for {
            self.props_for = pneed;
            self.props = match (&self.pkg, self.sel_obj) {
                (Some(p), Some(oi)) => p.props_editable(p.exports[oi].off),
                _ => vec![],
            };
        }

        egui::TopBottomPanel::top("top").show(ctx, |ui| {
            ui.horizontal(|ui| {
                ui.heading("Hysteria Studio");
                if ui.button("Open game folder...").clicked() {
                    if let Some(d) = rfd::FileDialog::new().pick_folder() { self.scan(d); }
                }
                if let Some(d) = &self.game_dir { ui.label(d.display().to_string()); }
            });
            ui.label(&self.status);
        });

        egui::SidePanel::left("packages").default_width(320.0).show(ctx, |ui| {
            ui.label(format!("Packages ({})", self.packages.len()));
            ui.text_edit_singleline(&mut self.pkg_filter);
            egui::ScrollArea::vertical().show(ui, |ui| {
                let filt = self.pkg_filter.to_lowercase();
                let mut to_load = None;
                for (i, p) in self.packages.iter().enumerate() {
                    let name = p.file_name().unwrap().to_string_lossy().to_string();
                    if !filt.is_empty() && !name.to_lowercase().contains(&filt) { continue; }
                    if ui.selectable_label(self.sel_pkg == Some(i), name).clicked() { to_load = Some(i); }
                }
                if let Some(i) = to_load { self.load_pkg(i); }
            });
        });

        let mut do_apply = false;
        let mut do_save = false;
        let mut do_replace = false;
        let mut play_data: Option<Vec<u8>> = None;
        let mut do_stop = false;
        let mut do_sndreplace = false;
        egui::SidePanel::right("details").default_width(360.0).show(ctx, |ui| {
            ui.heading("Object");
            if let (Some(pkg), Some(oi)) = (&self.pkg, self.sel_obj) {
                let e = &pkg.exports[oi];
                ui.label(format!("Name:  {}", e.name));
                ui.label(format!("Class: {}", e.class_name));
                ui.label(format!("Serial size: {} bytes", e.size));
                ui.separator();
                ui.horizontal(|ui| {
                    ui.strong("Properties (editable)");
                    if ui.button("Apply").clicked() { do_apply = true; }
                });
                egui::ScrollArea::vertical().max_height(180.0).id_salt("props").show(ui, |ui| {
                    egui::Grid::new("propgrid").striped(true).num_columns(2).show(ui, |ui| {
                        for row in &mut self.props {
                            ui.label(&row.name);
                            if row.kind != 0 {
                                ui.add(egui::TextEdit::singleline(&mut row.value).desired_width(150.0));
                            } else {
                                ui.label(&row.value);
                            }
                            ui.end_row();
                        }
                        if self.props.is_empty() { ui.label("(none)"); ui.end_row(); }
                    });
                });
                if let Some(handle) = &self.tex_handle {
                    ui.separator();
                    if let Some((w, h, _)) = &self.tex_px { ui.strong(format!("Texture {}x{}", w, h)); }
                    let s = handle.size_vec2();
                    let k = (300.0 / s.x).min(300.0 / s.y).min(1.0);
                    ui.image((handle.id(), s * k));
                    ui.horizontal(|ui| {
                        if ui.button("Export PNG").clicked() {
                            if let Some((w, h, rgba)) = &self.tex_px {
                                if let Some(p) = rfd::FileDialog::new().set_file_name(format!("{}.png", e.name)).save_file() {
                                    let _ = image::save_buffer(&p, rgba, *w as u32, *h as u32, image::ColorType::Rgba8);
                                    self.status = format!("exported {}x{} PNG -> {}", w, h, p.display());
                                }
                            }
                        }
                        if ui.button("Import PNG (replace)").clicked() { do_replace = true; }
                    });
                }
                if e.class_name == "SoundNodeWave" {
                    ui.separator();
                    ui.strong("Audio");
                    ui.horizontal(|ui| {
                        if ui.button("Play").clicked() {
                            if let Some((data, _)) = pkg.sound_data(e) { play_data = Some(data); }
                        }
                        if ui.button("Stop").clicked() { do_stop = true; }
                        if ui.button("Import (replace)").clicked() { do_sndreplace = true; }
                        if ui.button("Export").clicked() {
                            if let Some((data, ext)) = pkg.sound_data(e) {
                                if let Some(p) = rfd::FileDialog::new().set_file_name(format!("{}.{}", e.name, ext)).save_file() {
                                    let _ = std::fs::write(&p, &data);
                                    self.status = format!("exported {} ({} bytes) -> {}", ext, data.len(), p.display());
                                }
                            } else { self.status = "no embedded audio found".into(); }
                        }
                    });
                }
                ui.separator();
                if ui.button("Dump raw serial data...").clicked() {
                    let off = e.off as usize; let sz = e.size as usize;
                    if off + sz <= pkg.buf.len() {
                        if let Some(path) = rfd::FileDialog::new().set_file_name(format!("{}.bin", e.name)).save_file() {
                            let _ = std::fs::write(&path, &pkg.buf[off..off + sz]);
                            self.status = format!("dumped {} bytes -> {}", sz, path.display());
                        }
                    }
                }
            } else {
                ui.label("Select an object in the table.");
            }
            ui.separator();
            ui.heading("Package");
            if self.pkg.is_some() {
                if self.dirty { ui.colored_label(egui::Color32::from_rgb(255, 210, 90), "modified (unsaved)"); }
                if ui.button("Save package (loads in-game)...").clicked() { do_save = true; }
                ui.label("(uncompressed .upk with your edits — overwrite the original to deploy)");
            }
        });
        if do_apply {
            if let Some(pkg) = &mut self.pkg {
                let mut n = 0;
                for row in &self.props {
                    let o = row.off;
                    match row.kind {
                        1 => if let Ok(v) = row.value.trim().parse::<i32>() { pkg.buf[o..o+4].copy_from_slice(&v.to_le_bytes()); n += 1; },
                        2 => if let Ok(v) = row.value.trim().parse::<f32>() { pkg.buf[o..o+4].copy_from_slice(&v.to_le_bytes()); n += 1; },
                        3 => { pkg.buf[o] = matches!(row.value.trim(), "true" | "True" | "1") as u8; n += 1; },
                        4 => if let Ok(v) = row.value.trim().parse::<u8>() { pkg.buf[o] = v; n += 1; },
                        _ => {}
                    }
                }
                self.dirty = true;
                self.status = format!("applied {} edits to in-memory buffer (Save to write)", n);
            }
        }
        if do_replace {
            if let (Some(oi), Some(dir)) = (self.sel_obj, self.game_dir.clone()) {
                if let Some(path) = rfd::FileDialog::new().add_filter("PNG", &["png"]).pick_file() {
                    match image::open(&path) {
                        Ok(img) => {
                            let rgba = img.to_rgba8();
                            let (w, h) = (rgba.width() as usize, rgba.height() as usize);
                            if let Some(pkg) = &mut self.pkg {
                                match pkg.replace_texture(oi, rgba.as_raw(), w, h, &dir) {
                                    Ok(msg) => { self.dirty = true; self.tex_for = None; self.status = msg; }
                                    Err(e) => self.status = format!("replace failed: {}", e),
                                }
                            }
                        }
                        Err(e) => self.status = format!("PNG load failed: {}", e),
                    }
                }
            }
        }
        if do_stop { self.sink = None; self.status = "stopped".into(); }
        if do_sndreplace {
            if let Some(oi) = self.sel_obj {
                if let Some(path) = rfd::FileDialog::new().add_filter("audio", &["ogg", "wav"]).pick_file() {
                    match std::fs::read(&path) {
                        Ok(bytes) => if let Some(pkg) = &mut self.pkg {
                            match pkg.replace_sound(oi, &bytes) {
                                Ok(m) => { self.dirty = true; self.status = m; }
                                Err(e) => self.status = format!("sound replace failed: {}", e),
                            }
                        },
                        Err(e) => self.status = format!("read failed: {}", e),
                    }
                }
            }
        }
        if let Some(data) = play_data {
            if self.audio.is_none() { self.audio = rodio::OutputStream::try_default().ok(); }
            if let Some((_, handle)) = &self.audio {
                match rodio::Sink::try_new(handle) {
                    Ok(sink) => match rodio::Decoder::new(std::io::Cursor::new(data)) {
                        Ok(dec) => { sink.append(dec); self.sink = Some(sink); self.status = "playing...".into(); }
                        Err(e) => self.status = format!("audio decode failed: {}", e),
                    },
                    Err(e) => self.status = format!("sink error: {}", e),
                }
            } else { self.status = "no audio output device".into(); }
        }
        if do_save {
            if let (Some(pkg), Some(pi)) = (&self.pkg, self.sel_pkg) {
                let name = self.packages[pi].file_name().unwrap().to_string_lossy().to_string();
                if let Some(path) = rfd::FileDialog::new().set_file_name(&name).save_file() {
                    let out = pkg.to_uncompressed();
                    let _ = std::fs::write(&path, &out);
                    self.dirty = false;
                    self.status = format!("saved {} ({} KB, uncompressed, game-loadable) -> {}", name, out.len() / 1024, path.display());
                }
            }
        }

        egui::CentralPanel::default().show(ctx, |ui| {
            if let Some(pkg) = &self.pkg {
                ui.horizontal(|ui| { ui.label("Filter objects:"); ui.text_edit_singleline(&mut self.obj_filter); });
                let filt = self.obj_filter.to_lowercase();
                egui::ScrollArea::vertical().show(ui, |ui| {
                    egui::Grid::new("objs").striped(true).num_columns(3).show(ui, |ui| {
                        ui.strong("Class"); ui.strong("Name"); ui.strong("Size"); ui.end_row();
                        for (i, e) in pkg.exports.iter().enumerate() {
                            if !filt.is_empty()
                                && !e.class_name.to_lowercase().contains(&filt)
                                && !e.name.to_lowercase().contains(&filt) { continue; }
                            let sel = self.sel_obj == Some(i);
                            if ui.selectable_label(sel, &e.class_name).clicked() { self.sel_obj = Some(i); }
                            if ui.selectable_label(sel, &e.name).clicked() { self.sel_obj = Some(i); }
                            ui.label(format!("{}", e.size));
                            ui.end_row();
                        }
                    });
                });
            } else {
                ui.label("Select a package on the left.");
            }
        });
    }
}

fn main() -> eframe::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() > 1 && args[1] == "--all" {
        let dir = args.get(2).map(|s| s.as_str()).unwrap_or(DEFAULT_DIR);
        let mut pkgs = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let p = e.path();
                if p.is_dir() { walk(&p, out); }
                else if let Some(x) = p.extension() { let x = x.to_string_lossy().to_lowercase();
                    if x == "upk" || x == "xxx" || x == "umap" { out.push(p); } }
            }}
        }
        walk(std::path::Path::new(dir), &mut pkgs);
        let mut ok = 0; let mut fail = 0;
        for p in &pkgs {
            let r = std::panic::catch_unwind(|| Pkg::load(p));
            match r { Ok(Ok(_)) => ok += 1, _ => { fail += 1; println!("FAIL: {}", p.display()); } }
        }
        println!("loaded {}/{} packages OK, {} failed", ok, pkgs.len(), fail);
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--sndtest" {
        let mut p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let idx = p.exports.iter().position(|e| e.class_name == "SoundNodeWave").unwrap();
        let last = p.exports.len() - 1;
        let last_name = p.exports[last].name.clone();
        let (orig, _) = p.sound_data(&p.exports[idx]).unwrap();
        let newaudio = orig[..orig.len() / 2].to_vec();
        println!("replace sound[{}] {} -> {} bytes", idx, orig.len(), newaudio.len());
        p.replace_sound(idx, &newaudio).unwrap();
        let (got, _) = p.sound_data(&p.exports[idx]).unwrap();
        println!("re-extract: {} bytes (expect {})", got.len(), newaudio.len());
        let lp = p.read_props(p.exports[last].off);
        println!("last export '{}' (was '{}') props={}", p.exports[last].name, last_name, lp.len());
        std::fs::write("/tmp/snd_resized.upk", p.to_uncompressed()).unwrap();
        let p2 = Pkg::load(std::path::Path::new("/tmp/snd_resized.upk")).unwrap();
        let ok = p2.exports.len() == p.exports.len() && p2.exports[last].name == last_name;
        println!("reload: exports={} names={} integrity={}", p2.exports.len(), p2.names.len(), if ok {"OK"} else {"FAIL"});
        return Ok(());
    }
    if args.len() > 4 && args[1] == "--testenc" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let cooked = std::path::Path::new(DEFAULT_DIR);
        let e = p.exports.iter().find(|e| e.class_name == "Texture2D" && e.name.to_lowercase().contains(&args[3].to_lowercase())).unwrap();
        let t = p.texture(e, cooked).unwrap();
        let enc = dxt::encode_bc3(&t.rgba, t.w, t.h);
        let dec = dxt::decode_bc3(&enc, t.w, t.h);
        image::save_buffer(&args[4], &dec, t.w as u32, t.h as u32, image::ColorType::Rgba8).unwrap();
        println!("roundtrip {}x{}: encoded {} bytes, saved {}", t.w, t.h, enc.len(), args[4]);
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--repack" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let out = p.to_uncompressed();
        std::fs::write(&args[3], &out).unwrap();
        println!("wrote {} ({} bytes, compressed_src={})", args[3], out.len(), p.compressed);
        let p2 = Pkg::load(std::path::Path::new(&args[3])).unwrap();
        println!("reload: ver={} names={} imports={} exports={} compressed={}",
            p2.ver, p2.names.len(), p2.imports.len(), p2.exports.len(), p2.compressed);
        let ok = p2.names.len() == p.names.len() && p2.exports.len() == p.exports.len()
            && p2.exports.iter().zip(p.exports.iter()).all(|(a, b)| a.name == b.name && a.class_name == b.class_name);
        println!("integrity: {}", if ok { "OK (tables identical)" } else { "MISMATCH" });
        return Ok(());
    }
    if args.len() > 4 && args[1] == "--png" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let cooked = std::path::Path::new(DEFAULT_DIR);
        match p.exports.iter().find(|e| e.class_name == "Texture2D" && e.name.to_lowercase().contains(&args[3].to_lowercase())) {
            Some(e) => match p.texture(e, cooked) {
                Some(t) => {
                    println!("{} {}x{} {} ({} rgba bytes)", e.name, t.w, t.h, t.format, t.rgba.len());
                    image::save_buffer(&args[4], &t.rgba, t.w as u32, t.h as u32, image::ColorType::Rgba8).unwrap();
                    println!("saved {}", args[4]);
                }
                None => println!("decode failed"),
            },
            None => println!("no matching Texture2D"),
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--props" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for e in p.exports.iter().filter(|e| e.name.to_lowercase().contains(&args[3].to_lowercase())).take(3) {
            println!("== {} ({}) @ {} ==", e.name, e.class_name, e.off);
            for (n, t, v) in p.read_props(e.off) { println!("   {:<22} {:<16} {}", n, t, v); }
        }
        return Ok(());
    }
    if args.len() > 1 {
        match Pkg::load(std::path::Path::new(&args[1])) {
            Ok(p) => {
                println!("ver={} names={} imports={} exports={} ({} bytes)",
                    p.ver, p.names.len(), p.imports.len(), p.exports.len(), p.buf.len());
                for e in p.exports.iter().take(12) {
                    println!("  {:<22} {:<40} {:>9} @ {}", e.class_name, e.name, e.size, e.off);
                }
            }
            Err(e) => println!("error: {}", e),
        }
        return Ok(());
    }
    let opts = eframe::NativeOptions::default();
    eframe::run_native("Hysteria Studio", opts, Box::new(|_cc| Ok(Box::new(App::default()))))
}
