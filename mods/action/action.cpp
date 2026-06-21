#include "hysteria_api.h"
#include <math.h>
#include <windows.h>

static HysteriaAPI *A;

static int g_on = 1;
static int g_juggle = 1;
static float g_popUp = 380, g_perHit = 120, g_holdFrames = 150, g_decay = 7, g_penalty = 0.35f;

static float g_mana = 100, g_manaMax = 100, g_manaRegen = 0.30f, g_manaPerHit = 4.0f;

static int g_jumpOn = 1, g_dashOn = 1;
static float g_jumpPower = 900, g_dashPower = 2400;

static int g_dmgScale = 1;
static float g_dmgMax = 2.5f, g_lifesteal = 1.0f;
static float g_killStyle = 600, g_killMana = 20, g_killHeal = 25;

static int g_healOn = 1;
static float g_healCost = 45, g_healAmt = 80;
static int g_novaOn = 1;
static float g_novaCost = 30, g_novaDmg = 200, g_novaRadius = 1200, g_novaPush = 2600;

static int g_hystOn = 1;
static float g_hystMeter = 0, g_hystMax = 100, g_hystGain = 1.2f, g_hystKill = 8.0f;
static float g_hystDmg = 2.0f;
static int g_hystDur = 600, g_hystActive = 0;

static int g_healthHideMode = 1;
static int g_aliceHp = 0, g_aliceMax = 0, g_haveAliceHp = 0;

static int g_jumpVk = VK_SPACE, g_dashVk = VK_SHIFT, g_novaVk = 'X', g_healVk = 'G', g_hystVk = 'V';

static float g_style = 0;
static int g_combo = 0;
static float g_timer = 0, g_pendHeal = 0;
static int g_manaFlash = 0, g_swCd = 0, g_levelFlash = 0;
static AObj g_jq[64]; static int g_jqN = 0;
static AObj g_known[96]; static int g_knownN = 0;

enum { SK_BLOOD, SK_ARCANE, SK_BERSERK, SK_MOMENTUM, SK_CATA, SK_VIRTUOSO, SK_BULWARK, SK_EXEC, SK_SECOND, SK_RESOLVE, SK_N };
static int g_skill[SK_N] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
static int g_skillCap = 5;
static int g_level = 1, g_points = 0;
static float g_xp = 0, g_xpBase = 20;

static const float PI = 3.14159265358979f, UE_R = PI / 32768.0f;

static int hyst(void) { return g_hystActive > 0; }
static float eff_lifesteal(void) { return (g_lifesteal + g_skill[SK_BLOOD] * 1.0f) * (hyst() ? 2.0f : 1.0f); }
static float eff_killHeal(void)  { return g_killHeal + g_skill[SK_BLOOD] * 10.0f; }
static float eff_manaMax(void)   { return g_manaMax + g_skill[SK_ARCANE] * 25.0f; }
static float eff_manaRegen(void) { return (g_manaRegen + g_skill[SK_ARCANE] * 0.10f) * (hyst() ? 4.0f : 1.0f); }
static float eff_dmgMax(void)    { return g_dmgMax + g_skill[SK_BERSERK] * 0.30f; }
static float eff_dash(void)      { return g_dashPower + g_skill[SK_MOMENTUM] * 400.0f; }
static float eff_jump(void)      { return g_jumpPower + g_skill[SK_MOMENTUM] * 150.0f; }
static float eff_novaDmg(void)   { return g_novaDmg + g_skill[SK_CATA] * 100.0f; }
static float eff_novaRadius(void){ return g_novaRadius + g_skill[SK_CATA] * 200.0f; }
static float eff_perHit(void)    { return g_perHit + g_skill[SK_VIRTUOSO] * 30.0f; }
static float eff_decay(void)     { float d = g_decay - g_skill[SK_VIRTUOSO] * 1.0f; return d < 1.0f ? 1.0f : d; }
static float eff_armor(void)     { float a = 1.0f - g_skill[SK_BULWARK] * 0.10f; return a < 0.35f ? 0.35f : a; }
static float eff_xpMult(void)    { return 1.0f + g_skill[SK_EXEC] * 0.15f; }
static float eff_penalty(void)   { float p = g_penalty + (1.0f - g_penalty) * (g_skill[SK_RESOLVE] / 5.0f); return p > 1.0f ? 1.0f : p; }

