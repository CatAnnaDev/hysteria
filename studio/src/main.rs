#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
mod lzo;
mod upk;
mod dxt;
mod loc;
mod theme;
mod view3d;

use std::path::PathBuf;
use upk::Pkg;

#[derive(PartialEq)]
enum Mode { Packages, Map, Localization }

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
    tex_chan: u8,
    props: Vec<upk::PropEdit>,
    ptree: Vec<upk::PropNode>,
    props_for: Option<(usize, usize)>,
    dirty: bool,
    audio: Option<(rodio::OutputStream, rodio::OutputStreamHandle)>,
    sink: Option<rodio::Sink>,
    volume: f32,
    wave: Vec<(f32, f32)>,
    wave_for: Option<(usize, usize)>,
    mode: Mode,
    map_actors: Vec<upk::MapActor>,
    actor_filter: String,
    cam: view3d::Cam,
    view_tex: Option<egui::TextureHandle>,
    view_dirty: bool,
    view_cam_for: Option<usize>,
    view_size: (usize, usize),
    loc_files: Vec<PathBuf>,
    loc_root: Option<PathBuf>,
    loc_filter: String,
    sel_loc: Option<usize>,
    loc: Option<loc::Loc>,
    loc_entry_filter: String,
    loc_dirty: bool,
}

impl Default for App {
    fn default() -> Self {
        let mut a = App {
            game_dir: None, packages: vec![], pkg_filter: String::new(),
            sel_pkg: None, pkg: None, obj_filter: String::new(), sel_obj: None,
            status: "Open a game CookedPC folder to begin.".into(),
            tex_handle: None, tex_for: None, tex_px: None, tex_chan: 0,
            props: vec![], ptree: vec![], props_for: None, dirty: false,
            audio: None, sink: None, volume: 1.0, wave: vec![], wave_for: None,
            mode: Mode::Packages,
            map_actors: vec![], actor_filter: String::new(),
            cam: view3d::Cam { target: [0.0, 0.0, 0.0], yaw: 0.9, pitch: 0.6, dist: 1000.0 },
            view_tex: None, view_dirty: true, view_cam_for: None, view_size: (0, 0),
            loc_files: vec![], loc_root: None, loc_filter: String::new(),
            sel_loc: None, loc: None, loc_entry_filter: String::new(), loc_dirty: false,
        };
        let d = PathBuf::from(DEFAULT_DIR);
        if d.is_dir() { a.scan(d); }
        // optional startup hook (demos/screenshots): HS_OPEN=<pkg substr> HS_SEL=<obj substr> HS_MODE=map
        if let Ok(want) = std::env::var("HS_OPEN") {
            let want = want.to_lowercase();
            if let Some(i) = a.packages.iter().position(|p| p.file_name().map(|n| n.to_string_lossy().to_lowercase().contains(&want)).unwrap_or(false)) {
                a.load_pkg(i);
                if let Ok(sel) = std::env::var("HS_SEL") {
                    let sel = sel.to_lowercase();
                    if let Some(p) = &a.pkg {
                        a.sel_obj = p.exports.iter().position(|e| e.name.to_lowercase().contains(&sel) || e.class_name.to_lowercase().contains(&sel));
                    }
                }
            }
            if std::env::var("HS_MODE").map(|m| m == "map").unwrap_or(false) { a.mode = Mode::Map; }
        }
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
        self.sel_pkg = None; self.pkg = None; self.sel_obj = None; self.map_actors.clear();
        // drop localization state tied to the previous folder so it re-derives on next entry
        self.loc_files.clear(); self.loc_root = None; self.sel_loc = None;
        self.loc = None; self.loc_dirty = false;
    }

    fn scan_loc(&mut self) {
        let root = self.game_dir.as_ref().and_then(|d| d.parent()).map(|p| p.join("Localization"));
        self.loc_files.clear();
        self.sel_loc = None; self.loc = None; self.loc_dirty = false;
        if let Some(r) = &root {
            fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
                if let Ok(rd) = std::fs::read_dir(d) {
                    for e in rd.flatten() {
                        let p = e.path();
                        if p.is_dir() { walk(&p, out); } else if p.is_file() { out.push(p); }
                    }
                }
            }
            walk(r, &mut self.loc_files);
            self.loc_files.sort();
            self.status = format!("{} localization files under {}", self.loc_files.len(), r.display());
        } else {
            self.status = "open a game CookedPC folder first".into();
        }
        self.loc_root = root;
    }

    fn load_pkg(&mut self, idx: usize) {
        let path = self.packages[idx].clone();
        let res = std::panic::catch_unwind(|| Pkg::load(&path))
            .unwrap_or_else(|_| Err("parser panicked (unsupported package layout)".into()));
        match res {
            Ok(p) => {
                let actors = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| p.actors())).unwrap_or_default();
                self.status = format!("{}: ver {} | {} names, {} imports, {} exports, {} actors ({} KB decompressed)",
                    path.file_name().unwrap().to_string_lossy(), p.ver, p.names.len(),
                    p.imports.len(), p.exports.len(), actors.len(), p.buf.len() / 1024);
                self.map_actors = actors;
                self.pkg = Some(p); self.sel_pkg = Some(idx); self.sel_obj = None;
            }
            Err(e) => { self.status = format!("ERROR loading {}: {}", path.display(), e); }
        }
    }
}

