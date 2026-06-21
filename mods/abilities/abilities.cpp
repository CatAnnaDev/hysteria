#include "hysteria_api.h"
#include <math.h>
#include <windows.h>

// Abilities for Alice via the framework. Only effects that actually stick are kept:
// impulses on Alice herself (jump/dash), teleport (set Location), time scale, ground speed,
// and triggering the game's REAL Hysteria mode (with its built-in shockwave) via its own flags.
// Setting Velocity on enemies / sustained fall-caps do NOT work (the engine recomputes them),
// so grapple/glide/ground-pound/repel were removed.
// All toggleable + persisted to Mods/abilities.cfg; keys are VK codes rebindable there.
// Default letter keys (E/H) are the same physical position on AZERTY and QWERTY.

static HysteriaAPI *A;

static int g_djump = 1, g_dash = 1, g_blink = 1, g_slowmo = 1, g_speed = 0, g_shock = 1;
static int g_jumpVk = VK_SPACE, g_dashVk = VK_SHIFT, g_blinkVk = 'E', g_slowVk = VK_RBUTTON, g_shockVk = 'H';
static float g_jumpPower = 900, g_dashPower = 2400, g_blinkDist = 700, g_slowRate = 0.35f,
             g_speedVal = 800, g_shockDmg = 250, g_shockRadius = 900, g_shockPush = 2500;
static int g_slowActive = 0;

static const float PI = 3.14159265358979f;
static const float UE_R = PI / 32768.0f;

static int airborne(AObj p) { int ph = 0; A->get_byte(p, "Physics", &ph); return ph == 2 || ph == 4; }

static AObj g_pw[256];
static int g_pwN = 0;
static void collect(AObj o) { if (g_pwN < 256) g_pw[g_pwN++] = o; }
static int alive_enemy(AObj o, AObj player) {
    if (!o || o == player) return 0;
    if (!A->is_a(o, "Pawn")) return 0;
    int hp; return A->get_int(o, "Health", &hp) && hp > 0;
}

static void tick(void) {
    AObj pawn = A->player_pawn(), pc = A->player_controller();

    if (g_slowmo && pawn && A->key_down(g_slowVk)) {
        AObj wi = A->world_info();
        if (wi) { A->set_float(wi, "TimeDilation", g_slowRate < 0.05f ? 0.05f : g_slowRate); g_slowActive = 1; }
    } else if (g_slowActive) {
        AObj wi = A->world_info();
        if (wi) A->set_float(wi, "TimeDilation", 1.0f);
        g_slowActive = 0;
    }
    if (!pawn || !pc) return;

    int rot[3]; int haveRot = A->get_rot(pc, "Rotation", rot);
    float yaw = haveRot ? rot[1] * UE_R : 0.0f;
    float fwx = cosf(yaw), fwy = sinf(yaw);

    if (g_djump && A->key_pressed(g_jumpVk) && airborne(pawn)) {
        float v[3]; if (A->get_vec(pawn, "Velocity", v)) { v[2] = g_jumpPower; A->set_vec(pawn, "Velocity", v); }
    }
    if (g_dash && haveRot && A->key_pressed(g_dashVk)) {
        float v[3]; A->get_vec(pawn, "Velocity", v);
        v[0] = fwx * g_dashPower; v[1] = fwy * g_dashPower; if (v[2] < 0) v[2] = 0;
        A->set_vec(pawn, "Velocity", v);
    }
    if (g_blink && haveRot && A->key_pressed(g_blinkVk)) {
        float pl[3];
        if (A->get_vec(pawn, "Location", pl)) {
            float pitch = rot[0] * UE_R, cp = cosf(pitch);
            float nl[3] = { pl[0] + fwx * cp * g_blinkDist, pl[1] + fwy * cp * g_blinkDist, pl[2] + sinf(pitch) * g_blinkDist + 20 };
            A->set_vec(pawn, "Location", nl);
        }
    }
    if (g_speed && g_speedVal > 1) A->set_float(pawn, "GroundSpeed", g_speedVal);

    // Shockwave: hysteria-style radial PUSH + damage, without entering hysteria mode.
    // Pure reflection (no function calls -> no per-enemy object scan -> no freeze): switch each
    // nearby enemy to PHYS_Falling (so the launch velocity persists), set Velocity away from Alice,
    // and subtract Health directly. The Falling switch is the key the earlier repel was missing.
    if (g_shock && A->key_pressed(g_shockVk)) {
        float pl[3];
        if (A->get_vec(pawn, "Location", pl)) {
            g_pwN = 0; A->iter_objects("Pawn", collect);
            for (int i = 0; i < g_pwN; i++) {
                AObj o = g_pw[i]; if (!alive_enemy(o, pawn)) continue;
                float l[3]; if (!A->get_vec(o, "Location", l)) continue;
                float dx = l[0]-pl[0], dy = l[1]-pl[1], dz = l[2]-pl[2]; float d2 = dx*dx+dy*dy+dz*dz;
                if (d2 > g_shockRadius * g_shockRadius) continue;
                float d = sqrtf(d2); if (d < 1) d = 1;
                A->set_byte(o, "Physics", 2); // PHYS_Falling so velocity is not overwritten
                float v[3] = { dx/d * g_shockPush, dy/d * g_shockPush, g_shockPush * 0.5f };
                A->set_vec(o, "Velocity", v);
                if (g_shockDmg > 0) { int hp; if (A->get_int(o, "Health", &hp) && hp > 0) A->set_int(o, "Health", hp - (int)g_shockDmg); }
            }
        }
    }
}

