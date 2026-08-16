#include "coop.h"

PovSnap g_snap;

static void ue_axes(const int rot[3], float X[3], float Y[3], float Z[3]) {
    float p = rot[0] * URU_TO_RAD, y = rot[1] * URU_TO_RAD, r = rot[2] * URU_TO_RAD;
    float sp = sinf(p), cp = cosf(p), sy = sinf(y), cy = cosf(y), sr = sinf(r), cr = cosf(r);
    X[0] = cp * cy;                X[1] = cp * sy;                X[2] = sp;
    Y[0] = sr * sp * cy - cr * sy; Y[1] = sr * sp * sy + cr * cy; Y[2] = -sr * cp;
    Z[0] = -(cr * sp * cy + sr * sy); Z[1] = cy * sr - cr * sp * sy; Z[2] = cr * cp;
}

static int project(const float cam[3], const int rot[3], float fov_deg, float aspect,
                   int w, int h, const float pt[3], float out[2], float *depth) {
    float X[3], Y[3], Z[3], d[3], xv, yv, zv, tanH, tanV;
    int i;
    ue_axes(rot, X, Y, Z);
    for (i = 0; i < 3; i++) d[i] = pt[i] - cam[i];
    zv = d[0] * X[0] + d[1] * X[1] + d[2] * X[2];
    xv = d[0] * Y[0] + d[1] * Y[1] + d[2] * Y[2];
    yv = d[0] * Z[0] + d[1] * Z[1] + d[2] * Z[2];
    if (depth) *depth = zv;
    tanH = tanf(fov_deg * COOP_PI / 360.0f);
    if (!(tanH > 0.01f)) tanH = 0.7f;
    if (!(aspect > 0.1f)) aspect = (float)w / (float)h;
    tanV = tanH / aspect;
    if (zv < 1.0f) {
        out[0] = (float)w * 0.5f + (zv < 0.0f ? -xv : xv);
        out[1] = (float)h * 0.5f - yv;
        return 0;
    }
    out[0] = w * 0.5f * (1.0f + (xv / zv) / tanH);
    out[1] = h * 0.5f * (1.0f - (yv / zv) / tanV);
    return 1;
}

void hud_snapshot(float local_t) {
    long v = g_snap.ver;
    struct { float loc[3]; int rot[3]; float fov; } pov;
    AObj cam = g_localPC ? A->get_obj(g_localPC, "PlayerCamera") : 0;
    CoopState want;
    float wvel[3];
    unsigned camFlags = 0;
    float aspect = 0.0f, lastRender = 0.0f;

    g_snap.ver = v + 1;
    _ReadWriteBarrier();

    g_snap.valid = 0;
    g_snap.cinematic = 0;
    g_snap.vis = 1.0f;

    if (cam && A->read_raw(cam, O_CAM_POV, &pov, 28) && pov.fov > 10.0f && pov.fov < 170.0f) {
        g_snap.cam[0] = pov.loc[0]; g_snap.cam[1] = pov.loc[1]; g_snap.cam[2] = pov.loc[2];
        g_snap.rot[0] = pov.rot[0]; g_snap.rot[1] = pov.rot[1]; g_snap.rot[2] = pov.rot[2];
        g_snap.fov = pov.fov;
        if (A->read_raw(cam, O_CAM_ASPECT, &aspect, 4) && aspect > 0.5f && aspect < 4.0f)
            g_snap.aspect = aspect;
        else
            g_snap.aspect = 0.0f;
        if (A->read_raw(cam, O_CAM_FLAGS, &camFlags, 4) && (camFlags & F_bNonGamePlayCamera))
            g_snap.cinematic = 1;
    } else {
        _ReadWriteBarrier();
        g_snap.ver = v + 2;
        return;
    }

    if (!g_peerStateValid || !g_net.pinned) {
        _ReadWriteBarrier();
        g_snap.ver = v + 2;
        return;
    }

    if (!state_at(clock_render_time(local_t), &want, wvel)) {
        _ReadWriteBarrier();
        g_snap.ver = v + 2;
        return;
    }

    g_snap.head[0] = want.pos[0];
    g_snap.head[1] = want.pos[1];
    g_snap.head[2] = want.pos[2] + (float)want.coll_height + 16.0f;

    {
        float dx = g_snap.head[0] - g_snap.cam[0];
        float dy = g_snap.head[1] - g_snap.cam[1];
        float dz = g_snap.head[2] - g_snap.cam[2];
        g_snap.dist = sqrtf(dx * dx + dy * dy + dz * dz);
    }

    if (g_ghost.obj) {
        AObj m = A->get_obj(g_ghost.obj, "Mesh");
        if (!m) m = A->get_obj(g_ghost.obj, "SkeletalMeshComponent");
        if (m && g_worldInfo && A->read_raw(m, O_PRIM_LASTRENDER, &lastRender, 4))
            if (g_worldTime - lastRender > 0.10f) g_snap.vis = 0.35f;
    }

    g_snap.stale = g_extrapolating;
    wsprintfA(g_snap.label, "%s  %dm", g_net.peer_name[0] ? g_net.peer_name : "PAIR",
              (int)(g_snap.dist / 100.0f));
    g_snap.valid = 1;

    _ReadWriteBarrier();
    g_snap.ver = v + 2;
}

