#include "coop.h"

#define CINEN        160
#define CINE_POLL_MS 50
#define CINE_SCAN_MS 250

CoopCineStat g_cstat;

enum { CK_MATINEE = 0, CK_BINK = 1, CK_KINDS = 2 };
enum { CA_START = 0, CA_SYNC = 1, CA_STOP = 2 };

static const char *const CINE_CLASS[CK_KINDS] = { "SeqAct_Interp", "SeqAct_PlayBinkMovie" };

#pragma pack(push, 1)
typedef struct {
    unsigned char act;
    unsigned char flags;
    float         pos;
    float         rate;
    float         len;
} CineBody;
#pragma pack(pop)

#define CF_REVERSE 0x01u
#define CF_PAUSED  0x02u
#define CF_LOOPING 0x04u

typedef struct {
    AObj               obj;
    unsigned long long key;
    unsigned           sync_ms;
    float              pos;
    unsigned char      kind;
    unsigned char      playing;
} CineEnt;

static CineEnt  g_cine[CINEN];
static int      g_cineN;
static int      g_cineScan;
static int      g_cineFull;
static unsigned g_lastScanMs;
static unsigned g_lastPollMs;
static AObj     g_cineWorld;
static int      g_playing;
static int      g_cineMode;
static int      g_probed;
static int      g_setPosOk;
static int      g_scanKind;

int cine_local_active(void) { return g_cineMode; }
int cine_playing_count(void) { return g_playing; }

static int cine_sending(void) {
    return g_cfg.mirror_cine && coop_sending();
}

static void cine_log(const char *arrow, unsigned long long key, AObj o, const char *how) {
    if (!g_cfg.log_events) return;
    coop_log("coop: %s CINE   %08x%08x %s %s", arrow, (unsigned)(key >> 32), (unsigned)key,
             o ? A->name_of(o) : "?", how ? how : "");
}

static int cine_read(AObj o, int kind, float *pos, unsigned *flags) {
    unsigned f = 0;
    if (kind == CK_MATINEE) {
        if (!A->read_raw(o, O_INTERP_FLAGS, &f, 4)) return -1;
        if (pos) { *pos = 0.0f; A->read_raw(o, O_INTERP_POSITION, pos, 4); }
        if (flags) *flags = f;
        return (f & F_MAT_bIsPlaying) ? 1 : 0;
    }
    if (!A->read_raw(o, O_BINK_FLAGS, &f, 4)) return -1;
    if (pos) *pos = 0.0f;
    if (flags) *flags = f;
    return (f & F_BINK_bIsPlaying) ? 1 : 0;
}

static float cine_length(AObj o) {
    AObj data = 0;
    float len = 0.0f;
    if (!A->read_raw(o, O_INTERP_DATA, &data, 4) || !data) return 0.0f;
    if (!A->read_raw(data, O_INTERPDATA_LENGTH, &len, 4)) return 0.0f;
    return (len > 0.0f && len < 3600.0f) ? len : 0.0f;
}

static void cine_add_cb(AObj o) {
    const char *nm;
    int st;
    if (g_cineN >= CINEN) { g_cineFull = 1; return; }
    nm = A->name_of(o);
    if (!nm || strncmp(nm, "Default__", 9) == 0) return;
    st = cine_read(o, g_scanKind, 0, 0);
    if (st < 0) return;
    g_cine[g_cineN].obj = o;
    g_cine[g_cineN].key = coop_key(o);
    g_cine[g_cineN].kind = (unsigned char)g_scanKind;
    g_cine[g_cineN].playing = (unsigned char)st;
    g_cine[g_cineN].pos = 0.0f;
    g_cine[g_cineN].sync_ms = 0;
    g_cineN++;
}

static void cine_scan_step(void) {
    int before = g_cineN;
    g_scanKind = g_cineScan;
    A->iter_objects(CINE_CLASS[g_cineScan], cine_add_cb);
    if (g_cineN != before)
        coop_log("coop: cinematiques - %d %s suivies", g_cineN - before, CINE_CLASS[g_cineScan]);
    g_cineScan++;
    if (g_cineScan >= CK_KINDS && g_cineN)
        coop_log("coop: cinematiques - inventaire termine, %d objets%s", g_cineN,
                 g_cineFull ? " (TABLE PLEINE)" : "");
}

static void setpos_probe(AObj op) {
    if (g_probed) return;
    g_probed = 1;
    g_setPosOk = (A->find_func && A->find_func(op, "SetPosition")) ? 1 : 0;
    coop_log("coop: sonde cinematique - SeqAct_Interp.SetPosition %s, Stop %s, ForceActivateInput %s",
             g_setPosOk ? "TROUVEE" : "ABSENTE",
             (A->find_func && A->find_func(op, "Stop")) ? "trouvee" : "absente",
             (A->find_func && A->find_func(op, "ForceActivateInput")) ? "trouvee" : "absente");
}