static float xp_need(void) { return 120.0f + (float)(g_level * g_level) * 60.0f; }
static void grant_xp(float amt) {
    g_xp += amt;
    while (g_xp >= xp_need()) { g_xp -= xp_need(); g_level++; g_points++; g_levelFlash = 150; }
}

static int airborne(AObj p) { int ph = 0; A->get_byte(p, "Physics", &ph); return ph == 2 || ph == 4; }

static void remember(AObj o) {
    for (int i = 0; i < g_knownN; i++) if (g_known[i] == o) return;
    if (g_knownN < 96) g_known[g_knownN++] = o;
}
static void purge_known(void) {
    int w = 0;
    for (int i = 0; i < g_knownN; i++) {
        AObj o = g_known[i]; int hp;
        if (o && A->is_a(o, "Pawn") && A->get_int(o, "Health", &hp) && hp > 0) g_known[w++] = o;
    }
    g_knownN = w;
}

static const char *rank(float s) {
    if (s >= 8000) return "SSS"; if (s >= 5500) return "SS"; if (s >= 3500) return "S";
    if (s >= 2000) return "A"; if (s >= 1100) return "B"; if (s >= 500) return "C"; if (s > 0) return "D"; return "-";
}
static unsigned rank_col(float s) {
    if (s >= 5500) return 0xFFFF3030u; if (s >= 3500) return 0xFFFFA020u;
    if (s >= 2000) return 0xFFE8B23Au; if (s >= 500) return 0xFFB070E0u; return 0xFFC8B0C0u;
}
static float dmg_mult(void) {
    float m = 1.0f + (g_style / 12000.0f) * (eff_dmgMax() - 1.0f);
    if (hyst()) m *= g_hystDmg;
    return m < 1.0f ? 1.0f : m;
}

static void on_health(AEvent *e) {
    int mx, cur;
    if (A->param_get_int(e, "maxHealth", &mx)) { g_aliceMax = mx; g_haveAliceHp = 1; }
    if (A->param_get_int(e, "curHealth", &cur)) g_aliceHp = cur;
    if (g_healthHideMode == 1) e->block = 1;
}
static void on_postrender(AEvent *e) {
    if (g_healthHideMode == 2 && e->self && A->is_a(e->self, "AliceHud")) e->block = 1;
}

static int read_dmg(AEvent *e, const char **outName) {
    int dmg = 0; const char *pn = "DamageAmount";
    if (!A->param_get_int(e, pn, &dmg)) { pn = "Damage"; if (!A->param_get_int(e, pn, &dmg)) pn = 0; }
    *outName = pn; return dmg;
}

static void on_dmg(AEvent *e) {
    if (!g_on) return;
    AObj victim = e->self; if (!victim) return;

    if (victim == A->player_pawn()) {
        if (g_skill[SK_BULWARK] > 0) {
            const char *pn; int dmg = read_dmg(e, &pn);
            if (pn && dmg > 0) { int nd = (int)(dmg * eff_armor()); if (nd < 0) nd = 0; A->param_set_int(e, pn, nd); }
        }
        g_style *= eff_penalty(); g_combo = 0; g_timer = 0; return;
    }
    if (!A->is_a(victim, "Pawn")) return;

    int vhp = 0, hadHp = A->get_int(victim, "Health", &vhp);
    int vmax = 0; A->get_int(victim, "HealthMax", &vmax); if (vmax <= 0) vmax = (vhp > 0 ? vhp : 1);

    if (g_dmgScale) {
        const char *pn; int dmg = read_dmg(e, &pn);
        if (pn && dmg > 0) {
            float m = dmg_mult();
            if (g_skill[SK_EXEC] > 0 && hadHp && vhp < vmax * 0.20f) m *= (1.0f + 0.20f * g_skill[SK_EXEC]);
            int nd = (int)(dmg * m); if (nd < dmg) nd = dmg;
            A->param_set_int(e, pn, nd); dmg = nd;
        }
        if (dmg > 0 && hadHp && vhp > 0 && vhp - dmg <= 0) {
            g_style += g_killStyle; if (g_style > 12000) g_style = 12000;
            g_mana += g_killMana; if (g_mana > eff_manaMax()) g_mana = eff_manaMax();
            g_pendHeal += eff_killHeal();
            if (!hyst()) { g_hystMeter += g_hystKill; if (g_hystMeter > g_hystMax) g_hystMeter = g_hystMax; }
            grant_xp((g_xpBase * 0.5f + vmax / 5.0f) * eff_xpMult());
        }
    }

    if (g_juggle && g_jqN < 64) g_jq[g_jqN++] = victim;
    remember(victim);
    g_combo++;
    g_style += eff_perHit() * (1.0f + g_combo * 0.05f);
    if (g_style > 12000) g_style = 12000;
    g_pendHeal += eff_lifesteal();
    if (!hyst()) { g_hystMeter += g_hystGain; if (g_hystMeter > g_hystMax) g_hystMeter = g_hystMax; }
    g_timer = g_holdFrames;
    g_mana += g_manaPerHit; if (g_mana > eff_manaMax()) g_mana = eff_manaMax();
}

