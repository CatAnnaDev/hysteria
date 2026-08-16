#include "hysteria.h"

// Hysteria immediate-mode UI: self-contained, drawn with our own fill_rect/draw_text
// (no external GUI dependency). One movable, scrollable window with collapsible sections.
// The ui_* mod API maps straight onto these widgets, so mods need no changes.

int g_uiVisible = 0;
static int g_uiInit = 0;
static HWND g_uiHwnd;
static WNDPROC g_origWndProc;

// ---------- input ----------
static struct { int mx, my, down, prev, clicked, released, wheel; } M;
static int g_typed[16], g_typedN;     // WM_CHAR queue for the focused textbox
static unsigned g_active = 0;          // widget id currently dragged (slider/scrollbar)
static unsigned g_focus = 0;           // focused textbox id

static LRESULT CALLBACK ui_wndproc(HWND h, UINT m, WPARAM w, LPARAM l) {
    if (g_uiVisible) {
        if (m == WM_MOUSEWHEEL) M.wheel += (int)((short)HIWORD(w)) / 120;
        else if (m == WM_CHAR) { if (g_typedN < 16) g_typed[g_typedN++] = (int)w; }
    }
    return CallWindowProcA(g_origWndProc, h, m, w, l);
}

static unsigned hash_id(const char *s) {
    unsigned h = 2166136261u;
    for (; s && *s; s++) { h ^= (unsigned char)*s; h *= 16777619u; }
    return h ? h : 1;
}
static int hit(float x, float y, float w, float h) {
    return M.mx >= x && M.mx < x + w && M.my >= y && M.my < y + h;
}

// ---------- theme / layout ----------
#define PAD 10.0f
#define ROW 23.0f
#define GAP 4.0f
#define TITLE_H 28.0f
#define SEC_H 24.0f
#define SBW 8.0f
#define COL_BG     D3DCOLOR_ARGB(238, 16, 16, 22)
#define COL_TITLE  D3DCOLOR_ARGB(255, 28, 24, 46)
#define COL_SEC    D3DCOLOR_ARGB(255, 34, 32, 54)
#define COL_SECH   D3DCOLOR_ARGB(255, 52, 48, 84)
#define COL_WIDGET D3DCOLOR_ARGB(255, 40, 40, 56)
#define COL_HOT    D3DCOLOR_ARGB(255, 70, 64, 110)
#define COL_ACC    D3DCOLOR_ARGB(255, 150, 120, 255)
#define COL_ACC2   D3DCOLOR_ARGB(255, 120, 220, 170)
#define COL_TEXT   D3DCOLOR_XRGB(225, 225, 235)
#define COL_DIM    D3DCOLOR_XRGB(150, 150, 170)

static float g_wx = 40, g_wy = 40, g_ww = 360, g_wh = 600;
static float g_cy;          // running content y (already includes -scroll)
static float g_top, g_bot;  // content clip band (screen y)
static float g_scroll, g_contentTop;
static int g_secOpen;       // is the current section expanded (widgets emit only if so)
static int g_panelBase = 1; // is the enclosing mod-panel section open (gate for ui_tree headers)
static IDirect3DDevice9 *g_dev;
static int g_W, g_H;

// persisted section open-states
static struct { unsigned id; int open; } g_sec[64];
static int g_secN;
static int *sec_state(unsigned id) {
    for (int i = 0; i < g_secN; i++) if (g_sec[i].id == id) return &g_sec[i].open;
    if (g_secN < 64) { g_sec[g_secN].id = id; g_sec[g_secN].open = 0; return &g_sec[g_secN++].open; }
    static int dummy = 0; return &dummy;
}

static void outline(float x, float y, float w, float h, D3DCOLOR c) {
    fill_rect(g_dev, x, y, w, 1, c); fill_rect(g_dev, x, y + h - 1, w, 1, c);
    fill_rect(g_dev, x, y, 1, h, c); fill_rect(g_dev, x + w - 1, y, 1, h, c);
}
static int row_visible(float y, float h) { return y + h > g_top && y < g_bot; }

