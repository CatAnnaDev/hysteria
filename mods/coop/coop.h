#ifndef COOP_H
#define COOP_H

#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

#include "hysteria_api.h"
#include "coop_offsets.h"
#include "coop_proto.h"

#define URU_TO_RAD (6.2831853071795865f / 65536.0f)
#define COOP_PI    3.14159265358979f

extern HysteriaAPI *A;

typedef struct {
    int   role;
    int   listen_port;
    int   peer_ip[4];
    int   peer_port;
    int   discover_lan;
    int   ghost_mode;
    int   delay_ms;
    int   rate_hz;
    int   plate;
    float plate_max_m;
    int   mirror_world;
    float z_adjust;
    int   safe_mode;
    int   diag;
    int   key_repair;
    int   defer_ttl_ms;
    int   lane_gap_ms;
    int   echo_ttl_ms;
    int   mirror_kismet;
    int   mirror_trigger;
    int   kismet_probe;
    int   kismet_force;
    int   mirror_decor;
    int   mirror_mover;
    int   mirror_npc;
    int   mirror_loot;
    int   mirror_vo;
    int   mirror_msg;
    int   vo_dedup_ms;
    int   log_events;
    int   mirror_cine;
    int   cine_ghost;
    int   cine_force;
    int   cine_sync_ms;
    int   cine_drift_ms;
    int   travel_sync;
    int   travel_follow;
    int   travel_grace_ms;
    int   ckpt_follow;
    int   death_notify;
    int   peer_timeout_ms;
    int   ghost_drop_ms;
    int   desync_tol;
    int   prog_beat_ms;
    char  nickname[24];
} CoopCfg;

extern CoopCfg g_cfg;

void cfg_load_all(void);
void cfg_flush(void);
void cfg_set_nickname(const char *s);

typedef struct {
    int                up;
    int                host;
    int                pinned;
    int                bound_port;
    unsigned long long self_id;
    unsigned long long peer_id;
    struct sockaddr_in peer;
    unsigned           sent, recvd, bad, resent, dropped;
    unsigned           evsent, evrecv, replayed, unresolved, deferred, resolved;
    unsigned           stale, reordered, lane_skip, echo_swallowed, repaired, mismatch;
    unsigned           rtt_ms;
    unsigned           last_rx_ms;
    unsigned short     peer_epoch;
    char               peer_name[24];
} CoopNet;

extern CoopNet g_net;

int  net_open(void);
void net_close(void);
void net_pump(unsigned now, float world_time);
int  net_send_state(const CoopState *s, float world_time);
void net_send_bye(void);
void net_send_digest(const void *body, int n);
void net_set_peer(const char *ip, int port);

typedef void (*CoopEvCb)(const CoopEvent *e, const void *payload, int n);

void net_ev_begin(void);
int  net_ev_add(int type, unsigned long long key, int lane, unsigned flags,
                const void *payload, int n);
void net_ev_flush(void);
int  net_ev_now(int type, unsigned long long key, int lane, unsigned flags,
                const void *payload, int n);
int  net_ev_subscribe(int type, CoopEvCb cb);
void net_ev_dispatch(const CoopEvent *e, const void *payload, int n);
void net_ev_dispatch_deferred(const CoopEvent *e, const void *payload, int n);
void net_epoch_reset(void);
void net_send_event(int type, unsigned long long key, const void *payload, int n);

void on_state_packet(const CoopState *s, float remote_t, float local_t);
void on_digest_packet(const void *payload, int n);

unsigned long long coop_key_raw(AObj o);
unsigned long long coop_emit_obj(int type, AObj o, int lane, unsigned flags,
                                 const void *payload, int n);
unsigned long long coop_key(AObj o);
void coop_key_flush(void);
void coop_key_remember(AObj o, unsigned long long key);
AObj coop_key_resolve(unsigned long long key);
int  coop_need_obj(const CoopEvent *e, const void *payload, int n, AObj *out);
void coop_key_defer_pump(unsigned now);
void coop_key_epoch_reset(void);
void coop_key_audit(void);
void coop_witness_make(AObj o, CoopWitness *w);
int  coop_witness_read(const CoopEvent *e, const void *payload, int n, CoopWitness *w);
int  coop_witness_check(const CoopEvent *e, const void *payload, int n, AObj o, float max_uu);
unsigned short coop_class_tag(AObj o);

extern int            g_replayDepth;
extern unsigned short g_epoch;

#define COOP_REPLAY_BEGIN() (++g_replayDepth)
#define COOP_REPLAY_END()   (--g_replayDepth)

void echo_arm(unsigned long long key, int tag, unsigned ttl_ms);
int  echo_take(unsigned long long key, int tag);
void echo_pump(unsigned now);
void echo_clear(void);
int  done_test(unsigned long long key, int type);
void done_mark(unsigned long long key, int type);
void done_clear(void);
void coop_epoch_bump(const char *why);
void coop_epoch_adopt(unsigned short e);