static void do_nova(AObj pawn) {
    float pl[3]; if (!A->get_vec(pawn, "Location", pl)) return;
    float r = eff_novaRadius();
    for (int i = 0; i < g_knownN; i++) {
        AObj o = g_known[i]; int hp;
        if (!o || !A->is_a(o, "Pawn") || !A->get_int(o, "Health", &hp) || hp <= 0) continue;
        float l[3]; if (!A->get_vec(o, "Location", l)) continue;
        float dx = l[0] - pl[0], dy = l[1] - pl[1], dz = l[2] - pl[2];
        float d2 = dx * dx + dy * dy + dz * dz;
        if (d2 > r * r) continue;
        float d = sqrtf(d2); if (d < 1) d = 1;
        A->set_byte(o, "Physics", 2);
        float v[3] = { dx / d * g_novaPush, dy / d * g_novaPush, g_novaPush * 0.45f };
        A->set_vec(o, "Velocity", v);
        if (g_novaDmg > 0) A->set_int(o, "Health", hp - (int)(eff_novaDmg() * dmg_mult()));
    }
}

static void hframe(int x, int y, int w, int h, unsigned c) {
    A->hud_rect(x, y, w, 1, c); A->hud_rect(x, y + h - 1, w, 1, c);
    A->hud_rect(x, y, 1, h, c); A->hud_rect(x + w - 1, y, 1, h, c);
}
static void glow(int x, int y, unsigned col, const char *t) {
    A->hud_text(x - 1, y, 0xC0000000u, t); A->hud_text(x + 1, y, 0xC0000000u, t);
    A->hud_text(x, y - 1, 0xC0000000u, t); A->hud_text(x, y + 1, 0xC0000000u, t);
    A->hud_text(x, y, col, t);
}
static void segbar(int x, int y, int w, int h, float r, unsigned fill) {
    if (r < 0) r = 0; if (r > 1) r = 1;
    A->hud_rect(x, y, w, h, 0xFF1A0E1Cu);
    int fw = (int)(w * r), seg = 14, gap = 3, cx = x;
    while (cx < x + fw) { int sw = seg; if (cx + sw > x + fw) sw = x + fw - cx; if (sw > 0) A->hud_rect(cx, y, sw, h, fill); cx += seg + gap; }
    A->hud_rect(x, y, fw, 2, 0x55FFFFFFu);
    hframe(x, y, w, h, 0xFF6A4A6Au);
}

static void overlay(void) {
    int W = 0, H = 0; if (!A->screen_size(&W, &H) || W <= 0 || H <= 0) return;
    if (hyst()) {
        int bands = 6, t = 7;
        for (int i = 0; i < bands; i++) {
            unsigned a = (unsigned)(0x42 * (bands - i) / bands);
            unsigned col = (a << 24) | 0x00B0102Cu;
            A->hud_rect(0, i * t, W, t, col);
            A->hud_rect(0, H - (i + 1) * t, W, t, col);
            A->hud_rect(i * t, 0, t, H, col);
            A->hud_rect(W - (i + 1) * t, 0, t, H, col);
        }
        glow(W / 2 - 64, 44, 0xFFFF4858u, "H Y S T E R I A");
    }
    if (g_levelFlash > 0) {
        int by = H / 2 - 48;
        glow(W / 2 - 52, by, 0xFFFFD24Au, "LEVEL  UP");
        char lb[24]; wsprintfA(lb, "Level %d", g_level);
        glow(W / 2 - 34, by + 22, 0xFFFFE6A0u, lb);
    }
}

