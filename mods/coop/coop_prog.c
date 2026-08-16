#include "coop.h"

#define PROG_LOCAL_MS   500
#define CKPT_SUPPRESS   20000
#define TRAVEL_SUPPRESS 20000

CoopProgStat g_pstat;
CoopSess     g_peerSess;

#pragma pack(push, 1)
typedef struct {
    unsigned       map_hash;
    unsigned short seq;
    unsigned short epoch;
    unsigned short world_s;
    unsigned short loot;
    unsigned short broken;
    unsigned char  chapter;
    unsigned char  phase;
} SessBody;

typedef struct {
    unsigned      map_hash;
    unsigned char chapter;
    unsigned char why;
} TravelBody;

typedef struct {
    unsigned char kind;
    unsigned char chapter;
} CkptBody;

typedef struct {
    unsigned char level;
    short         health;
} DownBody;

typedef struct {
    unsigned char kind;
} ResyncBody;
#pragma pack(pop)

enum { RSY_ASK = 0, RSY_RELOAD = 1 };
enum { TRV_KISMET = 0, TRV_MANUEL = 1 };
enum { CKP_SAVE = 0, CKP_LOAD = 1 };

static char     g_map[64];
static unsigned short g_beatSeq;
static int      g_ackChapter = -1;
static char     g_chapName[48];
static unsigned g_mapHash;
static int      g_chapter = -1;
static unsigned g_loot, g_broken;
static AObj     g_progWorld;
static unsigned g_lastLocalMs;
static unsigned g_lastBeatMs;
static unsigned g_quietSince;
static unsigned g_ckptSuppressMs;
static unsigned g_travelSuppressMs;
static unsigned g_mismatchSince;
static unsigned g_followedMs;
static int      g_localDown;
static int      g_peerDown;
static int      g_diverge;
static int      g_mapAsked;
static unsigned g_lastArmMs;
static int      g_armGoto;
static int      g_armReload;
static int      g_doLoadChapter = -1;
static int      g_doLoadCheckpoint;
static unsigned g_lastCkptMs;
static unsigned g_lastTravelMs;
static int      g_lastTravelChapter = -1;
static int      g_loading;

int prog_peer_down(void) { return g_peerDown; }
int prog_local_down(void) { return g_localDown; }
int prog_diverge_level(void) { return g_diverge; }
const char *prog_map_name(void) { return g_map[0] ? g_map : "?"; }
int prog_chapter(void) { return g_chapter; }

static AObj game_info(void) {
    AObj gi = 0;
    if (g_worldInfo) A->read_raw(g_worldInfo, O_WI_GAME, &gi, 4);
    return gi;
}

static AObj cp_manager(void) {
    AObj gi = game_info(), cpm = 0;
    if (!gi) return 0;
    A->read_raw(gi, O_GI_CPMANAGER, &cpm, 4);
    return cpm;
}

static AObj alice_engine(void) {
    static AObj cached;
    AObj p = 0, o;
    if (cached && guard_obj_ok(cached)) return cached;
    cached = 0;
    if (!g_localPC) return 0;
    if (!A->read_raw(g_localPC, O_PC_PLAYER, &p, 4) || !p) return 0;
    o = A->get_outer(p);
    if (o && A->is_a(o, "AliceGameEngine")) cached = o;
    return cached;
}

static int fstring_read(AObj owner, int off, char *out, int cap) {
    unsigned d[3];
    unsigned short w[64];
    int i, n;

    if (!out || cap <= 0) return 0;
    out[0] = 0;
    if (!A->read_raw(owner, off, d, 12)) return 0;
    n = (int)d[1];
    if (!d[0] || n <= 0) return 0;
    if (n > 64) n = 64;
    if (n > cap - 1) n = cap - 1;
    if (!A->read_raw((AObj)(ULONG_PTR)d[0], 0, w, n * 2)) return 0;
    for (i = 0; i < n && w[i]; i++) out[i] = (w[i] < 0x80) ? (char)w[i] : '?';
    out[i] = 0;
    return i > 0;
}

