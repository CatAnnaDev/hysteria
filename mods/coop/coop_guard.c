#include "coop.h"
#include <stdarg.h>

int      g_safe;
int      g_offsetsOk;
unsigned g_rejects;
int      g_peerQuiet;
int      g_worldLoading;

static AObj     g_prevWorld;
static int      g_writesOk;
static unsigned g_lastLogMs;
static unsigned g_noteMs;

void coop_log(const char *fmt, ...) {
    char buf[400];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    buf[sizeof buf - 1] = 0;
    A->log(buf);
}

void coop_log_rate(const char *fmt, ...) {
    char buf[400];
    va_list ap;
    unsigned now = GetTickCount();
    if (now - g_lastLogMs < 1000) return;
    g_lastLogMs = now;
    va_start(ap, fmt);
    vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    buf[sizeof buf - 1] = 0;
    A->log(buf);
}

void guard_note(const char *what) {
    unsigned now = GetTickCount();
    if (now - g_noteMs < 1000) return;
    g_noteMs = now;
    coop_log("coop: %s", what);
}

int guard_offsets_verify(AObj pawn) {
    float a[3], b[3];
    int ra[3], rb[3], h1 = 0, h2 = 0;
    int gv, rv, gr, rr, gh, rh;
    static int reported;

    if (!pawn) return 0;

    gv = A->get_vec(pawn, "Location", a);
    rv = A->read_raw(pawn, O_LOCATION, b, 12);
    gr = A->get_rot(pawn, "Rotation", ra);
    rr = A->read_raw(pawn, O_ROTATION, rb, 12);
    gh = A->get_int(pawn, "Health", &h1);
    rh = A->read_raw(pawn, O_PAWN_HEALTH, &h2, 4);

    if (!reported) {
        reported = 1;
        coop_log("coop: offsets get_vec=%d read_vec=%d get_rot=%d read_rot=%d get_hp=%d read_hp=%d",
                 gv, rv, gr, rr, gh, rh);
        coop_log("coop: Location prop %.1f %.1f %.1f  brut %.1f %.1f %.1f",
                 a[0], a[1], a[2], b[0], b[1], b[2]);
        coop_log("coop: Yaw prop %d brut %d   Health prop %d brut %d", ra[1], rb[1], h1, h2);
    }

    if (!gv || !rv || !gr || !rr || !gh || !rh) return 0;
    if (a[0] != b[0] || a[1] != b[1] || a[2] != b[2]) return 0;
    if (ra[1] != rb[1]) return 0;
    return h1 == h2;
}

int coop_sending(void) {
    return g_net.pinned && !g_peerQuiet && !g_safe && !g_cfg.safe_mode;
}

static int world_busy(AObj wi) {
    AObj gi = 0;
    unsigned f = 0;
    if (!A->read_raw(wi, O_WI_GAME, &gi, 4) || !gi) return 0;
    if (!A->read_raw(gi, O_GI_FLAGS, &f, 4)) return 0;
    return (f & (F_GI_bLevelChange | F_GI_bCheckpointLoad)) ? 1 : 0;
}

int guard_obj_ok(AObj o) {
    if (!o) return 0;
    if (A->version >= 16 && A->is_valid) return A->is_valid(o);
    {
        unsigned f = 0;
        const char *cn = A->class_of(o);
        if (!cn || !cn[0]) return 0;
        if (!A->read_raw(o, O_ACTOR_FLAGS0, &f, 4)) return 0;
        return (f & F_bDeleteMe) ? 0 : 1;
    }
}

void guard_frame_begin(void) {
    AObj wi = A->world_info();
    unsigned pauser = 0;
    unsigned camFlags = 0;
    AObj cam;

    g_writesOk = 0;
    g_worldLoading = 0;
    if (!wi) return;
    g_worldLoading = world_busy(wi);
    if (g_safe || g_cfg.safe_mode) return;

    if (wi != g_prevWorld) {
        g_prevWorld = wi;
        state_reset();
        world_reset();
        cine_reset();
        prog_reset();
        ghost_drop();
        anim_reset();
        coop_epoch_bump("nouveau monde");
        guard_note("nouveau monde, etat remis a zero");
        return;
    }
    if (g_worldLoading) return;
    if (!g_localPawn || !g_localPC) return;
    if (A->read_raw(wi, O_WI_PAUSER, &pauser, 4) && pauser) return;

    cam = A->get_obj(g_localPC, "PlayerCamera");
    if (cam && A->read_raw(cam, O_CAM_FLAGS, &camFlags, 4) && (camFlags & F_bNonGamePlayCamera)) return;

    if (!g_offsetsOk) return;
    g_writesOk = 1;
}

void guard_frame_end(void) {
}

int guard_writes_allowed(void) { return g_writesOk; }

void guard_panic(void) {
    ghost_release(1);
    world_reset();
    state_reset();
    net_send_bye();
    net_close();
    g_safe = 1;
    coop_log("coop: PANIQUE - tout desarme, HUD seul");
}