static void hud(AObj pawn) {
    const int px = 30, py = 30, pw = 312, ph = 140;
    A->hud_rect(px, py, pw, ph, 0xCC120612u);
    hframe(px, py, pw, ph, 0xFF5A3A5Au);
    A->hud_rect(px, py, pw, 2, 0xFFC0A050u);
    glow(px + 12, py + 5, 0xFFD8A93Au, "HYSTERIA");

    char b[48];
    wsprintfA(b, "Lv %d", g_level); glow(px + pw - 54, py + 5, 0xFFD8A93Au, b);
    if (g_points > 0) { wsprintfA(b, "+%d", g_points); glow(px + pw - 92, py + 5, 0xFF70FF90u, b); }

    const int bx = px + 14, bw = pw - 28, bh = 13;
    int hy = py + 36, hp = 0, hpmax = 0;
    if (g_haveAliceHp) { hp = g_aliceHp; hpmax = g_aliceMax; }
    else { A->get_int(pawn, "Health", &hp); A->get_int(pawn, "HealthMax", &hpmax); }
    if (hpmax <= 0) hpmax = (hp > 0 ? hp : 1);
    glow(bx, hy - 16, 0xFFEDE0E8u, "HP");
    wsprintfA(b, "%d / %d", hp, hpmax); glow(bx + bw - 78, hy - 16, 0xFFE89098u, b);
    segbar(bx, hy, bw, bh, (float)hp / hpmax, 0xFFB81428u);

    int my = hy + 32;
    glow(bx, my - 16, 0xFFEDE0E8u, "MANA");
    wsprintfA(b, "%d / %d", (int)g_mana, (int)eff_manaMax()); glow(bx + bw - 78, my - 16, 0xFFB89CF0u, b);
    segbar(bx, my, bw, bh, g_mana / eff_manaMax(), g_manaFlash > 0 ? 0xFFE03040u : 0xFF7B3FF2u);

    int gy = my + 30;
    glow(bx, gy - 14, 0xFFEDC0C0u, "HYSTERIA");
    unsigned hcol = hyst() ? 0xFFFFC040u : (g_hystMeter >= g_hystMax ? 0xFFFFD24Au : 0xFFB02040u);
    segbar(bx, gy, bw, 8, g_hystMeter / g_hystMax, hcol);
    if (hyst()) { wsprintfA(b, "%ds", g_hystActive / 60 + 1); glow(bx + bw - 30, gy - 14, 0xFFFFD24Au, b); }
    else if (g_hystMeter >= g_hystMax) glow(bx + bw - 36, gy - 14, 0xFF70FF90u, "[V]");

    float xr = g_xp / xp_need(); if (xr < 0) xr = 0; if (xr > 1) xr = 1;
    A->hud_rect(px + 1, py + ph - 4, pw - 2, 3, 0xFF20121Eu);
    A->hud_rect(px + 1, py + ph - 4, (int)((pw - 2) * xr), 3, 0xFFD8A93Au);

    if (g_style > 0) {
        unsigned col = rank_col(g_style);
        int sy = py + ph + 10;
        glow(px + 4, sy, 0xFF9A7A9Au, "STYLE");
        glow(px + 70, sy - 3, col, rank(g_style));
        wsprintfA(b, "x%d", g_combo); glow(px + 132, sy, col, b);
        if (g_dmgScale) {
            float m = dmg_mult();
            wsprintfA(b, "DMG x%d.%d", (int)m, ((int)(m * 10)) % 10);
            glow(px + 196, sy, 0xFFE8C060u, b);
        }
        segbar(px + 4, sy + 22, pw - 8, 8, g_style / 12000.0f, col);
    }

    overlay();
}