// software cursor (the game hides the OS cursor in-game): a white arrow with a black edge
static void draw_cursor(int mx, int my) {
    float x = (float)mx, y = (float)my;
    for (int i = 0; i <= 17; i++) fill_rect(g_dev, x, y + i, (float)i * 0.6f + 3, 1, D3DCOLOR_ARGB(255, 0, 0, 0));
    for (int i = 1; i <= 14; i++) fill_rect(g_dev, x + 1, y + i, (float)i * 0.6f + 1, 1, D3DCOLOR_ARGB(255, 245, 245, 255));
}

// ---------- frame ----------
static void hui_begin(void) {
    // title bar drag
    unsigned bar = hash_id("__titlebar");
    if (M.clicked && hit(g_wx, g_wy, g_ww, TITLE_H)) g_active = bar;
    if (g_active == bar) {
        if (M.down) { static float ox, oy; if (M.clicked) { ox = M.mx - g_wx; oy = M.my - g_wy; }
            g_wx = M.mx - 0; g_wy = M.my - 0; (void)ox; (void)oy; }
    }
    if (g_wh > g_H - 60) g_wh = (float)(g_H - 60);
    if (g_wx < 0) g_wx = 0; if (g_wy < 0) g_wy = 0;
    if (g_wx + g_ww > g_W) g_wx = g_W - g_ww; if (g_wy + g_wh > g_H) g_wy = g_H - g_wh;

    fill_rect(g_dev, g_wx, g_wy, g_ww, g_wh, COL_BG);
    fill_rect(g_dev, g_wx, g_wy, g_ww, TITLE_H, COL_TITLE);
    outline(g_wx, g_wy, g_ww, g_wh, COL_ACC);
    draw_text(g_dev, (int)(g_wx + PAD), (int)(g_wy + 5), COL_ACC, "HYSTERIA");
    draw_text(g_dev, (int)(g_wx + g_ww - 150), (int)(g_wy + 6), COL_DIM, "Insert = close");

    g_top = g_wy + TITLE_H;
    g_bot = g_wy + g_wh;
    g_contentTop = g_top + PAD;
    g_cy = g_contentTop - g_scroll;
    g_secOpen = 1;
}

static void hui_end(void) {
    float used = (g_cy + g_scroll) - g_contentTop;       // total content height
    float view = g_wh - TITLE_H - PAD;
    float maxs = used - view; if (maxs < 0) maxs = 0;
    // wheel scroll
    g_scroll -= M.wheel * 48.0f;
    // scrollbar drag
    unsigned sb = hash_id("__scroll");
    float sbx = g_wx + g_ww - SBW - 2, sby = g_top + 2, sbh = g_wh - TITLE_H - 4;
    if (maxs > 0) {
        float kh = sbh * (view / used); if (kh < 24) kh = 24;
        float ky = sby + (sbh - kh) * (g_scroll / maxs);
        if (M.clicked && hit(sbx, sby, SBW, sbh)) g_active = sb;
        if (g_active == sb && M.down) {
            float t = (M.my - sby - kh * 0.5f) / (sbh - kh); if (t < 0) t = 0; if (t > 1) t = 1;
            g_scroll = t * maxs;
        }
        fill_rect(g_dev, sbx, sby, SBW, sbh, COL_WIDGET);
        fill_rect(g_dev, sbx, ky, SBW, kh, g_active == sb ? COL_ACC : COL_HOT);
    }
    if (g_scroll < 0) g_scroll = 0; if (g_scroll > maxs) g_scroll = maxs;
    if (!M.down) g_active = 0;
}

// returns 1 if the section is open (caller wraps its widgets in the if)
static int hui_section(const char *title) {
    unsigned id = hash_id(title);
    int *open = sec_state(id);
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD;
    if (row_visible(y, SEC_H)) {
        int hot = hit(x, y, w, SEC_H);
        fill_rect(g_dev, x, y, w, SEC_H, hot ? COL_SECH : COL_SEC);
        draw_text(g_dev, (int)(x + 8), (int)(y + 3), COL_TEXT, *open ? "-" : "+");
        draw_text(g_dev, (int)(x + 24), (int)(y + 3), COL_TEXT, title);
        if (hot && M.clicked) { *open = !*open; M.clicked = 0; }
    }
    g_cy += SEC_H + GAP;
    g_secOpen = *open;
    return *open;
}

