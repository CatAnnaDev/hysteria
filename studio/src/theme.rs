use egui::{Color32, FontFamily, FontId, Rounding, Stroke, TextStyle, Vec2};

// Ink & porcelain with an oxblood accent — Alice's gothic-Victorian asylum, not a default
// black/acid-green editor.
pub const BG: Color32 = Color32::from_rgb(0x15, 0x12, 0x0F);
pub const PANEL: Color32 = Color32::from_rgb(0x1F, 0x1B, 0x17);
pub const RAISED: Color32 = Color32::from_rgb(0x2A, 0x24, 0x1E);
pub const LINE: Color32 = Color32::from_rgb(0x32, 0x2B, 0x24);
pub const BONE: Color32 = Color32::from_rgb(0xE7, 0xE0, 0xD2);
pub const DIM: Color32 = Color32::from_rgb(0x9C, 0x91, 0x83);
pub const BLOOD: Color32 = Color32::from_rgb(0x9E, 0x2B, 0x25);
pub const BLOOD_HI: Color32 = Color32::from_rgb(0xC4, 0x3A, 0x32);
pub const TEAL: Color32 = Color32::from_rgb(0x6F, 0x8C, 0x7E);

pub const DISPLAY: &str = "display";
pub const LABEL: &str = "label";

fn family(name: &str) -> FontFamily { FontFamily::Name(name.into()) }

pub fn display_font(size: f32) -> FontId { FontId::new(size, family(DISPLAY)) }
pub fn label_font(size: f32) -> FontId { FontId::new(size, family(LABEL)) }

pub fn install(ctx: &egui::Context) {
    let mut fonts = egui::FontDefinitions::default();
    let mut add = |key: &str, path: &str| -> bool {
        if let Ok(bytes) = std::fs::read(path) {
            fonts.font_data.insert(key.to_owned(), egui::FontData::from_owned(bytes));
            fonts.families.insert(FontFamily::Name(key.into()), vec![key.to_owned()]);
            true
        } else { false }
    };
    let have_display = add(DISPLAY, "/System/Library/Fonts/Supplemental/BigCaslon.ttf")
        || add(DISPLAY, "/System/Library/Fonts/Supplemental/Georgia.ttf");
    let have_label = add(LABEL, "/System/Library/Fonts/Supplemental/Bodoni 72 Smallcaps Book.ttf");
    // graceful fallback: route the custom families to egui's proportional face if a system
    // font is missing (e.g. on Windows) so RichText with these families still renders.
    if !have_display { fonts.families.insert(family(DISPLAY).into(), vec!["Ubuntu-Light".to_owned()]); }
    if !have_label { fonts.families.insert(family(LABEL).into(), vec!["Ubuntu-Light".to_owned()]); }
    ctx.set_fonts(fonts);

    let mut style = (*ctx.style()).clone();
    style.text_styles.insert(TextStyle::Heading, display_font(20.0));
    style.text_styles.insert(TextStyle::Body, FontId::proportional(14.0));
    style.text_styles.insert(TextStyle::Button, FontId::proportional(13.5));
    style.text_styles.insert(TextStyle::Monospace, FontId::monospace(12.5));
    style.text_styles.insert(TextStyle::Small, FontId::proportional(11.0));
    style.text_styles.insert(TextStyle::Name("eyebrow".into()), label_font(13.0));
    style.text_styles.insert(TextStyle::Name("title".into()), display_font(26.0));

    let v = &mut style.visuals;
    v.dark_mode = true;
    v.override_text_color = Some(BONE);
    v.panel_fill = PANEL;
    v.window_fill = PANEL;
    v.extreme_bg_color = BG;
    v.faint_bg_color = Color32::from_rgb(0x24, 0x1F, 0x1A);
    v.hyperlink_color = TEAL;
    v.warn_fg_color = Color32::from_rgb(0xD8, 0xA8, 0x4B);
    v.error_fg_color = BLOOD_HI;
    v.window_stroke = Stroke::new(1.0_f32,LINE);
    v.selection.bg_fill = Color32::from_rgba_unmultiplied(0x9E, 0x2B, 0x25, 0x66);
    v.selection.stroke = Stroke::new(1.0_f32,BLOOD_HI);

    let r = Rounding::same(3.0_f32);
    for w in [&mut v.widgets.noninteractive, &mut v.widgets.inactive, &mut v.widgets.hovered, &mut v.widgets.active, &mut v.widgets.open] {
        w.rounding = r;
        w.fg_stroke = Stroke::new(1.0_f32,BONE);
        w.bg_stroke = Stroke::new(1.0_f32,LINE);
    }
    v.widgets.noninteractive.bg_fill = PANEL;
    v.widgets.noninteractive.fg_stroke = Stroke::new(1.0_f32,DIM);
    v.widgets.inactive.bg_fill = RAISED;
    v.widgets.inactive.weak_bg_fill = RAISED;
    v.widgets.hovered.bg_fill = Color32::from_rgb(0x36, 0x2E, 0x26);
    v.widgets.hovered.weak_bg_fill = Color32::from_rgb(0x36, 0x2E, 0x26);
    v.widgets.hovered.bg_stroke = Stroke::new(1.0_f32,BLOOD);
    v.widgets.active.bg_fill = BLOOD;
    v.widgets.active.weak_bg_fill = BLOOD;
    v.widgets.active.bg_stroke = Stroke::new(1.0_f32,BLOOD_HI);

    style.spacing.item_spacing = Vec2::new(8.0, 6.0);
    style.spacing.button_padding = Vec2::new(9.0, 4.0);
    style.spacing.window_margin = egui::Margin::same(10.0);
    style.spacing.menu_margin = egui::Margin::same(8.0);
    style.spacing.indent = 16.0;
    ctx.set_style(style);
}

