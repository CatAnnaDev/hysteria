#include "hysteria_api.h"
#include <math.h>
#include <windows.h>

// Autopilot (C++): finds the nearest living enemy, faces it, walks to it, and attacks.
// Movement uses DirectInput scancodes (layout-independent: physical W/Space) so it works on
// AZERTY too. Auto-jumps when it gets stuck. It will stall at platforming/puzzle sections
// (no nav/puzzle solving) and hand control back — that's expected.

static HysteriaAPI *A;

static int g_on = 0, g_combat = 1, g_approach = 1, g_jump = 1;
static float g_range = 3000.0f;

static const float PI = 3.14159265358979f;
static const float UE = 32768.0f / PI;

static AObj g_pawns[256];
static int g_pawnN = 0;
static void collect(AObj o) { if (g_pawnN < 256) g_pawns[g_pawnN++] = o; }

static int g_fwd = 0, g_atk = 0;
static void scan_key(int sc, int down) { keybd_event(0, (BYTE)sc, KEYEVENTF_SCANCODE | (down ? 0 : KEYEVENTF_KEYUP), 0); }
static void fwd(int d) { if (d != g_fwd) { scan_key(0x11, d); g_fwd = d; } }     // DIK_W (forward)
static void atk(int d) { if (d != g_atk) { mouse_event(d ? MOUSEEVENTF_LEFTDOWN : MOUSEEVENTF_LEFTUP, 0, 0, 0, 0); g_atk = d; } }
static void jump_once(void) { scan_key(0x39, 1); scan_key(0x39, 0); }            // DIK_SPACE tap

static int alive_enemy(AObj o, AObj player) {
    if (!o || o == player) return 0;
    if (!A->is_a(o, "Pawn")) return 0;
    int hp;
    return A->get_int(o, "Health", &hp) && hp > 0;
}

static AObj g_target = 0;
static int g_tick = 0, g_stuck = 0;
static float g_last[3];

static void release(void) { fwd(0); atk(0); }

static void tick(void) {
    if (!g_on) { release(); return; }
    AObj pawn = A->player_pawn(), pc = A->player_controller();
    if (!pawn || !pc) { release(); return; }
    float pl[3];
    if (!A->get_vec(pawn, "Location", pl)) { release(); return; }

    g_tick++;
    if (g_tick % 5 == 0 || !alive_enemy(g_target, pawn)) {
        g_pawnN = 0; A->iter_objects("Pawn", collect);
        AObj best = 0; float bd = g_range * g_range;
        for (int i = 0; i < g_pawnN; i++) {
            AObj o = g_pawns[i];
            if (!alive_enemy(o, pawn)) continue;
            float l[3];
            if (!A->get_vec(o, "Location", l)) continue;
            float dx = l[0] - pl[0], dy = l[1] - pl[1], dz = l[2] - pl[2];
            float d2 = dx * dx + dy * dy + dz * dz;
            if (d2 < bd) { bd = d2; best = o; }
        }
        g_target = best;
    }

    if (!g_target) { release(); return; }
    float el[3];
    if (!A->get_vec(g_target, "Location", el)) { release(); return; }

    float dx = el[0] - pl[0], dy = el[1] - pl[1], dz = (el[2] - pl[2]) + 40.0f;
    float horiz = sqrtf(dx * dx + dy * dy);
    int rot[3] = { (int)(atan2f(dz, horiz) * UE), (int)(atan2f(dy, dx) * UE), 0 };
    A->set_rot(pc, "Rotation", rot);

    float dist = sqrtf(horiz * horiz + dz * dz);
    int close = dist < 220.0f;

    atk(g_combat && close);

    if (g_approach && !close) {
        fwd(1);
        float mv = fabsf(pl[0] - g_last[0]) + fabsf(pl[1] - g_last[1]);
        if (mv < 3.0f) { if (++g_stuck > 10 && g_jump) { jump_once(); g_stuck = 0; } }
        else g_stuck = 0;
    } else {
        fwd(0);
        g_stuck = 0;
    }
    g_last[0] = pl[0]; g_last[1] = pl[1]; g_last[2] = pl[2];
}

static void panel(void) {
    A->ui_checkbox("Autopilot ON", &g_on);
    A->ui_checkbox("  fight (attack in melee)", &g_combat);
    A->ui_checkbox("  approach (walk to enemy)", &g_approach);
    A->ui_checkbox("  auto-jump when stuck", &g_jump);
    A->ui_slider_float("  detect range", &g_range, 500, 8000, 250);
    A->ui_label("Faces + walks to + attacks nearest enemy.");
    A->ui_label("Move = scancode W (AZERTY-safe). Stalls on");
    A->ui_label("platforming/puzzles (no nav/puzzle solving).");
    A->cfg_set_int("autoplay", "on", g_on);
    A->cfg_set_int("autoplay", "combat", g_combat);
    A->cfg_set_int("autoplay", "approach", g_approach);
    A->cfg_set_int("autoplay", "jump", g_jump);
    A->cfg_set_float("autoplay", "range", g_range);
    A->cfg_save("autoplay");
}

extern "C" __declspec(dllexport) void ModMain(HysteriaAPI *api) {
    A = api;
    g_on = A->cfg_get_int("autoplay", "on", 0);
    g_combat = A->cfg_get_int("autoplay", "combat", 1);
    g_approach = A->cfg_get_int("autoplay", "approach", 1);
    g_jump = A->cfg_get_int("autoplay", "jump", 1);
    g_range = A->cfg_get_float("autoplay", "range", 3000.0f);
    A->log("autoplay (C++) loaded - autopilot: approach + fight + jump");
    A->on_tick(tick);
    A->ui_panel("Auto / Combat", panel);
}
