#include "coop.h"

HysteriaAPI *A;

AObj  g_localPawn;
AObj  g_localPC;
AObj  g_worldInfo;
float g_worldTime;
int   g_gameTickSeen;

static int g_renderFrames;
static int g_renderFallback;
static int g_offsetTries;
static unsigned g_lastOffsetMs;
static int g_reqArm[5];
static int g_reqRelease;
static int g_reqNet;
static int g_reqRole;
static int g_reqPanic;
static int g_reqMirror;
static int g_reqZUp, g_reqZDown;
static int g_reqNextBody;
static int g_reqRespawn;
static int g_reqVerify;
static int g_reqAudit;
static int g_reqCine;
static int g_reqTravel;
static int g_reqCkpt;
static int g_reqGoto;
static int g_reqReload;
static int g_reqSummary;
static float g_lastLocalT;
static unsigned g_lastNameMs;
static int g_uiGhostMode;

static void refresh_locals(void) {
    g_localPC = A->player_controller();
    g_localPawn = A->player_pawn();
    g_worldInfo = A->world_info();
    if (g_worldInfo) {
        float t = 0.0f;
        if (A->read_raw(g_worldInfo, O_WI_TIMESECONDS, &t, 4) && t > 0.0f) g_worldTime = t;
    }
}

static void consume_requests(void) {
    int i;
    for (i = 0; i < 5; i++) {
        if (!g_reqArm[i]) continue;
        g_reqArm[i] = 0;
        ghost_arm(i);
    }
    if (g_reqRelease) { g_reqRelease = 0; ghost_release(0); g_ghost.armed = 0; }
    if (g_reqRespawn) {
        g_reqRespawn = 0;
        ghost_release(1);
        ghost_forget_recipe();
        g_ghost.fails = 0;
        g_ghost.last_try_ms = 0;
        coop_log("coop: cascade de spawn relancee depuis le premier essai");
    }
    if (g_reqNextBody) {
        g_reqNextBody = 0;
        ghost_bump_adopt_index();
        ghost_release(1);
        g_ghost.last_try_ms = 0;
    }
    if (g_reqMirror) {
        g_reqMirror = 0;
        g_cfg.mirror_world = !g_cfg.mirror_world;
        cfg_flush();
        coop_log("coop: monde en miroir %s", g_cfg.mirror_world ? "ACTIF" : "arrete");
    }
    if (g_reqZUp)   { g_reqZUp = 0;   g_cfg.z_adjust += 8.0f; cfg_flush(); }
    if (g_reqZDown) { g_reqZDown = 0; g_cfg.z_adjust -= 8.0f; cfg_flush(); }
    if (g_reqVerify) {
        g_reqVerify = 0;
        g_offsetsOk = guard_offsets_verify(g_localPawn);
        coop_log("coop: verification des offsets -> %s", g_offsetsOk ? "OK" : "ECHEC");
    }
    if (g_reqAudit) {
        g_reqAudit = 0;
        coop_log("coop: keyaudit demarre, la frame va tressauter");
        coop_key_audit();
    }
    if (g_reqCine) {
        g_reqCine = 0;
        g_cfg.mirror_cine = !g_cfg.mirror_cine;
        cfg_flush();
        coop_log("coop: miroir des cinematiques %s", g_cfg.mirror_cine ? "ACTIF" : "arrete");
    }
    if (g_reqTravel) {
        g_reqTravel = 0;
        g_cfg.travel_sync = !g_cfg.travel_sync;
        cfg_flush();
        coop_log("coop: annonce des transitions %s", g_cfg.travel_sync ? "ACTIVE" : "arretee");
    }
    if (g_reqCkpt) {
        g_reqCkpt = 0;
        g_cfg.ckpt_follow = !g_cfg.ckpt_follow;
        cfg_flush();
        coop_log("coop: suivi des checkpoints %s", g_cfg.ckpt_follow ? "ACTIF" : "arrete");
    }
    if (g_reqGoto) { g_reqGoto = 0; prog_request_goto(); }
    if (g_reqReload) { g_reqReload = 0; prog_request_reload(); }
    if (g_reqSummary) { g_reqSummary = 0; prog_summary(); }
    if (g_reqPanic) { g_reqPanic = 0; guard_panic(); }
    if (g_reqRole) {
        g_reqRole = 0;
        g_cfg.role = (g_cfg.role + 1) % 3;
        cfg_flush();
        coop_log("coop: role %s", g_cfg.role == 0 ? "auto" : g_cfg.role == 1 ? "hote" : "client");
        net_open();
    }
    if (g_reqNet) { g_reqNet = 0; net_open(); }
}