// A small-caps specimen eyebrow: "TEXTURE · DXT5 · 512×512".
pub fn eyebrow(ui: &mut egui::Ui, text: impl Into<String>) {
    ui.add(egui::Label::new(
        egui::RichText::new(text.into()).text_style(TextStyle::Name("eyebrow".into())).color(DIM),
    ));
}

pub fn display(text: impl Into<String>, size: f32) -> egui::RichText {
    egui::RichText::new(text.into()).font(display_font(size)).color(BONE)
}

// Hairline separator in the line color.
pub fn rule(ui: &mut egui::Ui) {
    let w = ui.available_width();
    let (rect, _) = ui.allocate_exact_size(Vec2::new(w, 1.0), egui::Sense::hover());
    ui.painter().hline(rect.x_range(), rect.center().y, Stroke::new(1.0_f32,LINE));
}

// Draw a two-tone alpha checkerboard inside `rect` so texture transparency reads.
pub fn checkerboard(painter: &egui::Painter, rect: egui::Rect, cell: f32) {
    let a = Color32::from_rgb(0x26, 0x21, 0x1B);
    let b = Color32::from_rgb(0x1A, 0x16, 0x12);
    painter.rect_filled(rect, 0.0_f32, b);
    let mut y = rect.top();
    let mut row = 0;
    while y < rect.bottom() {
        let mut x = rect.left();
        let mut col = 0;
        while x < rect.right() {
            if (row + col) % 2 == 0 {
                let r = egui::Rect::from_min_max(
                    egui::pos2(x, y),
                    egui::pos2((x + cell).min(rect.right()), (y + cell).min(rect.bottom())),
                );
                painter.rect_filled(r, 0.0_f32, a);
            }
            x += cell; col += 1;
        }
        y += cell; row += 1;
    }
}

// A stable, muted color per class name for the actor minimap.
pub fn class_color(class: &str) -> Color32 {
    let mut h: u32 = 2166136261;
    for b in class.bytes() { h = (h ^ b as u32).wrapping_mul(16777619); }
    let hue = (h % 360) as f32 / 360.0;
    let (r, g, b) = hsv(hue, 0.42, 0.82);
    Color32::from_rgb(r, g, b)
}

fn hsv(h: f32, s: f32, v: f32) -> (u8, u8, u8) {
    let i = (h * 6.0_f32).floor();
    let f = h * 6.0_f32 - i;
    let p = v * (1.0_f32 - s);
    let q = v * (1.0_f32 - f * s);
    let t = v * (1.0_f32 - (1.0_f32 - f) * s);
    let (r, g, b) = match (i as i32) % 6 {
        0 => (v, t, p), 1 => (q, v, p), 2 => (p, v, t),
        3 => (p, q, v), 4 => (t, p, v), _ => (v, p, q),
    };
    ((r * 255.0_f32) as u8, (g * 255.0_f32) as u8, (b * 255.0_f32) as u8)
}
