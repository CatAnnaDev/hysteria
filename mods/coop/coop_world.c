#include "coop.h"

#define KEYN        192
#define MOVERN      32
#define HOLDN       8
#define PROBEN      96
#define VODEDUPN    16
#define MSGDEDUPN   8
#define GENEV_MAX   32
#define OUTLINK_MAX 24
#define INLINK_MAX  16
#define WATCHN      512
#define WATCH_SLICE 64
#define WATCH_MS    100
#define NPC_WITNESS_UU 3000.0f

CoopWorldStat g_wstat;

enum { TRG_ACTIVATE = 0, TRG_TOUCH = 1, TRG_UNTOUCH = 2 };
enum { LOOT_MEMORY = 1, LOOT_SECRET = 2, LOOT_HEALTH = 3, LOOT_WEAPON = 4 };

enum {
    W_PAD = 0, W_BAL, W_CTX,
    W_BREAK, W_MEM, W_HEALTH, W_WEAPON,
    W_KINDS
};
#define W_FAST_KINDS 3

static const char *const WATCH_CLASS[W_KINDS] = {
    "PressurePad", "BalancePlatform", "ContextActor",
    "GameBreakableActor", "MemoryFragmentNormal", "HealthUpgradePickup",
    "AliceWeaponPickupFactory"
};

#pragma pack(push, 1)
typedef struct { unsigned char mode, idx; unsigned long long orig; } TrigBody;
typedef struct { unsigned char input; } KismetBody;
typedef struct { unsigned char times; } CtxBody;
typedef struct { unsigned char active; } PadBody;
typedef struct { unsigned char on, shrink; } BalBody;
typedef struct { int step; unsigned char last; } BreakBody;
typedef struct { unsigned char kind; } LootBody;
typedef struct { unsigned long long speaker; unsigned char pri, bits; } VoBody;
typedef struct { float dur; unsigned char type; char text[192]; } MsgBody;
#pragma pack(pop)

typedef struct {
    unsigned long long key;
    AObj               obj;
    unsigned char      lastState;
} KeyEntry;

static KeyEntry g_keys[KEYN];
static int      g_keyN;

typedef struct { AObj obj; float pos[3]; int rot[3]; } Mover;

static Mover    g_movers[MOVERN];
static int      g_moverN;
static unsigned g_lastMoverMs;
static unsigned g_lastDigestMs;
static int      g_moverScanDone;
static int      g_hardDiverge;

typedef struct { AObj obj; unsigned char kind, state; } Watch;

static Watch    g_watch[WATCHN];
static int      g_watchN;
static int      g_watchFast;
static int      g_watchScan;
static int      g_watchCursor;
static int      g_watchFull;
static unsigned g_lastWatchMs;
static AObj     g_lastWorld;

static AObj g_padHold[HOLDN];
static int  g_padHoldN;
static AObj g_balHold[HOLDN];
static int  g_balHoldN;

static unsigned long long g_probe[PROBEN];
static int                g_probeN;

typedef struct { unsigned long long key; unsigned ms; } Heard;
static Heard g_voHeard[VODEDUPN];
static int   g_voHeardW;
static Heard g_msgSeen[MSGDEDUPN];
static int   g_msgSeenW;

static AObj g_clsCtxActivated;
static AObj g_clsPadOn;
static AObj g_clsPadOff;
static int  g_ghostWarned;

static const char *const NOREPLAY_EVENTS[] = {
    "SeqEvent_Touch", "SeqEvent_TakeDamage", "SeqEvent_Death", "SeqEvent_Destroyed",
    "SeqEvent_LevelLoaded", "SeqEvent_RemoteEvent", "SeqEvent_SequenceActivated",
    "SeqEvent_Console", "SeqEvent_LevelBeginning", "SeqEvent_LevelStartup",
    "SeqEvent_ContextActionActivated", "SeqEvent_PadActivated", "SeqEvent_PadDeactivated",
    "SeqEvent_PickupStatusChange"
};
#define NOREPLAY_N ((int)(sizeof NOREPLAY_EVENTS / sizeof NOREPLAY_EVENTS[0]))

static int key_slot(unsigned long long key) {
    int i;
    for (i = 0; i < g_keyN; i++) if (g_keys[i].key == key) return i;
    if (g_keyN >= KEYN) return -1;
    g_keys[g_keyN].key = key;
    g_keys[g_keyN].obj = 0;
    g_keys[g_keyN].lastState = 0;
    return g_keyN++;
}

static void key_track(AObj o, unsigned long long key) {
    int i;
    if (!o || !key) return;
    i = key_slot(key);
    if (i >= 0) g_keys[i].obj = o;
}

static unsigned char world_state_byte(AObj o) {
    unsigned f = 0;
    unsigned char b = 0;
    int step = 0;
    if (!o) return 0;
    if (A->read_raw(o, O_ACTOR_FLAGS0, &f, 4) && (f & F_bHidden)) b |= 0x01;
    if (A->read_raw(o, O_BREAK_FLAGS, &f, 4) && (f & F_bDestoryed)) b |= 0x02;
    if (A->read_raw(o, O_PICKUP_FLAGS, &f, 4) && (f & F_bPickupHidden)) b |= 0x04;
    if (A->read_raw(o, O_BREAK_CURSTEP, &step, 4) && step > 0) b |= (unsigned char)((step & 0x1f) << 3);
    return b;
}

static int world_sending(void) {
    return g_cfg.mirror_world && coop_sending();
}

static void set_flag(AObj o, int off, unsigned mask, int on) {
    unsigned f;
    if (!A->read_raw(o, off, &f, 4)) return;
    if (on) f |= mask; else f &= ~mask;
    A->write_raw(o, off, &f, 4);
}

static const char *short_name(AObj o) {
    const char *n = o ? A->name_of(o) : 0;
    return n && n[0] ? n : "?";
}

static const char *short_class(AObj o) {
    const char *n = o ? A->class_of(o) : 0;
    return n && n[0] ? n : "?";
}

static void ev_log(const char *arrow, const char *fam, unsigned long long key,
                   AObj o, const char *how) {
    if (!g_cfg.log_events) return;
    coop_log("coop: %s %-6s %08x%08x %s.%s %s", arrow, fam,
             (unsigned)(key >> 32), (unsigned)key, short_class(o), short_name(o),
             how ? how : "");
}

static void ev_refuse(const char *fam, unsigned long long key, const char *why) {
    g_wstat.refused++;
    if (!g_cfg.log_events) return;
    coop_log("coop: !! %-6s %08x%08x refuse: %s", fam,
             (unsigned)(key >> 32), (unsigned)key, why);
}

static void emit(int type, int lane, unsigned flags, const void *payload, int n) {
    if (!world_sending()) return;
    net_ev_add(type, 0, lane, flags, payload, n);
}

static unsigned long long emit_obj(int type, AObj o, int lane, unsigned flags,
                                   const void *payload, int n) {
    if (!world_sending()) return 0;
    return coop_emit_obj(type, o, lane, flags, payload, n);
}

void world_send_name(void) {
    int n = (int)strlen(g_cfg.nickname);
    if (!g_net.pinned) return;
    if (n > 23) n = 23;
    net_ev_add(CEV_NAME, 0, LANE_LOOSE, 0, g_cfg.nickname, n);
}

