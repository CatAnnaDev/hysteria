#ifndef COOP_PROTO_H
#define COOP_PROTO_H

#define COOP_MAGIC    0x50434f41u
#define COOP_VERSION  5
#define COOP_MTU      512

enum {
    COOP_HELLO  = 1,
    COOP_STATE  = 2,
    COOP_EVENT  = 3,
    COOP_ACK    = 4,
    COOP_DIGEST = 5,
    COOP_BYE    = 6
};

enum {
    CEV_NAME          = 1,
    CEV_MAP           = 2,
    CEV_EPOCH         = 3,
    CEV_SPECIAL       = 4,
    CEV_DAMAGE        = 5,
    CEV_DEATH         = 6,
    CEV_LOOT          = 7,
    CEV_BREAK         = 8,
    CEV_MOVER         = 9,
    CEV_CONTEXT       = 10,
    CEV_KISMET        = 11,
    CEV_DRESS         = 12,
    CEV_LAND          = 13,
    CEV_CHECKPOINT    = 14,
    CEV_MATINEE       = 15,
    CEV_CINE          = 16,
    CEV_BINK          = 17,
    CEV_TRIGGER       = 18,
    CEV_PAD           = 19,
    CEV_NPC_DMG       = 20,
    CEV_NPC_DEATH     = 21,
    CEV_NPC_PART      = 22,
    CEV_PLAYER_DOWN   = 23,
    CEV_PLAYER_REVIVE = 24,
    CEV_BOTH_DOWN     = 25,
    CEV_TRAVEL_REQ    = 26,
    CEV_TRAVEL_ACK    = 27,
    CEV_CKPT_HOLD     = 28,
    CEV_BALANCE       = 29,
    CEV_CTXACT        = 30,
    CEV_AIMSWITCH     = 31,
    CEV_HEADSWITCH    = 32,
    CEV_BLOCKPIECE    = 33,
    CEV_BLOCKCMD      = 34,
    CEV_CHESSCMD      = 35,
    CEV_VO_LINE       = 36,
    CEV_VO_KISMET     = 37,
    CEV_VO_REMOTE     = 38,
    CEV_MEMORY        = 39,
    CEV_HUD_MSG       = 40,
    CEV_VOID          = 41,
    CEV_RESYNC        = 42,
    CEV_SESSION       = 43,
    CEV_MAX           = 44
};

enum {
    LANE_LOOSE   = 0,
    LANE_WORLD   = 1,
    LANE_PUZZLE  = 2,
    LANE_SESSION = 3,
    LANE_COUNT   = 4
};

#define EF_LANE_MASK 0x07u
#define EF_CANONICAL 0x08u
#define EF_ONCE      0x10u
#define EF_WITNESS   0x20u
#define EF_NEEDACK   0x40u
#define EF_NOECHO    0x80u

#pragma pack(push, 1)

typedef struct {
    unsigned           magic;
    unsigned char      version;
    unsigned char      msg;
    unsigned short     len;
    unsigned           seq;
    unsigned           rel_id;
    unsigned           rel_ack;
    unsigned long long rel_mask;
    unsigned short     epoch;
    unsigned short     pad;
    float              world_time;
} CoopHdr;

typedef struct {
    unsigned char      type;
    unsigned char      flags;
    unsigned short     ord;
    unsigned short     payload_len;
    unsigned short     epoch;
    unsigned long long key;
} CoopEvent;

typedef struct {
    unsigned short class_tag;
    short          qpos[3];
} CoopWitness;

typedef struct {
    float          pos[3];
    short          rot[3];
    short          vel[3];
    short          accel_xy[2];
    unsigned char  blkA[18];
    unsigned char  blkB[10];
    unsigned char  physics;
    unsigned char  ledge_type;
    unsigned char  weapon_type;
    unsigned char  health_level;
    short          health;
    short          health_max;
    unsigned short hysteria_ms;
    unsigned short coll_height;
    unsigned short coll_radius;
    unsigned short draw_scale;
    unsigned char  npc_attached;
    unsigned char  pad;
    unsigned       bits;
    unsigned       sm_flags;
} CoopState;

typedef struct {
    unsigned long long id;
    unsigned           nick[6];
} CoopHello;

#pragma pack(pop)

#define COOP_EV_PAYLOAD_MAX (COOP_MTU - (int)sizeof(CoopHdr) - (int)sizeof(CoopEvent))

#define FNV64_BASIS 1469598103934665603ull
#define FNV64_PRIME 1099511628211ull

unsigned long long fnv1a64(const char *s);
unsigned long long fnv1a64_mix(unsigned long long h, const void *p, int n);

#endif