static void tick(void) {
    if (!g_on) return;
    AObj pawn = A->player_pawn(), pc = A->player_controller();

    if (g_manaFlash > 0) g_manaFlash--;
    if (g_swCd > 0) g_swCd--;
    if (g_levelFlash > 0) g_levelFlash--;
    if (g_hystActive > 0) g_hystActive--;

    g_mana += eff_manaRegen(); if (g_mana > eff_manaMax()) g_mana = eff_manaMax();

    for (int i = 0; i < g_jqN; i++) {
        AObj o = g_jq[i]; if (!o || !A->is_a(o, "Pawn")) continue;
        int hp; if (!(A->get_int(o, "Health", &hp) && hp > 0)) continue;
        A->set_byte(o, "Physics", 2);
        float v[3]; if (A->get_vec(o, "Velocity", v)) { if (v[2] < g_popUp) v[2] = g_popUp; A->set_vec(o, "Velocity", v); }
    }
    g_jqN = 0;

    static int purgeT = 0; if (++purgeT >= 12) { purgeT = 0; purge_known(); }

    if (g_timer > 0) g_timer -= 1;
    else { if (g_style > 0) { g_style -= eff_decay(); if (g_style < 0) g_style = 0; } g_combo = 0; }

    if (pawn && g_skill[SK_SECOND] > 0 && g_swCd == 0) {
        int hp = 0, mx = 0; A->get_int(pawn, "Health", &hp); A->get_int(pawn, "HealthMax", &mx); if (mx <= 0) mx = 999;
        if (hp > 0 && hp < mx * 0.25f) {
            int heal = (int)(mx * 0.20f + mx * 0.06f * g_skill[SK_SECOND]);
            int nh = hp + heal; if (nh > mx) nh = mx; A->set_int(pawn, "Health", nh);
            g_swCd = 1200;
        }
    }

    if (pawn && g_pendHeal >= 1.0f) {
        int hp = 0, mx = 0; A->get_int(pawn, "Health", &hp); A->get_int(pawn, "HealthMax", &mx); if (mx <= 0) mx = 999;
        int add = (int)g_pendHeal; int nh = hp + add; if (nh > mx) nh = mx;
        if (nh > hp) A->set_int(pawn, "Health", nh);
        g_pendHeal -= add;
    }

    int paused = 0; AObj wi = A->world_info();
    if (wi) { AObj pz = A->get_obj(wi, "Pauser"); paused = (pz != 0); }
    static int hudRestored = 0;
    if (!hudRestored && pc) { AObj h = A->get_obj(pc, "myHUD"); if (h) { A->set_bool(h, "bShowHUD", 1); hudRestored = 1; } }

    if (pawn && !paused) hud(pawn);
    if (!pawn || !pc || paused) return;

    int rot[3]; int haveRot = A->get_rot(pc, "Rotation", rot);
    float yaw = haveRot ? rot[1] * UE_R : 0.0f, fwx = cosf(yaw), fwy = sinf(yaw);

    if (g_hystOn && A->key_pressed(g_hystVk) && !hyst() && g_hystMeter >= g_hystMax) { g_hystActive = g_hystDur; g_hystMeter = 0; }

    if (g_jumpOn && A->key_pressed(g_jumpVk) && airborne(pawn)) {
        float v[3]; if (A->get_vec(pawn, "Velocity", v)) { v[2] = eff_jump(); A->set_vec(pawn, "Velocity", v); }
    }
    if (g_dashOn && haveRot && A->key_pressed(g_dashVk)) {
        float v[3]; A->get_vec(pawn, "Velocity", v); v[0] = fwx * eff_dash(); v[1] = fwy * eff_dash(); if (v[2] < 0) v[2] = 0;
        A->set_vec(pawn, "Velocity", v);
    }

    if (g_novaOn && A->key_pressed(g_novaVk)) {
        if (g_mana >= g_novaCost) { g_mana -= g_novaCost; do_nova(pawn); } else g_manaFlash = 16;
    }
    if (g_healOn && A->key_pressed(g_healVk)) {
        if (g_mana >= g_healCost) {
            int hp = 0, mx = 0; A->get_int(pawn, "Health", &hp); A->get_int(pawn, "HealthMax", &mx); if (mx <= 0) mx = 999;
            int nh = hp + (int)g_healAmt; if (nh > mx) nh = mx;
            if (nh > hp) { A->set_int(pawn, "Health", nh); g_mana -= g_healCost; }
        } else g_manaFlash = 16;
    }
}

