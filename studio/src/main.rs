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

#[derive(Clone, Copy)]
struct GizmoDrag { axis: usize, mode: u8, off: [usize; 3], start: [f32; 3], start_ptr: egui::Pos2, unit: egui::Vec2, per_px: f32 }

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
    scene: view3d::Scene,
    scene_key: Option<(usize, Option<usize>)>,
    mesh_cache: std::collections::HashMap<usize, Option<(upk::Mesh, Vec<upk::SmSection>)>>,
    mat_cache: std::collections::HashMap<usize, [u8; 3]>,
    tex_data: std::collections::HashMap<usize, Option<(usize, usize, Vec<u8>)>>,
    assets: AssetCache,
    loc_files: Vec<PathBuf>,
    loc_root: Option<PathBuf>,
    loc_filter: String,
    sel_loc: Option<usize>,
    loc: Option<loc::Loc>,
    loc_entry_filter: String,
    loc_dirty: bool,
    loc_visible: Vec<usize>,
    loc_vis_filter: Option<String>,
    unused_rx: Option<std::sync::mpsc::Receiver<(Vec<PathBuf>, usize)>>,
    unused: Option<std::collections::HashSet<PathBuf>>,
    unused_only: bool,
    unused_failed: usize,
    xform: Vec<upk::PropEdit>,
    xform_orig: Vec<String>,
    xform_for: Option<usize>,
    asset_scene: view3d::Scene,
    asset_cam: view3d::Cam,
    asset_view_tex: Option<egui::TextureHandle>,
    asset_view_dirty: bool,
    asset_for: Option<usize>,
    asset_info: Option<String>,
    undo_stack: Vec<(Vec<u8>, Vec<upk::MapActor>)>,
    redo_stack: Vec<(Vec<u8>, Vec<upk::MapActor>)>,
    gizmo: Option<GizmoDrag>,
    gizmo_mode: u8,
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
            scene: view3d::Scene::new(), scene_key: None, mesh_cache: std::collections::HashMap::new(), mat_cache: std::collections::HashMap::new(), tex_data: std::collections::HashMap::new(), assets: AssetCache::default(),
            loc_files: vec![], loc_root: None, loc_filter: String::new(),
            sel_loc: None, loc: None, loc_entry_filter: String::new(), loc_dirty: false,
            loc_visible: vec![], loc_vis_filter: None,
            unused_rx: None, unused: None, unused_only: false, unused_failed: 0,
            xform: vec![], xform_orig: vec![], xform_for: None,
            asset_scene: view3d::Scene::new(),
            asset_cam: view3d::Cam { target: [0.0, 0.0, 0.0], yaw: 0.7, pitch: 0.15, dist: 300.0 },
            asset_view_tex: None, asset_view_dirty: true, asset_for: None, asset_info: None,
            undo_stack: Vec::new(), redo_stack: Vec::new(), gizmo: None, gizmo_mode: 0,
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
    fn push_undo(&mut self) {
        if let Some(pkg) = &self.pkg {
            if self.undo_stack.len() >= 40 { self.undo_stack.remove(0); }
            self.undo_stack.push((pkg.buf.clone(), self.map_actors.clone()));
            self.redo_stack.clear();
        }
    }

    fn restore_snapshot(&mut self, buf: Vec<u8>, actors: Vec<upk::MapActor>) {
        if let Some(pkg) = &mut self.pkg { pkg.buf = buf; }
        self.map_actors = actors;
        self.dirty = true;
        self.xform_for = None;
        self.scene_key = Some((self.sel_pkg.unwrap_or(0), Some(usize::MAX)));
        self.view_dirty = true;
    }

    fn undo(&mut self) {
        if let Some((buf, actors)) = self.undo_stack.pop() {
            if let Some(pkg) = &self.pkg { self.redo_stack.push((pkg.buf.clone(), self.map_actors.clone())); }
            self.restore_snapshot(buf, actors);
            self.status = format!("undo \u{2014} {} left", self.undo_stack.len());
        } else { self.status = "nothing to undo".into(); }
    }

    fn redo(&mut self) {
        if let Some((buf, actors)) = self.redo_stack.pop() {
            if let Some(pkg) = &self.pkg { self.undo_stack.push((pkg.buf.clone(), self.map_actors.clone())); }
            self.restore_snapshot(buf, actors);
            self.status = "redo".into();
        }
    }

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
        self.unused = None; self.unused_only = false; self.unused_rx = None; self.unused_failed = 0;
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
                self.undo_stack.clear(); self.redo_stack.clear(); self.gizmo = None;
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
        let aneed = match (&self.pkg, self.sel_obj) {
            (Some(p), Some(oi)) if oi < p.exports.len() && (p.exports[oi].class_name == "StaticMesh" || p.exports[oi].class_name == "SkeletalMesh") => Some(oi),
            _ => None,
        };
        if aneed != self.asset_for {
            self.asset_for = aneed;
            self.asset_view_tex = None;
            self.asset_info = None;
            self.asset_scene = view3d::Scene::new();
            if let Some(oi) = aneed {
                let cooked = self.game_dir.clone();
                let built = if let Some(pkg) = &self.pkg {
                    build_asset_scene(pkg, oi, cooked.as_deref(), &mut self.assets, &self.packages)
                } else { None };
                if let Some((sc, center, radius, info)) = built {
                    self.asset_scene = sc;
                    self.asset_cam = view3d::Cam { target: center, yaw: 0.7, pitch: 0.12, dist: radius * 2.6 };
                    self.asset_info = Some(info);
                }
                self.asset_view_dirty = true;
            }
        }
        if self.asset_for.is_some() && !self.asset_scene.tris.is_empty() && (self.asset_view_dirty || self.asset_view_tex.is_none()) {
            let (w, h) = (380usize, 440usize);
            let mut r = view3d::Raster::new(w, h);
            r.render(&self.asset_scene, &self.asset_cam.view_proj(w as f32 / h as f32), 0.0);
            let img = egui::ColorImage::from_rgba_unmultiplied([w, h], &r.col);
            self.asset_view_tex = Some(ctx.load_texture("asset3d", img, egui::TextureOptions::NEAREST));
            self.asset_view_dirty = false;
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
            if let Some(rx) = &self.unused_rx {
                match rx.try_recv() {
                    Ok((list, failed)) => { self.unused = Some(list.into_iter().collect()); self.unused_failed = failed; self.unused_only = true; self.unused_rx = None; }
                    Err(std::sync::mpsc::TryRecvError::Disconnected) => { self.unused_rx = None; self.status = "unused scan failed".into(); }
                    Err(_) => { ctx.request_repaint(); }
                }
            }
            ui.horizontal(|ui| {
                if self.unused_rx.is_some() {
                    ui.add(egui::Spinner::new());
                    ui.label(egui::RichText::new("scanning… (~1 min)").color(theme::DIM).size(12.0));
                } else if ui.button("Scan unused content").clicked() && !self.packages.is_empty() {
                    let paths = self.packages.clone();
                    let (tx, rx) = std::sync::mpsc::channel();
                    std::thread::spawn(move || { let r = scan_unused(&paths); let _ = tx.send((r.1, r.2)); });
                    self.unused_rx = Some(rx);
                    ctx.request_repaint();
                }
                if let Some(set) = &self.unused {
                    ui.checkbox(&mut self.unused_only, egui::RichText::new(format!("{} unused", set.len())).color(theme::BLOOD_HI).size(12.0));
                    if self.unused_failed > 0 { ui.label(egui::RichText::new(format!("· {} unreadable", self.unused_failed)).color(theme::DIM).size(11.0)); }
                }
            });
            ui.add_space(4.0);
            egui::ScrollArea::vertical().show(ui, |ui| {
                let filt = self.pkg_filter.to_lowercase();
                let mut to_load = None;
                for (i, p) in self.packages.iter().enumerate() {
                    let is_unused = self.unused.as_ref().map(|s| s.contains(p)).unwrap_or(false);
                    if self.unused_only && self.unused.is_some() && !is_unused { continue; }
                    let name = p.file_name().unwrap().to_string_lossy().to_string();
                    if !filt.is_empty() && !name.to_lowercase().contains(&filt) { continue; }
                    let is_map = name.to_lowercase().ends_with(".umap");
                    let col = if is_unused { theme::BLOOD_HI } else if is_map { theme::TEAL } else { theme::BONE };
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
                    self.loc_vis_filter = None;
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
            egui::ScrollArea::vertical().auto_shrink([false, false]).show(ui, |ui| {
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
                if e.class_name == "StaticMesh" || e.class_name == "SkeletalMesh" {
                    ui.separator();
                    theme::eyebrow(ui, "3D PREVIEW · drag to orbit · scroll to zoom");
                    if let Some(info) = &self.asset_info { ui.label(egui::RichText::new(info).color(theme::DIM).size(11.0)); }
                    let avail = ui.available_width();
                    let (rect, resp) = ui.allocate_exact_size(egui::vec2(avail, avail * 1.15), egui::Sense::drag());
                    if resp.dragged() {
                        let d = resp.drag_delta();
                        self.asset_cam.yaw -= d.x * 0.01;
                        self.asset_cam.pitch = (self.asset_cam.pitch + d.y * 0.01).clamp(-1.5, 1.5);
                        self.asset_view_dirty = true;
                    }
                    let scroll = ui.input(|i| i.raw_scroll_delta.y);
                    if resp.hovered() && scroll.abs() > 0.0 {
                        self.asset_cam.dist = (self.asset_cam.dist * (1.0 - scroll * 0.0015)).clamp(1.0, 1_000_000.0);
                        self.asset_view_dirty = true;
                    }
                    if let Some(t) = &self.asset_view_tex {
                        ui.painter().image(t.id(), rect, egui::Rect::from_min_max(egui::pos2(0.0, 0.0), egui::pos2(1.0, 1.0)), egui::Color32::WHITE);
                    } else {
                        ui.painter().rect_filled(rect, 3.0_f32, theme::BG);
                        ui.painter().text(rect.center(), egui::Align2::CENTER_CENTER, "decoding\u{2026}", egui::FontId::proportional(12.0), theme::DIM);
                    }
                    ui.painter().rect_stroke(rect, 3.0_f32, egui::Stroke::new(1.0_f32, theme::LINE));
                    if resp.dragged() || (resp.hovered() && scroll.abs() > 0.0) { ui.ctx().request_repaint(); }
                    ui.add_space(2.0);
                    if ui.small_button("Open in external UModel").clicked() { do_umodel = Some(e.name.clone()); }
                } else if e.class_name.contains("Mesh") {
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
                let mut focus: Option<(f32, f32, f32)> = None;
                let (mut do_xform, mut do_xsave) = (false, false);
                let mut do_delete: Option<usize> = None;
                if !ctx.wants_keyboard_input() && self.gizmo.is_none() {
                    let (cmd, shift, z, y, k1, k2, k3) = ctx.input(|i| (i.modifiers.command, i.modifiers.shift, i.key_pressed(egui::Key::Z), i.key_pressed(egui::Key::Y), i.key_pressed(egui::Key::Num1), i.key_pressed(egui::Key::Num2), i.key_pressed(egui::Key::Num3)));
                    if cmd && z && shift { self.redo(); }
                    else if cmd && z { self.undo(); }
                    else if cmd && y { self.redo(); }
                    if k1 { self.gizmo_mode = 0; } else if k2 { self.gizmo_mode = 1; } else if k3 { self.gizmo_mode = 2; }
                }
                let placed: Vec<(usize, String, (f32, f32, f32))> = self.map_actors.iter()
                    .filter_map(|a| a.pos.map(|p| (a.idx, a.class.clone(), p))).collect();
                theme::eyebrow(ui, format!("WORLD · {} PLACED · drag look · WASD/QE fly · scroll zoom · dbl-click actor to focus", placed.len()));
                if !placed.is_empty() {
                    if self.view_cam_for != self.sel_pkg {
                        self.view_cam_for = self.sel_pkg;
                        fit_cam(&mut self.cam, &placed);
                        self.view_dirty = true;
                    }
                    ui.horizontal(|ui| {
                        theme::eyebrow(ui, "GIZMO");
                        for (m, lbl) in [(0u8, "Move"), (1, "Rotate"), (2, "Scale")] {
                            if ui.selectable_label(self.gizmo_mode == m, lbl).clicked() { self.gizmo_mode = m; }
                        }
                        let avail = self.sel_obj.and_then(|s| self.pkg.as_ref().map(|p| p.transform_edits(s))).map(|es| {
                            let has = |n: &str| es.iter().any(|e| e.name.starts_with(n));
                            match self.gizmo_mode { 1 => has("Rotation."), 2 => has("DrawScale3D."), _ => has("Location.") }
                        }).unwrap_or(false);
                        if self.sel_obj.is_some() && !avail {
                            ui.label(egui::RichText::new("· no serialized tag on this actor for this mode").size(10.0).color(theme::BLOOD_HI));
                        } else {
                            ui.label(egui::RichText::new("· drag an axis · keys 1/2/3").size(10.0).color(theme::DIM));
                        }
                    });
                    let h = (ui.available_height() * 0.60).clamp(220.0, 660.0);
                    let (rect, resp) = ui.allocate_exact_size(egui::vec2(ui.available_width(), h), egui::Sense::click_and_drag());
                    let (vw, vh) = (rect.width().max(1.0), rect.height().max(1.0));
                    let vp = self.cam.view_proj(vw / vh);
                    let proj = |ue: [f32; 3]| -> Option<egui::Pos2> {
                        view3d::project_screen(&vp, swz((ue[0], ue[1], ue[2])), vw, vh).map(|(sx, sy)| rect.min + egui::vec2(sx, sy))
                    };
                    let axes_ue = [[1.0f32, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]];
                    let gl = (self.cam.dist * 0.13).max(20.0);
                    let gmode = self.gizmo_mode;
                    let giz: Option<([f32; 3], [usize; 3], [f32; 3], u8)> = self.sel_obj.and_then(|sel| {
                        let p = self.map_actors.iter().find(|a| a.idx == sel).and_then(|a| a.pos)?;
                        let pkg = self.pkg.as_ref()?;
                        let edits = pkg.transform_edits(sel);
                        let find = |nm: &str| edits.iter().find(|e| e.name.starts_with(nm)).map(|e| (e.off, e.value.trim().parse::<f32>().unwrap_or(0.0)));
                        // axis X/Y/Z maps to: move=Location, scale=DrawScale3D, rotate=Roll/Pitch/Yaw (UE: roll=about X, pitch=about Y, yaw=about Z)
                        let g = match gmode {
                            1 => [find("Rotation.Roll")?, find("Rotation.Pitch")?, find("Rotation.Yaw")?],
                            2 => [find("DrawScale3D.X")?, find("DrawScale3D.Y")?, find("DrawScale3D.Z")?],
                            _ => [find("Location.X")?, find("Location.Y")?, find("Location.Z")?],
                        };
                        Some(([p.0, p.1, p.2], [g[0].0, g[1].0, g[2].0], [g[0].1, g[1].1, g[2].1], gmode))
                    });
                    let mut gizmo_busy = false;
                    if let Some((p_ue, off, start, mode)) = giz {
                        let s0 = proj(p_ue);
                        let ends: [Option<egui::Pos2>; 3] = [
                            proj([p_ue[0] + axes_ue[0][0] * gl, p_ue[1] + axes_ue[0][1] * gl, p_ue[2] + axes_ue[0][2] * gl]),
                            proj([p_ue[0] + axes_ue[1][0] * gl, p_ue[1] + axes_ue[1][1] * gl, p_ue[2] + axes_ue[1][2] * gl]),
                            proj([p_ue[0] + axes_ue[2][0] * gl, p_ue[1] + axes_ue[2][1] * gl, p_ue[2] + axes_ue[2][2] * gl]),
                        ];
                        if resp.drag_started() && self.gizmo.is_none() {
                            if let (Some(ptr), Some(s0p)) = (resp.interact_pointer_pos(), s0) {
                                let mut bestd = 11.0f32; let mut best: Option<(usize, egui::Vec2, f32)> = None;
                                for (ai, e) in ends.iter().enumerate() {
                                    if let Some(ep) = e {
                                        let sa = *ep - s0p; let slen = sa.length();
                                        if slen < 12.0 { continue; }
                                        let d = seg_dist(ptr, s0p, *ep);
                                        if d < bestd { bestd = d; best = Some((ai, sa / slen, gl / slen)); }
                                    }
                                }
                                if let Some((ax, unit, wpp)) = best {
                                    self.push_undo();
                                    let per_px = match mode { 1 => 0.5, 2 => 0.01, _ => wpp };
                                    self.gizmo = Some(GizmoDrag { axis: ax, mode, off, start, start_ptr: ptr, unit, per_px });
                                }
                            }
                        }
                        if let Some(g) = self.gizmo {
                            gizmo_busy = true;
                            if resp.dragged() {
                                if let Some(ptr) = resp.interact_pointer_pos() {
                                    let t = (ptr - g.start_ptr).dot(g.unit);
                                    let nv = if g.mode == 2 {
                                        let raw = g.start[g.axis] + t * g.per_px;
                                        if raw.abs() < 0.01 { 0.01_f32.copysign(g.start[g.axis]) } else { raw }
                                    } else { g.start[g.axis] + t * g.per_px };
                                    if let Some(pkg) = &mut self.pkg {
                                        let o = g.off[g.axis];
                                        if o + 4 <= pkg.buf.len() {
                                            if g.mode == 1 { pkg.buf[o..o + 4].copy_from_slice(&((nv * 65536.0 / 360.0).round() as i32).to_le_bytes()); }
                                            else { pkg.buf[o..o + 4].copy_from_slice(&nv.to_le_bytes()); }
                                        }
                                    }
                                    if let Some(sel) = self.sel_obj {
                                        if let Some(m) = self.pkg.as_ref().and_then(|p| p.actor_matrix(sel)) {
                                            if let Some(a) = self.map_actors.iter_mut().find(|a| a.idx == sel) { a.pos = Some((m[12], m[13], m[14])); }
                                        }
                                    }
                                    self.dirty = true;
                                    self.scene_key = Some((self.sel_pkg.unwrap_or(0), Some(usize::MAX)));
                                    self.view_dirty = true;
                                    let lbl = match g.mode { 1 => "rot", 2 => "scale", _ => "move" };
                                    self.status = format!("{} {} {:+.2}", lbl, ["X", "Y", "Z"][g.axis], nv - g.start[g.axis]);
                                }
                            }
                            if resp.drag_stopped() { self.gizmo = None; self.xform_for = None; }
                        }
                    }
                    if !gizmo_busy && resp.dragged() {
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
                    if resp.hovered() && !ui.ctx().wants_keyboard_input() {
                        let cp = self.cam.pitch.cos();
                        let dir = [-(self.cam.yaw.cos() * cp), -self.cam.pitch.sin(), -(self.cam.yaw.sin() * cp)];
                        let right = view3d::norm(view3d::cross(dir, [0.0, 1.0, 0.0]));
                        let mut mv = [0.0f32; 3];
                        ui.input(|i| {
                            if i.key_down(egui::Key::W) { for k in 0..3 { mv[k] += dir[k]; } }
                            if i.key_down(egui::Key::S) { for k in 0..3 { mv[k] -= dir[k]; } }
                            if i.key_down(egui::Key::D) { for k in 0..3 { mv[k] += right[k]; } }
                            if i.key_down(egui::Key::A) { for k in 0..3 { mv[k] -= right[k]; } }
                            if i.key_down(egui::Key::E) || i.key_down(egui::Key::Space) { mv[1] += 1.0; }
                            if i.key_down(egui::Key::Q) { mv[1] -= 1.0; }
                        });
                        let len = (mv[0] * mv[0] + mv[1] * mv[1] + mv[2] * mv[2]).sqrt();
                        if len > 0.0 {
                            let dt = ui.input(|i| i.stable_dt).clamp(0.001, 0.1);
                            let speed = (self.cam.dist * 1.2).max(300.0);
                            for k in 0..3 { self.cam.target[k] += mv[k] / len * speed * dt; }
                            self.view_dirty = true;
                            ui.ctx().request_repaint();
                        }
                    }
                    let key = (self.sel_pkg.unwrap_or(0), self.sel_obj);
                    if self.scene_key != Some(key) {
                        if self.scene_key.map(|(p, _)| p) != Some(key.0) { self.mesh_cache.clear(); self.mat_cache.clear(); self.tex_data.clear(); }
                        let cooked = self.game_dir.clone();
                        self.scene = if let Some(pkg) = &self.pkg {
                            build_world_scene(pkg, &self.map_actors, self.sel_obj, &mut self.mesh_cache, &mut self.mat_cache, cooked.as_deref(), &mut self.tex_data, &mut self.assets, &self.packages)
                        } else { view3d::Scene::new() };
                        self.scene_key = Some(key);
                        self.view_dirty = true;
                    }
                    let pw = (rect.width() as usize).max(32);
                    let ph = (rect.height() as usize).max(32);
                    if self.view_dirty || self.view_size != (pw, ph) {
                        self.view_size = (pw, ph);
                        let mut r = view3d::Raster::new(pw, ph);
                        let fog = 0.6 / self.cam.dist.max(1.0);
                        r.render(&self.scene, &self.cam.view_proj(pw as f32 / ph as f32), fog);
                        let img = egui::ColorImage::from_rgba_unmultiplied([pw, ph], &r.col);
                        self.view_tex = Some(ctx.load_texture("view3d", img, egui::TextureOptions::NEAREST));
                        self.view_dirty = false;
                    }
                    if let Some(t) = &self.view_tex {
                        ui.painter().image(t.id(), rect, egui::Rect::from_min_max(egui::pos2(0.0, 0.0), egui::pos2(1.0, 1.0)), egui::Color32::WHITE);
                    }
                    ui.painter().rect_stroke(rect, 3.0_f32, egui::Stroke::new(1.0_f32, theme::LINE));
                    if let Some((p_ue, _, _, _)) = giz {
                        if let Some(s0p) = proj(p_ue) {
                            let cols = [egui::Color32::from_rgb(222, 80, 72), egui::Color32::from_rgb(96, 200, 112), egui::Color32::from_rgb(92, 142, 232)];
                            for ai in 0..3 {
                                let a = axes_ue[ai];
                                if let Some(ep) = proj([p_ue[0] + a[0] * gl, p_ue[1] + a[1] * gl, p_ue[2] + a[2] * gl]) {
                                    let active = self.gizmo.map(|g| g.axis == ai).unwrap_or(false);
                                    ui.painter().line_segment([s0p, ep], egui::Stroke::new(if active { 3.5_f32 } else { 2.0_f32 }, cols[ai]));
                                    ui.painter().circle_filled(ep, if active { 5.5_f32 } else { 3.5_f32 }, cols[ai]);
                                }
                            }
                            ui.painter().circle_filled(s0p, 3.0, egui::Color32::from_rgb(230, 224, 210));
                        }
                    }
                    if resp.clicked() && self.gizmo.is_none() {
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
                if self.xform_for != self.sel_obj {
                    self.xform = self.sel_obj.and_then(|s| self.pkg.as_ref().map(|p| p.transform_edits(s))).unwrap_or_default();
                    self.xform_orig = self.xform.iter().map(|e| e.value.clone()).collect();
                    self.xform_for = self.sel_obj;
                }
                if self.sel_obj.is_some() && !self.xform.is_empty() {
                    ui.add_space(4.0); theme::rule(ui);
                    let sel_name = self.map_actors.iter().find(|a| Some(a.idx) == self.sel_obj).map(|a| a.name.clone()).unwrap_or_default();
                    theme::eyebrow(ui, format!("TRANSFORM · {}", sel_name));
                    egui::Grid::new("xform").num_columns(2).spacing([10.0, 3.0]).show(ui, |ui| {
                        for pe in &mut self.xform {
                            ui.label(egui::RichText::new(&pe.name).size(11.0).color(theme::DIM));
                            ui.add(egui::TextEdit::singleline(&mut pe.value).desired_width(130.0));
                            ui.end_row();
                        }
                    });
                    ui.horizontal(|ui| {
                        if ui.button("Apply").clicked() { do_xform = true; }
                        if ui.button("Save .umap").clicked() { do_xform = true; do_xsave = true; }
                        if self.dirty { ui.colored_label(egui::Color32::from_rgb(255, 210, 90), "modified — unsaved"); }
                    });
                }
                if let Some(sel) = self.sel_obj {
                    let nm = self.map_actors.iter().find(|a| a.idx == sel).map(|a| a.name.clone()).unwrap_or_default();
                    if !nm.is_empty() {
                        ui.add_space(2.0);
                        if ui.button(egui::RichText::new(format!("Delete  {}", nm)).color(theme::BLOOD_HI)).clicked() { do_delete = Some(sel); }
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
                                let rc = ui.selectable_label(sel, &a.class);
                                if rc.clicked() { pick = Some(a.idx); }
                                if rc.double_clicked() { pick = Some(a.idx); focus = a.pos; }
                            });
                            let rn = ui.selectable_label(sel, egui::RichText::new(&a.name).color(theme::BONE));
                            if rn.clicked() { pick = Some(a.idx); }
                            if rn.double_clicked() { pick = Some(a.idx); focus = a.pos; }
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
                if let Some(p) = focus {
                    self.cam.target = swz(p);
                    self.cam.dist = self.cam.dist.clamp(500.0, 4000.0);
                    self.view_dirty = true;
                }
                if let Some(sel) = do_delete {
                    self.push_undo();
                    let r = self.pkg.as_mut().map(|p| p.delete_actor(sel));
                    match r {
                        Some(Ok(_)) => {
                            if let Some(p) = &self.pkg { self.map_actors = p.actors(); }
                            self.sel_obj = None; self.xform_for = None; self.dirty = true;
                            self.scene_key = Some((self.sel_pkg.unwrap_or(0), Some(usize::MAX)));
                            self.view_dirty = true;
                            self.status = "actor deleted — Save .umap to write".into();
                        }
                        Some(Err(e)) => { self.undo_stack.pop(); self.status = format!("delete failed: {}", e); }
                        None => { self.undo_stack.pop(); }
                    }
                }
                if do_xform {
                    if self.xform.iter().enumerate().any(|(i, pe)| self.xform_orig.get(i) != Some(&pe.value)) { self.push_undo(); }
                    if let Some(pkg) = &mut self.pkg {
                        for (i, pe) in self.xform.iter().enumerate() {
                            if self.xform_orig.get(i) == Some(&pe.value) { continue; }
                            let o = pe.off;
                            if o + 4 > pkg.buf.len() { continue; }
                            match pe.kind {
                                2 => if let Ok(v) = pe.value.trim().parse::<f32>() { pkg.buf[o..o + 4].copy_from_slice(&v.to_le_bytes()); },
                                5 => if let Ok(d) = pe.value.trim().parse::<f32>() { let u = (d * 65536.0 / 360.0).round() as i32; pkg.buf[o..o + 4].copy_from_slice(&u.to_le_bytes()); },
                                1 => if let Ok(v) = pe.value.trim().parse::<i32>() { pkg.buf[o..o + 4].copy_from_slice(&v.to_le_bytes()); },
                                _ => {}
                            }
                        }
                    }
                    if let (Some(sel), Some(pkg)) = (self.sel_obj, &self.pkg) {
                        if let Some(m) = pkg.actor_matrix(sel) {
                            if let Some(a) = self.map_actors.iter_mut().find(|a| a.idx == sel) { a.pos = Some((m[12], m[13], m[14])); }
                        }
                    }
                    self.xform_orig = self.xform.iter().map(|e| e.value.clone()).collect();
                    self.dirty = true;
                    self.scene_key = Some((self.sel_pkg.unwrap_or(0), Some(usize::MAX)));
                    self.view_dirty = true;
                    self.status = "transform applied — Save .umap to write".into();
                }
                if do_xsave {
                    if let (Some(pkg), Some(pi)) = (&self.pkg, self.sel_pkg) {
                        let name = self.packages[pi].file_name().unwrap().to_string_lossy().to_string();
                        let out = pkg.to_uncompressed();
                        let res = rfd::FileDialog::new().set_file_name(&name).save_file().map(|path| {
                            if path.exists() { let _ = std::fs::copy(&path, format!("{}.bak", path.display())); }
                            (std::fs::write(&path, &out), path)
                        });
                        match res {
                            Some((Ok(_), path)) => { self.dirty = false; self.status = format!("saved {} ({} KB) -> {}", name, out.len() / 1024, path.display()); }
                            Some((Err(e), _)) => self.status = format!("save FAILED ({}) — edits kept", e),
                            None => {}
                        }
                    }
                }
            }
            } else if self.loc.is_some() {
                ui.horizontal(|ui| {
                    ui.label("Filter:");
                    ui.text_edit_singleline(&mut self.loc_entry_filter);
                    if self.loc_dirty { ui.colored_label(egui::Color32::from_rgb(255, 210, 90), "modified"); }
                    if ui.button("Save (live in-game)").clicked() { do_loc_save = true; }
                });
                let filt = self.loc_entry_filter.to_lowercase();
                if self.loc_vis_filter.as_deref() != Some(filt.as_str()) {
                    let loc = self.loc.as_ref().unwrap();
                    self.loc_visible = loc.entries.iter().enumerate().filter(|(_, e)| {
                        let k = match &e.key { Some(k) => k, None => return false };
                        if filt.is_empty() { return true; }
                        let kt = k.trim_end().trim_end_matches('=').trim_end().to_lowercase();
                        kt.contains(&filt) || e.raw.to_lowercase().contains(&filt)
                    }).map(|(i, _)| i).collect();
                    self.loc_vis_filter = Some(filt);
                }
                let visible = self.loc_visible.clone();
                let loc = self.loc.as_mut().unwrap();
                let mut changed = false;
                egui::ScrollArea::vertical().show(ui, |ui| {
                    egui::Grid::new("locgrid").striped(true).num_columns(2).show(ui, |ui| {
                        for idx in visible {
                            let e = match loc.entries.get_mut(idx) { Some(e) => e, None => continue };
                            let kt = match &e.key { Some(k) => k.trim_end().trim_end_matches('=').trim_end().to_string(), None => continue };
                            ui.label(kt);
                            if ui.add(egui::TextEdit::singleline(&mut e.raw).desired_width(400.0)).changed() { changed = true; }
                            ui.end_row();
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

fn seg_dist(p: egui::Pos2, a: egui::Pos2, b: egui::Pos2) -> f32 {
    let ab = b - a; let l2 = ab.length_sq();
    if l2 < 1e-6 { return p.distance(a); }
    let t = ((p - a).dot(ab) / l2).clamp(0.0, 1.0);
    p.distance(a + ab * t)
}

fn scan_unused(paths: &[PathBuf]) -> (std::collections::HashSet<String>, Vec<PathBuf>, usize) {
    let mut referenced: std::collections::HashSet<String> = std::collections::HashSet::new();
    let mut failed = 0usize;
    for path in paths {
        let loaded = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| upk::Pkg::load(path))).ok().and_then(|r| r.ok());
        let p = match loaded { Some(p) => p, None => { failed += 1; continue } };
        for i in 0..p.imports.len() {
            let mut cur = i;
            let mut guard = 0;
            while guard < 64 {
                let outer = p.import_outers.get(cur).copied().unwrap_or(0);
                if outer < 0 { let n = (-(outer as i64) - 1) as usize; if n < p.imports.len() && n != cur { cur = n; } else { break; } } else { break; }
                guard += 1;
            }
            if let Some(name) = p.imports.get(cur) { referenced.insert(name.to_lowercase()); }
        }
    }
    let root = |stem: &str| ["startup", "globalpersistentcookerdata", "guidcache", "globalshadercache", "coalesced", "entry", "alicegame", "localshadercache"].iter().any(|r| stem.starts_with(r));
    let mut unused = Vec::new();
    for path in paths {
        let ext = path.extension().map(|x| x.to_string_lossy().to_lowercase()).unwrap_or_default();
        if ext == "umap" { continue; }
        let stem = path.file_stem().map(|s| s.to_string_lossy().to_lowercase()).unwrap_or_default();
        if stem.contains("_loc_") { continue; }
        if referenced.contains(&stem) || root(&stem) { continue; }
        unused.push(path.clone());
    }
    unused.sort();
    (referenced, unused, failed)
}

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

// Loads referenced packages on demand and caches decoded imported meshes, so a map's actors
// can pull geometry from other cooked packages (the cross-package "load everything").
#[derive(Default)]
struct AssetCache {
    loaded: std::collections::HashMap<String, Option<upk::Pkg>>,
    meshes: std::collections::HashMap<String, Option<upk::Mesh>>,
    skels: std::collections::HashMap<String, Option<upk::SkelMesh>>,
}

impl AssetCache {
    fn package(&mut self, name: &str, packages: &[PathBuf]) -> Option<&upk::Pkg> {
        if !self.loaded.contains_key(name) {
            let path = packages.iter().find(|p| p.file_stem().map(|s| s.eq_ignore_ascii_case(name)).unwrap_or(false)).cloned();
            let pkg = path.and_then(|p| std::panic::catch_unwind(|| upk::Pkg::load(&p)).ok().and_then(|r| r.ok()));
            self.loaded.insert(name.to_string(), pkg);
        }
        self.loaded.get(name).and_then(|o| o.as_ref())
    }

    fn diffuse_texture(&mut self, host: &upk::Pkg, root: usize, mesh_name: &str, packages: &[PathBuf], cooked: &std::path::Path) -> Option<(usize, usize, Vec<u8>)> {
        let mesh = mesh_name.to_lowercase();
        let verb = std::env::var("TEXVERB").is_ok();
        let dbg = std::env::var("TEXDBG").is_ok();
        let affinity = |a: &str, b: &str| -> usize { a.bytes().zip(b.bytes()).take_while(|(x, y)| x == y).count() };
        let mut seen = std::collections::HashSet::new();
        let mut queue = std::collections::VecDeque::new();
        let mut bonus: std::collections::HashMap<(String, usize), i32> = std::collections::HashMap::new();
        queue.push_back((String::new(), root));
        let mut cands: Vec<(i32, String, usize)> = Vec::new();
        let mut steps = 0;
        while let Some((pname, ei)) = queue.pop_front() {
            if steps > 600 { break; } steps += 1;
            if !seen.insert((pname.clone(), ei)) { continue; }
            let nodebonus = bonus.get(&(pname.clone(), ei)).copied().unwrap_or(0);
            type Enq = (Option<(String, String)>, usize, i32);
            let (cand, refs): (Option<i32>, Vec<Enq>) = {
                let pkg = if pname.is_empty() { host } else { match self.package(&pname, packages) { Some(p) => p, None => continue } };
                let e = match pkg.exports.get(ei) { Some(e) => e, None => continue };
                if verb { eprintln!("  visit {}.{} [{}] bonus={}", pname, e.name, e.class_name, nodebonus); }
                let mut cand = None;
                if e.class_name == "Texture2D" {
                    let n = e.name.to_lowercase();
                    let is_diff = n.contains("diffuse") || n.contains("albedo")
                        || ["_dm", "_diff", "_diffuse", "_albedo", "_col", "_bc"].iter().any(|s| n.ends_with(s));
                    let is_other = n.contains("normal") || n.contains("_mask") || n.contains("_spec")
                        || ["_n", "_nrm", "_norm", "_msk", "_sp", "_cube", "_emap", "_em", "_sm", "_nm"].iter().any(|s| n.ends_with(s));
                    let mut score = nodebonus;
                    if !mesh.is_empty() && n.starts_with(&mesh) { score += 1000; }
                    else if !mesh.is_empty() && n.contains(&mesh) { score += 600; }
                    if is_diff { score += 100; }
                    if pname.is_empty() { score += 20; }
                    if is_other { score -= 800; }
                    if dbg { eprintln!("  TEX {} score={}", e.name, score); }
                    cand = Some(score);
                }
                let follow = |cls: &str| cls == "StaticMesh" || cls == "SkeletalMesh" || cls == "Texture2D"
                    || (cls.contains("Material") && !cls.contains("Expression"));
                let mut refs: Vec<Enq> = Vec::new();
                if e.class_name.contains("Material") && !e.class_name.contains("Expression") {
                    if let Some(dr) = pkg.material_diffuse_ref(ei) {
                        let texname = if dr > 0 { pkg.exports.get((dr - 1) as usize).map(|x| x.name.to_lowercase()) }
                            else if dr < 0 { pkg.imports.get((-(dr as i64) - 1) as usize).map(|s| s.to_lowercase()) } else { None };
                        let aff = affinity(&e.name.to_lowercase(), &mesh).max(texname.as_deref().map(|t| affinity(t, &mesh)).unwrap_or(0)) as i32;
                        let b = 1500 + aff * 800;
                        match pkg.resolve_ref(dr) {
                            upk::Ref::Local(l) => refs.push((None, l, b)),
                            upk::Ref::Import { package, object } => refs.push((Some((package, object)), 0, b)),
                            upk::Ref::None => {}
                        }
                    }
                }
                let mut rr = pkg.collect_refs(e.off);
                rr.extend(pkg.relevant_refs(e));
                rr.sort_unstable(); rr.dedup();
                for r in rr {
                    let cls = match if r > 0 { pkg.exports.get((r - 1) as usize).map(|x| x.class_name.as_str()) }
                        else if r < 0 { pkg.import_classes.get((-(r as i64) - 1) as usize).map(|x| x.as_str()) }
                        else { None } { Some(c) => c, None => continue };
                    if !follow(cls) { continue; }
                    match pkg.resolve_ref(r) {
                        upk::Ref::Local(l) => refs.push((None, l, 0)),
                        upk::Ref::Import { package, object } => refs.push((Some((package, object)), 0, 0)),
                        upk::Ref::None => {}
                    }
                }
                (cand, refs)
            };
            if let Some(s) = cand { cands.push((s, pname.clone(), ei)); }
            for (imp, lei, b) in refs {
                let key = match imp {
                    None => (pname.clone(), lei),
                    Some((package, object)) => {
                        match self.package(&package, packages).and_then(|p2| p2.exports.iter().position(|x| x.name == object)) {
                            Some(oei) => (package, oei), None => continue,
                        }
                    }
                };
                if b > 0 { bonus.entry(key.clone()).and_modify(|x| *x = (*x).max(b)).or_insert(b); }
                queue.push_back(key);
            }
        }
        cands.sort_by(|a, b| b.0.cmp(&a.0));
        for (_, pname, ei) in cands {
            let pkg = if pname.is_empty() { host } else { match self.package(&pname, packages) { Some(p) => p, None => continue } };
            if let Some(e) = pkg.exports.get(ei) {
                if let Some(t) = pkg.texture(e, cooked) { return Some((t.w, t.h, t.rgba)); }
            }
        }
        None
    }

    fn import_mesh(&mut self, package: &str, object: &str, packages: &[PathBuf]) -> Option<&upk::Mesh> {
        let key = format!("{}/{}", package, object);
        if !self.meshes.contains_key(&key) {
            let m = self.package(package, packages).and_then(|pkg| {
                pkg.exports.iter().position(|e| e.class_name == "StaticMesh" && e.name == object)
                    .and_then(|ei| pkg.static_mesh(&pkg.exports[ei]))
            });
            self.meshes.insert(key.clone(), m);
        }
        self.meshes.get(&key).and_then(|o| o.as_ref())
    }

    fn import_texture(&mut self, package: &str, object: &str, packages: &[PathBuf], cooked: &std::path::Path) -> Option<(usize, usize, Vec<u8>)> {
        let pkg = self.package(package, packages)?;
        let e = pkg.exports.iter().find(|e| e.class_name.contains("Texture") && e.name == object)?;
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| pkg.texture(e, cooked))).ok().flatten().map(|t| (t.w, t.h, t.rgba))
    }

    fn material_diffuse(&mut self, pkg: &upk::Pkg, mat_ei: usize, packages: &[PathBuf], cooked: &std::path::Path) -> Option<(usize, usize, Vec<u8>)> {
        match pkg.resolve_ref(pkg.material_diffuse_ref(mat_ei)?) {
            upk::Ref::Local(li) => pkg.exports.get(li).filter(|x| x.class_name.contains("Texture")).and_then(|te| std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| pkg.texture(te, cooked))).ok().flatten()).map(|t| (t.w, t.h, t.rgba)),
            upk::Ref::Import { package, object } => self.import_texture(&package, &object, packages, cooked),
            upk::Ref::None => None,
        }
    }

    fn import_material_diffuse(&mut self, package: &str, object: &str, packages: &[PathBuf], cooked: &std::path::Path) -> Option<(usize, usize, Vec<u8>)> {
        let pkg = self.package(package, packages)?;
        let mei = pkg.exports.iter().position(|e| e.name == object && e.class_name.contains("Material") && !e.class_name.contains("Expression"))?;
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| pkg.diffuse_texture(mei, cooked))).ok().flatten().map(|t| (t.w, t.h, t.rgba))
    }

    fn section_diffuse(&mut self, pkg: &upk::Pkg, mat_ref: i32, packages: &[PathBuf], cooked: &std::path::Path) -> Option<(usize, usize, Vec<u8>)> {
        match pkg.resolve_ref(mat_ref) {
            upk::Ref::Local(li) => self.material_diffuse(pkg, li, packages, cooked)
                .or_else(|| std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| pkg.diffuse_texture(li, cooked))).ok().flatten().map(|t| (t.w, t.h, t.rgba))),
            upk::Ref::Import { package, object } => self.import_material_diffuse(&package, &object, packages, cooked),
            upk::Ref::None => None,
        }
    }

    fn import_skeletal_mesh(&mut self, package: &str, object: &str, packages: &[PathBuf]) -> Option<&upk::SkelMesh> {
        let key = format!("{}/{}", package, object);
        if !self.skels.contains_key(&key) {
            let m = self.package(package, packages).and_then(|pkg| {
                pkg.exports.iter().position(|e| e.class_name == "SkeletalMesh" && e.name == object)
                    .and_then(|ei| pkg.skeletal_mesh(&pkg.exports[ei]))
            });
            self.skels.insert(key.clone(), m);
        }
        self.skels.get(&key).and_then(|o| o.as_ref())
    }
}

fn swz3(w: [f32; 3]) -> [f32; 3] { [w[0], w[2], w[1]] }

fn is_fx_mesh(name: &str) -> bool {
    let n = name.to_lowercase();
    ["lightbeam", "moonbeam", "moonlight", "lightshaft", "godray", "lightcone", "lensflare",
     "smoke", "wisp", "flare", "dustmote", "motes", "lightcard", "beam_plane"]
        .iter().any(|k| n.contains(k))
}

// Map each level-BSP Model (the one a ModelComponent references) to a node-index -> Material-ref
// table, decoded from the component's FModelElements (each is a Material ref then a Nodes WORD-list).
fn bsp_element_materials(pkg: &upk::Pkg) -> std::collections::HashMap<usize, std::collections::HashMap<usize, i32>> {
    let b = &pkg.buf;
    let i32a = |o: usize| i32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]);
    let u16a = |o: usize| u16::from_le_bytes([b[o], b[o + 1]]) as usize;
    let u32a = |o: usize| u32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) as usize;
    let is_mat = |r: i32| r > 0 && pkg.exports.get((r - 1) as usize).map(|x| (x.class_name == "Material" || x.class_name.contains("MaterialInstance")) && !x.class_name.contains("Expression")).unwrap_or(false);
    let mut out: std::collections::HashMap<usize, std::collections::HashMap<usize, i32>> = std::collections::HashMap::new();
    for mc in pkg.exports.iter().filter(|x| x.class_name == "ModelComponent") {
        let (ms, me) = (mc.off as usize, ((mc.off + mc.size.max(0)) as usize).min(b.len()));
        let mut model_ei = None;
        let mut q = ms;
        while q + 4 <= me { let r = i32a(q); if r > 0 && pkg.exports.get((r - 1) as usize).map(|x| x.class_name == "Model").unwrap_or(false) { model_ei = Some((r - 1) as usize); break; } q += 1; }
        let model_ei = match model_ei { Some(m) => m, None => continue };
        if std::env::var("BSPDBG").is_ok() { eprintln!("  MC {} -> Model {}", mc.name, pkg.exports.get(model_ei).map(|x| x.name.as_str()).unwrap_or("?")); }
        let map = out.entry(model_ei).or_default();
        let mut q = ms;
        while q + 8 <= me {
            if is_mat(i32a(q)) {
                let ncount = u32a(q + 4);
                if ncount >= 1 && ncount <= 4096 && q + 8 + ncount * 2 <= me && (0..ncount).all(|k| u16a(q + 8 + k * 2) < 8192) {
                    for k in 0..ncount { map.insert(u16a(q + 8 + k * 2), i32a(q)); }
                    q += 8 + ncount * 2; continue;
                }
            }
            q += 1;
        }
    }
    out
}

fn append_terrain(sc: &mut view3d::Scene, pkg: &upk::Pkg, assets: &mut AssetCache, packages: &[PathBuf], cooked: Option<&std::path::Path>) {
    for (ei, e) in pkg.exports.iter().enumerate().filter(|(_, e)| e.class_name == "Terrain") {
        let t = match pkg.terrain_mesh(e, ei) { Some(t) => t, None => continue };
        let m = pkg.actor_matrix(ei);
        let mat_ref = pkg.first_ref_of_class(e, "TerrainLayerSetup")
            .filter(|&r| r > 0)
            .and_then(|r| pkg.exports.get((r - 1) as usize))
            .and_then(|tls| pkg.first_ref_of_class(tls, "TerrainMaterial"))
            .filter(|&r| r > 0)
            .and_then(|r| pkg.exports.get((r - 1) as usize))
            .and_then(|tm| pkg.object_ref(tm.off, "Material"));
        let ti = match (mat_ref, cooked) {
            (Some(mr), Some(c)) if mr > 0 => {
                let mei = (mr - 1) as usize;
                let hint = pkg.exports.get(mei).map(|x| x.name.split('_').next().unwrap_or("").to_lowercase()).unwrap_or_default();
                let tex = assets.material_diffuse(pkg, mei, packages, c)
                    .or_else(|| assets.diffuse_texture(pkg, mei, &hint, packages, c));
                match tex {
                    Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); (sc.textures.len() - 1) as i32 }
                    None => -1,
                }
            }
            _ => -1,
        };
        let mesh = upk::Mesh { verts: t.verts, uvs: t.uvs, indices: t.indices };
        add_mesh_tris(sc, &mesh, m, None, [150, 150, 138], ti);
    }
}