void ui_label_at(const char *t) {
    if (!g_secOpen) return;
    float y = g_cy, x = g_wx + PAD;
    if (row_visible(y, 18)) draw_text(g_dev, (int)(x + 2), (int)(y), COL_DIM, t ? t : "");
    g_cy += 18 + GAP;
}

int hui_button(const char *label) {
    if (!g_secOpen) return 0;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD;
    int clicked = 0;
    if (row_visible(y, ROW)) {
        int hot = hit(x, y, w, ROW);
        fill_rect(g_dev, x, y, w, ROW, hot ? COL_HOT : COL_WIDGET);
        if (hot) outline(x, y, w, ROW, COL_ACC);
        draw_text(g_dev, (int)(x + 8), (int)(y + 2), COL_TEXT, label ? label : "");
        if (hot && M.clicked) { clicked = 1; M.clicked = 0; }
    }
    g_cy += ROW + GAP;
    return clicked;
}

void hui_checkbox(const char *label, int *v) {
    if (!g_secOpen) return;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD, bs = 16;
    if (row_visible(y, ROW)) {
        int hot = hit(x, y, w, ROW);
        fill_rect(g_dev, x, y, w, ROW, hot ? COL_HOT : COL_WIDGET);
        fill_rect(g_dev, x + 4, y + (ROW - bs) / 2, bs, bs, D3DCOLOR_ARGB(255, 20, 20, 28));
        outline(x + 4, y + (ROW - bs) / 2, bs, bs, COL_DIM);
        if (v && *v) fill_rect(g_dev, x + 7, y + (ROW - bs) / 2 + 3, bs - 6, bs - 6, COL_ACC2);
        draw_text(g_dev, (int)(x + 28), (int)(y + 2), COL_TEXT, label ? label : "");
        if (hot && M.clicked && v) { *v = !*v; M.clicked = 0; }
    }
    g_cy += ROW + GAP;
}

static void slider(const char *label, float *fv, int *iv, float mn, float mx, float step, int isf) {
    if (!g_secOpen) return;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD, h = ROW + 4;
    unsigned id = hash_id(label) ^ (unsigned)(y * 7);
    if (row_visible(y, h)) {
        char buf[96];
        float val = isf ? *fv : (float)*iv;
        if (isf) wsprintfA(buf, "%s", label ? label : "");
        else wsprintfA(buf, "%s", label ? label : "");
        fill_rect(g_dev, x, y, w, h, COL_WIDGET);
        float ty = y + 16, tx = x + 6, tw = w - 12, th = 6;
        fill_rect(g_dev, tx, ty, tw, th, D3DCOLOR_ARGB(255, 22, 22, 30));
        float frac = (mx > mn) ? (val - mn) / (mx - mn) : 0; if (frac < 0) frac = 0; if (frac > 1) frac = 1;
        fill_rect(g_dev, tx, ty, tw * frac, th, COL_ACC);
        float kx = tx + tw * frac;
        fill_rect(g_dev, kx - 3, ty - 3, 6, th + 6, COL_TEXT);
        if (M.clicked && hit(x, y, w, h)) g_active = id;
        if (g_active == id && M.down) {
            float t = (M.mx - tx) / tw; if (t < 0) t = 0; if (t > 1) t = 1;
            float nv = mn + t * (mx - mn);
            if (step > 0) nv = mn + step * (float)((int)((nv - mn) / step + 0.5f));
            if (nv < mn) nv = mn; if (nv > mx) nv = mx;
            if (isf) *fv = nv; else *iv = (int)(nv + 0.5f);
        }
        char vs[40];
        if (isf) wsprintfA(vs, "%d.%02d", (int)val, (int)((val - (int)val) * 100 + 0.5f) < 0 ? 0 : (int)((val - (int)val) * 100 + 0.5f));
        else wsprintfA(vs, "%d", *iv);
        draw_text(g_dev, (int)(x + 6), (int)(y + 1), COL_TEXT, buf);
        draw_text(g_dev, (int)(x + w - 70), (int)(y + 1), COL_ACC2, vs);
    }
    g_cy += h + GAP;
}
void hui_slider_int(const char *l, int *v, int mn, int mx) { slider(l, 0, v, (float)mn, (float)mx, 1, 0); }
void hui_slider_float(const char *l, float *v, float mn, float mx, float st) { slider(l, v, 0, mn, mx, st, 1); }