static void game_frame(float dt) {
    unsigned now = GetTickCount();
    float local_t;

    refresh_locals();

    local_t = g_worldTime > 0.0f ? g_worldTime : (float)now * 0.001f;
    if (local_t < g_lastLocalT) state_reset();
    g_lastLocalT = local_t;

    {
        static unsigned dbgMs;
        if (now - dbgMs > 2000) {
            dbgMs = now;
            {
                CoopState pw;
                float wv[3] = {0, 0, 0}, me[3] = {0, 0, 0}, gp[3] = {0, 0, 0};
                int havePeer = state_at(local_t, &pw, wv);
                if (g_localPawn) A->read_raw(g_localPawn, O_LOCATION, me, 12);
                if (g_ghost.obj) A->read_raw(g_ghost.obj, O_LOCATION, gp, 12);
                coop_log("coop: etat %s offsetsOk=%d safe=%d writes=%d fantome=%s",
                         g_net.host ? "HOTE" : "CLIENT", g_offsetsOk, g_safe,
                         guard_writes_allowed(), g_ghost.obj ? "present" : "aucun");
                coop_log("coop: reseau env=%u rec=%u rej=%u renv=%u perdus=%u pin=%d",
                         g_net.sent, g_net.recvd, g_net.bad, g_net.resent,
                         g_net.dropped, g_net.pinned);
                coop_log("coop: evts emis=%u recus=%u rejoues=%u differes=%u resolus=%u non_resolus=%u",
                         g_net.evsent, g_net.evrecv, g_net.replayed, g_net.deferred,
                         g_net.resolved, g_net.unresolved);
                coop_log("coop: epoque=%u/%u perimes=%u reordonnes=%u sauts=%u echos=%u repares=%u classe_ko=%u",
                         (unsigned)g_epoch, (unsigned)g_net.peer_epoch, g_net.stale,
                         g_net.reordered, g_net.lane_skip, g_net.echo_swallowed,
                         g_net.repaired, g_net.mismatch);
                coop_log("coop: moi %.0f %.0f %.0f | pair %s %.0f %.0f %.0f | fantome %.0f %.0f %.0f",
                         me[0], me[1], me[2], havePeer ? "recu" : "AUCUN",
                         havePeer ? pw.pos[0] : 0.0f, havePeer ? pw.pos[1] : 0.0f,
                         havePeer ? pw.pos[2] : 0.0f, gp[0], gp[1], gp[2]);
            }
        }
    }
    if (!g_offsetsOk && g_localPawn && now - g_lastOffsetMs > 500) {
        g_lastOffsetMs = now;
        g_offsetTries++;
        g_offsetsOk = guard_offsets_verify(g_localPawn);
        if (g_offsetsOk)
            coop_log("coop: offsets verifies sur le pawn local");
        else if (g_offsetTries == 40) {
            coop_log("coop: offsets non verifies, les ecritures par nom de propriete restent actives");
        }
    }

    consume_requests();

    net_pump(now, local_t);
    echo_pump(now);
    coop_key_defer_pump(now);

    if (g_net.pinned && now - g_lastNameMs > 5000) {
        g_lastNameMs = now;
        world_send_name();
    }

    guard_frame_begin();
    net_ev_begin();
    prog_frame(now);
    if (g_cfg.mirror_cine) cine_frame(now);
    else                   ghost_hide(GH_CINE, 0);
    if (guard_writes_allowed()) {
        CoopState s;
        if (g_localPawn && state_sample(g_localPawn, &s)) net_send_state(&s, local_t);
        ghost_frame(dt, clock_render_time(local_t));
        if (g_cfg.mirror_world) world_frame(now);
    } else if (g_localPawn) {
        CoopState s;
        if (state_sample(g_localPawn, &s)) net_send_state(&s, local_t);
    }
    hud_snapshot(local_t);
    net_ev_flush();
    guard_frame_end();
}

static void on_player_tick(AEvent *e) {
    static int inTick;
    float dt = 0.016f;
    if (e->self != A->player_controller()) return;
    if (inTick) return;
    inTick = 1;
    if (!g_gameTickSeen) {
        g_gameTickSeen = 1;
        if (g_renderFallback) {
            g_renderFallback = 0;
            coop_log("coop: PlayerTick actif, retour sur le thread de jeu");
        }
        coop_log("coop: PlayerTick intercepte, boucle sur le thread de jeu");
    }
    A->param_get_float(e, "DeltaTime", &dt);
    if (!(dt > 0.0f) || dt > 0.25f) dt = 0.016f;
    game_frame(dt);
    inTick = 0;
}