static void map_refresh(void) {
    char nm[64];
    ACall c;

    if (g_mapAsked || !g_worldInfo) return;
    if (!A->call_ready || !A->call_ready()) return;
    g_mapAsked = 1;
    c = A->call_begin(g_worldInfo, "GetMapName");
    if (!c) { coop_log("coop: session - GetMapName introuvable, carte inconnue"); return; }
    A->call_arg_bool(c, "bIncludePrefix", 0);
    A->call_invoke(c);
    nm[0] = 0;
    A->call_out_str(c, "ReturnValue", nm, (int)sizeof nm);
    A->call_end(c);
    if (!nm[0]) { coop_log("coop: session - GetMapName n'a rien rendu"); return; }
    lstrcpynA(g_map, nm, sizeof g_map);
    g_mapHash = (unsigned)(fnv1a64(g_map) & 0xffffffffu);
    coop_log("coop: session - carte '%s' (empreinte %08x)", g_map, g_mapHash);
}

static void chapter_refresh(void) {
    AObj cpm = cp_manager();
    unsigned char b = 0;
    int ch;

    if (!cpm) return;
    if (!A->read_raw(cpm, O_CPM_LASTCHECKPOINT, &b, 1)) return;
    ch = (int)b;
    if (ch >= CPM_CHAPTERS) return;
    if (ch == g_chapter) return;
    g_chapter = ch;
    g_chapName[0] = 0;
    fstring_read(cpm, O_CPM_CHAPTERNAME + ch * CPM_FSTRING, g_chapName, sizeof g_chapName);
    coop_log("coop: session - chapitre %d '%s'", g_chapter, g_chapName[0] ? g_chapName : "?");
}

static int engine_busy(void) {
    AObj age = alice_engine();
    unsigned char b = 0;
    if (!age) return 0;
    if (!A->read_raw(age, O_AGE_PENDINGACTION, &b, 1)) return 0;
    return b ? 1 : 0;
}

int prog_loading(void) { return g_loading; }

static unsigned char phase_now(void) {
    unsigned char p = 0;
    if (prog_loading())        p |= PH_LOADING;
    if (cine_local_active())   p |= PH_CINE;
    if (g_localDown)           p |= PH_DOWN;
    if (cine_playing_count())  p |= PH_MATINEE;
    if (g_cfg.mirror_world)    p |= PH_MIRROR;
    return p;
}

static void beat_send(void) {
    SessBody sb;
    if (!g_net.pinned) return;
    world_progress(&g_loot, &g_broken);
    sb.map_hash = g_mapHash;
    sb.seq      = ++g_beatSeq;
    sb.epoch    = g_epoch;
    sb.world_s  = (unsigned short)(g_worldTime > 65000.0f ? 65000 : (unsigned short)g_worldTime);
    sb.loot     = (unsigned short)(g_loot > 65535 ? 65535 : g_loot);
    sb.broken   = (unsigned short)(g_broken > 65535 ? 65535 : g_broken);
    sb.chapter  = (unsigned char)(g_chapter < 0 ? 255 : g_chapter);
    sb.phase    = phase_now();
    net_ev_add(CEV_SESSION, 0, LANE_LOOSE, EF_NOECHO, &sb, (int)sizeof sb);
    g_pstat.beats_out++;
}

static void apply_session(const CoopEvent *e, const void *p, int n) {
    SessBody sb;
    (void)e;
    if (n < (int)sizeof sb) return;
    memcpy(&sb, p, sizeof sb);
    if (g_peerSess.have && (short)(sb.seq - g_peerSess.seq) <= 0) return;
    g_peerSess.seq      = sb.seq;
    g_peerSess.have     = 1;
    g_peerSess.ms       = GetTickCount();
    g_peerSess.map_hash = sb.map_hash;
    g_peerSess.epoch    = sb.epoch;
    g_peerSess.world_s  = sb.world_s;
    g_peerSess.loot     = sb.loot;
    g_peerSess.broken   = sb.broken;
    g_peerSess.chapter  = sb.chapter;
    g_peerSess.phase    = sb.phase;
    g_pstat.beats_in++;
}