fn append_bsp(sc: &mut view3d::Scene, pkg: &upk::Pkg, lo: [f32; 3], hi: [f32; 3], assets: &mut AssetCache, packages: &[PathBuf], cooked: Option<&std::path::Path>) {
    let dbg = std::env::var("BSPDBG").is_ok();
    let elem_mats = bsp_element_materials(pkg);
    let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]);
    let u32a = |b: &[u8], o: usize| u32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]) as usize;
    let i32a = |b: &[u8], o: usize| i32::from_le_bytes([b[o], b[o + 1], b[o + 2], b[o + 3]]);
    let inb = |v: [f32; 3]| (0..3).all(|k| v[k].is_finite() && v[k] >= lo[k] && v[k] <= hi[k]);
    for (model_ei, e) in pkg.exports.iter().enumerate().filter(|(_, e)| e.class_name == "Model" && e.size > 600) {
        let b = &pkg.buf;
        let (s, en) = (e.off as usize, ((e.off + e.size.max(0)) as usize).min(b.len()));
        // --- parse the UModel BSP arrays (Vectors/Points/Nodes are TArray::BulkSerialize:
        //     [elemSize i32][count i32][data]); Surfs (60B, Material@0) follow non-bulk after Nodes ---
        let mut anchor = None;
        let mut o = s;
        while o + 8 <= en {
            let (elem, cnt) = (u32a(b, o), u32a(b, o + 4));
            if elem == 12 && cnt >= 3 && cnt < 100000 && o + 8 + 12 * cnt <= en
                && (0..cnt.min(8)).all(|i| { let q = o + 8 + i * 12; (0..3).all(|k| { let v = f32a(b, q + k * 4); v.is_finite() && v.abs() < 1.0e6 }) }) { anchor = Some(o); break; }
            o += 4;
        }
        let a = match anchor { Some(a) => a, None => continue };
        let mut nodes: Vec<(usize, usize, usize)> = Vec::new();   // (iVertexIndex, NumVertices, iSurf)
        let (mut o, mut surf_off, mut steps) = (a, 0usize, 0);
        while o + 8 <= en && steps < 4 {
            let (elem, cnt) = (u32a(b, o), u32a(b, o + 4));
            if elem == 0 || elem > 4096 || cnt > 1_000_000 || o + 8 + elem * cnt > en { surf_off = o; break; }
            if elem == 64 {
                for n in 0..cnt { let no = o + 8 + n * 64; nodes.push((i32a(b, no + 24).max(0) as usize, b[no + 54] as usize, i32a(b, no + 20).max(0) as usize)); }
                surf_off = o + 8 + 64 * cnt;   // Surfs (FBspSurf 60B, Material@0) immediately follow Nodes
                break;
            }
            o += 8 + elem * cnt; steps += 1;
        }
        if nodes.is_empty() { continue; }
        let node_mat = match elem_mats.get(&model_ei) { Some(m) => m, None => continue };
        // Surfs follow Nodes after an 8-byte header ([Model selfref 4B][Count 4B]); each FBspSurf is
        // 60B with the Material object ref (4B i32) first. Material may be 0 (untextured surface).
        let max_isurf = nodes.iter().map(|&(_, _, si)| si).max().unwrap_or(0);
        let surf_start = surf_off + 8;
        let mut surfs: Vec<i32> = Vec::new();
        if surf_start + (max_isurf + 1) * 60 <= en {
            for si in 0..=max_isurf { surfs.push(i32a(b, surf_start + si * 60)); }
        }
        let stride = 36usize;
        let mut vb = (0usize, 0usize);
        let mut o = s;
        while o + 8 <= en {
            let count = u32a(b, o + 4);
            if u32a(b, o) == 36 && count >= 4 && count < 1_000_000 && o + 8 + 36 * count <= en
                && count > vb.1
                && (0..count.min(6)).all(|i| inb([f32a(b, o + 8 + i * 36), f32a(b, o + 8 + i * 36 + 4), f32a(b, o + 8 + i * 36 + 8)])) { vb = (o + 8, count); }
            o += 4;
        }
        let (start, vcount) = vb;
        if vcount < 4 { continue; }
        // resolve every material referenced by this Model's surfs and by its ModelComponent elements
        let mut texcache: std::collections::HashMap<i32, i32> = std::collections::HashMap::new();
        if let Some(c) = cooked {
            let mut uniq: Vec<i32> = surfs.clone();
            uniq.extend(node_mat.values().copied());
            uniq.sort_unstable(); uniq.dedup();
            for mref in uniq {
                if mref <= 0 { continue; }
                let m = match pkg.exports.get((mref - 1) as usize) { Some(m) => m, None => continue };
                if !((m.class_name == "Material" || m.class_name.contains("MaterialInstance")) && !m.class_name.contains("Expression")) { continue; }
                let hint = m.name.split('_').next().unwrap_or("").to_lowercase();
                if let Some((w, h, rgba)) = assets.diffuse_texture(pkg, (mref - 1) as usize, &hint, packages, c) {
                    if dbg { eprintln!("BSP {} mat {} -> {}x{}", e.name, m.name, w, h); }
                    sc.textures.push(view3d::Tex { w, h, rgba }); texcache.insert(mref, (sc.textures.len() - 1) as i32);
                }
            }
        }
        let b = &pkg.buf;
        let vert = |i: usize| -> ([f32; 3], [f32; 2]) {
            let vo = start + i * stride;
            (swz3([f32a(b, vo), f32a(b, vo + 4), f32a(b, vo + 8)]), [f32a(b, vo + 20), f32a(b, vo + 24)])
        };
        if dbg { eprintln!("BSP {} nodes={} surfs={} elem-mats={} verts={} stride={}", e.name, nodes.len(), surfs.len(), node_mat.len(), vcount, stride); }
        for (ni, &(ivx, nv, isurf)) in nodes.iter().enumerate() {
            if nv < 3 || ivx + nv > vcount { continue; }
            let mat_ref = node_mat.get(&ni).copied().filter(|&r| r > 0)
                .or_else(|| surfs.get(isurf).copied().filter(|&r| r > 0)).unwrap_or(0);
            let mtex = texcache.get(&mat_ref).copied().unwrap_or(-1);
            for t in 1..nv - 1 {
                let (p0, u0) = vert(ivx); let (p1, u1) = vert(ivx + t); let (p2, u2) = vert(ivx + t + 1);
                sc.tris.push(view3d::Tri { p: [p0, p1, p2], uv: [u0, u1, u2], tex: mtex, color: [150, 142, 128], light: [1.0; 3] });
            }
        }
    }
}