impl eframe::App for App {
    fn update(&mut self, ctx: &egui::Context, _f: &mut eframe::Frame) {
        if self.mode != Mode::Localization {
        let need = match (&self.pkg, self.sel_pkg, self.sel_obj) {
            (Some(p), Some(pi), Some(oi)) if p.exports[oi].class_name == "Texture2D" => Some((pi, oi)),
            _ => None,
        };
        if need != self.tex_for {
            self.tex_for = need; self.tex_handle = None; self.tex_px = None;
            if let (Some(p), Some(oi), Some(dir)) = (&self.pkg, self.sel_obj, &self.game_dir) {
                let decoded = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| p.texture(&p.exports[oi], dir))).ok().flatten();
                if let Some(t) = decoded {
                    let view = channel_view(&t.rgba, self.tex_chan);
                    let img = egui::ColorImage::from_rgba_unmultiplied([t.w, t.h], &view);
                    self.tex_handle = Some(ctx.load_texture("preview", img, egui::TextureOptions::NEAREST));
                    self.tex_px = Some((t.w, t.h, t.rgba));
                }
            }
        }
        let pneed = match (self.sel_pkg, self.sel_obj) { (Some(pi), Some(oi)) => Some((pi, oi)), _ => None };
        if pneed != self.props_for {
            self.props_for = pneed;
            let (props, ptree) = match (&self.pkg, self.sel_obj) {
                (Some(p), Some(oi)) if oi < p.exports.len() => {
                    let off = p.exports[oi].off;
                    let pe = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| p.props_editable(off))).unwrap_or_default();
                    let pt = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| p.prop_tree(off))).unwrap_or_default();
                    (pe, pt)
                }
                _ => (vec![], vec![]),
            };
            self.props = props; self.ptree = ptree;
        }
        let wneed = match (&self.pkg, self.sel_pkg, self.sel_obj) {
            (Some(p), Some(pi), Some(oi)) if p.exports[oi].class_name == "SoundNodeWave" => Some((pi, oi)),
            _ => None,
        };
        if wneed != self.wave_for {
            self.wave_for = wneed;
            self.wave = match (&self.pkg, self.sel_obj) {
                (Some(p), Some(oi)) => p.sound_data(&p.exports[oi])
                    .and_then(|(d, _)| std::panic::catch_unwind(|| decode_waveform(&d)).ok())
                    .unwrap_or_default(),
                _ => vec![],
            };
        }
        }

        egui::TopBottomPanel::top("top").frame(egui::Frame::none().fill(theme::BG).inner_margin(egui::Margin { left: 14.0, right: 14.0, top: 9.0, bottom: 9.0 })).show(ctx, |ui| {
            ui.horizontal(|ui| {
                ui.label(theme::display("Hysteria", 26.0));
                ui.add_space(2.0);
                ui.label(egui::RichText::new("STUDIO").text_style(egui::TextStyle::Name("eyebrow".into())).color(theme::BLOOD).size(13.0));
                ui.add_space(18.0);
                let tab = |ui: &mut egui::Ui, on: bool, txt: &str| {
                    let col = if on { theme::BONE } else { theme::DIM };
                    let r = ui.add(egui::Label::new(egui::RichText::new(txt).color(col).size(14.0)).sense(egui::Sense::click()));
                    if on { ui.painter().hline(r.rect.x_range(), r.rect.bottom() + 2.0_f32, egui::Stroke::new(2.0_f32, theme::BLOOD)); }
                    r.on_hover_cursor(egui::CursorIcon::PointingHand)
                };
                if tab(ui, self.mode == Mode::Packages, "Packages").clicked() { self.mode = Mode::Packages; }
                ui.add_space(14.0);
                let maplbl = if self.map_actors.is_empty() { "Map".to_string() } else { format!("Map · {}", self.map_actors.len()) };
                if tab(ui, self.mode == Mode::Map, &maplbl).clicked() { self.mode = Mode::Map; }
                ui.add_space(14.0);
                if tab(ui, self.mode == Mode::Localization, "Localization").clicked() {
                    self.mode = Mode::Localization;
                    if self.loc_files.is_empty() { self.scan_loc(); }
                }
                ui.with_layout(egui::Layout::right_to_left(egui::Align::Center), |ui| {
                    if ui.button("Open folder…").clicked() {
                        if let Some(d) = rfd::FileDialog::new().pick_folder() { self.scan(d); }
                    }
                    if let Some(d) = &self.game_dir {
                        let s = d.to_string_lossy();
                        let tail: String = s.rsplit('/').take(2).collect::<Vec<_>>().into_iter().rev().collect::<Vec<_>>().join("/");
                        ui.add(egui::Label::new(egui::RichText::new(format!("…/{}", tail)).color(theme::DIM).monospace().size(11.0)).truncate());
                    }
                });
            });
        });
        let bg = theme::BLOOD;
        egui::TopBottomPanel::bottom("status").frame(egui::Frame::none().fill(theme::BG).inner_margin(egui::Margin::symmetric(14.0, 5.0))).show(ctx, |ui| {
            ui.horizontal(|ui| {
                let glyph = if self.dirty || self.loc_dirty { ("●", bg) } else { ("·", theme::TEAL) };
                ui.label(egui::RichText::new(glyph.0).color(glyph.1).size(13.0));
                ui.add(egui::Label::new(egui::RichText::new(&self.status).color(theme::DIM).size(12.0)).truncate());
            });
        });

        if self.mode != Mode::Localization {
        egui::SidePanel::left("packages").default_width(320.0)
            .frame(egui::Frame::none().fill(theme::PANEL).inner_margin(egui::Margin { left: 10.0, right: 8.0, top: 10.0, bottom: 6.0 }))
            .show(ctx, |ui| {
            theme::eyebrow(ui, format!("PACKAGES · {}", self.packages.len()));
            ui.add(egui::TextEdit::singleline(&mut self.pkg_filter).hint_text("filter").desired_width(f32::INFINITY));
            ui.add_space(4.0);
            egui::ScrollArea::vertical().show(ui, |ui| {
                let filt = self.pkg_filter.to_lowercase();
                let mut to_load = None;
                for (i, p) in self.packages.iter().enumerate() {
                    let name = p.file_name().unwrap().to_string_lossy().to_string();
                    if !filt.is_empty() && !name.to_lowercase().contains(&filt) { continue; }
                    let is_map = name.to_lowercase().ends_with(".umap");
                    let col = if is_map { theme::TEAL } else { theme::BONE };
                    let txt = egui::RichText::new(&name).color(col).size(13.0);
                    if ui.add(egui::SelectableLabel::new(self.sel_pkg == Some(i), txt)).clicked() { to_load = Some(i); }
                }
                if let Some(i) = to_load { self.load_pkg(i); }
            });
        });
        } else {
        let root = self.loc_root.clone();
        let mut to_load = None;
        let mut do_rescan = false;
        egui::SidePanel::left("locfiles").default_width(340.0).show(ctx, |ui| {
            ui.label(format!("Localization files ({})", self.loc_files.len()));
            if ui.button("Rescan").clicked() { do_rescan = true; }
            ui.text_edit_singleline(&mut self.loc_filter);
            let filt = self.loc_filter.to_lowercase();
            egui::ScrollArea::vertical().show(ui, |ui| {
                for (i, p) in self.loc_files.iter().enumerate() {
                    let rel = root.as_ref().and_then(|r| p.strip_prefix(r).ok())
                        .map(|x| x.to_string_lossy().into_owned())
                        .unwrap_or_else(|| p.to_string_lossy().into_owned());
                    if !filt.is_empty() && !rel.to_lowercase().contains(&filt) { continue; }
                    if ui.selectable_label(self.sel_loc == Some(i), rel).clicked() { to_load = Some(i); }
                }
            });
        });
        if do_rescan { self.scan_loc(); }
        if let Some(i) = to_load {
            let p = self.loc_files[i].clone();
            match loc::Loc::load(&p) {
                Ok(l) => {
                    let kv = l.entries.iter().filter(|e| e.key.is_some()).count();
                    self.loc = Some(l); self.sel_loc = Some(i); self.loc_dirty = false;
                    self.status = format!("{} — {} editable strings", p.file_name().unwrap().to_string_lossy(), kv);
                }
                Err(e) => self.status = format!("load failed: {}", e),
            }
        }
        }

        let mut do_apply = false;
        let mut do_save = false;
        let mut do_replace = false;
        let mut play_data: Option<Vec<u8>> = None;
        let mut do_stop = false;
        let mut do_sndreplace = false;
        let mut do_bulk_tex = false;
        let mut do_bulk_snd = false;
        let mut do_umodel: Option<String> = None; // object name to 3D-view (empty = browse package)
        let mut sel_child: Option<usize> = None;
        let mut do_chan: Option<u8> = None;
        if self.mode != Mode::Localization {
        egui::SidePanel::right("details").default_width(372.0)
            .frame(egui::Frame::none().fill(theme::PANEL).inner_margin(egui::Margin { left: 12.0, right: 12.0, top: 10.0, bottom: 8.0 }))
            .show(ctx, |ui| {
            theme::eyebrow(ui, "OBJECT");
            if let (Some(pkg), Some(oi)) = (&self.pkg, self.sel_obj) {
                let e = &pkg.exports[oi];
                ui.label(theme::display(&e.name, 19.0));
                theme::eyebrow(ui, format!("{} · {} B", e.class_name.to_uppercase(), e.size));
                let kids = pkg.children(oi);
                if !kids.is_empty() {
                    ui.add_space(2.0);
                    egui::CollapsingHeader::new(egui::RichText::new(format!("Sub-objects · {}", kids.len())).color(theme::DIM).size(12.0)).default_open(true).show(ui, |ui| {
                        for &ci in &kids {
                            let c = &pkg.exports[ci];
                            ui.horizontal(|ui| {
                                ui.add(egui::Label::new(egui::RichText::new("\u{203A}").color(theme::BLOOD)));
                                if ui.selectable_label(false, egui::RichText::new(format!("{}  {}", c.name, c.class_name)).size(12.0)).clicked() { sel_child = Some(ci); }
                            });
                        }
                    });
                }
                theme::rule(ui);
                ui.horizontal(|ui| {
                    ui.strong("Properties (editable)");
                    if ui.button("Apply").clicked() { do_apply = true; }
                });
                egui::ScrollArea::vertical().max_height(180.0).id_salt("props").show(ui, |ui| {
                    egui::Grid::new("propgrid").striped(true).num_columns(2).show(ui, |ui| {
                        for row in &mut self.props {
                            ui.label(&row.name).on_hover_text(&row.typ);
                            match row.kind {
                                3 => {
                                    let mut b = matches!(row.value.trim(), "true" | "True" | "1");
                                    if ui.checkbox(&mut b, "").changed() { row.value = if b { "true".into() } else { "false".into() }; }
                                }
                                0 => { ui.label(&row.value); }
                                _ => { ui.add(egui::TextEdit::singleline(&mut row.value).desired_width(150.0)); }
                            }
                            ui.end_row();
                        }
                        if self.props.is_empty() { ui.label("(none)"); ui.end_row(); }
                    });
                });
                if !self.ptree.is_empty() {
                    egui::CollapsingHeader::new(format!("Full property tree ({})", self.ptree.len())).id_salt("ptree").show(ui, |ui| {
                        egui::ScrollArea::vertical().max_height(280.0).id_salt("ptreescroll").show(ui, |ui| {
                            show_tree(ui, &self.ptree);
                        });
                    });
                }
                if let Some(handle) = &self.tex_handle {
                    theme::rule(ui);
                    if let Some((w, h, _)) = &self.tex_px {
                        let fmt = pkg.prop_value(e.off, "Format").unwrap_or_else(|| "?".into());
                        let fmt = fmt.trim_start_matches("PF_");
                        theme::eyebrow(ui, format!("TEXTURE · {} · {}×{}", fmt, w, h));
                    }
                    let s = handle.size_vec2();
                    let avail = ui.available_width().min(330.0);
                    let k = (avail / s.x).min(avail / s.y).min(1.0);
                    let dim = s * k;
                    let (rect, _) = ui.allocate_exact_size(dim, egui::Sense::hover());
                    theme::checkerboard(ui.painter(), rect, 9.0);
                    ui.painter().image(handle.id(), rect, egui::Rect::from_min_max(egui::pos2(0.0, 0.0), egui::pos2(1.0, 1.0)), egui::Color32::WHITE);
                    ui.painter().rect_stroke(rect, 0.0_f32, egui::Stroke::new(1.0_f32, theme::LINE));
                    ui.horizontal(|ui| {
                        for (i, (lbl, col)) in [("RGBA", theme::BONE), ("R", egui::Color32::from_rgb(0xC4,0x5A,0x52)), ("G", egui::Color32::from_rgb(0x7A,0xA8,0x6E)), ("B", egui::Color32::from_rgb(0x6E,0x8E,0xC4)), ("A", theme::DIM)].iter().enumerate() {
                            let on = self.tex_chan == i as u8;
                            if ui.selectable_label(on, egui::RichText::new(*lbl).color(*col).monospace().size(11.0)).clicked() { do_chan = Some(i as u8); }
                        }
                    });
                    ui.horizontal(|ui| {
                        if ui.button("Export PNG").clicked() {
                            if let Some((w, h, rgba)) = &self.tex_px {
                                if let Some(p) = rfd::FileDialog::new().set_file_name(format!("{}.png", e.name)).save_file() {
                                    self.status = match image::save_buffer(&p, rgba, *w as u32, *h as u32, image::ColorType::Rgba8) {
                                        Ok(_) => format!("exported {}x{} PNG -> {}", w, h, p.display()),
                                        Err(err) => format!("PNG export failed: {}", err),
                                    };
                                }
                            }
                        }
                        if ui.button("Import PNG (replace)").clicked() { do_replace = true; }
                    });
                } else if e.class_name == "Texture2D" {
                    ui.separator();
                    let f = pkg.prop_value(e.off, "Format").unwrap_or_else(|| "?".into());
                    ui.label(format!("Texture2D — {} (no preview for this format yet)", f));
                }
                if e.class_name == "SoundNodeWave" {
                    theme::rule(ui);
                    let ext = pkg.sound_data(e).map(|(_, x)| x).unwrap_or("—");
                    theme::eyebrow(ui, format!("SOUND · {}", ext.to_uppercase()));
                    let (rect, _) = ui.allocate_exact_size(egui::vec2(ui.available_width().min(330.0), 84.0), egui::Sense::hover());
                    let p = ui.painter_at(rect);
                    p.rect_filled(rect, 3.0_f32, theme::BG);
                    p.rect_stroke(rect, 3.0_f32, egui::Stroke::new(1.0_f32, theme::LINE));
                    let mid = rect.center().y;
                    p.hline(rect.x_range(), mid, egui::Stroke::new(1.0_f32, theme::LINE));
                    if !self.wave.is_empty() {
                        let n = self.wave.len();
                        let half = rect.height() * 0.46;
                        for (i, (mn, mx)) in self.wave.iter().enumerate() {
                            let x = rect.left() + (i as f32 + 0.5) / n as f32 * rect.width();
                            let y0 = mid - mx.clamp(-1.0, 1.0) * half;
                            let y1 = mid - mn.clamp(-1.0, 1.0) * half;
                            p.vline(x, egui::Rangef::new(y0.min(y1), y0.max(y1) + 0.6), egui::Stroke::new(1.0_f32, theme::TEAL));
                        }
                    } else {
                        p.text(rect.center(), egui::Align2::CENTER_CENTER, "no decodable waveform", egui::FontId::proportional(11.0), theme::DIM);
                    }
                    ui.add_space(2.0);
                    ui.horizontal(|ui| {
                        if ui.button("Play").clicked() {
                            if let Some((data, _)) = pkg.sound_data(e) { play_data = Some(data); }
                        }
                        if ui.button("Stop").clicked() { do_stop = true; }
                        if ui.button("Import (replace)").clicked() { do_sndreplace = true; }
                        if ui.button("Export").clicked() {
                            if let Some((data, ext)) = pkg.sound_data(e) {
                                if let Some(p) = rfd::FileDialog::new().set_file_name(format!("{}.{}", e.name, ext)).save_file() {
                                    self.status = match std::fs::write(&p, &data) {
                                        Ok(_) => format!("exported {} ({} bytes) -> {}", ext, data.len(), p.display()),
                                        Err(err) => format!("audio export failed: {}", err),
                                    };
                                }
                            } else { self.status = "no embedded audio found".into(); }
                        }
                    });
                    if ui.add(egui::Slider::new(&mut self.volume, 0.0..=2.0).text("Volume")).changed() {
                        if let Some(s) = &self.sink { s.set_volume(self.volume); }
                    }
                }
                if e.class_name.contains("Mesh") {
                    ui.separator();
                    if ui.button("View in 3D (UModel)").clicked() { do_umodel = Some(e.name.clone()); }
                }
                ui.separator();
                egui::CollapsingHeader::new("Raw serial (hex)").show(ui, |ui| {
                    let s = pkg.serial(e);
                    let n = s.len().min(512);
                    let mut hex = String::new();
                    for row in s[..n].chunks(16) {
                        for byte in row { hex.push_str(&format!("{:02x} ", byte)); }
                        for _ in row.len()..16 { hex.push_str("   "); }
                        hex.push(' ');
                        for byte in row { let c = *byte; hex.push(if (32..127).contains(&c) { c as char } else { '.' }); }
                        hex.push('\n');
                    }
                    if s.len() > n { hex.push_str(&format!("... {} bytes total\n", s.len())); }
                    egui::ScrollArea::vertical().max_height(200.0).id_salt("hex").show(ui, |ui| {
                        ui.add(egui::Label::new(egui::RichText::new(hex).monospace().size(11.0)));
                    });
                });
                if ui.button("Dump raw serial data...").clicked() {
                    let off = e.off as usize; let sz = e.size as usize;
                    if off + sz <= pkg.buf.len() {
                        if let Some(path) = rfd::FileDialog::new().set_file_name(format!("{}.bin", e.name)).save_file() {
                            self.status = match std::fs::write(&path, &pkg.buf[off..off + sz]) {
                                Ok(_) => format!("dumped {} bytes -> {}", sz, path.display()),
                                Err(err) => format!("dump failed: {}", err),
                            };
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
                ui.separator();
                ui.label("Bulk export to a folder:");
                ui.horizontal(|ui| {
                    if ui.button("All textures (PNG)").clicked() { do_bulk_tex = true; }
                    if ui.button("All sounds").clicked() { do_bulk_snd = true; }
                });
            }
        });
        }
        if let Some(ci) = sel_child { self.sel_obj = Some(ci); }
        if let Some(c) = do_chan { self.tex_chan = c; self.tex_for = None; }
        if do_apply {
            if let Some(pkg) = &mut self.pkg {
                let mut n = 0;
                for row in &self.props {
                    let o = row.off;
                    if o == 0 || o >= pkg.buf.len() { continue; }
                    let fits4 = o + 4 <= pkg.buf.len();
                    match row.kind {
                        1 => if fits4 { if let Ok(v) = row.value.trim().parse::<i32>() { pkg.buf[o..o+4].copy_from_slice(&v.to_le_bytes()); n += 1; } },
                        2 => if fits4 { if let Ok(v) = row.value.trim().parse::<f32>() { pkg.buf[o..o+4].copy_from_slice(&v.to_le_bytes()); n += 1; } },
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
                    match std::fs::write(&path, &out) {
                        Ok(_) => {
                            self.dirty = false;
                            self.status = format!("saved {} ({} KB, uncompressed, game-loadable) -> {}", name, out.len() / 1024, path.display());
                        }
                        Err(e) => self.status = format!("save FAILED ({}) — your edits are kept, try another path", e),
                    }
                }
            }
        }

        if let Some(obj) = do_umodel {
            if let (Some(pi), Some(gd)) = (self.sel_pkg, &self.game_dir) {
                let pkg_stem = self.packages[pi].file_stem().map(|s| s.to_string_lossy().into_owned()).unwrap_or_default();
                let s = gd.to_string_lossy();
                let ck_wine = match s.find("drive_c/") { Some(i) => format!("C:\\{}", s[i + 8..].replace('/', "\\")), None => s.into_owned() };
                let cx = "/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/bin/cxstart";
                let r = std::process::Command::new(cx)
                    .args(["--bottle", "Steam", "C:\\umodel\\umodel_64.exe", &format!("-path={}", ck_wine), "-game=ue3", &pkg_stem, &obj])
                    .spawn();
                self.status = match r {
                    Ok(_) => format!("UModel: viewing {} / {} (3D window opening...)", pkg_stem, obj),
                    Err(e) => format!("UModel launch failed: {}", e),
                };
            }
        }
        if do_bulk_tex {
            if let (Some(pkg), Some(dir)) = (&self.pkg, self.game_dir.clone()) {
                if let Some(folder) = rfd::FileDialog::new().pick_folder() {
                    let mut n = 0;
                    for e in pkg.exports.iter().filter(|e| e.class_name == "Texture2D") {
                        let t = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| pkg.texture(e, &dir))).ok().flatten();
                        if let Some(t) = t {
                            let p = folder.join(format!("{}.png", e.name));
                            if image::save_buffer(&p, &t.rgba, t.w as u32, t.h as u32, image::ColorType::Rgba8).is_ok() { n += 1; }
                        }
                    }
                    self.status = format!("exported {} textures -> {}", n, folder.display());
                }
            }
        }
        if do_bulk_snd {
            if let Some(pkg) = &self.pkg {
                if let Some(folder) = rfd::FileDialog::new().pick_folder() {
                    let mut n = 0;
                    for e in pkg.exports.iter().filter(|e| e.class_name == "SoundNodeWave") {
                        if let Some((data, ext)) = pkg.sound_data(e) {
                            let p = folder.join(format!("{}.{}", e.name, ext));
                            if std::fs::write(&p, &data).is_ok() { n += 1; }
                        }
                    }
                    self.status = format!("exported {} sounds -> {}", n, folder.display());
                }
            }
        }

        let mut do_loc_save = false;
        egui::CentralPanel::default().frame(egui::Frame::none().fill(theme::BG).inner_margin(egui::Margin::same(12.0))).show(ctx, |ui| {
            if self.mode == Mode::Packages {
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
            } else if self.mode == Mode::Map {
            if self.pkg.is_none() {
                ui.add_space(48.0);
                ui.vertical_centered(|ui| { ui.label(egui::RichText::new("Open a Maps/*.umap on the left to read its level.").color(theme::DIM)); });
            } else if self.map_actors.is_empty() {
                ui.add_space(48.0);
                ui.vertical_centered(|ui| { ui.label(egui::RichText::new("This package has no PersistentLevel.").color(theme::DIM)); });
            } else {
                let mut pick = None;
                let placed: Vec<(usize, String, (f32, f32, f32))> = self.map_actors.iter()
                    .filter_map(|a| a.pos.map(|p| (a.idx, a.class.clone(), p))).collect();
                theme::eyebrow(ui, format!("WORLD · {} OF {} ACTORS PLACED · drag to orbit · scroll to zoom", placed.len(), self.map_actors.len()));
                if !placed.is_empty() {
                    if self.view_cam_for != self.sel_pkg {
                        self.view_cam_for = self.sel_pkg;
                        fit_cam(&mut self.cam, &placed);
                        self.view_dirty = true;
                    }
                    let h = (ui.available_height() * 0.60).clamp(220.0, 660.0);
                    let (rect, resp) = ui.allocate_exact_size(egui::vec2(ui.available_width(), h), egui::Sense::click_and_drag());
                    if resp.dragged() {
                        let d = resp.drag_delta();
                        self.cam.yaw -= d.x * 0.008;
                        self.cam.pitch = (self.cam.pitch + d.y * 0.008).clamp(-1.5, 1.5);
                        self.view_dirty = true;
                    }
                    let scroll = ui.input(|i| i.raw_scroll_delta.y);
                    if resp.hovered() && scroll.abs() > 0.0 {
                        self.cam.dist = (self.cam.dist * (1.0 - scroll * 0.0015)).clamp(10.0, 5_000_000.0);
                        self.view_dirty = true;
                    }
                    let pw = (rect.width() as usize).max(32);
                    let ph = (rect.height() as usize).max(32);
                    if self.view_dirty || self.view_size != (pw, ph) {
                        self.view_size = (pw, ph);
                        let scene = build_scene(&placed, self.sel_obj);
                        let mut r = view3d::Raster::new(pw, ph);
                        r.render(&scene, &self.cam.view_proj(pw as f32 / ph as f32), [18, 16, 13]);
                        let img = egui::ColorImage::from_rgba_unmultiplied([pw, ph], &r.col);
                        self.view_tex = Some(ctx.load_texture("view3d", img, egui::TextureOptions::NEAREST));
                        self.view_dirty = false;
                    }
                    if let Some(t) = &self.view_tex {
                        ui.painter().image(t.id(), rect, egui::Rect::from_min_max(egui::pos2(0.0, 0.0), egui::pos2(1.0, 1.0)), egui::Color32::WHITE);
                    }
                    ui.painter().rect_stroke(rect, 3.0_f32, egui::Stroke::new(1.0_f32, theme::LINE));
                    if resp.clicked() {
                        if let Some(ptr) = resp.interact_pointer_pos() {
                            let vp = self.cam.view_proj(pw as f32 / ph as f32);
                            let mut best = 16.0_f32; let mut bi = None;
                            for (idx, _, p) in &placed {
                                if let Some((sx, sy)) = view3d::project_screen(&vp, swz(*p), pw as f32, ph as f32) {
                                    let d = (rect.min + egui::vec2(sx, sy)).distance(ptr);
                                    if d < best { best = d; bi = Some(*idx); }
                                }
                            }
                            if bi.is_some() { pick = bi; }
                        }
                    }
                }
                ui.add_space(4.0);
                theme::rule(ui);
                ui.horizontal(|ui| {
                    theme::eyebrow(ui, "ACTORS");
                    ui.add(egui::TextEdit::singleline(&mut self.actor_filter).hint_text("filter").desired_width(180.0));
                });
                let filt = self.actor_filter.to_lowercase();
                egui::ScrollArea::vertical().show(ui, |ui| {
                    egui::Grid::new("actors").striped(true).num_columns(4).spacing([14.0, 4.0]).show(ui, |ui| {
                        for h in ["Class", "Actor", "Position", "·"] { theme::eyebrow(ui, h); }
                        ui.end_row();
                        for a in &self.map_actors {
                            if !filt.is_empty() && !a.class.to_lowercase().contains(&filt) && !a.name.to_lowercase().contains(&filt) { continue; }
                            let sel = self.sel_obj == Some(a.idx);
                            ui.horizontal(|ui| {
                                ui.add(egui::Label::new(egui::RichText::new("\u{25CF}").color(theme::class_color(&a.class)).size(9.0)));
                                if ui.selectable_label(sel, &a.class).clicked() { pick = Some(a.idx); }
                            });
                            if ui.selectable_label(sel, egui::RichText::new(&a.name).color(theme::BONE)).clicked() { pick = Some(a.idx); }
                            match a.pos {
                                Some((x, y, z)) => { ui.add(egui::Label::new(egui::RichText::new(format!("{:.0}, {:.0}, {:.0}", x, y, z)).monospace().size(11.0).color(theme::DIM))); }
                                None => { ui.label(egui::RichText::new("—").color(theme::LINE)); }
                            }
                            ui.label(egui::RichText::new(format!("{}", a.components.len())).color(theme::DIM).size(11.0));
                            ui.end_row();
                        }
                    });
                });
                if let Some(i) = pick { self.sel_obj = Some(i); self.view_dirty = true; }
            }
            } else if self.loc.is_some() {
                ui.horizontal(|ui| {
                    ui.label("Filter:");
                    ui.text_edit_singleline(&mut self.loc_entry_filter);
                    if self.loc_dirty { ui.colored_label(egui::Color32::from_rgb(255, 210, 90), "modified"); }
                    if ui.button("Save (live in-game)").clicked() { do_loc_save = true; }
                });
                let filt = self.loc_entry_filter.to_lowercase();
                let loc = self.loc.as_mut().unwrap();
                let mut changed = false;
                egui::ScrollArea::vertical().show(ui, |ui| {
                    egui::Grid::new("locgrid").striped(true).num_columns(2).show(ui, |ui| {
                        for e in loc.entries.iter_mut() {
                            if let Some(k) = &e.key {
                                let kt = k.trim_end().trim_end_matches('=').trim_end();
                                if !filt.is_empty() && !kt.to_lowercase().contains(&filt) && !e.raw.to_lowercase().contains(&filt) { continue; }
                                ui.label(kt);
                                if ui.add(egui::TextEdit::singleline(&mut e.raw).desired_width(400.0)).changed() { changed = true; }
                                ui.end_row();
                            }
                        }
                    });
                });
                if changed { self.loc_dirty = true; }
            } else {
                ui.label("Select a localization file on the left (e.g. FRA/GFxUI.fra).");
            }
        });
        if do_loc_save {
            if let (Some(l), Some(i)) = (&self.loc, self.sel_loc) {
                let p = self.loc_files[i].clone();
                match l.save(&p) {
                    Ok(_) => { self.loc_dirty = false; self.status = format!("saved {} (live in-game)", p.file_name().unwrap().to_string_lossy()); }
                    Err(e) => self.status = format!("save failed: {}", e),
                }
            }
        }
    }
}