// click-to-focus textbox; types via the WM_CHAR queue
static void hui_textbox(const char *id, char *buf, int *len, int cap) {
    if (!g_secOpen) return;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD;
    unsigned fid = hash_id(id);
    if (row_visible(y, ROW)) {
        int hot = hit(x, y, w, ROW);
        if (M.clicked) g_focus = hot ? fid : (g_focus == fid ? 0 : g_focus);
        int foc = g_focus == fid;
        fill_rect(g_dev, x, y, w, ROW, D3DCOLOR_ARGB(255, 22, 22, 30));
        outline(x, y, w, ROW, foc ? COL_ACC : COL_DIM);
        if (foc) for (int i = 0; i < g_typedN; i++) {
            int c = g_typed[i];
            if (c == 8) { if (*len > 0) buf[--(*len)] = 0; }
            else if (c >= 32 && c < 127 && *len < cap - 1) { buf[(*len)++] = (char)c; buf[*len] = 0; }
        }
        char shown[80]; lstrcpynA(shown, buf, sizeof shown);
        if (foc) lstrcatA(shown, "_");
        draw_text(g_dev, (int)(x + 6), (int)(y + 2), COL_TEXT, shown[0] ? shown : (foc ? "" : "search..."));
    }
    g_cy += ROW + GAP;
}

void ui_sep(void) { if (!g_secOpen) return; if (row_visible(g_cy, 1)) fill_rect(g_dev, g_wx + PAD, g_cy + 2, g_ww - 2 * PAD, 1, COL_DIM); g_cy += 6; }