#define CB(k,v) A->cfg_set_int("action",k,v)
#define CF(k,v) A->cfg_set_float("action",k,v)
#define GB(k,v) v=A->cfg_get_int("action",k,v)
#define GF(k,v) v=A->cfg_get_float("action",k,v)
static void cfg_load(void) {
    GB("on",g_on); GB("juggle",g_juggle); GB("healthHideMode",g_healthHideMode);
    GB("jumpOn",g_jumpOn); GB("dashOn",g_dashOn);
    GB("dmgScale",g_dmgScale); GB("healOn",g_healOn); GB("novaOn",g_novaOn); GB("hystOn",g_hystOn);
    GF("popUp",g_popUp); GF("perHit",g_perHit); GF("holdFrames",g_holdFrames); GF("decay",g_decay); GF("penalty",g_penalty);
    GF("manaMax",g_manaMax); GF("manaRegen",g_manaRegen); GF("manaPerHit",g_manaPerHit);
    GF("jumpPower",g_jumpPower); GF("dashPower",g_dashPower);
    GF("dmgMax",g_dmgMax); GF("lifesteal",g_lifesteal);
    GF("killStyle",g_killStyle); GF("killMana",g_killMana); GF("killHeal",g_killHeal);
    GF("healCost",g_healCost); GF("healAmt",g_healAmt);
    GF("novaCost",g_novaCost); GF("novaDmg",g_novaDmg); GF("novaRadius",g_novaRadius); GF("novaPush",g_novaPush);
    GF("hystMax",g_hystMax); GF("hystGain",g_hystGain); GF("hystKill",g_hystKill); GF("hystDmg",g_hystDmg);
    { int d=g_hystDur; GB("hystDur",d); g_hystDur=d; }
    GB("level",g_level); GB("points",g_points); GF("xp",g_xp); GF("xpBase",g_xpBase);
    for (int i = 0; i < SK_N; i++) { char k[8]; wsprintfA(k, "sk%d", i); g_skill[i] = A->cfg_get_int("action", k, g_skill[i]); }
    g_mana = eff_manaMax();
}
static void cfg_store(void) {
    CB("on",g_on); CB("juggle",g_juggle); CB("healthHideMode",g_healthHideMode);
    CB("jumpOn",g_jumpOn); CB("dashOn",g_dashOn);
    CB("dmgScale",g_dmgScale); CB("healOn",g_healOn); CB("novaOn",g_novaOn); CB("hystOn",g_hystOn);
    CF("popUp",g_popUp); CF("perHit",g_perHit); CF("holdFrames",g_holdFrames); CF("decay",g_decay); CF("penalty",g_penalty);
    CF("manaMax",g_manaMax); CF("manaRegen",g_manaRegen); CF("manaPerHit",g_manaPerHit);
    CF("jumpPower",g_jumpPower); CF("dashPower",g_dashPower);
    CF("dmgMax",g_dmgMax); CF("lifesteal",g_lifesteal);
    CF("killStyle",g_killStyle); CF("killMana",g_killMana); CF("killHeal",g_killHeal);
    CF("healCost",g_healCost); CF("healAmt",g_healAmt);
    CF("novaCost",g_novaCost); CF("novaDmg",g_novaDmg); CF("novaRadius",g_novaRadius); CF("novaPush",g_novaPush);
    CF("hystMax",g_hystMax); CF("hystGain",g_hystGain); CF("hystKill",g_hystKill); CF("hystDmg",g_hystDmg);
    CB("hystDur",g_hystDur);
    CB("level",g_level); CB("points",g_points); CF("xp",g_xp); CF("xpBase",g_xpBase);
    for (int i = 0; i < SK_N; i++) { char k[8]; wsprintfA(k, "sk%d", i); A->cfg_set_int("action", k, g_skill[i]); }
    A->cfg_save("action");
}

static const char *g_skNames[SK_N] = {
    "Bloodlust  lifesteal + kill-heal",
    "Arcane  mana max + regen",
    "Berserker  max damage mult",
    "Momentum  dash + air-jump",
    "Cataclysm  nova dmg + radius",
    "Virtuoso  style gain + slow decay",
    "Bulwark  take less damage",
    "Executioner  +xp, execute low-hp",
    "Second Wind  auto-heal when low",
    "Resolve  keep style when hit",
};