static int cine_set_position(AObj op, float pos, int jump) {
    ACall c;
    if (!g_setPosOk) return 0;
    c = A->call_begin(op, "SetPosition");
    if (!c) return 0;
    A->call_arg_float(c, "NewPosition", pos);
    A->call_arg_bool(c, "bJump", jump);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static int cine_stop(AObj op) {
    ACall c = A->call_begin(op, "Stop");
    if (!c) return 0;
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static int cine_force_input(AObj op, int idx) {
    ACall c = A->call_begin(op, "ForceActivateInput");
    if (!c) return 0;
    A->call_arg_int(c, "InputIdx", idx);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static void cine_emit(CineEnt *e, int act, float pos, unsigned raw) {
    CineBody cb;
    unsigned long long k;

    if (!cine_sending()) return;
    cb.act = (unsigned char)act;
    cb.flags = 0;
    if (e->kind == CK_MATINEE) {
        if (raw & F_MAT_bReversePlayback) cb.flags |= CF_REVERSE;
        if (raw & F_MAT_bPaused)          cb.flags |= CF_PAUSED;
        if (raw & F_MAT_bLooping)         cb.flags |= CF_LOOPING;
        cb.rate = 1.0f;
        A->read_raw(e->obj, O_INTERP_PLAYRATE, &cb.rate, 4);
        cb.len = cine_length(e->obj);
    } else {
        if (raw & F_BINK_bPaused) cb.flags |= CF_PAUSED;
        cb.rate = 1.0f;
        cb.len = 0.0f;
    }
    cb.pos = pos;

    if (act == CA_SYNC) {
        k = e->key ? e->key : coop_key(e->obj);
        if (!k) return;
        if (!net_ev_add(CEV_CINE, k, LANE_LOOSE, EF_NOECHO, &cb, (int)sizeof cb)) return;
        g_cstat.sync_out++;
        return;
    }
    k = coop_emit_obj(e->kind == CK_BINK ? CEV_BINK : CEV_MATINEE, e->obj, LANE_PUZZLE, 0,
                      &cb, (int)sizeof cb);
    if (!k) return;
    e->key = k;
    if (act == CA_START) g_cstat.start_out++; else g_cstat.stop_out++;
    cine_log(">>", k, e->obj, act == CA_START ? "demarree ici" : "terminee ici");
}

static CineEnt *cine_find(AObj o) {
    int i;
    for (i = 0; i < g_cineN; i++) if (g_cine[i].obj == o) return &g_cine[i];
    return 0;
}

static void apply_cine(const CoopEvent *e, const void *raw, int n, int w, int kind, int defer) {
    const unsigned char *p = (const unsigned char *)raw + w;
    CineBody cb;
    CineEnt *ent;
    AObj op;
    float here = 0.0f, drift, tol;
    int st;

    if (!g_cfg.mirror_cine || prog_loading()) return;
    if (n - w < (int)sizeof cb) return;
    if (defer) {
        if (!coop_need_obj(e, raw, n, &op)) return;
    } else {
        op = coop_key_resolve(e->key);
        if (!op) return;
    }
    memcpy(&cb, p, sizeof cb);

    setpos_probe(op);
    ent = cine_find(op);
    st = cine_read(op, kind, &here, 0);
    if (st < 0) { g_cstat.refused++; return; }
    tol = (float)g_cfg.cine_drift_ms * 0.001f;

    if (cb.act == CA_STOP) {
        if (!st) return;
        if (!cine_stop(op)) { g_cstat.refused++; cine_log("!!", e->key, op, "Stop introuvable"); return; }
        if (ent) ent->sync_ms = GetTickCount();
        g_cstat.stop_in++;
        cine_log("<<", e->key, op, "arretee par le pair");
        return;
    }

    if (st) {
        drift = cb.pos - here;
        if (drift < 0.0f) drift = -drift;
        if (drift > tol && kind == CK_MATINEE) {
            if (cine_set_position(op, cb.pos, 0)) {
                g_cstat.aligned++;
                if (ent) ent->pos = cb.pos;
            }
        }
        if (cb.act == CA_START) {
            g_cstat.start_in++;
            cine_log("==", e->key, op, "deja en cours, simple recalage");
        }
        return;
    }

    if (cb.act == CA_SYNC && !g_cfg.cine_force) return;

    if (!cine_force_input(op, 0)) {
        g_cstat.refused++;
        cine_log("!!", e->key, op, "ForceActivateInput introuvable");
        return;
    }
    if (kind == CK_MATINEE && cb.pos > tol) cine_set_position(op, cb.pos, 1);
    if (ent) { ent->pos = cb.pos; ent->sync_ms = GetTickCount(); }
    g_cstat.start_in++;
    cine_log("<<", e->key, op, cb.act == CA_START ? "demarree par le pair" :
                               "demarree en rattrapage (cine_force)");
}

static void cine_event(const CoopEvent *e, const void *payload, int n) {
    int w = coop_witness_read(e, payload, n, 0);
    switch (e->type) {
    case CEV_MATINEE: apply_cine(e, payload, n, w, CK_MATINEE, 1); return;
    case CEV_BINK:    apply_cine(e, payload, n, w, CK_BINK, 1);    return;
    case CEV_CINE:    apply_cine(e, payload, n, w, CK_MATINEE, 0); return;
    default: return;
    }
}

static int pc_cinematic(void) {
    unsigned f = 0;
    if (!g_localPC) return 0;
    if (!A->read_raw(g_localPC, O_PC_CINEFLAGS, &f, 4)) return 0;
    return (f & F_PC_bCinematicMode) ? 1 : 0;
}

void cine_frame(unsigned now) {
    int i, playing = 0, mode;

    if (g_worldInfo && g_worldInfo != g_cineWorld) {
        g_cineWorld = g_worldInfo;
        cine_reset();
        return;
    }
    if (g_cineScan < CK_KINDS) {
        if (now - g_lastScanMs < CINE_SCAN_MS) return;
        g_lastScanMs = now;
        cine_scan_step();
        return;
    }
    if (prog_loading()) return;
    if (now - g_lastPollMs < CINE_POLL_MS) return;
    g_lastPollMs = now;

    for (i = 0; i < g_cineN; i++) {
        CineEnt *e = &g_cine[i];
        unsigned raw = 0;
        float pos = 0.0f;
        int st;
        if (!e->obj) continue;
        if (!guard_obj_ok(e->obj)) { e->obj = 0; continue; }
        st = cine_read(e->obj, e->kind, &pos, &raw);
        if (st < 0) { e->obj = 0; continue; }
        if (st) playing++;
        if (st != (int)e->playing) {
            e->playing = (unsigned char)st;
            e->pos = pos;
            e->sync_ms = now;
            cine_emit(e, st ? CA_START : CA_STOP, pos, raw);
            continue;
        }
        if (!st || e->kind != CK_MATINEE) continue;
        if (!g_net.host || !g_cfg.cine_sync_ms) continue;
        if (now - e->sync_ms < (unsigned)g_cfg.cine_sync_ms) continue;
        e->sync_ms = now;
        e->pos = pos;
        cine_emit(e, CA_SYNC, pos, raw);
    }

    g_playing = playing;
    mode = (playing > 0) || pc_cinematic();
    if (mode != g_cineMode) {
        g_cineMode = mode;
        if (g_cfg.log_events)
            coop_log("coop: cinematique locale %s (%d en cours)", mode ? "DEBUT" : "fin", playing);
    }
    ghost_hide(GH_CINE, g_cineMode && !g_cfg.cine_ghost);
}

void cine_reset(void) {
    g_cineN = 0;
    g_cineScan = 0;
    g_cineFull = 0;
    g_lastScanMs = 0;
    g_lastPollMs = 0;
    g_playing = 0;
    g_cineMode = 0;
    ghost_hide(GH_CINE, 0);
}

void cine_hooks_install(void) {
    net_ev_subscribe(CEV_MATINEE, cine_event);
    net_ev_subscribe(CEV_BINK, cine_event);
    net_ev_subscribe(CEV_CINE, cine_event);
}

void cine_panel(void) {
    char line[160];

    A->ui_checkbox("Miroir des cinematiques  (Ctrl+Maj+C)", &g_cfg.mirror_cine);
    A->ui_checkbox("Garder le fantome pendant une cinematique", &g_cfg.cine_ghost);
    A->ui_checkbox("Demarrer une cinematique que seul le pair joue", &g_cfg.cine_force);
    A->ui_slider_int("Recalage de position (ms)", &g_cfg.cine_sync_ms, 0, 5000);
    A->ui_slider_int("Derive toleree (ms)", &g_cfg.cine_drift_ms, 50, 2000);

    wsprintfA(line, "suivies %d%s   en cours %d   mode %s", g_cineN,
              g_cineFull ? " TABLE PLEINE" : "", g_playing, g_cineMode ? "CINEMATIQUE" : "jeu");
    A->ui_label(line);
    wsprintfA(line, "debuts e%u r%u   fins e%u r%u", g_cstat.start_out, g_cstat.start_in,
              g_cstat.stop_out, g_cstat.stop_in);
    A->ui_label(line);
    wsprintfA(line, "recalages envoyes %u   appliques %u   refus %u",
              g_cstat.sync_out, g_cstat.aligned, g_cstat.refused);
    A->ui_label(line);
    wsprintfA(line, "SetPosition %s", !g_probed ? "non sondee" : g_setPosOk ? "disponible" : "ABSENTE");
    A->ui_label(line);
}