static void plate_draw(const PovSnap *p, int w, int h) {
    float sc[2], depth = 0.0f;
    int on, x, y, tw = 0, th = 0;
    unsigned base, alpha;

    on = project(p->cam, p->rot, p->fov, p->aspect, w, h, p->head, sc, &depth);

    if (A->hud_text_size) A->hud_text_size(p->label, &tw, &th);
    if (tw <= 0) tw = (int)strlen(p->label) * 11 + 16;
    if (th <= 0) th = 18;
    tw += 14;

    alpha = (unsigned)(p->vis * (p->stale ? 120.0f : 220.0f));
    if (alpha > 255) alpha = 255;
    base = p->stale ? 0x00A0A8B8u : 0x007CE38Bu;

    if (!on || sc[0] < 0.0f || sc[0] > (float)w || sc[1] < 0.0f || sc[1] > (float)h) {
        float cx = (float)w * 0.5f, cy = (float)h * 0.5f;
        float dx = sc[0] - cx, dy = sc[1] - cy, m;
        m = fabsf(dx) > fabsf(dy) ? fabsf(dx) : fabsf(dy);
        if (m < 1.0f) m = 1.0f;
        dx = dx / m * (cx - 48.0f);
        dy = dy / m * (cy - 48.0f);
        x = (int)(cx + dx);
        y = (int)(cy + dy);
        A->hud_rect(x - 5, y - 5, 10, 10, (alpha << 24) | 0x00E8836Bu);
        A->hud_text(x - tw / 2 + 7, y - 26, (alpha << 24) | 0x00E8836Bu, p->label);
        return;
    }
    if (p->dist > g_cfg.plate_max_m * 100.0f) return;

    x = (int)sc[0];
    y = (int)sc[1];
    A->hud_rect(x - tw / 2, y - th - 8, tw, th + 6, ((alpha * 3 / 4) << 24) | 0x00101014u);
    A->hud_text(x - tw / 2 + 7, y - th - 6, (alpha << 24) | base, p->label);
    A->hud_rect(x - 3, y - 3, 6, 6, (alpha << 24) | base);
}