typedef struct {
    int   have;
    float t;
    CoopState s;
} CoopSample;

extern CoopState g_peerState;
extern int       g_peerStateValid;
extern float     g_peerLastT;
extern int       g_extrapolating;

int  state_sample(AObj pawn, CoopState *s);
void state_push(float t, const CoopState *s);
int  state_at(float t, CoopState *out, float vel_out[3]);
void state_apply(AObj ghost, const CoopState *s);
void state_unpack_bits(AObj g, unsigned bits);
unsigned state_pack_bits(AObj pawn);
void state_reset(void);
void clock_update(float remote_t, float local_t);
float clock_render_time(float local_t);

typedef struct {
    AObj  obj;
    int   armed;
    int   mode;
    int   ready;
    int   fails;
    int   stolen;
    int   adopted;
    int   objIndex;
    AObj  cls;
    unsigned last_try_ms;
    float pos[3];
    char  name[48];
    char  how[48];
} CoopGhost;

extern CoopGhost g_ghost;

void ghost_frame(float dt, float render_t);
int  ghost_arm(int mode);
void ghost_release(int quiet);
void ghost_drop(void);
void ghost_bump_adopt_index(void);
int  ghost_valid(void);
void ghost_set_physics_mode(int mode);
void ghost_hooks_install(void);
void ghost_forget_recipe(void);

enum { GH_CINE = 1, GH_DOWN = 2, GH_QUIET = 4 };
void ghost_hide(int reason, int on);
void actor_set_physics(AObj a, int phys);
int  ghost_hidden(void);

void anim_frame(const CoopState *s, float dt);
void anim_reset(void);

void world_hooks_install(void);
void world_frame(unsigned now);
void world_apply_event(const CoopEvent *e, const void *payload, int n);
void world_reset(void);
void world_send_name(void);
void world_release_holds(const char *why);
void world_panel(void);

typedef struct {
    unsigned kismet_out, kismet_in;
    unsigned decor_out, decor_in;
    unsigned loot_out, loot_in;
    unsigned vo_out, vo_in;
    unsigned refused, dedup;
} CoopWorldStat;

extern CoopWorldStat g_wstat;

void world_progress(unsigned *loot, unsigned *broken);

typedef struct {
    unsigned start_out, start_in;
    unsigned stop_out, stop_in;
    unsigned sync_out, aligned;
    unsigned refused;
} CoopCineStat;

extern CoopCineStat g_cstat;

void cine_hooks_install(void);
void cine_frame(unsigned now);
void cine_reset(void);
void cine_panel(void);
int  cine_local_active(void);
int  cine_playing_count(void);

#define PH_LOADING 0x01u
#define PH_CINE    0x02u
#define PH_DOWN    0x04u
#define PH_MATINEE 0x08u
#define PH_MIRROR  0x10u

typedef struct {
    int            have;
    unsigned       ms;
    unsigned       map_hash;
    unsigned short seq, epoch, world_s, loot, broken;
    unsigned char  chapter, phase;
} CoopSess;

extern CoopSess g_peerSess;

typedef struct {
    unsigned beats_out, beats_in;
    unsigned travel_out, travel_in;
    unsigned ckpt_out, ckpt_in;
    unsigned down_out, down_in;
    unsigned resync_out, resync_in;
    unsigned quiet, warned;
} CoopProgStat;

extern CoopProgStat g_pstat;

void prog_hooks_install(void);
void prog_frame(unsigned now);
void prog_reset(void);
void prog_panel(void);
void prog_summary(void);
void prog_request_goto(void);
void prog_request_reload(void);
int  prog_goto_peer(void);
int  prog_reload_both(void);
int  prog_banner(char *out, int cap, unsigned *argb);
int  prog_loading(void);
int  prog_peer_down(void);
int  prog_local_down(void);
int  prog_diverge_level(void);
const char *prog_map_name(void);
int  prog_chapter(void);

typedef struct {
    volatile long ver;
    float cam[3];
    int   rot[3];
    float fov, aspect;
    float head[3];
    float dist, vis;
    int   valid, stale, cinematic, offscreen_ok;
    char  label[48];
} PovSnap;

extern PovSnap g_snap;

void hud_snapshot(float local_t);
void hud_draw(void);

int  guard_offsets_verify(AObj pawn);
void guard_frame_begin(void);
void guard_frame_end(void);
int  guard_writes_allowed(void);
int  coop_sending(void);
int  guard_obj_ok(AObj o);
void guard_panic(void);
void guard_note(const char *what);
extern int g_safe;
extern int g_offsetsOk;
extern int g_peerQuiet;
extern int g_worldLoading;
extern unsigned g_rejects;

void coop_log(const char *fmt, ...);
void coop_log_rate(const char *fmt, ...);

extern AObj  g_localPawn;
extern AObj  g_localPC;
extern AObj  g_worldInfo;
extern float g_worldTime;
extern int   g_gameTickSeen;

#endif