// ---------- v13 UI builder widgets ----------
static void ui_spacing_at(int px) { if (!g_secOpen) return; g_cy += (px > 0 ? px : 6); }
static void ui_text_colored_at(unsigned argb, const char *t) {
    if (!g_secOpen) return;
    float y = g_cy, x = g_wx + PAD;
    if (row_visible(y, 18)) draw_text(g_dev, (int)(x + 2), (int)y, (D3DCOLOR)argb, t ? t : "");
    g_cy += 18 + GAP;
}
static void ui_progress_at(const char *label, float f) {
    if (!g_secOpen) return; if (f < 0) f = 0; if (f > 1) f = 1;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD, h = ROW;
    if (row_visible(y, h)) {
        fill_rect(g_dev, x, y, w, h, D3DCOLOR_ARGB(255, 22, 22, 30));
        fill_rect(g_dev, x + 1, y + 1, (w - 2) * f, h - 2, COL_ACC);
        draw_text(g_dev, (int)(x + 8), (int)(y + 2), COL_TEXT, label ? label : "");
    }
    g_cy += h + GAP;
}
static int ui_combo_at(const char *label, int *idx, const char *const *opts, int n) {
    if (!g_secOpen || !idx || !opts || n <= 0) return 0;
    if (*idx < 0) *idx = 0; if (*idx >= n) *idx = n - 1;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD, h = ROW; int changed = 0;
    if (row_visible(y, h)) {
        int hot = hit(x, y, w, h);
        fill_rect(g_dev, x, y, w, h, hot ? COL_HOT : COL_WIDGET);
        char buf[120]; wsprintfA(buf, "%s: %s", label ? label : "", opts[*idx] ? opts[*idx] : "");
        draw_text(g_dev, (int)(x + 8), (int)(y + 2), COL_TEXT, buf);
        draw_text(g_dev, (int)(x + w - 16), (int)(y + 2), COL_ACC2, ">");
        if (hot && M.clicked) { *idx = (*idx + 1) % n; changed = 1; M.clicked = 0; }
    }
    g_cy += h + GAP; return changed;
}
static int ui_input_int_at(const char *label, int *v, int step, int mn, int mx) {
    if (!g_secOpen || !v) return 0;
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD, h = ROW, bw = ROW; int changed = 0;
    if (row_visible(y, h)) {
        int hotm = hit(x, y, bw, h), hotp = hit(x + w - bw, y, bw, h);
        fill_rect(g_dev, x, y, w, h, COL_WIDGET);
        fill_rect(g_dev, x, y, bw, h, hotm ? COL_HOT : COL_SEC); draw_text(g_dev, (int)(x + bw / 2 - 3), (int)(y + 2), COL_TEXT, "-");
        fill_rect(g_dev, x + w - bw, y, bw, h, hotp ? COL_HOT : COL_SEC); draw_text(g_dev, (int)(x + w - bw / 2 - 3), (int)(y + 2), COL_TEXT, "+");
        draw_text(g_dev, (int)(x + bw + 8), (int)(y + 2), COL_TEXT, label ? label : "");
        char vs[24]; wsprintfA(vs, "%d", *v); draw_text(g_dev, (int)(x + w - bw - 54), (int)(y + 2), COL_ACC2, vs);
        if (M.clicked && hotm) { *v -= step; changed = 1; M.clicked = 0; }
        if (M.clicked && hotp) { *v += step; changed = 1; M.clicked = 0; }
    }
    if (mx > mn) { if (*v < mn) *v = mn; if (*v > mx) *v = mx; }
    g_cy += h + GAP; return changed;
}
static int ui_tree_at(const char *title) {
    if (!g_panelBase) { g_secOpen = 0; return 0; }
    unsigned id = hash_id(title) ^ 0x7e7eu;
    int *open = sec_state(id);
    float y = g_cy, x = g_wx + PAD, w = g_ww - 2 * PAD;
    if (row_visible(y, SEC_H)) {
        int hot = hit(x, y, w, SEC_H);
        fill_rect(g_dev, x, y, w, SEC_H, hot ? COL_SECH : COL_SEC);
        draw_text(g_dev, (int)(x + 8), (int)(y + 3), COL_TEXT, *open ? "-" : "+");
        draw_text(g_dev, (int)(x + 24), (int)(y + 3), COL_ACC2, title ? title : "");
        if (hot && M.clicked) { *open = !*open; M.clicked = 0; }
    }
    g_cy += SEC_H + GAP;
    g_secOpen = *open;
    return *open;
}

// ---------- mod panel registry + API ----------
typedef struct { char title[48]; void (*draw)(void); } ModPanel;
static ModPanel g_panels[32]; static int g_panelN = 0;
void ui_panels_clear(void) { g_panelN = 0; }
static void ui_panel_impl(const char *title, void (*draw)(void)) {
    if (g_panelN < 32 && title && draw) { lstrcpynA(g_panels[g_panelN].title, title, sizeof g_panels[g_panelN].title); g_panels[g_panelN].draw = draw; g_panelN++; }
}
static int  ui_button_impl(const char *l) { return hui_button(l ? l : ""); }
static void ui_checkbox_impl(const char *l, int *v) { hui_checkbox(l ? l : "", v); }
static void ui_slideri_impl(const char *l, int *v, int mn, int mx) { hui_slider_int(l ? l : "", v, mn, mx); }
static void ui_sliderf_impl(const char *l, float *v, float mn, float mx, float st) { hui_slider_float(l ? l : "", v, mn, mx, st); }
static void ui_label_impl(const char *t) { ui_label_at(t ? t : ""); }