static int trigger_event_class(AObj on, AObj *cls, const char *clsName, AObj instigator) {
    ACall c;
    if (!on) return 0;
    if (!*cls) *cls = A->find_class(clsName);
    if (!*cls) return 0;
    c = A->call_begin(on, "TriggerEventClass");
    if (!c) return 0;
    A->call_arg_obj(c, "InEventClass", *cls);
    A->call_arg_obj(c, "InInstigator", instigator);
    A->call_arg_int(c, "ActivateIndex", -1);
    A->call_arg_bool(c, "bTest", 0);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static AObj replay_instigator(int needs_ghost) {
    if (g_ghost.obj && ghost_valid()) return g_ghost.obj;
    if (needs_ghost) {
        if (!g_ghostWarned) {
            g_ghostWarned = 1;
            coop_log("coop: miroir Kismet sans fantome, les declencheurs de contact restent "
                     "ignores (armez un corps avec Ctrl+Maj+1..4)");
        }
        return 0;
    }
    return g_localPawn;
}

static int seq_replay(AObj ev, AObj orig, AObj inst, int mode) {
    const char *fn = mode == TRG_TOUCH ? "CheckTouchActivate" :
                     mode == TRG_UNTOUCH ? "CheckUnTouchActivate" : "CheckActivate";
    unsigned flags = 0, patched;
    int had = 0, ok = 0;
    ACall c;

    if (!ev || !inst) return -1;
    if (A->read_raw(ev, O_SEQEVT_FLAGS, &flags, 4)) {
        had = 1;
        patched = (flags | F_SE_bEnabled) & ~F_SE_bPlayerOnly;
        if (patched != flags) A->write_raw(ev, O_SEQEVT_FLAGS, &patched, 4);
    }
    c = A->call_begin(ev, fn);
    if (c) {
        A->call_arg_obj(c, "InOriginator", orig);
        A->call_arg_obj(c, "InInstigator", inst);
        A->call_arg_bool(c, "bTest", 0);
        A->call_invoke(c);
        A->call_out_bool(c, "ReturnValue", &ok);
        A->call_end(c);
    }
    if (had) A->write_raw(ev, O_SEQEVT_FLAGS, &flags, 4);
    return c ? ok : -1;
}

static int seq_force_input(AObj op, int idx) {
    ACall c;
    if (!op || idx < 0 || idx >= INLINK_MAX) return 0;
    c = A->call_begin(op, "ForceActivateInput");
    if (!c) return 0;
    A->call_arg_int(c, "InputIdx", idx);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static void probe_note(AObj op) {
    unsigned long long h = fnv1a64(short_class(op));
    int i;
    for (i = 0; i < g_probeN; i++) if (g_probe[i] == h) return;
    if (g_probeN >= PROBEN) return;
    g_probe[g_probeN++] = h;
    coop_log("coop: sonde Kismet - Activated recu sur %s (%s)", short_class(op), short_name(op));
}

static int is_noreplay(const char *cls) {
    int i;
    for (i = 0; i < NOREPLAY_N; i++) if (strcmp(cls, NOREPLAY_EVENTS[i]) == 0) return 1;
    return 0;
}

static int seq_local_cause(AObj op, AObj *origOut) {
    AObj orig = 0, inst = 0;
    A->read_raw(op, O_SEQEVT_ORIGINATOR, &orig, 4);
    A->read_raw(op, O_SEQEVT_INSTIGATOR, &inst, 4);
    if (origOut) *origOut = orig;
    if (!g_localPawn) return 0;
    if (g_ghost.obj && (inst == g_ghost.obj || orig == g_ghost.obj)) return 0;
    if (inst == g_localPawn || inst == g_localPC) return 1;
    if (!inst && orig == g_localPawn) return 1;
    return 0;
}

static void emit_downstream(AObj ev) {
    unsigned char row[SEQ_OUTLINK_STRIDE];
    int n, i, sent = 0;

    n = A->array_num(ev, "OutputLinks");
    if (n <= 0 || n > OUTLINK_MAX) return;
    if (A->array_stride(ev, "OutputLinks") != SEQ_OUTLINK_STRIDE) return;

    for (i = 0; i < n; i++) {
        AObj links = 0;
        int cnt = 0, j;
        if (!A->array_get(ev, "OutputLinks", i, row, SEQ_OUTLINK_STRIDE)) continue;
        if (!(row[OL_BHASIMPULSE] & 1)) continue;
        memcpy(&links, row, 4);
        memcpy(&cnt, row + 4, 4);
        if (!links || cnt <= 0 || cnt > OUTLINK_MAX) continue;
        for (j = 0; j < cnt; j++) {
            AObj target = 0;
            int input = 0;
            KismetBody kb;
            unsigned long long k;
            if (!A->read_raw(links, j * 8, &target, 4)) break;
            if (!A->read_raw(links, j * 8 + 4, &input, 4)) break;
            if (!target || !guard_obj_ok(target)) continue;
            if (input < 0 || input >= INLINK_MAX) continue;
            kb.input = (unsigned char)input;
            k = emit_obj(CEV_KISMET, target, LANE_WORLD, 0, &kb, (int)sizeof kb);
            if (!k) continue;
            sent++;
            g_wstat.kismet_out++;
            ev_log(">>", "KISMET", k, target, "aval d'un declencheur sans cle");
        }
    }
    if (!sent) ev_refuse("KISMET", 0, "declencheur sans cle et sans aval exploitable");
}

static void emit_trigger(AObj ev, AObj orig, int mode) {
    TrigBody tb;
    unsigned long long k;

    if (!ev) return;
    if (!coop_key(ev)) { emit_downstream(ev); return; }
    tb.mode = (unsigned char)mode;
    tb.idx = 0xff;
    tb.orig = orig ? coop_key(orig) : 0;
    k = emit_obj(CEV_TRIGGER, ev, LANE_WORLD, 0, &tb, (int)sizeof tb);
    if (!k) return;
    g_wstat.kismet_out++;
    ev_log(">>", "TRIGGR", k, ev,
           mode == TRG_TOUCH ? "contact" : mode == TRG_UNTOUCH ? "fin de contact" : "activation");
}

static void hook_activated(AEvent *e) {
    AObj op = e->self, orig = 0;

    if (!op) return;
    if (g_cfg.kismet_probe) probe_note(op);
    if (!world_sending() || !g_cfg.mirror_kismet) return;
    if (!A->is_a(op, "SequenceEvent")) return;
    if (is_noreplay(short_class(op))) return;
    if (!seq_local_cause(op, &orig)) return;
    emit_trigger(op, orig, TRG_ACTIVATE);
}

static void emit_touch_events(AObj actor, int mode) {
    int n, i;
    if (!actor) return;
    n = A->array_num(actor, "GeneratedEvents");
    if (n <= 0 || n > GENEV_MAX) return;
    for (i = 0; i < n; i++) {
        AObj ev = A->array_obj(actor, "GeneratedEvents", i);
        if (!ev || !guard_obj_ok(ev)) continue;
        if (!A->is_a(ev, "SeqEvent_Touch")) continue;
        emit_trigger(ev, actor, mode);
    }
}

static void hook_touch(AEvent *e) {
    if (!e->self || !world_sending() || !g_cfg.mirror_kismet) return;
    if (A->param_get_obj(e, "Other") != g_localPawn) return;
    emit_touch_events(e->self, TRG_TOUCH);
}

static void hook_untouch(AEvent *e) {
    if (!e->self || !world_sending() || !g_cfg.mirror_kismet) return;
    if (A->param_get_obj(e, "Other") != g_localPawn) return;
    emit_touch_events(e->self, TRG_UNTOUCH);
}

static void apply_kismet(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj op;
    KismetBody kb;

    if (!g_cfg.mirror_trigger) return;
    if (n - w < (int)sizeof kb) return;
    if (!coop_need_obj(e, raw, n, &op)) return;
    memcpy(&kb, p, sizeof kb);
    if (!seq_force_input(op, kb.input)) {
        ev_refuse("KISMET", e->key, "ForceActivateInput introuvable");
        return;
    }
    g_wstat.kismet_in++;
    ev_log("<<", "KISMET", e->key, op, "entree forcee");
}

static void apply_trigger(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj ev, orig, inst;
    TrigBody tb;
    int r;

    if (!g_cfg.mirror_trigger) return;
    if (n - w < (int)sizeof tb) return;
    if (!coop_need_obj(e, raw, n, &ev)) return;
    memcpy(&tb, p, sizeof tb);

    inst = replay_instigator(tb.mode != TRG_ACTIVATE);
    if (!inst) { ev_refuse("TRIGGR", e->key, "aucun instigateur disponible"); return; }

    orig = tb.orig ? coop_key_resolve(tb.orig) : 0;
    if (!orig) A->read_raw(ev, O_SEQEVT_ORIGINATOR, &orig, 4);
    if (!orig || !guard_obj_ok(orig)) orig = ev;

    r = seq_replay(ev, orig, inst, tb.mode);
    if (r < 0) { ev_refuse("TRIGGR", e->key, "fonction de declenchement introuvable"); return; }
    if (!r) {
        if (!g_cfg.kismet_force) { ev_refuse("TRIGGR", e->key, "activation refusee par le jeu"); return; }
        if (!seq_force_input(ev, 0)) { ev_refuse("TRIGGR", e->key, "forcage impossible"); return; }
        g_wstat.kismet_in++;
        ev_log("<<", "TRIGGR", e->key, ev, "refuse puis force (HYPOTHESE NON VERIFIEE)");
        return;
    }
    g_wstat.kismet_in++;
    ev_log("<<", "TRIGGR", e->key, ev,
           tb.mode == TRG_TOUCH ? "contact rejoue" :
           tb.mode == TRG_UNTOUCH ? "fin de contact rejouee" : "activation rejouee");
}

static int hold_has(AObj *tab, int n, AObj o) {
    int i;
    for (i = 0; i < n; i++) if (tab[i] == o) return 1;
    return 0;
}

static void hold_del(AObj *tab, int *n, AObj o) {
    int i;
    for (i = 0; i < *n; i++) if (tab[i] == o) { tab[i] = tab[--(*n)]; return; }
}

static void apply_pad(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj pad;
    PadBody pb;
    unsigned f = 0;

    if (!g_cfg.mirror_decor) return;
    if (n - w < (int)sizeof pb) return;
    if (!coop_need_obj(e, raw, n, &pad)) return;
    memcpy(&pb, p, sizeof pb);

    A->read_raw(pad, O_PAD_FLAGS, &f, 4);
    if (pb.active) {
        if (!hold_has(g_padHold, g_padHoldN, pad) && g_padHoldN < HOLDN)
            g_padHold[g_padHoldN++] = pad;
        if (!(f & F_PAD_IsEventTrigged)) {
            f |= F_PAD_IsEventTrigged;
            A->write_raw(pad, O_PAD_FLAGS, &f, 4);
            if (!trigger_event_class(pad, &g_clsPadOn, "SeqEvent_PadActivated", pad)) {
                ev_refuse("PLAQUE", e->key, "SeqEvent_PadActivated introuvable");
                return;
            }
        }
    } else {
        hold_del(g_padHold, &g_padHoldN, pad);
        if (f & F_PAD_IsEventTrigged) {
            f &= ~F_PAD_IsEventTrigged;
            A->write_raw(pad, O_PAD_FLAGS, &f, 4);
            trigger_event_class(pad, &g_clsPadOff, "SeqEvent_PadDeactivated", pad);
        }
    }
    key_track(pad, e->key);
    g_wstat.decor_in++;
    ev_log("<<", "PLAQUE", e->key, pad, pb.active ? "maintenue enfoncee" : "relachee");
}

static void pad_hold_frame(void) {
    unsigned f;
    int i;
    for (i = 0; i < g_padHoldN; ) {
        AObj o = g_padHold[i];
        if (!o || !guard_obj_ok(o)) { g_padHold[i] = g_padHold[--g_padHoldN]; continue; }
        if (A->read_raw(o, O_PAD_FLAGS, &f, 4) && !(f & F_PAD_IsEventTrigged)) {
            f |= F_PAD_IsEventTrigged;
            A->write_raw(o, O_PAD_FLAGS, &f, 4);
            trigger_event_class(o, &g_clsPadOn, "SeqEvent_PadActivated", o);
            ev_log("<<", "PLAQUE", coop_key(o), o, "reactivee apres relachement local");
        }
        i++;
    }
}

void world_release_holds(const char *why) {
    unsigned f;
    int i, n = g_padHoldN + g_balHoldN;

    if (!n) return;
    for (i = 0; guard_writes_allowed() && i < g_padHoldN; i++) {
        AObj o = g_padHold[i];
        if (!o || !guard_obj_ok(o)) continue;
        if (!A->read_raw(o, O_PAD_FLAGS, &f, 4) || !(f & F_PAD_IsEventTrigged)) continue;
        f &= ~F_PAD_IsEventTrigged;
        A->write_raw(o, O_PAD_FLAGS, &f, 4);
        trigger_event_class(o, &g_clsPadOff, "SeqEvent_PadDeactivated", o);
    }
    g_padHoldN = 0;
    g_balHoldN = 0;
    coop_log("coop: %d maintiens du pair relaches (%s)", n, why ? why : "");
}

static void hook_balance_post(AEvent *e) {
    AObj self = e->self;
    int weight = 0;
    ACall c;

    if (!self || !g_cfg.mirror_decor || !g_balHoldN) return;
    if (!hold_has(g_balHold, g_balHoldN, self)) return;
    if (!A->read_raw(self, O_BAL_WEIGHT, &weight, 4) || weight) return;
    weight = 1;
    A->write_raw(self, O_BAL_WEIGHT, &weight, 4);
    c = A->call_begin(self, "CheckPlatformBalance");
    if (c) { A->call_invoke(c); A->call_end(c); }
}

static void apply_balance(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj bal;
    BalBody bb;

    if (!g_cfg.mirror_decor) return;
    if (n - w < (int)sizeof bb) return;
    if (!coop_need_obj(e, raw, n, &bal)) return;
    memcpy(&bb, p, sizeof bb);

    if (bb.on) {
        if (!hold_has(g_balHold, g_balHoldN, bal) && g_balHoldN < HOLDN)
            g_balHold[g_balHoldN++] = bal;
    } else {
        hold_del(g_balHold, &g_balHoldN, bal);
    }
    key_track(bal, e->key);
    g_wstat.decor_in++;
    ev_log("<<", "BALANC", e->key, bal, bb.on ? "pair maintenu dessus" : "pair retire");
}

static void apply_ctxact(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj ctx;
    CtxBody cb;

    if (!g_cfg.mirror_decor) return;
    if (n - w < (int)sizeof cb) return;
    if (!coop_need_obj(e, raw, n, &ctx)) return;
    memcpy(&cb, p, sizeof cb);
    A->set_int(ctx, "TriggerTimes", cb.times);
    if (!trigger_event_class(ctx, &g_clsCtxActivated, "SeqEvent_ContextActionActivated",
                             g_localPawn)) {
        ev_refuse("CONTXT", e->key, "TriggerEventClass indisponible");
        return;
    }
    key_track(ctx, e->key);
    g_wstat.decor_in++;
    ev_log("<<", "CONTXT", e->key, ctx, "Kismet d'action de contexte declenche");
}

static void apply_break(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj obj;
    BreakBody bb;
    ACall c;
    unsigned f = 0;

    if (!g_cfg.mirror_decor) return;
    if (n - w < (int)sizeof bb) return;
    if (!coop_need_obj(e, raw, n, &obj)) return;
    memcpy(&bb, p, sizeof bb);
    if (A->read_raw(obj, O_BREAK_FLAGS, &f, 4) && (f & F_bDestoryed)) return;

    c = A->call_begin(obj, "TakeStepDamage");
    if (c) {
        A->call_arg_int(c, "Damage", 1000000);
        A->call_arg_obj(c, "EventInstigator", g_localPC);
        A->call_arg_bool(c, "bIsBroken", 0);
        A->call_arg_int(c, "BrokenStep", 0);
        A->call_invoke(c);
        A->call_end(c);
        key_track(obj, e->key);
        g_wstat.decor_in++;
        ev_log("<<", "CASSE", e->key, obj, "brise par des degats rejoues");
        return;
    }
    if (bb.step >= 0 && bb.step < 64) A->write_raw(obj, O_BREAK_CURSTEP, &bb.step, 4);
    set_flag(obj, O_BREAK_FLAGS, F_bDestoryed, 1);
    set_flag(obj, O_BREAK_FLAGS, F_bSaveDestroyed, 1);
    set_flag(obj, O_ACTOR_FLAGS0, F_bHidden, 1);
    key_track(obj, e->key);
    g_wstat.decor_in++;
    ev_log("<<", "CASSE", e->key, obj, "cache faute de TakeStepDamage");
}

static const char *loot_word(int kind) {
    switch (kind) {
    case LOOT_MEMORY: return "fragment de memoire";
    case LOOT_SECRET: return "secret";
    case LOOT_HEALTH: return "amelioration de vie";
    case LOOT_WEAPON: return "arme";
    default: return "?";
    }
}

static void apply_loot(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj obj;
    LootBody lb;
    ACall c;
    unsigned f = 0;

    if (!g_cfg.mirror_loot) return;
    if (n - w < (int)sizeof lb) return;
    if (!coop_need_obj(e, raw, n, &obj)) return;
    memcpy(&lb, p, sizeof lb);
    if (!g_localPawn) { ev_refuse("BUTIN", e->key, "pas de pion local"); return; }

    if (lb.kind == LOOT_HEALTH) {
        if (A->read_raw(obj, O_HUPICK_FLAGS, &f, 4) && (f & F_HU_bPickUped)) return;
    } else if (lb.kind == LOOT_MEMORY || lb.kind == LOOT_SECRET) {
        if (A->read_raw(obj, O_MEMFRAG_FLAGS, &f, 4) && (f & F_MF_bPickUped)) return;
    } else if (lb.kind == LOOT_WEAPON) {
        if (A->read_raw(obj, O_WPICK_FLAGS, &f, 4) && !(f & F_WP_bIsActive)) return;
    }

    c = A->call_begin(obj, "GiveTo");
    if (!c) { ev_refuse("BUTIN", e->key, "GiveTo introuvable"); return; }
    A->call_arg_obj(c, "P", g_localPawn);
    A->call_invoke(c);
    A->call_end(c);
    key_track(obj, e->key);
    g_wstat.loot_in++;
    ev_log("<<", "BUTIN", e->key, obj, loot_word(lb.kind));
}

static int heard_take(Heard *ring, int n, int *cursor, unsigned long long key, unsigned ttl) {
    unsigned now = GetTickCount();
    int i;
    if (!key) return 0;
    for (i = 0; i < n; i++)
        if (ring[i].key == key && now - ring[i].ms < ttl) return 1;
    ring[*cursor].key = key;
    ring[*cursor].ms = now;
    *cursor = (*cursor + 1) % n;
    return 0;
}

static void hook_dialogue(AEvent *e) {
    AObj speaker, cue;
    VoBody vb;
    unsigned long long ck;
    int pri = 0;

    if (!e->self) return;
    if (!A->is_a(e->self, "AliceSpeechManager") && !A->is_a(e->self, "AliceGameInfo")) return;
    cue = A->param_get_obj(e, "Audio");
    if (!cue) return;
    ck = coop_key(cue);
    if (!ck) return;
    if (heard_take(g_voHeard, VODEDUPN, &g_voHeardW, ck, (unsigned)g_cfg.vo_dedup_ms)) return;
    if (!world_sending() || !g_cfg.mirror_vo) return;

    speaker = A->param_get_obj(e, "Speaker");
    if (!speaker) return;
    A->param_get_int(e, "PRI", &pri);
    vb.speaker = coop_key(speaker);
    vb.pri = (unsigned char)(pri & 0xff);
    vb.bits = 0;
    if (!vb.speaker) return;
    if (!net_ev_add(CEV_VO_LINE, ck, LANE_LOOSE, 0, &vb, (int)sizeof vb)) return;
    g_wstat.vo_out++;
    ev_log(">>", "VOIX", ck, cue, short_name(speaker));
}

static void apply_vo(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    AObj cue, speaker;
    VoBody vb;
    ACall c;

    if (!g_cfg.mirror_vo) return;
    if (n - w < (int)sizeof vb) return;
    if (!coop_need_obj(e, raw, n, &cue)) return;
    memcpy(&vb, p, sizeof vb);

    if (heard_take(g_voHeard, VODEDUPN, &g_voHeardW, e->key, (unsigned)g_cfg.vo_dedup_ms)) {
        g_wstat.dedup++;
        ev_log("==", "VOIX", e->key, cue, "deja entendue localement");
        return;
    }
    speaker = coop_key_resolve(vb.speaker);
    if (!speaker || !guard_obj_ok(speaker)) { ev_refuse("VOIX", e->key, "locuteur introuvable"); return; }

    c = A->call_begin(speaker, A->is_a(speaker, "AliceRemoteSpeaker") ? "RemoteSpeakLine" : "SpeakLine");
    if (!c) { ev_refuse("VOIX", e->key, "SpeakLine introuvable"); return; }
    A->call_arg_obj(c, "Addressee", g_localPawn);
    A->call_arg_obj(c, "Audio", cue);
    A->call_arg_str(c, "DebugText", "coop");
    A->call_arg_float(c, "DelaySec", 0.0f);
    A->call_arg_int(c, "Priority", vb.pri);
    A->call_invoke(c);
    A->call_end(c);
    g_wstat.vo_in++;
    ev_log("<<", "VOIX", e->key, cue, short_name(speaker));
}

static void hook_kismet_ui(AEvent *e) {
    MsgBody mb;
    int type = 0, len;
    unsigned long long h;

    if (!e->self || e->self != g_localPC) return;
    memset(&mb, 0, sizeof mb);
    if (!A->param_get_str(e, "sText", mb.text, (int)sizeof mb.text)) return;
    mb.text[sizeof mb.text - 1] = 0;
    len = (int)strlen(mb.text);
    if (!len) return;
    A->param_get_float(e, "Duration", &mb.dur);
    A->param_get_int(e, "Type", &type);
    mb.type = (unsigned char)(type & 0xff);
    h = fnv1a64(mb.text);
    heard_take(g_msgSeen, MSGDEDUPN, &g_msgSeenW, h, 6000);
    if (!world_sending() || !g_cfg.mirror_msg) return;
    if (!net_ev_add(CEV_HUD_MSG, h, LANE_LOOSE, 0, &mb,
                    (int)(sizeof mb - sizeof mb.text) + len + 1)) return;
    g_wstat.vo_out++;
    ev_log(">>", "MESSAG", h, e->self, mb.text);
}

static void apply_msg(const CoopEvent *e, const void *raw, int n, int w) {
    const unsigned char *p = (const unsigned char *)raw + w;
    MsgBody mb;
    ACall c;
    int head = (int)(sizeof mb - sizeof mb.text);
    int body = n - w;

    if (!g_cfg.mirror_msg || !g_localPC) return;
    if (body <= head || body > (int)sizeof mb) return;
    memset(&mb, 0, sizeof mb);
    memcpy(&mb, p, (size_t)body);
    mb.text[sizeof mb.text - 1] = 0;
    if (heard_take(g_msgSeen, MSGDEDUPN, &g_msgSeenW, e->key, 6000)) { g_wstat.dedup++; return; }

    c = A->call_begin(g_localPC, "ShowKismetCustomUI");
    if (!c) { ev_refuse("MESSAG", e->key, "ShowKismetCustomUI introuvable"); return; }
    A->call_arg_float(c, "Duration", mb.dur > 0.1f && mb.dur < 60.0f ? mb.dur : 3.0f);
    A->call_arg_str(c, "sText", mb.text);
    A->call_arg_int(c, "Type", mb.type);
    A->call_invoke(c);
    A->call_end(c);
    g_wstat.vo_in++;
    ev_log("<<", "MESSAG", e->key, g_localPC, mb.text);
}

static int watch_state(AObj o, int kind) {
    unsigned f = 0;
    switch (kind) {
    case W_PAD:
        if (!A->read_raw(o, O_PAD_FLAGS, &f, 4)) return -1;
        return (f & F_PAD_IsActived) ? 1 : 0;
    case W_BAL:
        if (!A->read_raw(o, O_BAL_FLAGS, &f, 4)) return -1;
        return ((f & F_BAL_bAliceOn) ? 1 : 0) | ((f & F_BAL_bAliceShrink) ? 2 : 0);
    case W_CTX:
        if (!A->read_raw(o, O_CTX_FLAGS, &f, 4)) return -1;
        return (f & F_bContextActionStarted) ? 1 : 0;
    case W_BREAK:
        if (!A->read_raw(o, O_BREAK_FLAGS, &f, 4)) return -1;
        return (f & F_bDestoryed) ? 1 : 0;
    case W_MEM:
        if (!A->read_raw(o, O_MEMFRAG_FLAGS, &f, 4)) return -1;
        return (f & (F_MF_bPickUped | F_MF_bPickUpedPdata)) ? 1 : 0;
    case W_HEALTH:
        if (!A->read_raw(o, O_HUPICK_FLAGS, &f, 4)) return -1;
        return (f & (F_HU_bPickUped | F_HU_bPickedInPdata)) ? 1 : 0;
    case W_WEAPON:
        if (!A->read_raw(o, O_WPICK_FLAGS, &f, 4)) return -1;
        return (f & F_WP_bIsActive) ? 0 : 1;
    default:
        return -1;
    }
}

static int g_scanKind;

static void watch_add_cb(AObj o) {
    const char *nm;
    int st;
    if (g_watchN >= WATCHN) { g_watchFull = 1; return; }
    nm = A->name_of(o);
    if (!nm || strncmp(nm, "Default__", 9) == 0) return;
    st = watch_state(o, g_scanKind);
    if (st < 0) return;
    g_watch[g_watchN].obj = o;
    g_watch[g_watchN].kind = (unsigned char)g_scanKind;
    g_watch[g_watchN].state = (unsigned char)st;
    g_watchN++;
}

static void watch_scan_step(void) {
    int before = g_watchN;
    g_scanKind = g_watchScan;
    A->iter_objects(WATCH_CLASS[g_watchScan], watch_add_cb);
    if (g_watchScan < W_FAST_KINDS) g_watchFast = g_watchN;
    if (g_watchN != before)
        coop_log("coop: miroir - %d %s suivis", g_watchN - before, WATCH_CLASS[g_watchScan]);
    g_watchScan++;
    if (g_watchScan >= W_KINDS) {
        coop_log("coop: miroir - inventaire termine, %d objets suivis%s",
                 g_watchN, g_watchFull ? " (TABLE PLEINE)" : "");
    }
}

static int watch_emit(AObj o, int kind, int old, int now) {
    unsigned long long k;

    switch (kind) {
    case W_PAD: {
        PadBody pb;
        pb.active = (unsigned char)(now ? 1 : 0);
        k = emit_obj(CEV_PAD, o, LANE_WORLD, EF_NOECHO, &pb, (int)sizeof pb);
        if (!k) return 0;
        key_track(o, k);
        g_wstat.decor_out++;
        ev_log(">>", "PLAQUE", k, o, now ? "enfoncee par le joueur local" : "liberee");
        return 1;
    }
    case W_BAL: {
        BalBody bb;
        bb.on = (unsigned char)((now & 1) ? 1 : 0);
        bb.shrink = (unsigned char)((now & 2) ? 1 : 0);
        k = emit_obj(CEV_BALANCE, o, LANE_WORLD, EF_NOECHO, &bb, (int)sizeof bb);
        if (!k) return 0;
        key_track(o, k);
        g_wstat.decor_out++;
        ev_log(">>", "BALANC", k, o, bb.on ? "joueur local dessus" : "joueur local parti");
        return 1;
    }
    case W_CTX: {
        AObj alice = 0;
        CtxBody cb;
        int times = 0;
        if (!(old && !now)) return 1;
        A->read_raw(o, O_CTX_ALICE, &alice, 4);
        if (alice && alice != g_localPawn) return 1;
        A->get_int(o, "TriggerTimes", &times);
        cb.times = (unsigned char)(times > 255 ? 255 : times < 0 ? 0 : times);
        k = emit_obj(CEV_CTXACT, o, LANE_PUZZLE, EF_NOECHO, &cb, (int)sizeof cb);
        if (!k) return 0;
        key_track(o, k);
        g_wstat.decor_out++;
        ev_log(">>", "CONTXT", k, o, "action de contexte terminee");
        return 1;
    }
    case W_BREAK: {
        BreakBody bb;
        if (!now) return 1;
        bb.step = 0;
        bb.last = 1;
        A->read_raw(o, O_BREAK_CURSTEP, &bb.step, 4);
        k = emit_obj(CEV_BREAK, o, LANE_WORLD, EF_ONCE, &bb, (int)sizeof bb);
        if (!k) return 0;
        key_track(o, k);
        g_wstat.decor_out++;
        ev_log(">>", "CASSE", k, o, "brise localement");
        return 1;
    }
    case W_MEM: case W_HEALTH: case W_WEAPON: {
        LootBody lb;
        if (!now) return 1;
        lb.kind = (unsigned char)(kind == W_HEALTH ? LOOT_HEALTH :
                                  kind == W_WEAPON ? LOOT_WEAPON :
                                  A->is_a(o, "SecretPickup") || A->is_a(o, "BigSecretPickup")
                                      ? LOOT_SECRET : LOOT_MEMORY);
        k = emit_obj(CEV_LOOT, o, LANE_WORLD, EF_ONCE, &lb, (int)sizeof lb);
        if (!k) return 0;
        key_track(o, k);
        g_wstat.loot_out++;
        ev_log(">>", "BUTIN", k, o, loot_word(lb.kind));
        return 1;
    }
    default:
        return 1;
    }
}

static int watch_kind_on(int kind) {
    if (kind == W_MEM || kind == W_HEALTH || kind == W_WEAPON) return g_cfg.mirror_loot;
    return g_cfg.mirror_decor;
}

static void watch_one(int i) {
    Watch *w = &g_watch[i];
    int st;
    if (!w->obj) return;
    if (!guard_obj_ok(w->obj)) { w->obj = 0; return; }
    st = watch_state(w->obj, w->kind);
    if (st < 0 || st == (int)w->state) return;
    if (watch_kind_on(w->kind) && world_sending() &&
        !watch_emit(w->obj, w->kind, w->state, st)) return;
    w->state = (unsigned char)st;
}

static void watch_pump(unsigned now) {
    int i, end;

    if (!g_cfg.mirror_decor && !g_cfg.mirror_loot) return;
    if (now - g_lastWatchMs < WATCH_MS) return;
    g_lastWatchMs = now;

    if (g_watchScan < W_KINDS) { watch_scan_step(); return; }
    if (!g_watchN) return;

    for (i = 0; i < g_watchFast; i++) watch_one(i);

    if (g_watchCursor < g_watchFast) g_watchCursor = g_watchFast;
    end = g_watchCursor + WATCH_SLICE;
    if (end > g_watchN) end = g_watchN;
    for (i = g_watchCursor; i < end; i++) watch_one(i);
    g_watchCursor = end >= g_watchN ? g_watchFast : end;
}

static void hook_dress(AEvent *e) {
    unsigned char d[2] = {0, 0};
    if (!world_sending() || e->self != g_localPawn) return;
    A->read_raw(e->self, O_AP_BLOCKB + BLKB_DRESS, &d[0], 1);
    A->read_raw(e->self, O_AP_BLOCKB + BLKB_PENDINGDRESS, &d[1], 1);
    emit(CEV_DRESS, LANE_LOOSE, 0, d, 2);
}

static void hook_switchland(AEvent *e) {
    unsigned char at = 0;
    if (!world_sending() || e->self != g_localPC) return;
    if (g_localPawn) A->read_raw(g_localPawn, O_AP_BLOCKB + BLKB_ARCHETYPE, &at, 1);
    emit(CEV_LAND, LANE_LOOSE, 0, &at, 1);
}

static void hook_special(AEvent *e) {
    unsigned char buf[5];
    int mv = 0;
    unsigned smf = 0;
    if (!world_sending() || e->self != g_localPawn) return;
    A->param_get_int(e, "NewMove", &mv);
    A->read_raw(e->self, O_AGP_SMFLAGS, &smf, 4);
    buf[0] = (unsigned char)mv;
    memcpy(buf + 1, &smf, 4);
    emit(CEV_SPECIAL, LANE_LOOSE, 0, buf, 5);
}

static void hook_checkpoint(AEvent *e) {
    (void)e;
    if (g_replayDepth) return;
    coop_epoch_bump("checkpoint local");
    if (!world_sending()) return;
    net_ev_add(CEV_CHECKPOINT, 0, LANE_SESSION, 0, &g_epoch, 2);
    g_hardDiverge = 0;
}

#define NPCN 96

typedef struct {
    unsigned long long key;
    unsigned           total;
    unsigned           applied;
    int                lastHealth;
    unsigned           stamp;
    unsigned char      used;
    unsigned char      dead;
} CoopNpc;

static CoopNpc g_npc[NPCN];
static AObj    g_dmgClass;
static char    g_dmgClassName[64];

static CoopNpc *npc_slot(unsigned long long key) {
    CoopNpc *free_slot = 0, *oldest = &g_npc[0];
    int i;
    if (!key) return 0;
    for (i = 0; i < NPCN; i++) {
        CoopNpc *r = &g_npc[i];
        if (r->used && r->key == key) return r;
        if (!r->used) { if (!free_slot) free_slot = r; continue; }
        if ((int)(r->stamp - oldest->stamp) < 0) oldest = r;
    }
    if (free_slot) { memset(free_slot, 0, sizeof *free_slot); free_slot->key = key; return free_slot; }
    memset(oldest, 0, sizeof *oldest);
    oldest->key = key;
    return oldest;
}

static void npc_forget(void) { memset(g_npc, 0, sizeof g_npc); }

static AObj damage_class(const char *name) {
    AObj c;
    if (!name || !name[0]) name = "DamageType";
    if (g_dmgClass && strcmp(g_dmgClassName, name) == 0) return g_dmgClass;
    c = A->find_class(name);
    if (!c) return 0;
    g_dmgClass = c;
    strncpy(g_dmgClassName, name, sizeof g_dmgClassName - 1);
    g_dmgClassName[sizeof g_dmgClassName - 1] = 0;
    return c;
}

static int npc_deal_damage(AObj o, int dmg, const char *dtName) {
    static const float zero[3] = { 0.0f, 0.0f, 0.0f };
    float loc[3] = { 0.0f, 0.0f, 0.0f };
    AObj ctrl = 0, dtc;
    ACall c;
    if (!o || dmg <= 0) return 0;
    A->read_raw(o, O_LOCATION, loc, 12);
    if (g_localPawn) A->read_raw(g_localPawn, O_PAWN_CONTROLLER, &ctrl, 4);
    dtc = damage_class(dtName);
    if (!dtc) dtc = damage_class("DamageType");
    c = A->call_begin(o, "TakeDamage");
    if (!c) return 0;
    A->call_arg_int(c, "Damage", dmg);
    A->call_arg_int(c, "DamageAmount", dmg);
    A->call_arg_obj(c, "InstigatedBy", ctrl);
    A->call_arg_obj(c, "EventInstigator", ctrl);
    A->call_arg_vec(c, "HitLocation", loc);
    A->call_arg_vec(c, "Momentum", zero);
    if (dtc) A->call_arg_obj(c, "DamageType", dtc);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static void hook_damage_post(AEvent *e) {
    unsigned char buf[80];
    unsigned long long k;
    const char *dtn;
    CoopNpc *r;
    AObj dt;
    int hp = 0, n, ln;

    if (g_replayDepth || !g_cfg.mirror_npc) return;
    if (!world_sending() || !e->self || e->self == g_localPawn) return;
    if (e->self == g_ghost.obj) return;
    if (!A->is_a(e->self, "Pawn")) return;
    if (!A->read_raw(e->self, O_PAWN_HEALTH, &hp, 4)) return;

    k = coop_key(e->self);
    r = npc_slot(k);
    if (!r) return;
    if (!r->used) {
        r->used = 1;
        r->lastHealth = hp;
        if (!A->read_raw(e->self, O_PAWN_HEALTHMAX, &r->lastHealth, 4)) r->lastHealth = hp;
        if (r->lastHealth < hp) r->lastHealth = hp;
    }
    if (hp < r->lastHealth) r->total += (unsigned)(r->lastHealth - hp);
    r->lastHealth = hp;
    r->stamp = GetTickCount();

    dt = A->param_get_obj(e, "DamageType");
    dtn = dt ? A->name_of(dt) : 0;
    ln = dtn ? (int)strlen(dtn) : 0;
    if (ln > 63) ln = 63;

    memcpy(buf, &r->total, 4);
    memcpy(buf + 4, &hp, 4);
    buf[8] = (unsigned char)ln;
    n = 9;
    if (ln) { memcpy(buf + n, dtn, (size_t)ln); n += ln; }

    key_track(e->self, emit_obj(CEV_NPC_DMG, e->self, LANE_WORLD, 0, buf, n));
}

static void hook_destroyed(AEvent *e) {
    if (g_replayDepth || !g_cfg.mirror_npc) return;
    if (!world_sending() || !e->self || e->self == g_localPawn) return;
    if (e->self == g_ghost.obj) return;
    if (!A->is_a(e->self, "Pawn")) return;
    emit_obj(CEV_NPC_DEATH, e->self, LANE_WORLD, EF_ONCE, 0, 0);
}

void world_apply_event(const CoopEvent *e, const void *raw, int n) {
    const unsigned char *p = (const unsigned char *)raw;
    int w = coop_witness_read(e, raw, n, 0);
    int body = n - w;
    AObj o;

    p += w;

    if (e->type == CEV_NAME) {
        int len = body < (int)sizeof g_net.peer_name - 1 ? body : (int)sizeof g_net.peer_name - 1;
        if (len > 0) {
            memcpy(g_net.peer_name, p, (size_t)len);
            g_net.peer_name[len] = 0;
        }
        return;
    }
    if (!g_cfg.mirror_world) return;

    switch (e->type) {
    case CEV_DRESS:
        if (body >= 2 && g_ghost.obj && !g_ghost.adopted) {
            if (p[0] < 12) A->write_raw(g_ghost.obj, O_AP_BLOCKB + BLKB_DRESS, &p[0], 1);
            if (p[1] < 12) A->write_raw(g_ghost.obj, O_AP_BLOCKB + BLKB_PENDINGDRESS, &p[1], 1);
        }
        return;
    case CEV_LAND:
        if (body >= 1 && g_ghost.obj && !g_ghost.adopted && p[0] < 9)
            A->write_raw(g_ghost.obj, O_AP_BLOCKB + BLKB_ARCHETYPE, &p[0], 1);
        return;
    case CEV_SPECIAL:
        if (body >= 5 && g_ghost.obj && !g_ghost.adopted) {
            unsigned smf;
            if (p[0] < 70) A->write_raw(g_ghost.obj, O_AGP_BLOCKA + 2, &p[0], 1);
            memcpy(&smf, p + 1, 4);
            A->write_raw(g_ghost.obj, O_AGP_SMFLAGS, &smf, 4);
        }
        return;
    case CEV_CHECKPOINT:
        g_hardDiverge = 0;
        world_reset();
        guard_note("checkpoint du pair, monde resynchronise");
        return;
    case CEV_KISMET:  apply_kismet(e, raw, n, w);  return;
    case CEV_TRIGGER: apply_trigger(e, raw, n, w); return;
    case CEV_CTXACT:  apply_ctxact(e, raw, n, w);  return;
    case CEV_PAD:     apply_pad(e, raw, n, w);     return;
    case CEV_BALANCE: apply_balance(e, raw, n, w); return;
    case CEV_BREAK:   apply_break(e, raw, n, w);   return;
    case CEV_LOOT:    apply_loot(e, raw, n, w);    return;
    case CEV_VO_LINE: apply_vo(e, raw, n, w);      return;
    case CEV_HUD_MSG: apply_msg(e, raw, n, w);     return;
    default:
        break;
    }

    switch (e->type) {
    case CEV_MOVER:
        if (!g_cfg.mirror_mover) return;
        break;
    case CEV_NPC_DMG: case CEV_NPC_DEATH:
        if (!g_cfg.mirror_npc) return;
        break;
    default:
        return;
    }
    if (!coop_need_obj(e, raw, n, &o)) return;

    if (!A->is_a(o, e->type == CEV_MOVER ? "Actor" : "Pawn")) {
        g_net.mismatch++;
        return;
    }
    if (e->type != CEV_MOVER && !coop_witness_check(e, raw, n, o, NPC_WITNESS_UU)) {
        g_net.mismatch++;
        ev_refuse("PNJ", e->key, "le temoin ne correspond pas a l'acteur trouve");
        return;
    }

    switch (e->type) {
    case CEV_MOVER:
        if (body >= 18) {
            float pos[3];
            short r[3];
            int rot[3];
            unsigned char phys;
            memcpy(pos, p, 12);
            memcpy(r, p + 12, 6);
            rot[0] = r[0]; rot[1] = r[1]; rot[2] = r[2];
            A->write_raw(o, O_LOCATION, pos, 12);
            A->write_raw(o, O_ROTATION, rot, 12);
            if (body >= 19) { phys = p[18]; if (phys < 21) actor_set_physics(o, phys); }
        }
        break;
    case CEV_NPC_DMG: {
        char dtn[64];
        CoopNpc *r;
        unsigned total;
        int peerHp, hp = 0, dmg, ln;

        if (body < 9) break;
        memcpy(&total, p, 4);
        memcpy(&peerHp, p + 4, 4);
        ln = p[8];
        if (ln < 0 || ln > 63 || 9 + ln > body) ln = 0;
        if (ln) memcpy(dtn, p + 9, (size_t)ln);
        dtn[ln] = 0;

        r = npc_slot(e->key);
        if (!r) break;
        r->stamp = GetTickCount();
        if (!r->used) {
            r->used = 1;
            if (!A->read_raw(o, O_PAWN_HEALTH, &r->lastHealth, 4)) r->lastHealth = 0;
        }
        if (r->dead) break;
        if (!A->read_raw(o, O_PAWN_HEALTH, &hp, 4)) break;
        if (hp <= 0) { r->dead = 1; break; }

        dmg = (int)(total - r->applied);
        if (peerHp <= 0) { dmg = hp + 1000; r->dead = 1; }
        if (dmg <= 0) break;
        if (dmg > 100000) dmg = 100000;
        r->applied = total;
        npc_deal_damage(o, dmg, dtn);
        if (!A->read_raw(o, O_PAWN_HEALTH, &r->lastHealth, 4)) r->lastHealth = 0;
        break;
    }
    case CEV_NPC_DEATH: {
        CoopNpc *r = npc_slot(e->key);
        int hp = 0;
        if (r) { r->used = 1; r->dead = 1; r->stamp = GetTickCount(); }
        if (!A->read_raw(o, O_PAWN_HEALTH, &hp, 4)) break;
        if (hp <= 0) break;
        npc_deal_damage(o, hp + 1000, 0);
        break;
    }
    default:
        return;
    }

    key_track(o, e->key);
    { int i = key_slot(e->key); if (i >= 0) g_keys[i].lastState = world_state_byte(o); }
}

void world_hooks_install(void) {
    net_ev_subscribe(0, world_apply_event);

    A->on("Activated", hook_activated);
    A->on("Touch", hook_touch);
    A->on("UnTouch", hook_untouch);
    A->on_post("CheckBalanceProc", hook_balance_post);
    A->on("NotifyDialogueStart", hook_dialogue);
    A->on("ShowKismetCustomUI", hook_kismet_ui);

    A->on_post("TakeDamage", hook_damage_post);
    A->on("Destroyed", hook_destroyed);
    A->on("SetWonderlandDress", hook_dress);
    A->on("OnSwitchLand", hook_switchland);
    A->on("DoSpecialMove", hook_special);
    A->on("PostLoadCheckpoint", hook_checkpoint);
}

static void mover_scan_cb(AObj o) {
    const char *nm = A->name_of(o);
    if (g_moverN >= MOVERN) return;
    if (!nm || strncmp(nm, "Default__", 9) == 0) return;
    g_movers[g_moverN].obj = o;
    A->read_raw(o, O_LOCATION, g_movers[g_moverN].pos, 12);
    A->read_raw(o, O_ROTATION, g_movers[g_moverN].rot, 12);
    g_moverN++;
}

static void mover_pump(unsigned now) {
    int i;
    if (!world_sending() || !g_cfg.mirror_mover || !g_net.host) return;
    if (now - g_lastMoverMs < 100) return;
    g_lastMoverMs = now;

    if (!g_moverScanDone) {
        g_moverScanDone = 1;
        g_moverN = 0;
        A->iter_objects("InterpActor", mover_scan_cb);
        if (g_moverN) coop_log("coop: %d plateformes suivies en position", g_moverN);
        return;
    }
    for (i = 0; i < g_moverN; i++) {
        float pos[3];
        int rot[3];
        Mover *m = &g_movers[i];
        if (!m->obj || !guard_obj_ok(m->obj)) { m->obj = 0; continue; }
        if (!A->read_raw(m->obj, O_LOCATION, pos, 12)) continue;
        A->read_raw(m->obj, O_ROTATION, rot, 12);
        if (fabsf(pos[0] - m->pos[0]) < 1.0f && fabsf(pos[1] - m->pos[1]) < 1.0f &&
            fabsf(pos[2] - m->pos[2]) < 1.0f && abs(rot[1] - m->rot[1]) < 64)
            continue;
        {
            unsigned char buf[19];
            short r[3];
            unsigned char phys = 0;
            r[0] = (short)rot[0]; r[1] = (short)rot[1]; r[2] = (short)rot[2];
            A->read_raw(m->obj, O_PHYSICS, &phys, 1);
            memcpy(buf, pos, 12);
            memcpy(buf + 12, r, 6);
            buf[18] = phys;
            emit_obj(CEV_MOVER, m->obj, LANE_LOOSE, EF_CANONICAL, buf, 19);
        }
        memcpy(m->pos, pos, 12);
        memcpy(m->rot, rot, 12);
    }
}

static void digest_pump(unsigned now) {
    unsigned char body[8 + 48 * 9];
    unsigned long long fp = FNV64_BASIS;
    int i, n = 0;

    if (!world_sending() || now - g_lastDigestMs < 2000) return;
    g_lastDigestMs = now;
    if (!g_keyN) return;

    for (i = 0; i < g_keyN && n < 48; i++) {
        AObj o = g_keys[i].obj;
        unsigned char st;
        if (!o || !guard_obj_ok(o)) continue;
        st = world_state_byte(o);
        g_keys[i].lastState = st;
        memcpy(body + 8 + n * 9, &g_keys[i].key, 8);
        body[8 + n * 9 + 8] = st;
        fp = fnv1a64_mix(fp, &g_keys[i].key, 8);
        fp = fnv1a64_mix(fp, &st, 1);
        n++;
    }
    if (!n) return;
    memcpy(body, &fp, 8);
    net_send_digest(body, 8 + n * 9);
}

void on_digest_packet(const void *payload, int n) {
    const unsigned char *p = (const unsigned char *)payload;
    int count, i, diverged = 0;

    if (!g_cfg.mirror_world || n < 9) return;
    count = (n - 8) / 9;
    for (i = 0; i < count; i++) {
        unsigned long long key;
        unsigned char remote;
        AObj o;
        memcpy(&key, p + 8 + i * 9, 8);
        remote = p[8 + i * 9 + 8];
        o = coop_key_resolve(key);
        if (!o) continue;
        if (world_state_byte(o) != remote) diverged++;
    }
    if (diverged > 32 && !g_hardDiverge) {
        g_hardDiverge = 1;
        guard_note("divergence dure du monde, resynchro au prochain checkpoint");
    }
}

void world_frame(unsigned now) {
    if (g_worldInfo && g_worldInfo != g_lastWorld) {
        g_lastWorld = g_worldInfo;
        world_reset();
        return;
    }
    if (g_cfg.mirror_decor && g_padHoldN) pad_hold_frame();
    watch_pump(now);
    mover_pump(now);
    digest_pump(now);
}

void world_progress(unsigned *loot, unsigned *broken) {
    unsigned l = 0, b = 0;
    int i;
    for (i = 0; i < g_watchN; i++) {
        if (!g_watch[i].obj || !g_watch[i].state) continue;
        if (g_watch[i].kind == W_BREAK) b++;
        else if (g_watch[i].kind >= W_MEM) l++;
    }
    if (loot) *loot = l;
    if (broken) *broken = b;
}

void world_reset(void) {
    npc_forget();
    g_keyN = 0;
    g_moverN = 0;
    g_moverScanDone = 0;
    g_hardDiverge = 0;
    g_watchN = 0;
    g_watchFast = 0;
    g_watchScan = 0;
    g_watchCursor = 0;
    g_watchFull = 0;
    g_padHoldN = 0;
    g_balHoldN = 0;
    g_voHeardW = 0;
    g_msgSeenW = 0;
    memset(g_voHeard, 0, sizeof g_voHeard);
    memset(g_msgSeen, 0, sizeof g_msgSeen);
    g_clsCtxActivated = 0;
    g_clsPadOn = 0;
    g_clsPadOff = 0;
    g_ghostWarned = 0;
}

void world_panel(void) {
    char line[160];

    A->ui_checkbox("Kismet : capter les declencheurs", &g_cfg.mirror_kismet);
    A->ui_checkbox("Kismet : rejouer chez soi", &g_cfg.mirror_trigger);
    A->ui_checkbox("Kismet : forcer si le jeu refuse", &g_cfg.kismet_force);
    A->ui_checkbox("Kismet : sonde Activated (journal)", &g_cfg.kismet_probe);
    A->ui_checkbox("Decor, enigmes et cassables", &g_cfg.mirror_decor);
    A->ui_checkbox("Plateformes par position (secours)", &g_cfg.mirror_mover);
    A->ui_checkbox("PNJ : degats et morts (cles instables)", &g_cfg.mirror_npc);
    A->ui_checkbox("Butin unique", &g_cfg.mirror_loot);
    A->ui_checkbox("Voix et dialogues", &g_cfg.mirror_vo);
    A->ui_checkbox("Messages d'interface", &g_cfg.mirror_msg);
    A->ui_checkbox("Journal detaille des evenements", &g_cfg.log_events);
    A->ui_slider_int("Anti-doublon des voix (ms)", &g_cfg.vo_dedup_ms, 0, 15000);

    wsprintfA(line, "Kismet  emis %u   rejoues %u", g_wstat.kismet_out, g_wstat.kismet_in);
    A->ui_label(line);
    wsprintfA(line, "Decor   emis %u   rejoues %u", g_wstat.decor_out, g_wstat.decor_in);
    A->ui_label(line);
    wsprintfA(line, "Butin   emis %u   rejoues %u", g_wstat.loot_out, g_wstat.loot_in);
    A->ui_label(line);
    wsprintfA(line, "Paroles emis %u   rejoues %u", g_wstat.vo_out, g_wstat.vo_in);
    A->ui_label(line);
    wsprintfA(line, "refus %u   doublons evites %u", g_wstat.refused, g_wstat.dedup);
    A->ui_label(line);
    wsprintfA(line, "objets surveilles %d (%d rapides)%s   plaques %d   balances %d",
              g_watchN, g_watchFast, g_watchFull ? " TABLE PLEINE" : "",
              g_padHoldN, g_balHoldN);
    A->ui_label(line);
}