// Transform a mesh's local triangles to world (component matrix if present, else translate by
// the actor position) and append them, swizzled UE Z-up -> render Y-up.
fn add_mesh_tris(sc: &mut view3d::Scene, mesh: &upk::Mesh, mat: Option<[f32; 16]>, pos: Option<(f32, f32, f32)>, color: [u8; 3], tex: i32) {
    let xf = |lp: [f32; 3]| -> [f32; 3] {
        let w = match mat {
            Some(m) => [
                lp[0] * m[0] + lp[1] * m[4] + lp[2] * m[8] + m[12],
                lp[0] * m[1] + lp[1] * m[5] + lp[2] * m[9] + m[13],
                lp[0] * m[2] + lp[1] * m[6] + lp[2] * m[10] + m[14],
            ],
            None => match pos { Some(p) => [lp[0] + p.0, lp[1] + p.1, lp[2] + p.2], None => lp },
        };
        swz3(w)
    };
    let nv = mesh.verts.len();
    let huv = tex >= 0 && mesh.uvs.len() == nv;
    for t in mesh.indices.chunks_exact(3) {
        let (a, b, c) = (t[0] as usize, t[1] as usize, t[2] as usize);
        if a < nv && b < nv && c < nv {
            let uv = if huv { [mesh.uvs[a], mesh.uvs[b], mesh.uvs[c]] } else { [[0.0; 2]; 3] };
            sc.tris.push(view3d::Tri { p: [xf(mesh.verts[a]), xf(mesh.verts[b]), xf(mesh.verts[c])], uv, tex, color, light: [1.0; 3] });
        }
    }
}