void ui_install_api(void) {
    HysteriaAPI *a = hysteria_api_get(); if (!a) return;
    a->ui_panel = ui_panel_impl; a->ui_button = ui_button_impl; a->ui_checkbox = ui_checkbox_impl;
    a->ui_slider_int = ui_slideri_impl; a->ui_slider_float = ui_sliderf_impl; a->ui_label = ui_label_impl;
    a->ui_separator = ui_sep; a->ui_spacing = ui_spacing_at; a->ui_text_colored = ui_text_colored_at;
    a->ui_progress = ui_progress_at; a->ui_combo = ui_combo_at; a->ui_input_int = ui_input_int_at;
    a->ui_tree = ui_tree_at;
}

void ui_init(IDirect3DDevice9 *dev, int W, int H) {
    if (g_uiInit) return;
    g_uiInit = 1;
    (void)W; (void)H;
    D3DDEVICE_CREATION_PARAMETERS cp;
    if (IDirect3DDevice9_GetCreationParameters(dev, &cp) == D3D_OK && cp.hFocusWindow) {
        g_uiHwnd = cp.hFocusWindow;
        g_origWndProc = (WNDPROC)(LONG_PTR)SetWindowLongPtrA(g_uiHwnd, GWLP_WNDPROC, (LONG_PTR)ui_wndproc);
    }
    ui_install_api();
    logmsg("[hysteria] ui init (hysteria-gui) hwnd=%p\r\n", g_uiHwnd);
}

static void poll_input(void) {
    POINT p; if (GetCursorPos(&p)) { if (g_uiHwnd) ScreenToClient(g_uiHwnd, &p); M.mx = p.x; M.my = p.y; }
    M.down = (GetAsyncKeyState(VK_LBUTTON) & 0x8000) ? 1 : 0;
    M.clicked = M.down && !M.prev;
    M.released = !M.down && M.prev;
}