type Placed = (usize, String, (f32, f32, f32));

// UE is Z-up; the software renderer is Y-up, so swizzle (x, y, z) -> (x, z, y).
fn swz(p: (f32, f32, f32)) -> view3d::V3 { [p.0, p.2, p.1] }

// Robust per-axis bounds (p6..p94) so a handful of mis-extracted outlier positions don't
// blow up the framing. Returns (min, max) of the trimmed range.
fn scene_bounds(placed: &[Placed]) -> ([f32; 3], [f32; 3]) {
    let mut mn = [0.0f32; 3]; let mut mx = [0.0f32; 3];
    for k in 0..3 {
        let mut v: Vec<f32> = placed.iter().map(|(_, _, p)| swz(*p)[k]).collect();
        v.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));
        let lo = v[(((v.len() - 1) as f32) * 0.06) as usize];
        let hi = v[(((v.len() - 1) as f32) * 0.94) as usize];
        mn[k] = lo; mx[k] = hi;
    }
    (mn, mx)
}

fn fit_cam(cam: &mut view3d::Cam, placed: &[Placed]) {
    if placed.is_empty() { return; }
    let (mn, mx) = scene_bounds(placed);
    cam.target = [(mn[0] + mx[0]) / 2.0, (mn[1] + mx[1]) / 2.0, (mn[2] + mx[2]) / 2.0];
    let ext = ((mx[0] - mn[0]).powi(2) + (mx[1] - mn[1]).powi(2) + (mx[2] - mn[2]).powi(2)).sqrt().max(100.0);
    cam.dist = ext * 0.75 + 200.0;
    cam.yaw = 0.9; cam.pitch = 0.55;
}