#define CB(k,v) A->cfg_set_int("abilities",k,v)
#define CF(k,v) A->cfg_set_float("abilities",k,v)
static void cfg_load(void) {
    g_djump=A->cfg_get_int("abilities","djump",g_djump); g_dash=A->cfg_get_int("abilities","dash",g_dash);
    g_blink=A->cfg_get_int("abilities","blink",g_blink); g_slowmo=A->cfg_get_int("abilities","slowmo",g_slowmo);
    g_speed=A->cfg_get_int("abilities","speed",g_speed); g_shock=A->cfg_get_int("abilities","shock",g_shock);
    g_jumpPower=A->cfg_get_float("abilities","jumpPower",g_jumpPower); g_dashPower=A->cfg_get_float("abilities","dashPower",g_dashPower);
    g_blinkDist=A->cfg_get_float("abilities","blinkDist",g_blinkDist); g_slowRate=A->cfg_get_float("abilities","slowRate",g_slowRate);
    g_speedVal=A->cfg_get_float("abilities","speedVal",g_speedVal);
    g_shockDmg=A->cfg_get_float("abilities","shockDmg",g_shockDmg); g_shockRadius=A->cfg_get_float("abilities","shockRadius",g_shockRadius);
    g_shockPush=A->cfg_get_float("abilities","shockPush",g_shockPush);
    g_jumpVk=A->cfg_get_int("abilities","jumpVk",g_jumpVk); g_dashVk=A->cfg_get_int("abilities","dashVk",g_dashVk);
    g_blinkVk=A->cfg_get_int("abilities","blinkVk",g_blinkVk); g_slowVk=A->cfg_get_int("abilities","slowVk",g_slowVk);
    g_shockVk=A->cfg_get_int("abilities","shockVk",g_shockVk);
}
static void cfg_store(void) {
    CB("djump",g_djump); CB("dash",g_dash); CB("blink",g_blink); CB("slowmo",g_slowmo); CB("speed",g_speed); CB("shock",g_shock);
    CF("jumpPower",g_jumpPower); CF("dashPower",g_dashPower); CF("blinkDist",g_blinkDist); CF("slowRate",g_slowRate);
    CF("speedVal",g_speedVal); CF("shockDmg",g_shockDmg); CF("shockRadius",g_shockRadius); CF("shockPush",g_shockPush);
    CB("jumpVk",g_jumpVk); CB("dashVk",g_dashVk); CB("blinkVk",g_blinkVk); CB("slowVk",g_slowVk); CB("shockVk",g_shockVk);
    A->cfg_save("abilities");
}

static void panel(void) {
    A->ui_checkbox("Infinite air-jump (Space)", &g_djump);
    A->ui_slider_float("  jump power", &g_jumpPower, 300, 2000, 50);
    A->ui_checkbox("Dash (L-Shift)", &g_dash);
    A->ui_slider_float("  dash power", &g_dashPower, 500, 6000, 100);
    A->ui_checkbox("Blink/teleport (E)", &g_blink);
    A->ui_slider_float("  blink dist", &g_blinkDist, 200, 3000, 50);
    A->ui_checkbox("Slow-mo (hold R-Mouse)", &g_slowmo);
    A->ui_slider_float("  slow rate", &g_slowRate, 0.10f, 1.0f, 0.05f);
    A->ui_checkbox("Speed boost", &g_speed);
    A->ui_slider_float("  ground speed", &g_speedVal, 300, 3000, 50);
    A->ui_checkbox("Shockwave / hysteria push (H)", &g_shock);
    A->ui_slider_float("  shock damage", &g_shockDmg, 0, 2000, 50);
    A->ui_slider_float("  shock radius", &g_shockRadius, 200, 3000, 100);
    A->ui_slider_float("  shock push", &g_shockPush, 300, 8000, 100);
    A->ui_label("Rebind keys (VK) in Mods/abilities.cfg");
    cfg_store();
}

extern "C" __declspec(dllexport) void ModMain(HysteriaAPI *api) {
    A = api;
    cfg_load();
    A->log("abilities (C++) loaded - jump/dash/blink/slowmo/speed/shockwave");
    A->on_tick(tick);
    A->ui_panel("Abilities", panel);
}