fn add_mesh_sections(sc: &mut view3d::Scene, verts: &[[f32; 3]], uvs: &[[f32; 2]], indices: &[u32], secs: &[(usize, usize)], sec_tex: &[i32], mat: Option<[f32; 16]>, pos: Option<(f32, f32, f32)>, color: [u8; 3]) {
    let xf = |lp: [f32; 3]| -> [f32; 3] {
        let w = match mat {
            Some(m) => [
                lp[0] * m[0] + lp[1] * m[4] + lp[2] * m[8] + m[12],
                lp[0] * m[1] + lp[1] * m[5] + lp[2] * m[9] + m[13],
                lp[0] * m[2] + lp[1] * m[6] + lp[2] * m[10] + m[14],
            ],
            None => match pos { Some(p) => [lp[0] + p.0, lp[1] + p.1, lp[2] + p.2], None => lp },
        };
        swz3(w)
    };
    let nv = verts.len();
    for (si, &(first, count)) in secs.iter().enumerate() {
        let tex = sec_tex.get(si).copied().unwrap_or(-1);
        let huv = tex >= 0 && uvs.len() == nv;
        let endi = (first + count).min(indices.len());
        let mut i = first;
        while i + 3 <= endi {
            let (a, b, c) = (indices[i] as usize, indices[i + 1] as usize, indices[i + 2] as usize);
            if a < nv && b < nv && c < nv {
                let uv = if huv { [uvs[a], uvs[b], uvs[c]] } else { [[0.0; 2]; 3] };
                sc.tris.push(view3d::Tri { p: [xf(verts[a]), xf(verts[b]), xf(verts[c])], uv, tex, color, light: [1.0; 3] });
            }
            i += 3;
        }
    }
}

fn build_asset_scene(pkg: &upk::Pkg, ei: usize, cooked: Option<&std::path::Path>, assets: &mut AssetCache, packages: &[PathBuf]) -> Option<(view3d::Scene, [f32; 3], f32, String)> {
    let e = pkg.exports.get(ei)?;
    let mut sc = view3d::Scene::new();
    let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
    let info;
    if e.class_name == "SkeletalMesh" {
        let m = pkg.skeletal_mesh(e)?;
        let mut sec_tex = Vec::with_capacity(m.sections.len());
        let mut ntex = 0;
        for s in &m.sections {
            let mref = m.materials.get(s.material).copied().unwrap_or(0);
            let ti = if mref > 0 {
                match cooked.and_then(|c| assets.material_diffuse(pkg, (mref - 1) as usize, packages, c)) {
                    Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); ntex += 1; (sc.textures.len() - 1) as i32 }
                    None => -1,
                }
            } else { -1 };
            sec_tex.push(ti);
        }
        for v in &m.verts { let w = swz3(*v); for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); } }
        add_skel_tris(&mut sc, &m, None, None, [188, 176, 166], &sec_tex);
        info = format!("SkeletalMesh · {} verts · {} tris · {} sections · {}/{} textured", m.verts.len(), m.indices.len() / 3, m.sections.len(), ntex, m.sections.len());
    } else if e.class_name == "StaticMesh" {
        if let Some((m, secs)) = pkg.static_mesh_structured(e) {
            let mut ntex = 0;
            let mut sec_tex = Vec::with_capacity(secs.len());
            for s in &secs {
                let ti = match cooked.and_then(|c| assets.section_diffuse(pkg, s.material, packages, c)) {
                    Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); ntex += 1; (sc.textures.len() - 1) as i32 }
                    None => -1,
                };
                sec_tex.push(ti);
            }
            for v in &m.verts { let w = swz3(*v); for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); } }
            let ranges: Vec<(usize, usize)> = secs.iter().map(|s| (s.first, s.count)).collect();
            add_mesh_sections(&mut sc, &m.verts, &m.uvs, &m.indices, &ranges, &sec_tex, None, None, [188, 176, 166]);
            info = format!("StaticMesh · {} verts · {} tris · {} sections · {}/{} textured", m.verts.len(), m.indices.len() / 3, secs.len(), ntex, secs.len());
        } else {
            let m = pkg.static_mesh(e)?;
            let smc = pkg.exports.iter().enumerate().find(|(_, c)| c.class_name.contains("StaticMeshComponent") && pkg.object_ref(c.off, "StaticMesh") == Some(ei as i32 + 1)).map(|(i, _)| i);
            let hint = e.name.split('_').next().unwrap_or("").to_lowercase();
            let tex = cooked.and_then(|c| assets.diffuse_texture(pkg, smc.unwrap_or(ei), &hint, packages, c));
            let ti = match tex { Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); 0i32 } None => -1 };
            for v in &m.verts { let w = swz3(*v); for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); } }
            add_mesh_tris(&mut sc, &m, None, None, [188, 176, 166], ti);
            info = format!("StaticMesh · {} verts · {} tris · {} (heuristic)", m.verts.len(), m.indices.len() / 3, if ti >= 0 { "textured" } else { "untextured" });
        }
    } else { return None; }
    if sc.tris.is_empty() { return None; }
    sc.shade();
    let center = [(mn[0] + mx[0]) / 2.0, (mn[1] + mx[1]) / 2.0, (mn[2] + mx[2]) / 2.0];
    let radius = ((mx[0] - mn[0]).powi(2) + (mx[1] - mn[1]).powi(2) + (mx[2] - mn[2]).powi(2)).sqrt().max(1.0) * 0.5;
    Some((sc, center, radius, info))
}