static void panel(void) {
    char b[80];
    A->ui_checkbox("ACTION OVERHAUL on", &g_on);
    A->ui_label("Hide native health (0 off, 1 block-update, 2 block-postrender)");
    A->ui_slider_int("  health hide mode", &g_healthHideMode, 0, 2);
    wsprintfA(b, "Level %d    XP %d / %d", g_level, (int)g_xp, (int)xp_need());
    A->ui_label(b);
    wsprintfA(b, "Skill points: %d", g_points);
    A->ui_label(b);
    A->ui_label("== Passives (click to spend) ==");
    for (int i = 0; i < SK_N; i++) {
        wsprintfA(b, "%s  [%d/%d]", g_skNames[i], g_skill[i], g_skillCap);
        if (A->ui_button(b)) { if (g_points > 0 && g_skill[i] < g_skillCap) { g_skill[i]++; g_points--; } }
    }
    if (A->ui_button("Respec (refund all points)")) { for (int i = 0; i < SK_N; i++) { g_points += g_skill[i]; g_skill[i] = 0; } }
    A->ui_label("== Hysteria Mode (V) ==");
    A->ui_checkbox("Enabled", &g_hystOn);
    A->ui_slider_float("  damage mult", &g_hystDmg, 1.0f, 5.0f, 0.25f);
    A->ui_slider_int("  duration (frames)", &g_hystDur, 120, 1800);
    A->ui_slider_float("  meter/hit", &g_hystGain, 0.0f, 10.0f, 0.2f);
    A->ui_slider_float("  meter/kill", &g_hystKill, 0.0f, 50.0f, 1.0f);
    A->ui_label("== Combat ==");
    A->ui_checkbox("Juggle (hits pop enemies up)", &g_juggle);
    A->ui_slider_float("  pop-up", &g_popUp, 0, 1500, 20);
    A->ui_checkbox("Style-scaled damage", &g_dmgScale);
    A->ui_slider_float("  base max dmg mult", &g_dmgMax, 1.0f, 5.0f, 0.1f);
    A->ui_slider_float("  base points/hit", &g_perHit, 20, 500, 10);
    A->ui_slider_float("  combo hold", &g_holdFrames, 30, 600, 10);
    A->ui_slider_float("  base lifesteal/hit", &g_lifesteal, 0, 20, 1);
    A->ui_label("== XP / Kill reward ==");
    A->ui_slider_float("  xp per kill (base)", &g_xpBase, 5, 200, 5);
    A->ui_slider_float("  kill style", &g_killStyle, 0, 3000, 100);
    A->ui_slider_float("  kill mana", &g_killMana, 0, 100, 5);
    A->ui_slider_float("  base kill heal", &g_killHeal, 0, 200, 5);
    A->ui_label("== Mana ==");
    A->ui_slider_float("  base max", &g_manaMax, 50, 500, 10);
    A->ui_slider_float("  base regen/tick", &g_manaRegen, 0.0f, 3.0f, 0.05f);
    A->ui_slider_float("  gain/hit", &g_manaPerHit, 0.0f, 20.0f, 1.0f);
    A->ui_label("== Move ==");
    A->ui_checkbox("Air-jump (Space)", &g_jumpOn);
    A->ui_checkbox("Dash (Shift)", &g_dashOn);
    A->ui_label("== Spells ==");
    A->ui_checkbox("Hysteria Nova (X)", &g_novaOn);
    A->ui_slider_float("  nova cost", &g_novaCost, 0, 100, 5);
    A->ui_slider_float("  base nova dmg", &g_novaDmg, 0, 2000, 50);
    A->ui_slider_float("  base nova radius", &g_novaRadius, 300, 4000, 100);
    A->ui_slider_float("  nova push", &g_novaPush, 300, 8000, 100);
    A->ui_checkbox("Heal (G)", &g_healOn);
    A->ui_slider_float("  heal cost", &g_healCost, 0, 100, 5);
    A->ui_slider_float("  heal amount", &g_healAmt, 10, 500, 10);
    cfg_store();
}

extern "C" __declspec(dllexport) void ModMain(HysteriaAPI *api) {
    A = api;
    cfg_load();
    A->log("ACTION OVERHAUL loaded - combat/move/magic/XP/Hysteria/HUD");
    A->on("TakeDamage", on_dmg);
    A->on("UpdateAliceHealth", on_health);
    A->on("PostRender", on_postrender);
    A->on_tick(tick);
    A->ui_panel("ACTION", panel);
}