void ui_render(IDirect3DDevice9 *dev, int W, int H) {
    if (!g_uiInit || !g_uiVisible) return;
    g_dev = dev; g_W = W; g_H = H;
    poll_input();
    hui_begin();

    if (hui_section("Freecam")) {
        hui_checkbox("Freecam", &g_freecam);
        ui_label_at("WASD move, arrows look, Spc/Ctrl up/dn, Shift x4");
        hui_slider_float("Freecam speed", &g_fcSpeed, 500, 20000, 100);
    }
    if (hui_section("Visuals")) {
        hui_checkbox("Hitboxes (F3)", &g_showHB);
        hui_checkbox("Labels", &g_labels);
        hui_checkbox("Enemy health bars", &g_healthbars);
        hui_checkbox("3D boxes (off = flat 2D)", &g_box3d);
        hui_checkbox("Enemies", &g_fEnemy);
        hui_checkbox("Triggers", &g_fTrigger);
        hui_checkbox("Pickups", &g_fPickup);
        hui_checkbox("Nodes", &g_fNode);
        hui_checkbox("Walls", &g_fWall);
        hui_checkbox("Other", &g_fOther);
        hui_slider_float("Distance", &g_hbDist, 1000, 20000, 500);
    }
    if (hui_section("Actors")) {
        char hdr[64]; wsprintfA(hdr, "%d nearby (click = TP)", g_actorN);
        ui_label_at(hdr);
        static const char tags[6] = {'.', 'E', 'T', 'P', 'N'};
        for (int i = 0; i < g_actorN; i++) {
            int k = g_actors[i].kind;
            char t = (k == 5) ? 'W' : (k >= 0 && k < 5) ? tags[k] : '.';
            char row[96]; wsprintfA(row, "[%c] %s  d:%d", t, g_actors[i].name, g_actors[i].dist / 100);
            if (hui_button(row)) { g_tpX = g_actors[i].x; g_tpY = g_actors[i].y; g_tpZ = g_actors[i].z; g_uiGoReq = 1; }
        }
    }
    if (hui_section("Enemies")) {
        if (hui_button("Kill nearby enemies")) g_killEnemiesReq = 1;
        hui_checkbox("Freeze enemies", &g_freezeEnemies);
    }
    if (hui_section("Modding")) {
        char st[64]; wsprintfA(st, "ProcessEvent: %s", g_modFound ? "HOOKED" : (g_modFind ? "searching..." : "off"));
        ui_label_at(st);
        hui_checkbox("Find + hook ProcessEvent", &g_modFind);
        hui_checkbox("Log player events", &g_modLog);
        hui_checkbox("Live log console (in-game)", &g_consoleVisible);
        if (hui_button("Reload mods (Mods/*.dll)")) g_modReloadReq = 1;
        char gl[64]; wsprintfA(gl, "Logs du jeu: %s (%d/s)", gamelog_active() ? "CAPTURE" : "off", g_gameLogRate);
        ui_label_at(gl);
        { int on = gamelog_active(); hui_checkbox("Capturer les logs du script (F4)", &on);
          if (on != gamelog_active()) gamelog_set(on); }
    }
    if (hui_section("Live Editor")) {
        static char filter[64]; static int flen = 0;
        static void *objs[256]; static int objN = 0;
        static void *sel = NULL;
        static AEditProp props[256]; static int propN = 0;
        hui_textbox("ed_filter", filter, &flen, 64);
        if (hui_button("Search")) { objN = editor_list(filter, objs, 256); sel = NULL; propN = 0; }
        if (hui_button("Player")) { objs[0] = g_pc; objs[1] = g_modPawn; objN = (g_modPawn ? 2 : 1); sel = NULL; propN = 0; }
        char oh[48]; wsprintfA(oh, "%d objects", objN); ui_label_at(oh);
        for (int i = 0; i < objN && i < 60; i++) {
            if (!objs[i]) continue;
            char row[100]; wsprintfA(row, "%s : %s", obj_class_name(objs[i]), obj_name(objs[i]));
            if (hui_button(row)) { sel = objs[i]; propN = editor_props(sel, props, 256); }
        }
        if (sel) {
            ui_sep();
            char sh[64]; wsprintfA(sh, "%s (%d props)", obj_name(sel), propN); ui_label_at(sh);
            for (int i = 0; i < propN; i++) {
                AEditProp *p = &props[i]; void *a = (char *)sel + p->off;
                if (!mem_ok(a, 4)) continue;
                if (p->typ == 'i') { int v = *(int *)a; hui_slider_int(p->name, &v, -100000, 100000); *(int *)a = v; }
                else if (p->typ == 'f') { float v = *(float *)a; hui_slider_float(p->name, &v, -10000, 10000, 0.5f); *(float *)a = v; }
                else if (p->typ == 'y') { int v = *(unsigned char *)a; hui_slider_int(p->name, &v, 0, 255); *(unsigned char *)a = (unsigned char)v; }
                else if (p->typ == 'b' && p->mask) { int v = (*(unsigned *)a & p->mask) ? 1 : 0, o = v; hui_checkbox(p->name, &v); if (v != o) { if (v) *(unsigned *)a |= p->mask; else *(unsigned *)a &= ~p->mask; } }
                else ui_label_at(p->name);
            }
        }
    }
    if (hui_section("Info")) {
        char b[128];
        wsprintfA(b, "Renderer: %s", g_renderer[0] ? g_renderer : "?"); ui_label_at(b);
        wsprintfA(b, "Map: %s", g_uiMap); ui_label_at(b);
        wsprintfA(b, "Pos: %d %d %d", (int)g_uiPos[0], (int)g_uiPos[1], (int)g_uiPos[2]); ui_label_at(b);
        wsprintfA(b, "Speed: %d   HP: %d", (int)g_uiSpeed, g_uiHP); ui_label_at(b);
        if (hui_button("Dump level (F1)")) g_uiDumpReq = 1;
        if (hui_button("Dump EVERYTHING (F2)")) g_uiDumpAllReq = 1;
    }

    for (int i = 0; i < g_panelN; i++)
        if (hui_section(g_panels[i].title)) { g_panelBase = g_secOpen; if (g_panels[i].draw) g_panels[i].draw(); g_panelBase = 1; }

    hui_end();
    draw_cursor(M.mx, M.my);

    M.prev = M.down;
    M.wheel = 0; M.clicked = 0; M.released = 0; g_typedN = 0;
}