fn class_rgb(class: &str) -> [u8; 3] { let c = theme::class_color(class); [c.r(), c.g(), c.b()] }

fn build_scene(placed: &[Placed], sel: Option<usize>) -> view3d::Scene {
    let mut sc = view3d::Scene::new();
    if placed.is_empty() { return sc; }
    let (mn, mx) = scene_bounds(placed);
    let ext = (mx[0] - mn[0]).max(mx[1] - mn[1]).max(mx[2] - mn[2]).max(1.0);
    let hs = ext / 150.0;
    // ground grid at the lowest actor, just under the boxes
    let gy = mn[1] - hs;
    let n = 16;
    let (gx0, gx1, gz0, gz1) = (mn[0] - hs, mx[0] + hs, mn[2] - hs, mx[2] + hs);
    for i in 0..=n {
        let f = i as f32 / n as f32;
        let tx = gx0 + (gx1 - gx0) * f;
        let tz = gz0 + (gz1 - gz0) * f;
        sc.lines.push(([tx, gy, gz0], [tx, gy, gz1], [44, 39, 32]));
        sc.lines.push(([gx0, gy, tz], [gx1, gy, tz], [44, 39, 32]));
    }
    for (idx, class, p) in placed {
        let c = swz(*p);
        if sel == Some(*idx) {
            sc.box_solid(c, [hs * 1.5; 3], [206, 58, 50]);
        } else {
            sc.box_solid(c, [hs; 3], class_rgb(class));
        }
    }
    sc
}