static void keys_poll(void) {
    if (!(A->key_down(VK_CONTROL) && A->key_down(VK_SHIFT))) return;
    if (A->key_pressed('1')) g_reqArm[0] = 1;
    if (A->key_pressed('2')) g_reqArm[1] = 1;
    if (A->key_pressed('3')) g_reqArm[2] = 1;
    if (A->key_pressed('4')) g_reqArm[3] = 1;
    if (A->key_pressed('0')) g_reqRelease = 1;
    if (A->key_pressed('V')) g_reqNextBody = 1;
    if (A->key_pressed('S')) g_reqRespawn = 1;
    if (A->key_pressed('M')) g_reqMirror = 1;
    if (A->key_pressed('H')) g_reqRole = 1;
    if (A->key_pressed('R')) g_reqNet = 1;
    if (A->key_pressed('U')) g_reqZUp = 1;
    if (A->key_pressed('J')) g_reqZDown = 1;
    if (A->key_pressed('O')) g_reqVerify = 1;
    if (A->key_pressed('K')) g_reqAudit = 1;
    if (A->key_pressed('C')) g_reqCine = 1;
    if (A->key_pressed('T')) g_reqTravel = 1;
    if (A->key_pressed('N')) g_reqCkpt = 1;
    if (A->key_pressed('G')) g_reqGoto = 1;
    if (A->key_pressed('P')) g_reqReload = 1;
    if (A->key_pressed('B')) g_reqSummary = 1;
    if (A->key_pressed(VK_DELETE)) g_reqPanic = 1;
}

static void on_frame(void) {
    keys_poll();
    hud_draw();
    if (!g_gameTickSeen) {
        if (++g_renderFrames == 300) {
            g_renderFallback = 1;
            coop_log("coop: PlayerTick jamais declenche, boucle depuis le thread de rendu");
        }
        if (g_renderFrames >= 300) game_frame(0.016f);
    }
}

static const char *const GHOST_MODES[5] = {
    "0 AlicePawn marche", "1 AlicePawn vol", "2 AlicePawn teleport",
    "3 corps adopte", "4 plaque seule"
};