fn add_skel_tris(sc: &mut view3d::Scene, mesh: &upk::SkelMesh, mat: Option<[f32; 16]>, pos: Option<(f32, f32, f32)>, color: [u8; 3], sec_tex: &[i32]) {
    let xf = |lp: [f32; 3]| -> [f32; 3] {
        let w = match mat {
            Some(m) => [
                lp[0] * m[0] + lp[1] * m[4] + lp[2] * m[8] + m[12],
                lp[0] * m[1] + lp[1] * m[5] + lp[2] * m[9] + m[13],
                lp[0] * m[2] + lp[1] * m[6] + lp[2] * m[10] + m[14],
            ],
            None => match pos { Some(p) => [lp[0] + p.0, lp[1] + p.1, lp[2] + p.2], None => lp },
        };
        swz3(w)
    };
    let nv = mesh.verts.len();
    for (si, s) in mesh.sections.iter().enumerate() {
        let tex = sec_tex.get(si).copied().unwrap_or(-1);
        let huv = tex >= 0 && mesh.uvs.len() == nv;
        let end = (s.first + s.count).min(mesh.indices.len());
        let mut i = s.first;
        while i + 3 <= end {
            let (a, b, c) = (mesh.indices[i] as usize, mesh.indices[i + 1] as usize, mesh.indices[i + 2] as usize);
            if a < nv && b < nv && c < nv {
                let uv = if huv { [mesh.uvs[a], mesh.uvs[b], mesh.uvs[c]] } else { [[0.0; 2]; 3] };
                sc.tris.push(view3d::Tri { p: [xf(mesh.verts[a]), xf(mesh.verts[b]), xf(mesh.verts[c])], uv, tex, color, light: [1.0; 3] });
            }
            i += 3;
        }
    }
}