void hud_draw(void) {
    PovSnap snap;
    long v0, v1;
    int w, h;
    char line[160];
    unsigned age = GetTickCount() - g_net.last_rx_ms;
    int live = g_net.pinned && g_peerStateValid && age < 1000;
    unsigned col = live ? 0xFF7CE38Bu : 0xFFE8836Bu;

    if (!A->screen_size(&w, &h) || w <= 0 || h <= 0) return;

    v0 = g_snap.ver;
    if (!(v0 & 1)) {
        memcpy(&snap, (const void *)&g_snap, sizeof snap);
        v1 = g_snap.ver;
        if (v1 == v0 && snap.valid && g_cfg.plate && !snap.cinematic) plate_draw(&snap, w, h);
    }

    A->hud_rect(12, 12, 380, g_cfg.diag ? 180 : 108, 0xB0101014u);
    wsprintfA(line, "COOP %s  %s  port %d", g_net.host ? "HOTE" : "CLIENT",
              !g_net.up ? "socket KO" : g_net.pinned ? (live ? "LIE" : "silence") : "recherche",
              g_net.bound_port);
    A->hud_text(20, 18, col, line);

    wsprintfA(line, "env %u  rec %u  rej %u  ren %u", g_net.sent, g_net.recvd, g_net.bad, g_net.resent);
    A->hud_text(20, 36, 0xFFBFC4D0u, line);

    if (g_peerStateValid)
        wsprintfA(line, "pair %d %d %d  il y a %u ms", (int)g_peerState.pos[0],
                  (int)g_peerState.pos[1], (int)g_peerState.pos[2], age);
    else
        lstrcpynA(line, "aucun etat de pair", sizeof line);
    A->hud_text(20, 54, 0xFFBFC4D0u, line);

    wsprintfA(line, "fantome: %s", g_ghost.obj ? g_ghost.how :
              g_ghost.armed ? "en attente" : "desarme (Ctrl+Maj+1..4)");
    A->hud_text(20, 72, g_ghost.obj ? 0xFF7CE38Bu : 0xFF8A90A0u, line);

    wsprintfA(line, "monde %s   appels %s   %s", g_cfg.mirror_world ? "ON" : "off",
              (A->call_ready && A->call_ready()) ? "OK" : "KO",
              (g_safe || g_cfg.safe_mode) ? "MODE SUR" : (g_gameTickSeen ? "tick jeu" : "tick rendu"));
    A->hud_text(20, 90, 0xFF8A90A0u, line);

    {
        char banner[160];
        unsigned bc = 0xFFE8836Bu;
        if (prog_banner(banner, (int)sizeof banner, &bc)) {
            int tw = 0, th = 0;
            if (A->hud_text_size) A->hud_text_size(banner, &tw, &th);
            if (tw <= 0) tw = (int)strlen(banner) * 11;
            if (th <= 0) th = 18;
            A->hud_rect(w / 2 - tw / 2 - 12, h - 116, tw + 24, th + 10, 0xC0101014u);
            A->hud_text(w / 2 - tw / 2, h - 111, bc, banner);
        }
    }

    if (!g_cfg.diag) return;

    wsprintfA(line, "ev e%u r%u rj%u dif%u nr%u", g_net.evsent, g_net.evrecv,
              g_net.replayed, g_net.deferred, g_net.unresolved);
    A->hud_text(20, 108, g_net.unresolved ? 0xFFE8C36Bu : 0xFFBFC4D0u, line);

    wsprintfA(line, "ep%u/%u per%u reo%u sau%u ech%u", (unsigned)g_epoch,
              (unsigned)g_net.peer_epoch, g_net.stale, g_net.reordered,
              g_net.lane_skip, g_net.echo_swallowed);
    A->hud_text(20, 126, g_net.lane_skip ? 0xFFE8836Bu : 0xFF8A90A0u, line);

    wsprintfA(line, "%s ch%d  pair ch%d  cine %d  %s", prog_map_name(), prog_chapter(),
              g_peerSess.have ? (int)g_peerSess.chapter : -1, cine_playing_count(),
              prog_loading() ? "CHARGEMENT" : "en jeu");
    A->hud_text(20, 144, prog_diverge_level() ? 0xFFE8836Bu : 0xFF8A90A0u, line);

    wsprintfA(line, "moi %s  pair %s  divergence %d%s", prog_local_down() ? "a terre" : "debout",
              prog_peer_down() ? "a terre" : "debout", prog_diverge_level(),
              ghost_hidden() ? "  fantome masque" : "");
    A->hud_text(20, 162, prog_diverge_level() > 1 ? 0xFFE8836Bu : 0xFF8A90A0u, line);
}