static void panel(void) {
    char line[160];

    wsprintfA(line, "Socket %s  port %d  role %s", g_net.up ? "ouverte" : "fermee",
              g_net.bound_port, g_net.host ? "HOTE" : "CLIENT");
    A->ui_label(line);
    wsprintfA(line, "Pair %s%s", g_net.pinned ? "lie: " : "non lie",
              g_net.pinned ? g_net.peer_name : "");
    A->ui_label(line);
    wsprintfA(line, "Appels jeu %s   offsets %s",
              (A->call_ready && A->call_ready()) ? "OK" : "indisponibles",
              g_offsetsOk ? "OK" : "non verifies");
    A->ui_label(line);

    A->ui_separator();
    if (A->ui_button("Reouvrir la socket  (Ctrl+Maj+R)")) g_reqNet = 1;
    if (A->ui_button("Changer de role  (Ctrl+Maj+H)")) g_reqRole = 1;
    if (A->ui_button("Verifier les offsets  (Ctrl+Maj+O)")) g_reqVerify = 1;
    if (A->ui_button("Audit des cles d'objet  (Ctrl+Maj+K)")) g_reqAudit = 1;

    A->ui_separator();
    if (A->ui_tree("Diagnostic du canal d'evenements")) {
        wsprintfA(line, "emis %u   recus %u   rejoues %u", g_net.evsent, g_net.evrecv, g_net.replayed);
        A->ui_label(line);
        wsprintfA(line, "differes %u   resolus %u   non resolus %u",
                  g_net.deferred, g_net.resolved, g_net.unresolved);
        A->ui_label(line);
        wsprintfA(line, "perimes %u   reordonnes %u   sauts de voie %u",
                  g_net.stale, g_net.reordered, g_net.lane_skip);
        A->ui_label(line);
        wsprintfA(line, "echos avales %u   reparations %u   epoque %u/%u",
                  g_net.echo_swallowed, g_net.repaired,
                  (unsigned)g_epoch, (unsigned)g_net.peer_epoch);
        A->ui_label(line);
        wsprintfA(line, "renvoyes %u   perdus %u   rejetes %u",
                  g_net.resent, g_net.dropped, g_net.bad);
        A->ui_label(line);
    }

    A->ui_separator();
    A->ui_label("Fantome du pair");
    A->ui_combo("Mode voulu", &g_uiGhostMode, GHOST_MODES, 5);
    if (A->ui_button("Armer ce mode")) {
        if (g_uiGhostMode >= 0 && g_uiGhostMode < 5) g_reqArm[g_uiGhostMode] = 1;
    }
    if (A->ui_button("Relacher  (Ctrl+Maj+0)")) g_reqRelease = 1;
    if (A->ui_button("Corps adopte suivant  (Ctrl+Maj+V)")) g_reqNextBody = 1;
    if (A->ui_button("Relancer la cascade de spawn  (Ctrl+Maj+S)")) g_reqRespawn = 1;
    A->ui_label(g_ghost.obj ? g_ghost.how : "aucun corps");
    A->ui_slider_float("Hauteur du corps", &g_cfg.z_adjust, -200.0f, 200.0f, 4.0f);

    A->ui_separator();
    A->ui_checkbox("Monde en miroir  (Ctrl+Maj+M)", &g_cfg.mirror_world);
    if (A->ui_tree("Contenu du monde en miroir")) world_panel();
    if (A->ui_tree("Cinematiques")) cine_panel();
    if (A->ui_tree("Progression, transitions et garde-fous")) prog_panel();
    A->ui_checkbox("Plaque de nom", &g_cfg.plate);
    A->ui_checkbox("Diagnostic sur le HUD", &g_cfg.diag);
    A->ui_checkbox("Reparation de cle par temoin", &g_cfg.key_repair);
    A->ui_checkbox("Decouverte reseau local", &g_cfg.discover_lan);
    A->ui_slider_int("Retard de rendu (ms)", &g_cfg.delay_ms, 0, 300);
    A->ui_slider_int("Cadence (Hz)", &g_cfg.rate_hz, 10, 60);
    if (A->ui_button("Enregistrer les reglages")) cfg_flush();

    A->ui_separator();
    if (A->ui_button("PANIQUE : tout desarmer  (Ctrl+Maj+Suppr)")) g_reqPanic = 1;
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
    WSADATA wsa;
    A = api;

    if (A->version < 16) {
        A->log("coop: API trop ancienne (v16 requise), mod inactif");
        return;
    }
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        A->log("coop: WSAStartup echec");
        return;
    }

    cfg_load_all();
    g_uiGhostMode = g_cfg.ghost_mode;
    g_ghost.mode = g_cfg.ghost_mode;
    g_ghost.armed = 0;
    g_safe = g_cfg.safe_mode;

    net_open();
    world_hooks_install();
    cine_hooks_install();
    prog_hooks_install();
    ghost_hooks_install();
    A->on("PlayerTick", on_player_tick);
    A->ui_panel("Coop", panel);
    A->on_tick(on_frame);

    coop_log("coop v4 charge (API v%d, spawn_probe %s) - rien n'est arme, Ctrl+Maj+1..4 pour le fantome",
             A->version, (A->version >= 18 && A->spawn_probe) ? "disponible" : "ABSENT");
    coop_log("coop: protocole v%d, en-tete %d o, evenement %d o, charge utile max %d o",
             COOP_VERSION, (int)sizeof(CoopHdr), (int)sizeof(CoopEvent), COOP_EV_PAYLOAD_MAX);
    coop_log("coop: contenu du miroir - kismet=%d rejeu=%d forcage=%d sonde=%d decor=%d "
             "plateformes=%d butin=%d voix=%d messages=%d journal=%d",
             g_cfg.mirror_kismet, g_cfg.mirror_trigger, g_cfg.kismet_force, g_cfg.kismet_probe,
             g_cfg.mirror_decor, g_cfg.mirror_mover, g_cfg.mirror_loot, g_cfg.mirror_vo,
             g_cfg.mirror_msg, g_cfg.log_events);
    coop_log("coop: progression - cinematiques=%d fantome_en_cine=%d forcage_cine=%d "
             "transitions=%d suivre_carte=%d suivre_checkpoint=%d morts=%d",
             g_cfg.mirror_cine, g_cfg.cine_ghost, g_cfg.cine_force, g_cfg.travel_sync,
             g_cfg.travel_follow, g_cfg.ckpt_follow, g_cfg.death_notify);
    coop_log("coop: garde-fous - silence %d ms, largage du fantome %d ms, tolerance %d, "
             "battement %d ms", g_cfg.peer_timeout_ms, g_cfg.ghost_drop_ms,
             g_cfg.desync_tol, g_cfg.prog_beat_ms);
}