// Build the renderable world: real StaticMesh geometry (coloured by its material's diffuse
// texture where resolvable) and small markers for lights and other non-mesh actors.
fn build_world_scene(pkg: &upk::Pkg, actors: &[upk::MapActor], sel: Option<usize>,
    meshc: &mut std::collections::HashMap<usize, Option<(upk::Mesh, Vec<upk::SmSection>)>>,
    matc: &mut std::collections::HashMap<usize, [u8; 3]>,
    cooked: Option<&std::path::Path>,
    texd: &mut std::collections::HashMap<usize, Option<(usize, usize, Vec<u8>)>>,
    assets: &mut AssetCache, packages: &[PathBuf]) -> view3d::Scene {
    let perf = std::env::var("PERFDBG").is_ok();
    let t0 = std::time::Instant::now();
    let (mut t_mesh, mut t_tex) = (std::time::Duration::ZERO, std::time::Duration::ZERO);
    let mut sc = view3d::Scene::new();
    let mut tex_idx: std::collections::HashMap<i32, i32> = std::collections::HashMap::new();
    let placed: Vec<Placed> = actors.iter().filter_map(|a| a.pos.map(|p| (a.idx, a.class.clone(), p))).collect();
    if placed.is_empty() { return sc; }
    let (mn, mx) = scene_bounds(&placed);
    let ext = (mx[0] - mn[0]).max(mx[1] - mn[1]).max(mx[2] - mn[2]).max(1.0);
    let hs = ext / 150.0;
    let gy = mn[1] - hs;
    let n = 16;
    let (gx0, gx1, gz0, gz1) = (mn[0] - hs, mx[0] + hs, mn[2] - hs, mx[2] + hs);
    for i in 0..=n {
        let f = i as f32 / n as f32;
        sc.lines.push(([gx0 + (gx1 - gx0) * f, gy, gz0], [gx0 + (gx1 - gx0) * f, gy, gz1], [44, 39, 32]));
        sc.lines.push(([gx0, gy, gz0 + (gz1 - gz0) * f], [gx1, gy, gz0 + (gz1 - gz0) * f], [44, 39, 32]));
    }
    let terrainonly = std::env::var("TERRAINONLY").is_ok();
    let bsponly = std::env::var("BSPONLY").is_ok() || terrainonly;
    let (mut n_local, mut n_import) = (0usize, 0usize);
    for a in actors.iter().filter(|_| !bsponly) {
        let is_sel = sel == Some(a.idx);
        // collect real point lights from the map (PointLight / SpotLight) to light the scene
        let smc = a.components.iter().copied().find(|&c| pkg.exports[c].class_name.contains("StaticMeshComponent"));
        let mut drew_mesh = false;
        if let Some(smc) = smc {
            let off = pkg.exports[smc].off;
            let mat = pkg.actor_matrix(a.idx).or_else(|| pkg.world_matrix(off));
            if let Some(r) = pkg.object_ref(off, "StaticMesh") {
                match pkg.resolve_ref(r) {
                    upk::Ref::Local(ei) if is_fx_mesh(pkg.exports.get(ei).map(|e| e.name.as_str()).unwrap_or("")) => { drew_mesh = true; }
                    upk::Ref::Import { object, .. } if is_fx_mesh(&object) => { drew_mesh = true; }
                    upk::Ref::Local(ei) => {
                        let tm = std::time::Instant::now();
                        let mesh = meshc.entry(ei).or_insert_with(|| {
                            pkg.exports.get(ei).filter(|e| e.class_name == "StaticMesh")
                                .and_then(|e| pkg.static_mesh_structured(e).or_else(|| pkg.static_mesh(e).map(|m| (m, Vec::new()))))
                        });
                        t_mesh += tm.elapsed();
                        if let Some((m, secs)) = mesh {
                            let ranges: Vec<(usize, usize)> = if secs.is_empty() { vec![(0, m.indices.len())] } else { secs.iter().map(|s| (s.first, s.count)).collect() };
                            let sec_tex: Vec<i32> = if is_sel {
                                vec![-1; ranges.len()]
                            } else if secs.is_empty() {
                                let key = -(ei as i32) - 1000000;
                                let ti = if let Some(&i) = tex_idx.get(&key) { i } else {
                                    if !texd.contains_key(&(key as usize)) {
                                        let mname = pkg.exports.get(ei).map(|e| e.name.clone()).unwrap_or_default();
                                        let tt = std::time::Instant::now();
                                        let decoded = cooked.and_then(|c| assets.diffuse_texture(pkg, smc, &mname, packages, c));
                                        t_tex += tt.elapsed();
                                        texd.insert(key as usize, decoded);
                                    }
                                    let i = match texd.get(&(key as usize)).and_then(|o| o.as_ref()) {
                                        Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w: *w, h: *h, rgba: rgba.clone() }); (sc.textures.len() - 1) as i32 }
                                        None => -1,
                                    };
                                    tex_idx.insert(key, i); i
                                };
                                vec![ti]
                            } else {
                                secs.iter().map(|s| {
                                    let mref = s.material;
                                    if mref == 0 { return -1; }
                                    if let Some(&i) = tex_idx.get(&mref) { return i; }
                                    if !texd.contains_key(&(mref as usize)) {
                                        let tt = std::time::Instant::now();
                                        let decoded = cooked.and_then(|c| assets.section_diffuse(pkg, mref, packages, c));
                                        t_tex += tt.elapsed();
                                        texd.insert(mref as usize, decoded);
                                    }
                                    let i = match texd.get(&(mref as usize)).and_then(|o| o.as_ref()) {
                                        Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w: *w, h: *h, rgba: rgba.clone() }); (sc.textures.len() - 1) as i32 }
                                        None => -1,
                                    };
                                    tex_idx.insert(mref, i); i
                                }).collect()
                            };
                            let col = if is_sel { [206, 58, 50] }
                                else if sec_tex.iter().any(|&t| t >= 0) { [180, 175, 165] }
                                else { *matc.entry(ei).or_insert_with(|| cooked.and_then(|c| pkg.diffuse_color(smc, c)).unwrap_or([150, 140, 130])) };
                            add_mesh_sections(&mut sc, &m.verts, &m.uvs, &m.indices, &ranges, &sec_tex, mat, a.pos, col);
                            n_local += 1;
                            drew_mesh = true;
                        }
                    }
                    upk::Ref::Import { package, object } => {
                        if let Some(m) = assets.import_mesh(&package, &object, packages) {
                            let col = if is_sel { [206, 58, 50] } else { [150, 155, 165] };
                            add_mesh_tris(&mut sc, m, mat, a.pos, col, -1);
                            n_import += 1;
                            drew_mesh = true;
                        }
                    }
                    upk::Ref::None => {}
                }
            }
        }
        if !drew_mesh {
            if let Some(skc) = a.components.iter().copied().find(|&c| pkg.exports[c].class_name.contains("SkeletalMeshComponent")) {
                let off = pkg.exports[skc].off;
                let mat = pkg.actor_matrix(a.idx).or_else(|| pkg.world_matrix(off));
                if let Some(r) = pkg.object_ref(off, "SkeletalMesh") {
                    match pkg.resolve_ref(r) {
                        upk::Ref::Local(ei) => {
                            let sm = pkg.exports.get(ei).filter(|e| e.class_name == "SkeletalMesh").and_then(|e| pkg.skeletal_mesh(e));
                            if let Some(m) = sm {
                                let mut sec_tex = Vec::with_capacity(m.sections.len());
                                for s in &m.sections {
                                    let mref = m.materials.get(s.material).copied().unwrap_or(0);
                                    let ti = if mref > 0 {
                                        match cooked.and_then(|c| assets.material_diffuse(pkg, (mref - 1) as usize, packages, c)) {
                                            Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); (sc.textures.len() - 1) as i32 }
                                            None => -1,
                                        }
                                    } else { -1 };
                                    sec_tex.push(ti);
                                }
                                let col = if is_sel { [206, 58, 50] } else { [185, 172, 162] };
                                add_skel_tris(&mut sc, &m, mat, a.pos, col, &sec_tex);
                                drew_mesh = true;
                            }
                        }
                        upk::Ref::Import { package, object } => {
                            let hint = object.to_lowercase();
                            let tex = cooked.and_then(|c| assets.diffuse_texture(pkg, skc, &hint, packages, c));
                            let ti = match tex { Some((w, h, rgba)) => { sc.textures.push(view3d::Tex { w, h, rgba }); (sc.textures.len() - 1) as i32 } None => -1 };
                            if let Some(m) = assets.import_skeletal_mesh(&package, &object, packages) {
                                let col = if is_sel { [206, 58, 50] } else { [180, 168, 178] };
                                let sec_tex = vec![ti; m.sections.len()];
                                add_skel_tris(&mut sc, m, mat, a.pos, col, &sec_tex);
                                drew_mesh = true;
                            }
                        }
                        upk::Ref::None => {}
                    }
                }
            }
        }
        if !drew_mesh {
            if let Some(p) = a.pos {
                let lc = a.class.to_lowercase();
                let (sz, col) = if is_sel { (hs * 1.4, [206, 58, 50]) }
                    else if lc.contains("light") { (hs * 0.4, [220, 200, 120]) }
                    else if lc.contains("spawn") || lc.contains("playerstart") { (hs * 0.6, [120, 200, 130]) }
                    else { (hs * 0.6, class_rgb(&a.class)) };
                sc.box_solid(swz(p), [sz; 3], col);
            }
        }
    }
    {
        let ue: Vec<[f32; 3]> = actors.iter().filter_map(|a| a.pos.map(|p| [p.0, p.1, p.2])).collect();
        if ue.len() >= 3 {
            let (mut blo, mut bhi) = ([f32::MAX; 3], [f32::MIN; 3]);
            for v in &ue { for k in 0..3 { blo[k] = blo[k].min(v[k]); bhi[k] = bhi[k].max(v[k]); } }
            let bext = (bhi[0] - blo[0]).max(bhi[1] - blo[1]).max(bhi[2] - blo[2]).max(2000.0);
            for k in 0..3 { blo[k] -= bext; bhi[k] += bext; }
            if !terrainonly { append_bsp(&mut sc, pkg, blo, bhi, assets, packages, cooked); }
        }
    }
    append_terrain(&mut sc, pkg, assets, packages, cooked);
    sc.shade();
    if perf { eprintln!("PERF total {:?} | static_mesh {:?} | diffuse_texture {:?} ({} tris)", t0.elapsed(), t_mesh, t_tex, sc.tris.len()); }
    if std::env::var("SMSTATS").is_ok() { eprintln!("SMSTATS local(per-section)={} import(untextured)={}", n_local, n_import); }
    if std::env::var("TEXDBG").is_ok() {
        let textured = sc.tris.iter().filter(|t| t.tex >= 0).count();
        eprintln!("TEXDBG textures={} tris={} textured_tris={}", sc.textures.len(), sc.tris.len(), textured);
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
    if args.len() > 2 && args[1] == "--xtest" {
        let mut p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let actors = p.actors();
        let idx = actors.iter().map(|a| a.idx).filter(|&i| !p.transform_edits(i).is_empty()).max_by_key(|&i| p.transform_edits(i).len()).expect("no editable actor");
        let edits = p.transform_edits(idx);
        let targets: Vec<f32> = edits.iter().map(|e| {
            let cur: f32 = e.value.trim().parse().unwrap_or(0.0);
            if e.kind == 5 { cur + 45.0 } else if e.name.starts_with("DrawScale") { cur + 0.5 } else { cur + 1234.0 }
        }).collect();
        for (e, &t) in edits.iter().zip(targets.iter()) {
            let o = e.off; if o + 4 > p.buf.len() { continue; }
            match e.kind {
                2 => p.buf[o..o + 4].copy_from_slice(&t.to_le_bytes()),
                5 => { let u = (t * 65536.0 / 360.0).round() as i32; p.buf[o..o + 4].copy_from_slice(&u.to_le_bytes()); }
                1 => p.buf[o..o + 4].copy_from_slice(&(t as i32).to_le_bytes()),
                _ => {}
            }
        }
        std::fs::write("/tmp/xtest.umap", p.to_uncompressed()).unwrap();
        let p2 = Pkg::load(std::path::Path::new("/tmp/xtest.umap")).unwrap();
        let after = p2.transform_edits(idx);
        let mut allok = true;
        for (e, &want) in edits.iter().zip(targets.iter()) {
            let got: f32 = after.iter().find(|x| x.name == e.name).map(|x| x.value.trim().parse().unwrap_or(f32::NAN)).unwrap_or(f32::NAN);
            let tol = if e.kind == 5 { 0.02 } else { 0.5 };
            let ok = (got - want).abs() < tol; if !ok { allok = false; }
            println!("  {:<24} {} -> reloaded {} (want {}) [{}]", e.name, e.value, got, want, if ok { "OK" } else { "FAIL" });
        }
        println!("actor[{}] transform round-trip: {}", idx, if allok { "ALL OK" } else { "FAIL" });
        return Ok(());
    }
    if args.len() > 1 && args[1] == "--classes" {
        let dir = args.get(2).map(|s| s.as_str()).unwrap_or(DEFAULT_DIR);
        let mut paths = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let q = e.path();
                if q.is_dir() { walk(&q, out); }
                else if q.extension().map(|x| { let x = x.to_string_lossy().to_lowercase(); x == "upk" || x == "xxx" || x == "umap" }).unwrap_or(false) { out.push(q); }
            }}
        }
        walk(std::path::Path::new(dir), &mut paths);
        let mut hist: std::collections::BTreeMap<String, usize> = std::collections::BTreeMap::new();
        let mut failed = 0usize;
        for path in &paths {
            match std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| Pkg::load(path))).ok().and_then(|r| r.ok()) {
                Some(p) => for e in &p.exports { *hist.entry(e.class_name.clone()).or_default() += 1; },
                None => failed += 1,
            }
        }
        let mut v: Vec<(String, usize)> = hist.into_iter().collect();
        v.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
        let total: usize = v.iter().map(|(_, n)| n).sum();
        for (c, n) in &v { println!("{:>8}  {}", n, c); }
        println!("--- {} distinct classes, {} total exports, {} packages, {} failed ---", v.len(), total, paths.len(), failed);
        return Ok(());
    }
    if args.len() > 1 && args[1] == "--unused" {
        let dir = args.get(2).map(|s| s.as_str()).unwrap_or(DEFAULT_DIR);
        let mut paths = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let p = e.path();
                if p.is_dir() { walk(&p, out); }
                else if p.extension().map(|x| { let x = x.to_string_lossy().to_lowercase(); x == "upk" || x == "xxx" || x == "umap" }).unwrap_or(false) { out.push(p); }
            }}
        }
        walk(std::path::Path::new(dir), &mut paths);
        let (referenced, unused, failed) = scan_unused(&paths);
        println!("{} packages scanned ({} failed to parse), {} referenced package names, {} UNUSED (never imported, not a map, not a root):", paths.len(), failed, referenced.len(), unused.len());
        let base = std::path::Path::new(dir);
        for p in &unused { println!("  {}", p.strip_prefix(base).unwrap_or(p).display()); }
        return Ok(());
    }
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
        // walk up to the cooked root that actually holds the .tfc files
        let mut cooked = std::path::Path::new(&args[2]).parent().unwrap_or_else(|| std::path::Path::new(DEFAULT_DIR));
        for _ in 0..6 {
            if std::fs::read_dir(cooked).map(|rd| rd.flatten().any(|e| e.path().extension().map(|x| x == "tfc").unwrap_or(false))).unwrap_or(false) { break; }
            if let Some(par) = cooked.parent() { cooked = par; } else { break; }
        }
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
    if args.len() > 3 && args[1] == "--mesh" {
        // --mesh <pkg> <namesubstr> [obj.out] : decode a StaticMesh and report / export OBJ
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let want = args[3].to_lowercase();
        for e in p.exports.iter().filter(|e| e.class_name == "StaticMesh" && e.name.to_lowercase().contains(&want)).take(8) {
            match p.static_mesh(e) {
                Some(m) => {
                    let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
                    for v in &m.verts { for k in 0..3 { mn[k] = mn[k].min(v[k]); mx[k] = mx[k].max(v[k]); } }
                    let (mut umn, mut umx, mut vmn, mut vmx) = (f32::MAX, f32::MIN, f32::MAX, f32::MIN);
                    for uv in &m.uvs { umn = umn.min(uv[0]); umx = umx.max(uv[0]); vmn = vmn.min(uv[1]); vmx = vmx.max(uv[1]); }
                    println!("{:<26} verts={:<6} tris={:<6} bbox=({:.0}..{:.0}, {:.0}..{:.0}, {:.0}..{:.0}) uv=({:.2}..{:.2}, {:.2}..{:.2})",
                        e.name, m.verts.len(), m.indices.len() / 3, mn[0], mx[0], mn[1], mx[1], mn[2], mx[2], umn, umx, vmn, vmx);
                    if let Some(out) = args.get(4) {
                        let mut s = String::new();
                        for v in &m.verts { s.push_str(&format!("v {} {} {}\n", v[0], v[1], v[2])); }
                        for t in m.indices.chunks_exact(3) { s.push_str(&format!("f {} {} {}\n", t[0] + 1, t[1] + 1, t[2] + 1)); }
                        std::fs::write(out, s).unwrap();
                        println!("  wrote OBJ -> {}", out);
                    }
                }
                None => println!("{:<26} decode failed", e.name),
            }
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--rawat" {
        // --rawat <pkg> <namesubstr> [skip] [len] : hex-dump an export's serial bytes
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let skip: usize = args.get(4).and_then(|s| s.parse().ok()).unwrap_or(0);
        let len: usize = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(256);
        if let Some(e) = p.exports.iter().find(|e| e.name.to_lowercase().contains(&args[3].to_lowercase())) {
            let base = e.off as usize + skip;
            let end = (base + len).min((e.off + e.size) as usize).min(p.buf.len());
            println!("{} ({}) size {} — bytes [{}..{}]", e.name, e.class_name, e.size, skip, skip + (end - base));
            let b = &p.buf;
            for row in (base..end).step_by(16) {
                let mut hex = String::new(); let mut asc = String::new();
                for o in row..(row + 16).min(end) {
                    hex.push_str(&format!("{:02x} ", b[o]));
                    let c = b[o]; asc.push(if (32..127).contains(&c) { c as char } else { '.' });
                }
                let f32s: Vec<String> = (row..(row + 16).min(end)).step_by(4)
                    .filter(|&o| o + 4 <= b.len())
                    .map(|o| format!("{:.1}", f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]))).collect();
                println!("{:6} {:<48} {:<16} | {}", row - e.off as usize, hex, asc, f32s.join(" "));
            }
        } else { println!("no export matching '{}'", args[3]); }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--names" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for idx in args[3].split(',') {
            if let Ok(i) = idx.parse::<usize>() {
                println!("names[{}] = {:?}", i, p.names.get(i));
            }
        }
        return Ok(());
    }
    if args.len() > 4 && args[1] == "--render" {
        // --render <pkg> <meshname> <out.png> : decode one StaticMesh and render it isolated
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let e = p.exports.iter().find(|e| e.class_name == "StaticMesh" && e.name.to_lowercase().contains(&args[3].to_lowercase())).expect("mesh not found");
        let m = p.static_mesh(e).expect("decode failed");
        let ei = p.exports.iter().position(|x| std::ptr::eq(x, e)).unwrap_or(0);
        let cooked = std::path::Path::new(&args[2]).parent().unwrap_or(std::path::Path::new("."));
        let mut sc = view3d::Scene::new();
        // resolve the texture via a component that references this mesh (the material lives there)
        let smc = p.exports.iter().enumerate().find(|(_, c)| c.class_name.contains("StaticMeshComponent")
            && p.object_ref(c.off, "StaticMesh") == Some(ei as i32 + 1)).map(|(i, _)| i);
        let tex = match smc.and_then(|s| p.diffuse_texture(s, cooked)) {
            Some(t) => { println!("  texture {}x{} {}", t.w, t.h, t.format); sc.textures.push(view3d::Tex { w: t.w, h: t.h, rgba: t.rgba }); 0i32 }
            None => {
                println!("  no texture -> checkerboard test");
                let (cw, ch) = (64usize, 64usize);
                let mut rgba = vec![0u8; cw * ch * 4];
                for y in 0..ch { for x in 0..cw {
                    let on = ((x / 8) + (y / 8)) % 2 == 0;
                    let c = if on { [220, 80, 80] } else { [40, 40, 60] };
                    let o = (y * cw + x) * 4; rgba[o] = c[0]; rgba[o + 1] = c[1]; rgba[o + 2] = c[2]; rgba[o + 3] = 255;
                }}
                sc.textures.push(view3d::Tex { w: cw, h: ch, rgba }); 0i32
            }
        };
        let huv = tex >= 0 && m.uvs.len() == m.verts.len();
        let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
        for v in &m.verts { let w = swz3(*v); for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); } }
        for t in m.indices.chunks_exact(3) {
            let (a, b, c) = (t[0] as usize, t[1] as usize, t[2] as usize);
            let uv = if huv { [m.uvs[a], m.uvs[b], m.uvs[c]] } else { [[0.0; 2]; 3] };
            sc.tris.push(view3d::Tri { p: [swz3(m.verts[a]), swz3(m.verts[b]), swz3(m.verts[c])], uv, tex, color: [180, 170, 160], light: [1.0; 3] });
        }
        let center = [(mn[0] + mx[0]) / 2.0, (mn[1] + mx[1]) / 2.0, (mn[2] + mx[2]) / 2.0];
        let diag = ((mx[0] - mn[0]).powi(2) + (mx[1] - mn[1]).powi(2) + (mx[2] - mn[2]).powi(2)).sqrt().max(1.0);
        let cam = view3d::Cam { target: center, yaw: 0.7, pitch: 0.5, dist: diag * 1.3 };
        let (w, h) = (700usize, 700usize);
        let mut r = view3d::Raster::new(w, h);
        r.render(&sc, &cam.view_proj(1.0), 0.0);
        image::save_buffer(&args[4], &r.col, w as u32, h as u32, image::ColorType::Rgba8).unwrap();
        println!("rendered {} ({} verts, {} tris) -> {}", e.name, m.verts.len(), m.indices.len() / 3, args[4]);
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--smstruct" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let want = args.get(3).map(|s| s.to_lowercase()).unwrap_or_default();
        let (mut ok, mut fail, mut multi) = (0, 0, 0);
        for e in p.exports.iter().filter(|e| e.class_name == "StaticMesh" && e.name.to_lowercase().contains(&want)) {
            match p.static_mesh_structured(e) {
                Some((m, secs)) => {
                    ok += 1;
                    if secs.len() > 1 { multi += 1; }
                    let heur = p.static_mesh(e).map(|h| h.indices.len() / 3).unwrap_or(0);
                    let oob = m.indices.iter().any(|&i| i as usize >= m.verts.len());
                    if !want.is_empty() || secs.len() > 1 {
                        println!("OK  {:<26} verts={} tris={} sections={} (heur_tris={}) oob={}", e.name, m.verts.len(), m.indices.len() / 3, secs.len(), heur, oob);
                        for s in &secs { println!("      section mat={} first={} tris={}", p.idx_name(s.material), s.first, s.count / 3); }
                    }
                }
                None => { fail += 1; if !want.is_empty() { println!("FAIL {}", e.name); } }
            }
        }
        println!("== {} : OK={} FAIL={} (multi-material={}) ==", std::path::Path::new(&args[2]).file_name().unwrap().to_string_lossy(), ok, fail, multi);
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--postest" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let acts = p.actors();
        let mut n = 0;
        for a in &acts {
            let smc = a.components.iter().copied().find(|&c| p.exports[c].class_name.contains("StaticMeshComponent"));
            let smc = match smc { Some(s) => s, None => continue };
            let am = p.actor_matrix(a.idx).map(|m| (m[12], m[13], m[14]));
            let wm = p.world_matrix(p.exports[smc].off).map(|m| (m[12], m[13], m[14]));
            println!("{:<26} pos={:?}", a.name, a.pos.map(|p| (p.0 as i32, p.1 as i32, p.2 as i32)));
            println!("    actor_matrix(mesh+gizmo a.pos)={:?}  world_matrix(component)={:?}",
                am.map(|m| (m.0 as i32, m.1 as i32, m.2 as i32)), wm.map(|m| (m.0 as i32, m.1 as i32, m.2 as i32)));
            n += 1; if n >= 8 { break; }
        }
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--acttest" {
        let mut p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let before = p.actors();
        let victim = before.iter().rev().find(|a| a.pos.is_some() && !a.class.contains("WorldInfo") && !a.class.contains("Brush") && !a.class.contains("LevelInfo")).map(|a| a.idx);
        let victim = match victim { Some(v) => v, None => { println!("no deletable actor"); return Ok(()); } };
        let vname = p.exports[victim].name.clone();
        let nexp = p.exports.len();
        match p.delete_actor(victim) {
            Ok(n) => println!("deleted '{}' (export {}) — nulled {} Actors slot(s)", vname, victim, n),
            Err(e) => { println!("delete FAILED: {}", e); return Ok(()); }
        }
        let out = p.to_uncompressed();
        std::fs::write("/tmp/acttest.umap", &out).unwrap();
        let p2 = Pkg::load(std::path::Path::new("/tmp/acttest.umap")).unwrap();
        let after = p2.actors();
        let still = after.iter().any(|a| a.idx == victim && a.name == vname);
        println!("actors {} -> {} | exports {} -> {} | deleted-still-listed={}", before.len(), after.len(), nexp, p2.exports.len(), still);
        println!("RESULT: {}", if after.len() == before.len() - 1 && !still && p2.exports.len() == nexp { "OK" } else { "MISMATCH" });
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--terrain" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for (ei, e) in p.exports.iter().enumerate().filter(|(_, e)| e.class_name == "Terrain") {
            match p.terrain_mesh(e, ei) {
                Some(t) => {
                    let mat = p.actor_matrix(ei);
                    println!("OK  {:<18} {}x{} verts={} tris={} localZ=[{:.1}..{:.1}] matrix={}", e.name, t.nvx, t.nvy, t.verts.len(), t.indices.len() / 3, t.hmin, t.hmax, if mat.is_some() { "yes" } else { "NONE(identity)" });
                    if let Some(m) = mat {
                        let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
                        for v in &t.verts {
                            let w = [v[0]*m[0]+v[1]*m[4]+v[2]*m[8]+m[12], v[0]*m[1]+v[1]*m[5]+v[2]*m[9]+m[13], v[0]*m[2]+v[1]*m[6]+v[2]*m[10]+m[14]];
                            for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); }
                        }
                        println!("    world bbox [{:.0},{:.0},{:.0}]..[{:.0},{:.0},{:.0}]", mn[0],mn[1],mn[2], mx[0],mx[1],mx[2]);
                    }
                    if args.len() > 3 {
                        let m = p.actor_matrix(ei).unwrap_or([1.0,0.0,0.0,0.0, 0.0,1.0,0.0,0.0, 0.0,0.0,1.0,0.0, 0.0,0.0,0.0,1.0]);
                        let mut s = String::new();
                        for v in &t.verts {
                            let w = [v[0]*m[0]+v[1]*m[4]+v[2]*m[8]+m[12], v[0]*m[1]+v[1]*m[5]+v[2]*m[9]+m[13], v[0]*m[2]+v[1]*m[6]+v[2]*m[10]+m[14]];
                            s.push_str(&format!("v {} {} {}\n", w[0], w[1], w[2]));
                        }
                        for tri in t.indices.chunks_exact(3) { s.push_str(&format!("f {} {} {}\n", tri[0]+1, tri[1]+1, tri[2]+1)); }
                        std::fs::write(&args[3], s).unwrap();
                        println!("    wrote OBJ -> {}", args[3]);
                    }
                }
                None => println!("FAIL {:<18} @off {} (ei {})", e.name, e.off, ei),
            }
        }
        return Ok(());
    }
    if args.len() > 4 && args[1] == "--renderasset" {
        let mp = std::path::Path::new(&args[2]);
        let p = Pkg::load(mp).unwrap();
        let mut cooked = mp.parent().unwrap_or(std::path::Path::new("."));
        loop {
            if std::fs::read_dir(cooked).map(|rd| rd.flatten().any(|x| x.path().extension().map(|y| y == "tfc").unwrap_or(false))).unwrap_or(false) { break; }
            if let Some(par) = cooked.parent() { cooked = par; } else { break; }
        }
        let mut packages = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let q = e.path();
                if q.is_dir() { walk(&q, out); }
                else if q.extension().map(|x| { let x = x.to_string_lossy().to_lowercase(); x == "upk" || x == "xxx" || x == "umap" }).unwrap_or(false) { out.push(q); }
            }}
        }
        walk(cooked, &mut packages);
        let ei = p.exports.iter().position(|e| (e.class_name == "StaticMesh" || e.class_name == "SkeletalMesh") && e.name.to_lowercase().contains(&args[3].to_lowercase())).expect("mesh not found");
        let mut assets = AssetCache::default();
        let (sc, center, radius, info) = build_asset_scene(&p, ei, Some(cooked), &mut assets, &packages).expect("decode failed");
        println!("  {}", info);
        let yaw = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(0.6f32);
        let pitch = args.get(6).and_then(|s| s.parse().ok()).unwrap_or(0.12f32);
        let cam = view3d::Cam { target: center, yaw, pitch, dist: radius * 2.6 };
        let (w, h) = (640usize, 740usize);
        let mut r = view3d::Raster::new(w, h);
        r.render(&sc, &cam.view_proj(w as f32 / h as f32), 0.0);
        image::save_buffer(&args[4], &r.col, w as u32, h as u32, image::ColorType::Rgba8).unwrap();
        println!("rendered {} ({} tris, {} textures) -> {}", p.exports[ei].name, sc.tris.len(), sc.textures.len(), args[4]);
        return Ok(());
    }
    if args.len() > 4 && args[1] == "--renderskel" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let e = p.exports.iter().find(|e| e.class_name == "SkeletalMesh" && e.name.to_lowercase().contains(&args[3].to_lowercase())).expect("mesh not found");
        let m = p.skeletal_mesh(e).expect("decode failed");
        let mut cooked = std::path::Path::new(&args[2]).parent().unwrap_or(std::path::Path::new("."));
        loop {
            if std::fs::read_dir(cooked).map(|rd| rd.flatten().any(|x| x.path().extension().map(|y| y == "tfc").unwrap_or(false))).unwrap_or(false) { break; }
            if let Some(par) = cooked.parent() { cooked = par; } else { break; }
        }
        let mut sc = view3d::Scene::new();
        let mut sec_tex = Vec::with_capacity(m.sections.len());
        for s in &m.sections {
            let mref = m.materials.get(s.material).copied().unwrap_or(0);
            let ti = if mref > 0 {
                let dref = p.material_diffuse_ref((mref - 1) as usize);
                let tex = dref.and_then(|dr| if dr > 0 { p.exports.get((dr - 1) as usize).and_then(|te| p.texture(te, cooked)) } else { None })
                    .or_else(|| p.diffuse_texture((mref - 1) as usize, cooked));
                match tex {
                    Some(t) => { println!("  section mat {} -> tex {}x{} {}", p.idx_name(mref), t.w, t.h, t.format); sc.textures.push(view3d::Tex { w: t.w, h: t.h, rgba: t.rgba }); (sc.textures.len() - 1) as i32 }
                    None => { println!("  section mat {} -> no texture", p.idx_name(mref)); -1 }
                }
            } else { -1 };
            sec_tex.push(ti);
        }
        let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
        for v in &m.verts { let w = swz3(*v); for k in 0..3 { mn[k] = mn[k].min(w[k]); mx[k] = mx[k].max(w[k]); } }
        add_skel_tris(&mut sc, &m, None, None, [185, 172, 162], &sec_tex);
        sc.shade();
        let center = [(mn[0] + mx[0]) / 2.0, (mn[1] + mx[1]) / 2.0, (mn[2] + mx[2]) / 2.0];
        let diag = ((mx[0] - mn[0]).powi(2) + (mx[1] - mn[1]).powi(2) + (mx[2] - mn[2]).powi(2)).sqrt().max(1.0);
        let yaw = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(0.7f32);
        let pitch = args.get(6).and_then(|s| s.parse().ok()).unwrap_or(0.15f32);
        let cam = view3d::Cam { target: center, yaw, pitch, dist: diag * 1.25 };
        let (w, h) = (640usize, 820usize);
        let mut r = view3d::Raster::new(w, h);
        r.render(&sc, &cam.view_proj(w as f32 / h as f32), 0.0);
        image::save_buffer(&args[4], &r.col, w as u32, h as u32, image::ColorType::Rgba8).unwrap();
        println!("rendered {} ({} verts, {} tris, {} sections, {} textures) -> {}", e.name, m.verts.len(), m.indices.len() / 3, m.sections.len(), sc.textures.len(), args[4]);
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--skmesh" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for (ei, e) in p.exports.iter().enumerate() {
            if e.class_name != "SkeletalMesh" || !e.name.to_lowercase().contains(&args[3].to_lowercase()) { continue; }
            match p.skeletal_mesh(e) {
                Some(m) => {
                    let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
                    for v in &m.verts { for k in 0..3 { mn[k] = mn[k].min(v[k]); mx[k] = mx[k].max(v[k]); } }
                    let (mut umn, mut umx) = (f32::MAX, f32::MIN);
                    for uv in &m.uvs { umn = umn.min(uv[0]).min(uv[1]); umx = umx.max(uv[0]).max(uv[1]); }
                    let degen = m.indices.iter().any(|&i| i as usize >= m.verts.len());
                    println!("OK  {:<26} verts={} uvs={} tris={} sections={} mats={} bbox=[{:.1},{:.1},{:.1}]..[{:.1},{:.1},{:.1}] uv=[{:.2}..{:.2}] idx_oob={}",
                        e.name, m.verts.len(), m.uvs.len(), m.indices.len()/3, m.sections.len(), m.materials.len(),
                        mn[0],mn[1],mn[2], mx[0],mx[1],mx[2], umn, umx, degen);
                    for s in &m.sections { println!("      section mat={} ({}) first={} tris={}", s.material, m.materials.get(s.material).map(|&r| p.idx_name(r)).unwrap_or_default(), s.first, s.count/3); }
                    if args.len() > 4 {
                        let mut s = String::new();
                        for v in &m.verts { s.push_str(&format!("v {} {} {}\n", v[0], v[1], v[2])); }
                        for t in m.indices.chunks_exact(3) { s.push_str(&format!("f {} {} {}\n", t[0]+1, t[1]+1, t[2]+1)); }
                        std::fs::write(&args[4], s).unwrap();
                        println!("      wrote OBJ -> {}", args[4]);
                    }
                }
                None => println!("FAIL {:<26} @off {} (ei {})", e.name, e.off, ei),
            }
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--umodel" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let u32a = |b: &[u8], o: usize| u32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]) as usize;
        let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let b = &p.buf;
        for e in p.exports.iter().filter(|e| e.class_name == "Model" && e.name.to_lowercase().contains(&args[3].to_lowercase())) {
            let (s, en) = (e.off as usize, ((e.off + e.size.max(0)) as usize).min(b.len()));
            println!("== {} (Model) @ {} size {} ==", e.name, e.off, e.size);
            // anchor: Vectors bulk array = [elemSize=12][count][count unit-length FVectors]
            let mut anchor = None;
            let mut o = s;
            while o + 8 <= en {
                let elem = u32a(b, o); let cnt = u32a(b, o + 4);
                if elem == 12 && cnt >= 3 && cnt < 100000 && o + 8 + 12 * cnt <= en {
                    let okv = (0..cnt.min(8)).all(|i| { let q = o + 8 + i * 12; (0..3).all(|k| { let v = f32a(b, q + k*4); v.is_finite() && v.abs() < 1.0e6 }) });
                    if okv { anchor = Some(o); break; }
                }
                o += 4;
            }
            let mut o = match anchor { Some(a) => { println!("  Vectors bulk @ serial-off {}", a - s); a }, None => { println!("  no Vectors anchor"); continue; } };
            let names = ["Vectors", "Points", "Nodes", "?", "Verts", "?", "?", "?"];
            let mut ai = 0;
            while o + 8 <= en && ai < 8 {
                let elem = u32a(b, o); let cnt = u32a(b, o + 4);
                if elem == 0 || elem > 4096 || cnt > 1_000_000 || o + 8 + elem * cnt > en {
                    println!("  [stop=Surfs?] @off {}: i32s:", o - s);
                    let i32a = |q: usize| i32::from_le_bytes([b[q], b[q+1], b[q+2], b[q+3]]);
                    let resolve = |r: i32| if r > 0 { p.exports.get((r-1) as usize).map(|x| format!("{}[{}]", x.name, x.class_name)).unwrap_or_default() } else { String::new() };
                    for k in 0..24 { let q = o + k*4; println!("    +{:<3} {:<10} {}", k*4, i32a(q), resolve(i32a(q))); }
                    println!("  -- surf materials (surf_start=+8, stride 60) --");
                    for si in 0..16 { let q = o + 8 + si*60; if q+4 <= en { let r = i32a(q); println!("    surf{:<2} Material={:<8} {}", si, r, resolve(r)); } }
                    break;
                }
                println!("  {:<8} bulk @off {:<6} elemSize={:<4} count={:<5} -> data {}..{}", names.get(ai).unwrap_or(&"?"), o - s, elem, cnt, o + 8 - s, o + 8 + elem * cnt - s);
                if elem == 64 {
                    let i32a = |o: usize| i32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
                    for n in 0..cnt.min(20) {
                        let no = o + 8 + n * 64;
                        println!("    node{:<2} iSurf@20={:<4} iVertexIndex@24={:<4} NumVerts@54={}", n, i32a(no+20), i32a(no+24), b[no+54]);
                    }
                }
                o += 8 + elem * cnt; ai += 1;
            }
            println!("  (serial ends at {})", en - s);
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--bsp" {
        let map_path = std::path::Path::new(&args[2]);
        let p = Pkg::load(map_path).unwrap();
        let actors = p.actors();
        let placed: Vec<(f32,f32,f32)> = actors.iter().filter_map(|a| a.pos).collect();
        let (mut mn, mut mx) = ([f32::MAX;3],[f32::MIN;3]);
        for q in &placed { let v=[q.0,q.1,q.2]; for k in 0..3 { mn[k]=mn[k].min(v[k]); mx[k]=mx[k].max(v[k]); } }
        let ext = (mx[0]-mn[0]).max(mx[1]-mn[1]).max(mx[2]-mn[2]).max(2000.0);
        let lo = [mn[0]-ext, mn[1]-ext, mn[2]-ext];
        let hi = [mx[0]+ext, mx[1]+ext, mx[2]+ext];
        let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o],b[o+1],b[o+2],b[o+3]]);
        let inb = |v: [f32;3]| (0..3).all(|k| v[k].is_finite() && v[k]>=lo[k] && v[k]<=hi[k]);
        let b = &p.buf;
        let mut sc = view3d::Scene::new();
        let mut total = 0usize;
        for e in p.exports.iter().filter(|e| e.class_name == "Model" && e.size > 2000) {
            let (s, en) = (e.off as usize, ((e.off + e.size.max(0)) as usize).min(b.len()));
            // offsets where a world-space FVector sits
            let mut hits: Vec<usize> = Vec::new();
            let mut o = s;
            while o + 12 <= en { if inb([f32a(b,o),f32a(b,o+4),f32a(b,o+8)]) { hits.push(o); } o += 4; }
            if hits.len() < 9 { continue; }
            let hitset: std::collections::HashSet<usize> = hits.iter().copied().collect();
            // longest run with a constant stride (the vertex buffer)
            let mut best: (usize, usize, usize) = (0,0,0); // (start_off, stride, len)
            for &h0 in &hits {
                for stride in [28usize,32,36,40,44,48] {
                    if hitset.contains(&(h0.wrapping_sub(stride))) { continue; } // only run starts
                    let mut cnt = 1; let mut cur = h0;
                    while hitset.contains(&(cur+stride)) { cur += stride; cnt += 1; }
                    if cnt > best.2 { best = (h0, stride, cnt); }
                }
            }
            let (start, stride, mut cnt) = best;
            if cnt < 6 { continue; }
            if start >= s + 4 {
                let field = u32::from_le_bytes([b[start-4],b[start-3],b[start-2],b[start-1]]) as usize;
                if field >= cnt && field <= cnt*4 && start + field*stride <= en { cnt = field; }
            }
            println!("{} vbuf @off {} stride {} count {}", e.name, start-s, stride, cnt);
            let mode = args.get(6).and_then(|s| s.parse::<u32>().ok()).unwrap_or(0);
            let vert = |i: usize| -> ([f32;3],[f32;2]) {
                let vo = start + i*stride;
                (swz3([f32a(b,vo), f32a(b,vo+4), f32a(b,vo+8)]), [f32a(b,vo+20), f32a(b,vo+24)])
            };
            let mut idx: Vec<usize> = Vec::new();
            match mode {
                1 => { for i in 0..cnt.saturating_sub(2) { idx.extend([0, i+1, i+2]); } }                // fan
                2 => { for i in 0..cnt.saturating_sub(2) { if i%2==0 { idx.extend([i,i+1,i+2]); } else { idx.extend([i+1,i,i+2]); } } } // strip
                3 => { for q in 0..cnt/4 { let o=q*4; idx.extend([o,o+1,o+2, o,o+2,o+3]); } }            // quads
                _ => { for t in 0..cnt/3 { idx.extend([t*3,t*3+1,t*3+2]); } }                            // list
            }
            for tri3 in idx.chunks_exact(3) {
                let (a,ua)=vert(tri3[0]); let (bb,ub)=vert(tri3[1]); let (cc,uc)=vert(tri3[2]);
                sc.tris.push(view3d::Tri { p: [a,bb,cc], uv: [ua,ub,uc], tex: -1, color: [120,120,130], light: [1.0;3] });
                total += 1;
            }
        }
        println!("total BSP tris: {}", total);
        if sc.tris.is_empty() { println!("no BSP geometry"); return Ok(()); }
        let cen = |k: usize| { let mut v: Vec<f32> = sc.tris.iter().flat_map(|t| t.p.iter().map(move |p| p[k])).collect(); v.sort_by(|a,b| a.partial_cmp(b).unwrap()); v[v.len()/2] };
        let center = [cen(0),cen(1),cen(2)];
        let mut d: Vec<f32> = sc.tris.iter().flat_map(|t| t.p.iter()).map(|q| ((q[0]-center[0]).powi(2)+(q[1]-center[1]).powi(2)+(q[2]-center[2]).powi(2)).sqrt()).collect();
        d.sort_by(|a,b| a.partial_cmp(b).unwrap());
        let radius = d[d.len()*80/100].max(1.0);
        let yaw = args.get(4).and_then(|s| s.parse().ok()).unwrap_or(0.7f32);
        let pitch = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(0.5f32);
        let cam = view3d::Cam { target: center, yaw, pitch, dist: radius*2.2 };
        let (w,h) = (1000usize, 700usize);
        let mut r = view3d::Raster::new(w,h);
        r.render(&sc, &cam.view_proj(w as f32/h as f32), 0.0);
        let out = args.get(3).map(|s| s.as_str()).unwrap_or("/tmp/bsp.png");
        image::save_buffer(out, &r.col, w as u32, h as u32, image::ColorType::Rgba8).unwrap();
        println!("rendered -> {}", out);
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--modelscan" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let u32a = |b: &[u8], o: usize| u32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let b = &p.buf;
        for (ei, e) in p.exports.iter().enumerate().filter(|(_, e)| e.class_name == "Model" && e.name.to_lowercase().contains(&args[3].to_lowercase())) {
            let (s, en) = (e.off as usize, ((e.off + e.size.max(0)) as usize).min(b.len()));
            if en - s < 64 { continue; }
            println!("== {} (Model) @ {} size {} ei={} ==", e.name, e.off, e.size, ei);
            let mut o = s;
            while o + 4 <= en {
                let count = u32a(b, o) as usize;
                if count >= 3 && count < 200000 && o + 4 + count * 12 <= en {
                    let mut ok = true;
                    let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
                    for i in 0..count.min(64) {
                        let v = [f32a(b, o+4+i*12), f32a(b, o+4+i*12+4), f32a(b, o+4+i*12+8)];
                        if v.iter().any(|c| !c.is_finite() || c.abs() > 1.0e7) { ok = false; break; }
                        for k in 0..3 { mn[k] = mn[k].min(v[k]); mx[k] = mx[k].max(v[k]); }
                    }
                    let span = (mx[0]-mn[0]).abs() + (mx[1]-mn[1]).abs() + (mx[2]-mn[2]).abs();
                    if ok && span > 1.0 {
                        println!("  FVec[{}] @off {} range x[{:.0},{:.0}] y[{:.0},{:.0}] z[{:.0},{:.0}]", count, o-s, mn[0],mx[0], mn[1],mx[1], mn[2],mx[2]);
                        o += 4 + count*12; continue;
                    }
                }
                o += 4;
            }
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--findmatrix" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let actors = p.actors();
        let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let b = &p.buf;
        for a in actors.iter().filter(|a| a.name.to_lowercase().contains(&args[3].to_lowercase())).take(4) {
            let loc = match a.pos { Some(p) => p, None => continue };
            println!("== {} ({}) loc=({:.0},{:.0},{:.0}) comps={:?} ==", a.name, a.class, loc.0, loc.1, loc.2, a.components.len());
            let scan = |label: &str, ei: usize| {
                let e = &p.exports[ei];
                let (s, en) = (e.off as usize, ((e.off + e.size.max(0)) as usize).min(b.len()));
                let mut o = s;
                while o + 12 <= en {
                    if (f32a(b,o)-loc.0).abs() < 1.0 && (f32a(b,o+4)-loc.1).abs() < 1.0 && (f32a(b,o+8)-loc.2).abs() < 1.0 {
                        let endw = (o + 56).min(en);
                        let hex: Vec<String> = b[o..endw].iter().map(|x| format!("{:02x}", x)).collect();
                        println!("  {} {} loc@{} hex: {}", label, e.name, o-s, hex.join(" "));
                        let flts: Vec<String> = (0..11).map(|k| format!("{:.3}", f32a(b, o+k*4))).collect();
                        let ints: Vec<String> = (0..11).map(|k| i32::from_le_bytes([b[o+k*4],b[o+k*4+1],b[o+k*4+2],b[o+k*4+3]]).to_string()).collect();
                        println!("     f32: {}", flts.join(" "));
                        println!("     i32: {}", ints.join(" "));
                        return;
                    }
                    o += 1;
                }
            };
            for &c in &a.components { scan("comp", c); }
            scan("actor", a.idx);
            match p.actor_matrix(a.idx) {
                Some(m) => {
                    let sx = (m[0]*m[0]+m[1]*m[1]+m[2]*m[2]).sqrt();
                    let sy = (m[4]*m[4]+m[5]*m[5]+m[6]*m[6]).sqrt();
                    let sz = (m[8]*m[8]+m[9]*m[9]+m[10]*m[10]).sqrt();
                    println!("     actor_matrix: scale=({:.2},{:.2},{:.2}) trans=({:.0},{:.0},{:.0}) row0=[{:.2} {:.2} {:.2}]", sx, sy, sz, m[12], m[13], m[14], m[0], m[1], m[2]);
                }
                None => println!("     actor_matrix: NONE"),
            }
        }
        return Ok(());
    }
    if args.len() > 2 && args[1] == "--xform" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        let actors = p.actors();
        let placed: Vec<(f32, f32, f32)> = actors.iter().filter_map(|a| a.pos).collect();
        let (mut mn, mut mx) = ([f32::MAX; 3], [f32::MIN; 3]);
        for q in &placed { let v = [q.0, q.1, q.2]; for k in 0..3 { mn[k] = mn[k].min(v[k]); mx[k] = mx[k].max(v[k]); } }
        let ext = (mx[0]-mn[0]).max(mx[1]-mn[1]).max(mx[2]-mn[2]).max(1000.0);
        let f32a = |b: &[u8], o: usize| f32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let i32a = |b: &[u8], o: usize| i32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
        let b = &p.buf;
        let mut n = 0;
        for e in p.exports.iter() {
            if e.class_name != "StaticMeshActor" { continue; }
            let (st, en) = (e.off as usize, (e.off + e.size) as usize);
            let mut o = st;
            while o + 12 <= en {
                let v = [f32a(b, o), f32a(b, o+4), f32a(b, o+8)];
                if (0..3).all(|k| v[k] >= mn[k]-ext && v[k] <= mx[k]+ext) && v.iter().any(|f| f.abs() > 1.0) {
                    println!("{} loc@{} ({:.0},{:.0},{:.0})", e.name, o-st, v[0], v[1], v[2]);
                    let ints: Vec<String> = (0..10).map(|k| i32a(b, o+12+k*4).to_string()).collect();
                    let flts: Vec<String> = (0..10).map(|k| format!("{:.2}", f32a(b, o+12+k*4))).collect();
                    println!("   i32 after loc: {}", ints.join(" "));
                    println!("   f32 after loc: {}", flts.join(" "));
                    break;
                }
                o += 1;
            }
            n += 1; if n >= 6 { break; }
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--rendermap" {
        let map_path = std::path::Path::new(&args[2]);
        let p = Pkg::load(map_path).unwrap();
        let mut cooked = map_path.parent().unwrap_or_else(|| std::path::Path::new(DEFAULT_DIR));
        loop {
            if std::fs::read_dir(cooked).map(|rd| rd.flatten().any(|e| e.path().extension().map(|x| x == "tfc").unwrap_or(false))).unwrap_or(false) { break; }
            if let Some(par) = cooked.parent() { cooked = par; } else { break; }
        }
        let mut packages = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let q = e.path();
                if q.is_dir() { walk(&q, out); }
                else if q.extension().map(|x| { let x = x.to_string_lossy().to_lowercase(); x == "upk" || x == "xxx" || x == "umap" }).unwrap_or(false) { out.push(q); }
            }}
        }
        walk(cooked, &mut packages);
        let actors = p.actors();
        let (mut meshc, mut matc, mut texd) = (std::collections::HashMap::new(), std::collections::HashMap::new(), std::collections::HashMap::new());
        let mut assets = AssetCache::default();
        let sc = build_world_scene(&p, &actors, None, &mut meshc, &mut matc, Some(cooked), &mut texd, &mut assets, &packages);
        if sc.tris.is_empty() { println!("no geometry"); return Ok(()); }
        let cen = |k: usize| { let mut v: Vec<f32> = sc.tris.iter().flat_map(|t| t.p.iter().map(move |p| p[k])).collect(); v.sort_by(|a,b| a.partial_cmp(b).unwrap()); v[v.len()/2] };
        let center = [cen(0), cen(1), cen(2)];
        let mut dists: Vec<f32> = sc.tris.iter().flat_map(|t| t.p.iter()).map(|p| ((p[0]-center[0]).powi(2)+(p[1]-center[1]).powi(2)+(p[2]-center[2]).powi(2)).sqrt()).collect();
        dists.sort_by(|a,b| a.partial_cmp(b).unwrap());
        let radius = dists[dists.len()*80/100].max(1.0);
        let yaw = args.get(4).and_then(|s| s.parse().ok()).unwrap_or(0.7f32);
        let pitch = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(0.30f32);
        let fog: f32 = args.get(6).and_then(|s| s.parse().ok()).unwrap_or(0.0);
        let distmul: f32 = args.get(7).and_then(|s| s.parse().ok()).unwrap_or(2.2);
        let cam = view3d::Cam { target: center, yaw, pitch, dist: radius * distmul };
        let (w, h) = (1100usize, 700usize);
        let mut r = view3d::Raster::new(w, h);
        r.render(&sc, &cam.view_proj(w as f32 / h as f32), fog);
        image::save_buffer(&args[3], &r.col, w as u32, h as u32, image::ColorType::Rgba8).unwrap();
        println!("rendered {} tris, {} textures -> {}", sc.tris.len(), sc.textures.len(), args[3]);
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--texparams" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for (ei, e) in p.exports.iter().enumerate().filter(|(_, e)| e.name.to_lowercase().contains(&args[3].to_lowercase()) && e.class_name.contains("Material")).take(4) {
            println!("== {} ({}) ==", e.name, e.class_name);
            for (n, r) in p.texture_params(ei) {
                let nm = if r > 0 { p.exports.get((r-1) as usize).map(|x| x.name.clone()).unwrap_or_default() }
                    else if r < 0 { let i=(-(r as i64)-1) as usize; p.imports.get(i).cloned().unwrap_or_default() } else { "none".into() };
                println!("   {:<28} -> {}", n, nm);
            }
            println!("   DIFFUSE PICK -> {:?}", p.material_diffuse_ref(ei).map(|r| if r>0 { p.exports.get((r-1) as usize).map(|x| x.name.clone()).unwrap_or_default() } else if r<0 { let i=(-(r as i64)-1) as usize; p.imports.get(i).cloned().unwrap_or_default() } else { "none".into() }));
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--refs" {
        let p = Pkg::load(std::path::Path::new(&args[2])).unwrap();
        for e in p.exports.iter().filter(|e| e.name.to_lowercase().contains(&args[3].to_lowercase())).take(3) {
            println!("== {} ({}) @ {} size {} ==", e.name, e.class_name, e.off, e.size);
            let resolve = |r: i32| -> String {
                if r > 0 { p.exports.get((r-1) as usize).map(|x| format!("LOCAL {} [{}]", x.name, x.class_name)).unwrap_or("?".into()) }
                else if r < 0 { let i = (-(r as i64)-1) as usize; format!("IMPORT {} [{}]", p.imports.get(i).cloned().unwrap_or_default(), p.import_classes.get(i).cloned().unwrap_or_default()) }
                else { "none".into() }
            };
            println!("  -- collect_refs --");
            for r in p.collect_refs(e.off) { println!("     {:>8}  {}", r, resolve(r)); }
            println!("  -- relevant_refs --");
            for r in p.relevant_refs(e) { println!("     {:>8}  {}", r, resolve(r)); }
            println!("  -- stride-1 Material/Texture2D scan --");
            let b = &p.buf;
            let (s, en) = (e.off as usize, ((e.off as i64 + e.size.max(0) as i64) as usize).min(b.len()));
            let mut hits: Vec<(usize, i32)> = Vec::new();
            let mut o = s;
            while o + 4 <= en {
                let v = i32::from_le_bytes([b[o], b[o+1], b[o+2], b[o+3]]);
                let cls = if v > 0 { p.exports.get((v-1) as usize).map(|x| x.class_name.as_str()) }
                    else if v < 0 { p.import_classes.get((-(v as i64)-1) as usize).map(|x| x.as_str()) } else { None };
                if let Some(c) = cls { if c == "Texture2D" || c.ends_with("Material") || c == "MaterialInstanceConstant" { hits.push((o - s, v)); } }
                o += 1;
            }
            for (off, v) in hits.iter().take(40) { println!("     @{:>6} {:>8}  {}", off, v, resolve(*v)); }
        }
        return Ok(());
    }
    if args.len() > 3 && args[1] == "--difftex" {
        let map_path = std::path::Path::new(&args[2]);
        let p = Pkg::load(map_path).unwrap();
        let mut cooked = map_path.parent().unwrap_or_else(|| std::path::Path::new(DEFAULT_DIR));
        loop {
            if std::fs::read_dir(cooked).map(|rd| rd.flatten().any(|e| e.path().extension().map(|x| x == "tfc").unwrap_or(false))).unwrap_or(false) { break; }
            if let Some(par) = cooked.parent() { cooked = par; } else { break; }
        }
        let mut packages = Vec::new();
        fn walk(d: &std::path::Path, out: &mut Vec<PathBuf>) {
            if let Ok(rd) = std::fs::read_dir(d) { for e in rd.flatten() {
                let q = e.path();
                if q.is_dir() { walk(&q, out); }
                else if q.extension().map(|x| { let x = x.to_string_lossy().to_lowercase(); x == "upk" || x == "xxx" || x == "umap" }).unwrap_or(false) { out.push(q); }
            }}
        }
        walk(cooked, &mut packages);
        let want = args[3].to_lowercase();
        let actors = p.actors();
        let mut assets = AssetCache::default();
        if want == "list" {
            let mut seen = std::collections::BTreeSet::new();
            for a in &actors {
                let smc = match a.components.iter().copied().find(|&c| p.exports[c].class_name.contains("StaticMeshComponent")) { Some(s) => s, None => continue };
                let mname = match p.object_ref(p.exports[smc].off, "StaticMesh").map(|r| p.resolve_ref(r)) {
                    Some(upk::Ref::Local(ei)) => format!("LOCAL {}", p.exports.get(ei).map(|e| e.name.clone()).unwrap_or_default()),
                    Some(upk::Ref::Import { package, object }) => format!("IMPORT {}.{}", package, object),
                    _ => continue,
                };
                seen.insert(mname);
            }
            for m in &seen { println!("  {}", m); }
            return Ok(());
        }
        let mut found = 0;
        for a in &actors {
            let smc = match a.components.iter().copied().find(|&c| p.exports[c].class_name.contains("StaticMeshComponent")) { Some(s) => s, None => continue };
            let mref = p.object_ref(p.exports[smc].off, "StaticMesh");
            let mname = match mref.map(|r| p.resolve_ref(r)) {
                Some(upk::Ref::Local(ei)) => p.exports.get(ei).map(|e| e.name.clone()).unwrap_or_default(),
                Some(upk::Ref::Import { object, .. }) => object,
                _ => continue,
            };
            if !mname.to_lowercase().contains(&want) { continue; }
            println!("== actor {} mesh={} smc={} ({}) ==", a.name, mname, smc, p.exports[smc].name);
            let r = assets.diffuse_texture(&p, smc, &mname, &packages, cooked);
            match &r { Some((w, h, rgba)) => {
                let _ = image::save_buffer(format!("/tmp/chose_{}.png", mname), rgba, *w as u32, *h as u32, image::ColorType::Rgba8);
                println!("  -> CHOSE {}x{} -> /tmp/chose_{}.png", w, h, mname);
            }, None => println!("  -> none") }
            found += 1; if found >= 3 { break; }
        }
        if found == 0 { println!("no actor with a StaticMesh matching '{}'", want); }
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