static int load_chapter(int chapter) {
    AObj cpm = cp_manager();
    ACall c;
    if (!cpm || chapter < 0 || chapter >= CPM_CHAPTERS) return 0;
    c = A->call_begin(cpm, "LoadChapter");
    if (!c) return 0;
    A->call_arg_int(c, "beLoadedCharpter", chapter);
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static int load_checkpoint(void) {
    ACall c;
    if (!g_localPC) return 0;
    c = A->call_begin(g_localPC, "LoadCheckpoint");
    if (!c) return 0;
    A->call_invoke(c);
    A->call_end(c);
    return 1;
}

static void travel_local(AObj op) {
    TravelBody tb;
    unsigned char ch = 0;
    unsigned now = GetTickCount();

    if (!A->read_raw(op, O_CHAPTERPT_NAME, &ch, 1)) return;
    if (ch >= CPM_CHAPTERS) return;
    coop_log("coop: transition locale demandee vers le chapitre %d", (int)ch);
    if (!g_cfg.travel_sync) return;
    if (g_replayDepth) return;
    if (g_travelSuppressMs && (int)(now - g_travelSuppressMs) < 0) return;
    if (!coop_sending()) return;
    tb.map_hash = g_mapHash;
    tb.chapter = ch;
    tb.why = TRV_KISMET;
    g_lastTravelChapter = (int)ch;
    g_lastTravelMs = now;
    if (!net_ev_add(CEV_TRAVEL_REQ, 0, LANE_SESSION, 0, &tb, (int)sizeof tb)) return;
    g_pstat.travel_out++;
    coop_log("coop: >> TRAJET chapitre %d annonce au pair", (int)ch);
}

static void apply_travel_req(const CoopEvent *e, const void *p, int n) {
    TravelBody tb;
    (void)e;
    if (n < (int)sizeof tb) return;
    memcpy(&tb, p, sizeof tb);
    g_pstat.travel_in++;
    if (!g_cfg.travel_sync) {
        coop_log("coop: !! TRAJET chapitre %d ignore (travel_sync eteint)", (int)tb.chapter);
        return;
    }
    if (tb.chapter == (unsigned char)g_chapter && tb.map_hash == g_mapHash) {
        coop_log("coop: == TRAJET chapitre %d, deja au meme endroit", (int)tb.chapter);
        return;
    }
    if ((int)tb.chapter == g_lastTravelChapter &&
        GetTickCount() - g_lastTravelMs < TRAVEL_SUPPRESS) {
        coop_log("coop: == TRAJET chapitre %d, deja en route de notre cote", (int)tb.chapter);
        return;
    }
    g_doLoadChapter = (int)tb.chapter;
}

static void apply_travel_ack(const CoopEvent *e, const void *p, int n) {
    TravelBody tb;
    (void)e;
    if (n < (int)sizeof tb) return;
    memcpy(&tb, p, sizeof tb);
    coop_log("coop: le pair a confirme le trajet vers le chapitre %d", (int)tb.chapter);
}

static void ckpt_emit(int kind) {
    CkptBody cb;
    if (!coop_sending()) return;
    cb.kind = (unsigned char)kind;
    cb.chapter = (unsigned char)(g_chapter < 0 ? 255 : g_chapter);
    if (!net_ev_add(CEV_CKPT_HOLD, 0, LANE_SESSION, 0, &cb, (int)sizeof cb)) return;
    g_pstat.ckpt_out++;
}

static void hook_ckpt_load(AEvent *e) {
    unsigned now = GetTickCount();
    (void)e;
    g_lastCkptMs = now;
    if (g_ckptSuppressMs && (int)(now - g_ckptSuppressMs) < 0) {
        g_ckptSuppressMs = 0;
        coop_log("coop: checkpoint recharge sur ordre du pair, rien renvoye");
        return;
    }
    coop_log("coop: checkpoint recharge localement, le monde est revenu en arriere");
    ckpt_emit(CKP_LOAD);
}

static void apply_ckpt(const CoopEvent *e, const void *p, int n) {
    CkptBody cb;
    (void)e;
    if (n < (int)sizeof cb) return;
    memcpy(&cb, p, sizeof cb);
    g_pstat.ckpt_in++;
    if (cb.kind == CKP_SAVE) {
        coop_log("coop: le pair a enregistre un checkpoint (chapitre %d)", (int)cb.chapter);
        return;
    }
    if (g_lastCkptMs && GetTickCount() - g_lastCkptMs < CKPT_SUPPRESS / 2) {
        coop_log("coop: == checkpoint, nous venons de recharger aussi");
        return;
    }
    if (!g_cfg.ckpt_follow) {
        g_pstat.warned++;
        coop_log("coop: !! le pair a recharge un checkpoint et pas nous - les mondes divergent "
                 "(activez 'Suivre les checkpoints' ou Ctrl+Maj+P)");
        return;
    }
    g_doLoadCheckpoint = 1;
}

static void hook_activated(AEvent *e) {
    const char *cls;
    if (!e->self) return;
    cls = A->class_of(e->self);
    if (!cls) return;
    if (strcmp(cls, "SeqAct_Chapterpoint") == 0) { travel_local(e->self); return; }
    if (strcmp(cls, "SeqAct_Checkpoint") == 0 && !g_replayDepth) ckpt_emit(CKP_SAVE);
}

static void down_set(int down) {
    DownBody db;
    int lvl = 0, hp = 0;

    if (down == g_localDown) return;
    g_localDown = down;
    if (g_localPawn) A->read_raw(g_localPawn, O_PAWN_HEALTH, &hp, 4);
    if (g_localPC) {
        unsigned char b = 0;
        if (A->read_raw(g_localPC, O_APC_RESPAWNLEVEL, &b, 1)) lvl = b;
    }
    coop_log("coop: joueur local %s (respawn niveau %d, vie %d)",
             down ? "A TERRE" : "de retour", lvl, hp);
    if (!g_cfg.death_notify || !coop_sending()) return;
    db.level = (unsigned char)lvl;
    db.health = (short)hp;
    net_ev_add(down ? CEV_PLAYER_DOWN : CEV_PLAYER_REVIVE, 0, LANE_SESSION, 0,
               &db, (int)sizeof db);
    g_pstat.down_out++;
}

static void hook_begin_state(AEvent *e) {
    const char *st;
    AObj owner;
    if (e->self != g_localPC || !e->func) return;
    owner = A->get_outer(e->func);
    st = owner ? A->name_of(owner) : 0;
    if (!st) return;
    if (strcmp(st, "Dead") == 0) down_set(1);
    else if (g_localDown) down_set(0);
}

static void hook_respawn(AEvent *e) {
    if (e->self != g_localPC) return;
    down_set(0);
}

static void apply_down(const CoopEvent *e, const void *p, int n) {
    DownBody db;
    int down = (e->type == CEV_PLAYER_DOWN);
    if (n < (int)sizeof db) { db.level = 0; db.health = 0; }
    else memcpy(&db, p, sizeof db);
    if (down == g_peerDown) return;
    g_peerDown = down;
    g_pstat.down_in++;
    ghost_hide(GH_DOWN, down);
    coop_log("coop: le pair est %s (respawn niveau %d)",
             down ? "A TERRE" : "de retour", (int)db.level);
}

static void apply_resync(const CoopEvent *e, const void *p, int n) {
    ResyncBody rb;
    (void)e;
    if (n < (int)sizeof rb) return;
    memcpy(&rb, p, sizeof rb);
    if (rb.kind == RSY_ASK) {
        g_lastBeatMs = 0;
        coop_log("coop: le pair demande un point de situation");
        return;
    }
    g_pstat.resync_in++;
    g_doLoadCheckpoint = 1;
    coop_log("coop: le pair demande un rechargement de checkpoint des deux cotes");
}

static void prog_event(const CoopEvent *e, const void *payload, int n) {
    switch (e->type) {
    case CEV_SESSION:       apply_session(e, payload, n);    return;
    case CEV_TRAVEL_REQ:    apply_travel_req(e, payload, n); return;
    case CEV_TRAVEL_ACK:    apply_travel_ack(e, payload, n); return;
    case CEV_CKPT_HOLD:     apply_ckpt(e, payload, n);       return;
    case CEV_PLAYER_DOWN:   apply_down(e, payload, n);       return;
    case CEV_PLAYER_REVIVE: apply_down(e, payload, n);       return;
    case CEV_RESYNC:        apply_resync(e, payload, n);     return;
    default: return;
    }
}

int prog_goto_peer(void) {
    if (!g_peerSess.have || g_peerSess.chapter >= CPM_CHAPTERS) {
        coop_log("coop: impossible de rejoindre le pair, son chapitre est inconnu");
        return 0;
    }
    if ((int)g_peerSess.chapter == g_chapter) {
        coop_log("coop: deja sur le chapitre du pair (%d)", (int)g_peerSess.chapter);
        return 0;
    }
    g_followedMs = GetTickCount();
    g_doLoadChapter = (int)g_peerSess.chapter;
    {
        AObj cpm = cp_manager();
        char target[48];
        target[0] = 0;
        if (cpm) fstring_read(cpm, O_CPM_MAPNAME + (int)g_peerSess.chapter * CPM_FSTRING,
                              target, (int)sizeof target);
        coop_log("coop: chargement du chapitre %d (carte '%s') pour rejoindre le pair",
                 (int)g_peerSess.chapter, target[0] ? target : "?");
    }
    return 1;
}

int prog_reload_both(void) {
    ResyncBody rb;
    rb.kind = RSY_RELOAD;
    if (coop_sending()) {
        net_ev_add(CEV_RESYNC, 0, LANE_SESSION, 0, &rb, (int)sizeof rb);
        g_pstat.resync_out++;
    }
    g_doLoadCheckpoint = 1;
    coop_log("coop: rechargement du checkpoint demande des deux cotes");
    return 1;
}

static void prog_release_holds(void) {
    g_ackChapter = -1;
    g_doLoadChapter = -1;
    g_doLoadCheckpoint = 0;
    g_armGoto = 0;
    g_armReload = 0;
    g_lastArmMs = 0;
}

static void prog_actions(unsigned now) {
    if (g_doLoadChapter >= 0) {
        int ch = g_doLoadChapter;
        g_doLoadChapter = -1;
        g_travelSuppressMs = now + TRAVEL_SUPPRESS;
        g_lastTravelChapter = ch;
        g_lastTravelMs = now;
        if (load_chapter(ch)) {
            g_ackChapter = ch;
            coop_log("coop: << chargement du chapitre %d lance", ch);
        } else {
            coop_log("coop: !! LoadChapter indisponible, chapitre %d non charge", ch);
        }
    }
    if (g_doLoadCheckpoint) {
        g_doLoadCheckpoint = 0;
        g_ckptSuppressMs = now + CKPT_SUPPRESS;
        if (load_checkpoint()) {
            coop_log("coop: << checkpoint recharge");
        } else {
            g_ckptSuppressMs = 0;
            coop_log("coop: !! LoadCheckpoint indisponible, rechargement impossible");
        }
    }
}

static void prog_quiet(unsigned now) {
    unsigned age;

    if (!g_net.up || !g_net.pinned) {
        if (g_peerQuiet) {
            g_peerQuiet = 0;
            ghost_hide(GH_QUIET, 0);
        }
        return;
    }
    age = now - g_net.last_rx_ms;
    if (!g_peerQuiet) {
        if (age <= (unsigned)g_cfg.peer_timeout_ms) return;
        g_peerQuiet = 1;
        g_quietSince = now;
        g_pstat.quiet++;
        ghost_hide(GH_QUIET, 1);
        prog_release_holds();
        world_release_holds("pair muet");
        coop_log("coop: le pair est muet depuis %u ms - emission suspendue, fantome masque", age);
        return;
    }
    if (age < 1000) {
        g_peerQuiet = 0;
        ghost_hide(GH_QUIET, 0);
        coop_log("coop: le pair est revenu apres %u ms", now - g_quietSince);
        coop_epoch_bump("retour du pair");
        return;
    }
    if (g_ghost.obj && !g_loading && now - g_quietSince > (unsigned)g_cfg.ghost_drop_ms) {
        coop_log("coop: silence prolonge du pair, fantome relache");
        ghost_release(1);
    }
}

static void prog_diverge_eval(unsigned now) {
    int lvl = 0;

    if (!g_peerSess.have || now - g_peerSess.ms > 6000 || g_peerQuiet) {
        g_mismatchSince = 0;
        if (g_diverge) { g_diverge = 0; }
        return;
    }
    if (g_mapHash && g_peerSess.map_hash && g_peerSess.map_hash != g_mapHash) lvl = 3;
    else if (g_chapter >= 0 && g_peerSess.chapter < CPM_CHAPTERS &&
             (int)g_peerSess.chapter != g_chapter) lvl = 2;
    else {
        int dl = (int)g_peerSess.loot - (int)g_loot;
        int db = (int)g_peerSess.broken - (int)g_broken;
        if (dl < 0) dl = -dl;
        if (db < 0) db = -db;
        if (dl > g_cfg.desync_tol || db > g_cfg.desync_tol) lvl = 1;
    }

    if (!lvl) {
        if (g_diverge) coop_log("coop: les deux mondes sont de nouveau d'accord");
        g_diverge = 0;
        g_mismatchSince = 0;
        return;
    }
    if (!g_mismatchSince) g_mismatchSince = now;
    if (lvl >= 2 && now - g_mismatchSince < (unsigned)g_cfg.travel_grace_ms) return;
    if (prog_loading() || (g_peerSess.phase & PH_LOADING)) return;

    if (lvl != g_diverge) {
        g_diverge = lvl;
        g_pstat.warned++;
        if (lvl == 3)
            coop_log("coop: !! DESYNCHRO - cartes differentes (moi %08x, pair %08x)",
                     g_mapHash, g_peerSess.map_hash);
        else if (lvl == 2)
            coop_log("coop: !! DESYNCHRO - chapitres differents (moi %d, pair %d)",
                     g_chapter, (int)g_peerSess.chapter);
        else
            coop_log("coop: !! DESYNCHRO - progression differente (butin %u/%u, casse %u/%u)",
                     g_loot, (unsigned)g_peerSess.loot, g_broken, (unsigned)g_peerSess.broken);
    }
    if (lvl >= 2 && g_cfg.travel_follow && !g_net.host &&
        now - g_followedMs > (unsigned)g_cfg.travel_grace_ms)
        prog_goto_peer();
}

static void prog_arm(unsigned now) {
    if (!g_lastArmMs) return;
    if (now - g_lastArmMs < 3000) return;
    if (g_armGoto || g_armReload) coop_log("coop: demande de resynchronisation annulee (delai passe)");
    g_armGoto = 0;
    g_armReload = 0;
    g_lastArmMs = 0;
}

void prog_request_goto(void) {
    unsigned now = GetTickCount();
    if (g_armGoto && now - g_lastArmMs < 3000) {
        g_armGoto = 0;
        g_lastArmMs = 0;
        prog_goto_peer();
        return;
    }
    g_armGoto = 1;
    g_armReload = 0;
    g_lastArmMs = now;
    coop_log("coop: appuyez de nouveau sur Ctrl+Maj+G dans les 3 s pour charger le chapitre du pair");
}

void prog_request_reload(void) {
    unsigned now = GetTickCount();
    if (g_armReload && now - g_lastArmMs < 3000) {
        g_armReload = 0;
        g_lastArmMs = 0;
        prog_reload_both();
        return;
    }
    g_armReload = 1;
    g_armGoto = 0;
    g_lastArmMs = now;
    coop_log("coop: appuyez de nouveau sur Ctrl+Maj+P dans les 3 s pour recharger le checkpoint "
             "des deux cotes");
}

void prog_frame(unsigned now) {
    g_loading = g_worldLoading || engine_busy();
    if (!g_net.up) return;

    if (g_worldInfo && g_worldInfo != g_progWorld) {
        g_progWorld = g_worldInfo;
        g_mapAsked = 0;
        g_map[0] = 0;
        g_mapHash = 0;
        g_chapter = -1;
        g_chapName[0] = 0;
        g_mismatchSince = 0;
        g_diverge = 0;
        g_localDown = 0;
    }
    if (!g_loading) prog_actions(now);
    if (now - g_lastLocalMs >= PROG_LOCAL_MS) {
        g_lastLocalMs = now;
        map_refresh();
        chapter_refresh();
    }

    if (g_ackChapter >= 0 && coop_sending()) {
        TravelBody tb;
        tb.map_hash = g_mapHash;
        tb.chapter = (unsigned char)g_ackChapter;
        tb.why = TRV_KISMET;
        if (net_ev_add(CEV_TRAVEL_ACK, 0, LANE_SESSION, 0, &tb, (int)sizeof tb))
            g_ackChapter = -1;
    }

    prog_arm(now);
    prog_quiet(now);

    if (g_cfg.prog_beat_ms > 0 && now - g_lastBeatMs >= (unsigned)g_cfg.prog_beat_ms) {
        g_lastBeatMs = now;
        beat_send();
        prog_diverge_eval(now);
    }
}

void prog_hooks_install(void) {
    net_ev_subscribe(CEV_SESSION, prog_event);
    net_ev_subscribe(CEV_TRAVEL_REQ, prog_event);
    net_ev_subscribe(CEV_TRAVEL_ACK, prog_event);
    net_ev_subscribe(CEV_CKPT_HOLD, prog_event);
    net_ev_subscribe(CEV_PLAYER_DOWN, prog_event);
    net_ev_subscribe(CEV_PLAYER_REVIVE, prog_event);
    net_ev_subscribe(CEV_RESYNC, prog_event);

    A->on("Activated", hook_activated);
    A->on("PostLoadCheckpoint", hook_ckpt_load);
    A->on("BeginState", hook_begin_state);
    A->on("RespawnAlice", hook_respawn);
}

void prog_reset(void) {
    g_peerDown = 0;
    g_localDown = 0;
    g_diverge = 0;
    g_mismatchSince = 0;
    g_peerSess.have = 0;
    prog_release_holds();
    ghost_hide(GH_DOWN, 0);
}

int prog_banner(char *out, int cap, unsigned *argb) {
    if (!out || cap <= 0) return 0;
    if (g_peerQuiet) {
        lstrcpynA(out, "PAIR MUET - en attente de son retour", cap);
        *argb = 0xFFE8836Bu;
        return 1;
    }
    if (g_diverge >= 2) {
        wsprintfA(out, "DESYNCHRO - chapitre %d ici, %d chez le pair  (Ctrl+Maj+G)",
                  g_chapter, (int)g_peerSess.chapter);
        *argb = 0xFFE8836Bu;
        return 1;
    }
    if (g_peerDown && g_localDown) {
        lstrcpynA(out, "LES DEUX A TERRE", cap);
        *argb = 0xFFE8C36Bu;
        return 1;
    }
    if (g_peerDown) {
        lstrcpynA(out, "PAIR A TERRE", cap);
        *argb = 0xFFE8C36Bu;
        return 1;
    }
    if (g_diverge == 1) {
        lstrcpynA(out, "progression differente entre les deux mondes", cap);
        *argb = 0xFFE8C36Bu;
        return 1;
    }
    if (g_peerSess.have && (g_peerSess.phase & PH_LOADING)) {
        lstrcpynA(out, "le pair charge...", cap);
        *argb = 0xFFBFC4D0u;
        return 1;
    }
    return 0;
}

void prog_summary(void) {
    coop_log("coop: --- bilan de session ---");
    coop_log("coop: moi   carte '%s' (%08x) chapitre %d '%s' epoque %u",
             g_map[0] ? g_map : "?", g_mapHash, g_chapter,
             g_chapName[0] ? g_chapName : "?", (unsigned)g_epoch);
    if (g_peerSess.have)
        coop_log("coop: pair  carte %08x chapitre %d epoque %u  il y a %u ms  phase %02x",
                 g_peerSess.map_hash, (int)g_peerSess.chapter, (unsigned)g_peerSess.epoch,
                 GetTickCount() - g_peerSess.ms, (unsigned)g_peerSess.phase);
    else
        coop_log("coop: pair  aucun point de situation recu");
    coop_log("coop: progression butin %u/%u  casse %u/%u  divergence niveau %d",
             g_loot, (unsigned)g_peerSess.loot, g_broken, (unsigned)g_peerSess.broken, g_diverge);
    coop_log("coop: battements e%u r%u  trajets e%u r%u  checkpoints e%u r%u",
             g_pstat.beats_out, g_pstat.beats_in, g_pstat.travel_out, g_pstat.travel_in,
             g_pstat.ckpt_out, g_pstat.ckpt_in);
    coop_log("coop: morts e%u r%u  resynchro e%u r%u  silences %u  alertes %u",
             g_pstat.down_out, g_pstat.down_in, g_pstat.resync_out, g_pstat.resync_in,
             g_pstat.quiet, g_pstat.warned);
    coop_log("coop: cinematiques debuts e%u r%u  fins e%u r%u  recalages e%u a%u  refus %u",
             g_cstat.start_out, g_cstat.start_in, g_cstat.stop_out, g_cstat.stop_in,
             g_cstat.sync_out, g_cstat.aligned, g_cstat.refused);
    coop_log("coop: --- fin du bilan ---");
}

void prog_panel(void) {
    char line[160];

    A->ui_checkbox("Annoncer les transitions de chapitre  (Ctrl+Maj+T)", &g_cfg.travel_sync);
    A->ui_checkbox("Suivre le pair s'il part ailleurs", &g_cfg.travel_follow);
    A->ui_checkbox("Suivre les rechargements de checkpoint  (Ctrl+Maj+N)", &g_cfg.ckpt_follow);
    A->ui_checkbox("Annoncer les morts", &g_cfg.death_notify);
    A->ui_slider_int("Battement de session (ms)", &g_cfg.prog_beat_ms, 250, 5000);
    A->ui_slider_int("Delai avant alerte de carte (ms)", &g_cfg.travel_grace_ms, 1000, 30000);
    A->ui_slider_int("Silence tolere du pair (ms)", &g_cfg.peer_timeout_ms, 2000, 30000);
    A->ui_slider_int("Largage du fantome apres (ms)", &g_cfg.ghost_drop_ms, 3000, 120000);
    A->ui_slider_int("Ecart de progression tolere", &g_cfg.desync_tol, 0, 40);

    wsprintfA(line, "moi  %s  chapitre %d %s", g_map[0] ? g_map : "?", g_chapter,
              g_chapName[0] ? g_chapName : "");
    A->ui_label(line);
    if (g_peerSess.have)
        wsprintfA(line, "pair carte %08x  chapitre %d  il y a %u ms", g_peerSess.map_hash,
                  (int)g_peerSess.chapter, GetTickCount() - g_peerSess.ms);
    else
        lstrcpynA(line, "pair aucun point de situation", sizeof line);
    A->ui_label(line);
    wsprintfA(line, "butin %u/%u   casse %u/%u   divergence %d", g_loot,
              (unsigned)g_peerSess.loot, g_broken, (unsigned)g_peerSess.broken, g_diverge);
    A->ui_label(line);
    wsprintfA(line, "local %s   pair %s   chargement %s",
              g_localDown ? "A TERRE" : "debout", g_peerDown ? "A TERRE" : "debout",
              prog_loading() ? "EN COURS" : "non");
    A->ui_label(line);

    if (A->ui_button("Rejoindre le chapitre du pair  (Ctrl+Maj+G)")) prog_request_goto();
    if (A->ui_button("Recharger le checkpoint des deux cotes  (Ctrl+Maj+P)")) prog_request_reload();
    if (A->ui_button("Bilan de session dans le journal  (Ctrl+Maj+B)")) prog_summary();
}