fn decode_waveform(data: &[u8]) -> Vec<(f32, f32)> {
    use rodio::Source;
    let dec = match rodio::Decoder::new(std::io::Cursor::new(data.to_vec())) { Ok(d) => d, Err(_) => return Vec::new() };
    let ch = dec.channels().max(1) as usize;
    let samples: Vec<f32> = dec.convert_samples::<f32>().step_by(ch).collect();
    if samples.is_empty() { return Vec::new(); }
    let buckets = 520usize;
    let per = (samples.len() / buckets).max(1);
    samples.chunks(per).map(|c| {
        (c.iter().cloned().fold(f32::MAX, f32::min), c.iter().cloned().fold(f32::MIN, f32::max))
    }).collect()
}

fn channel_view(rgba: &[u8], chan: u8) -> Vec<u8> {
    if chan == 0 { return rgba.to_vec(); }
    let mut v = vec![0u8; rgba.len()];
    for (i, px) in rgba.chunks_exact(4).enumerate() {
        let g = match chan { 1 => px[0], 2 => px[1], 3 => px[2], _ => px[3] };
        let o = i * 4;
        v[o] = g; v[o + 1] = g; v[o + 2] = g; v[o + 3] = 255;
    }
    v
}

fn show_tree(ui: &mut egui::Ui, nodes: &[upk::PropNode]) {
    for (i, n) in nodes.iter().enumerate() {
        ui.push_id(i, |ui| {
            if n.children.is_empty() {
                ui.horizontal(|ui| {
                    ui.strong(&n.name);
                    if !n.typ.is_empty() { ui.weak(&n.typ); }
                    ui.label(&n.value);
                });
            } else {
                let head = if n.typ.is_empty() { format!("{}  {}", n.name, n.value) } else { format!("{} [{}]  {}", n.name, n.typ, n.value) };
                egui::CollapsingHeader::new(head).show(ui, |ui| { show_tree(ui, &n.children); });
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
        let cooked = std::path::Path::new(&args[2]).parent().unwrap_or_else(|| std::path::Path::new(DEFAULT_DIR));
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
        let cooked = std::path::Path::new(&args[2]).parent().unwrap_or_else(|| std::path::Path::new(DEFAULT_DIR));
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
    if args.len() > 6 && args[1] == "--recolor" {
        // --recolor <pkg> <texname> <pink|gothic> <cooked_dir> <out_pkg>
        let mut p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let idx = p.exports.iter().position(|e| e.class_name == "Texture2D" && e.name.to_lowercase().contains(&args[3].to_lowercase())).expect("texture not found");
        let cooked = std::path::Path::new(&args[5]);
        let t = p.texture(&p.exports[idx], cooked).expect("decode failed");
        let mode = args[4].as_str();
        let mut rgba = t.rgba.clone();
        for px in rgba.chunks_mut(4) {
            let (r, g, b) = (px[0] as f32, px[1] as f32, px[2] as f32);
            let lum = 0.299 * r + 0.587 * g + 0.114 * b;
            match mode {
                "pink" => {
                    px[0] = (lum * 0.55 + 130.0).min(255.0) as u8;
                    px[1] = (lum * 0.35 + 40.0).min(255.0) as u8;
                    px[2] = (lum * 0.50 + 110.0).min(255.0) as u8;
                }
                "gothic" => {
                    let d = lum * 0.30;
                    px[0] = (d * 0.85) as u8;
                    px[1] = (d * 0.70) as u8;
                    px[2] = (d * 1.15).min(255.0) as u8;
                }
                _ => {}
            }
        }
        let msg = p.replace_texture(idx, &rgba, t.w, t.h, cooked).unwrap();
        println!("recolor[{}] {}: {}", mode, p.exports[idx].name, msg);
        std::fs::write(&args[6], p.to_uncompressed()).unwrap();
        println!("wrote {} ({} bytes)", args[6], std::fs::metadata(&args[6]).unwrap().len());
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--hdr" {
        let raw = std::fs::read(&args[2]).unwrap();
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        println!("ver={} compressed={} cflags_off={} name_off={} raw={} buf={}", p.ver, p.compressed, p.cflags_off, p.name_off, raw.len(), p.buf.len());
        let ru = |b: &[u8], o: usize| u32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        println!("RAW cflags@{}={} nch@{}={}", p.cflags_off, ru(&raw, p.cflags_off), p.cflags_off+4, ru(&raw, p.cflags_off+4));
        let dump = |label: &str, b: &[u8]| {
            println!("--- {} (first 272) ---", label);
            for o in (0..272.min(b.len())).step_by(16) {
                let mut h = String::new(); let mut a = String::new();
                for i in o..(o+16).min(b.len()) { h.push_str(&format!("{:02x} ", b[i])); let c=b[i]; a.push(if (32..127).contains(&c){c as char}else{'.'}); }
                println!("{:5}  {:<48} {}", o, h, a);
            }
        };
        dump("RAW (on-disk)", &raw);
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--objs" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let cf = args.get(3).map(|s| s.to_lowercase());
        for e in &p.exports {
            if let Some(f) = &cf { if !e.class_name.to_lowercase().contains(f) && !e.name.to_lowercase().contains(f) { continue; } }
            println!("{:<22} {:<44} {:>9} @ {}", e.class_name, e.name, e.size, e.off);
        }
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--loctest" {
        let l = loc::Loc::load(std::path::Path::new(&args[2])).unwrap();
        let kv = l.entries.iter().filter(|e| e.key.is_some()).count();
        l.save(std::path::Path::new("/tmp/loctest.out")).unwrap();
        let a = std::fs::read(&args[2]).unwrap();
        let b = std::fs::read("/tmp/loctest.out").unwrap();
        println!("entries={} editable={} bom={} crlf={} roundtrip_identical={} ({} vs {} bytes)",
            l.entries.len(), kv, l.bom, l.crlf, a == b, a.len(), b.len());
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--map" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let actors = p.actors();
        let mut hist: std::collections::BTreeMap<String, usize> = std::collections::BTreeMap::new();
        for a in &actors { *hist.entry(a.class.clone()).or_default() += 1; }
        let placed = actors.iter().filter(|a| a.pos.is_some()).count();
        println!("{} actors ({} positioned), {} classes:", actors.len(), placed, hist.len());
        for (c, n) in hist.iter().rev().take(30) { println!("  {:>4}  {}", n, c); }
        println!("--- actors with a known position ---");
        let filt = args.get(3).map(|s| s.to_lowercase());
        for a in actors.iter().filter(|a| a.pos.is_some()) {
            if let Some(f) = &filt { if !a.class.to_lowercase().contains(f) && !a.name.to_lowercase().contains(f) { continue; } }
            let (x, y, z) = a.pos.unwrap();
            println!("  {:<26} {:<24} ({:>9.1},{:>9.1},{:>9.1})  {} comps", a.class, a.name, x, y, z, a.components.len());
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--tree" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        fn print_tree(nodes: &[upk::PropNode], depth: usize) {
            for n in nodes {
                let pad = "  ".repeat(depth + 1);
                let ty = if n.typ.is_empty() { String::new() } else { format!("[{}] ", n.typ) };
                println!("{}{} {}{}", pad, n.name, ty, n.value);
                if !n.children.is_empty() { print_tree(&n.children, depth + 1); }
            }
        }
        for e in p.exports.iter().filter(|e| e.name.to_lowercase().contains(&args[3].to_lowercase()) || e.class_name.to_lowercase().contains(&args[3].to_lowercase())).take(3) {
            println!("== {} ({}) ==", e.name, e.class_name);
            print_tree(&p.prop_tree(e.off), 0);
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--probe" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for e in p.exports.iter().filter(|e| e.name.to_lowercase().contains(&args[3].to_lowercase()) || e.class_name.to_lowercase().contains(&args[3].to_lowercase())).take(4) {
            println!("{}", p.probe(e));
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
                println!("ver={} names={} imports={} exports={} compressed={} ({} bytes)",
                    p.ver, p.names.len(), p.imports.len(), p.exports.len(), p.compressed, p.buf.len());
                for e in p.exports.iter().take(12) {
                    println!("  {:<22} {:<40} {:>9} @ {}", e.class_name, e.name, e.size, e.off);
                }
            }
            Err(e) => println!("error: {}", e),
        }
        return Ok(());
    }
    let opts = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default().with_inner_size([1280.0, 820.0]).with_min_inner_size([900.0, 600.0]),
        ..Default::default()
    };
    eframe::run_native("Hysteria Studio", opts, Box::new(|cc| {
        theme::install(&cc.egui_ctx);
        Ok(Box::new(App::default()))
    }))
}
