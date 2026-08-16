#include "coop.h"

CoopState g_peerState;
int       g_peerStateValid;
float     g_peerLastT;
int       g_extrapolating;

#define BUFN 48
typedef struct { float t; CoopState s; } Sample;
static Sample   g_buf[BUFN];
static int      g_bufN, g_bufHead;

#define OFFN 8
static float    g_offBucket[OFFN];
static int      g_offHave[OFFN];
static int      g_offCur = -1;
static float    g_offBase;
static int      g_clockInit;

static const struct { unsigned char word; unsigned mask; } BITSRC[32] = {
    {2, 0x00000001u}, {2, 0x00000002u}, {2, 0x00000004u}, {0, 0x00000200u},
    {0, 0x00000080u}, {0, 0x00000020u}, {0, 0x00000100u}, {0, 0x00000004u},
    {0, 0x10000000u}, {0, 0x00000800u}, {0, 0x08000000u}, {0, 0x00080000u},
    {0, 0x00010000u}, {1, 0x00000040u}, {1, 0x00000080u}, {1, 0x00000020u},
    {1, 0x00800000u}, {1, 0x00000002u}, {1, 0x00000001u}, {1, 0x00002000u},
    {2, 0x00010000u}, {4, 0x00000040u}, {4, 0x00200000u}, {4, 0x00010000u},
    {3, 0x00000008u}, {3, 0x00000010u}, {3, 0x00000020u}, {3, 0x00000080u},
    {3, 0x00000001u}, {5, 0x00000008u}, {5, 0x00000002u}, {6, 0x00000010u}
};
static const int BITWORD_OFF[7] = {
    O_AP_F99C, O_AP_F9A0, O_AP_F9A4, O_AGP_FLAGS0, O_AGP_FLAGS1,
    O_PAWN_FLAGS0, O_ACTOR_FLAGS0
};
static const unsigned BITWORD_LOCAL = (1u << 6);

static const unsigned char BLKA_MAX[18] = {8,8,70,70,8,4,5,4,5,2,4,22,5,15,255,255,255,255};
static const unsigned char BLKB_MAX[10] = {255,2,5,5,4,9,5,12,12,255};
static const unsigned char BLKB_LOCAL[10] = {1,0,0,0,0,0,0,1,1,1};

static short sat16(float v) {
    if (v > 32767.0f) return 32767;
    if (v < -32767.0f) return -32767;
    return (short)v;
}

void state_reset(void) {
    int i;
    g_bufN = 0;
    g_bufHead = 0;
    g_peerStateValid = 0;
    g_extrapolating = 0;
    g_clockInit = 0;
    g_offCur = -1;
    for (i = 0; i < OFFN; i++) g_offHave[i] = 0;
}

unsigned state_pack_bits(AObj pawn) {
    unsigned w[7], bits = 0;
    int i;
    for (i = 0; i < 7; i++)
        if (!A->read_raw(pawn, BITWORD_OFF[i], &w[i], 4)) w[i] = 0;
    for (i = 0; i < 32; i++)
        if (w[BITSRC[i].word] & BITSRC[i].mask) bits |= (1u << i);
    return bits;
}

void state_unpack_bits(AObj g, unsigned bits) {
    unsigned w[7];
    int i, dirty[7];
    for (i = 0; i < 7; i++) {
        dirty[i] = 0;
        if (!A->read_raw(g, BITWORD_OFF[i], &w[i], 4)) w[i] = 0;
    }
    for (i = 0; i < 32; i++) {
        int wi = BITSRC[i].word;
        if (BITWORD_LOCAL & (1u << wi)) continue;
        if (bits & (1u << i)) w[wi] |= BITSRC[i].mask;
        else                  w[wi] &= ~BITSRC[i].mask;
        dirty[wi] = 1;
    }
    for (i = 0; i < 7; i++)
        if (dirty[i]) A->write_raw(g, BITWORD_OFF[i], &w[i], 4);
}

int state_sample(AObj pawn, CoopState *s) {
    float v[3], acc[3], hyst = 0.0f;
    int rot[3];
    AObj cyl;
    float ch = 0.0f, cr = 0.0f;
    int hp = 0, hpmax = 0, hl = 0;

    if (!pawn || !s) return 0;
    memset(s, 0, sizeof *s);
    if (!A->read_raw(pawn, O_LOCATION, s->pos, 12)) return 0;

    if (A->read_raw(pawn, O_ROTATION, rot, 12)) {
        s->rot[0] = (short)rot[0]; s->rot[1] = (short)rot[1]; s->rot[2] = (short)rot[2];
    }
    if (A->read_raw(pawn, O_VELOCITY, v, 12)) {
        s->vel[0] = sat16(v[0]); s->vel[1] = sat16(v[1]); s->vel[2] = sat16(v[2]);
    }
    if (A->read_raw(pawn, O_ACCELERATION, acc, 12)) {
        s->accel_xy[0] = sat16(acc[0]); s->accel_xy[1] = sat16(acc[1]);
    }
    A->read_raw(pawn, O_AGP_BLOCKA, s->blkA, AGP_BLOCKA_LEN);
    A->read_raw(pawn, O_AP_BLOCKB, s->blkB, AP_BLOCKB_LEN);
    A->read_raw(pawn, O_PHYSICS, &s->physics, 1);
    A->read_raw(pawn, O_PAWN_LEDGETYPE, &s->ledge_type, 1);
    A->read_raw(pawn, O_AGP_SMFLAGS, &s->sm_flags, 4);

    if (A->read_raw(pawn, O_PAWN_HEALTH, &hp, 4))       s->health = (short)hp;
    if (A->read_raw(pawn, O_PAWN_HEALTHMAX, &hpmax, 4)) s->health_max = (short)hpmax;
    if (A->read_raw(pawn, O_AP_CURHEALTHLEVEL, &hl, 4)) s->health_level = (unsigned char)hl;
    if (A->read_raw(pawn, O_AP_HYSTERIALEFT, &hyst, 4) && hyst > 0.0f && hyst < 60.0f)
        s->hysteria_ms = (unsigned short)(hyst * 1000.0f);

    {
        AObj wp = A->get_obj(pawn, "Weapon");
        int wt = 0;
        if (wp && A->read_raw(wp, 0x528, &wt, 1)) s->weapon_type = (unsigned char)wt;
    }

    {
        float ds = 1.0f;
        int npc = 0;
        if (A->read_raw(pawn, O_DRAWSCALE, &ds, 4) && ds > 0.01f && ds < 64.0f)
            s->draw_scale = (unsigned short)(ds * 1000.0f);
        else s->draw_scale = 1000;
        if (A->read_raw(pawn, O_AP_NBATTACHEDNPC, &npc, 4) && npc >= 0 && npc < 256)
            s->npc_attached = (unsigned char)npc;
    }

    s->bits = state_pack_bits(pawn);

    cyl = A->get_obj(pawn, "CylinderComponent");
    if (cyl) {
        A->read_raw(cyl, O_CYL_HEIGHT, &ch, 4);
        A->read_raw(cyl, O_CYL_RADIUS, &cr, 4);
    }
    s->coll_height = (unsigned short)(ch > 1.0f ? ch : 44.0f);
    s->coll_radius = (unsigned short)(cr > 1.0f ? cr : 21.0f);
    return 1;
}

void clock_update(float remote_t, float local_t) {
    float off = local_t - remote_t;
    int b = ((int)(local_t * 4.0f)) & (OFFN - 1);
    if (!g_clockInit) {
        int i;
        g_clockInit = 1;
        g_offBase = off;
        for (i = 0; i < OFFN; i++) { g_offBucket[i] = off; g_offHave[i] = 1; }
        g_offCur = b;
        return;
    }
    if (b != g_offCur) { g_offCur = b; g_offBucket[b] = off; g_offHave[b] = 1; }
    else if (off < g_offBucket[b]) g_offBucket[b] = off;

    {
        float mn = 0.0f;
        int i, have = 0;
        for (i = 0; i < OFFN; i++) {
            if (!g_offHave[i]) continue;
            if (!have || g_offBucket[i] < mn) { mn = g_offBucket[i]; have = 1; }
        }
        if (have) g_offBase = mn;
    }
}

float clock_render_time(float local_t) {
    if (!g_clockInit) return 0.0f;
    return local_t - g_offBase - (float)g_cfg.delay_ms * 0.001f;
}

void state_push(float t, const CoopState *s) {
    int last = (g_bufHead - 1 + BUFN) % BUFN;
    if (g_bufN && t <= g_buf[last].t) {
        if (g_buf[last].t - t > 1.0f) {
            coop_log("coop: horloge du pair repartie (%.1f -> %.1f), tampon vide",
                     g_buf[last].t, t);
            state_reset();
        } else {
            return;
        }
    }
    g_buf[g_bufHead].t = t;
    g_buf[g_bufHead].s = *s;
    g_bufHead = (g_bufHead + 1) % BUFN;
    if (g_bufN < BUFN) g_bufN++;
}

static const Sample *sample_at_index(int i) {
    return &g_buf[(g_bufHead - g_bufN + i + BUFN) % BUFN];
}

static short rot_lerp(short a, short b, float f) {
    int d = (short)(b - a);
    return (short)(a + (int)(d * f));
}

int state_at(float t, CoopState *out, float vel_out[3]) {
    const Sample *a, *b;
    int lo, hi, mid, i;
    float dt, f, h00, h10, h01, h11;

    if (!g_bufN || !out) return 0;
    g_extrapolating = 0;

    a = sample_at_index(0);
    b = sample_at_index(g_bufN - 1);
    if (t <= a->t) {
        *out = a->s;
        if (vel_out) { vel_out[0] = a->s.vel[0]; vel_out[1] = a->s.vel[1]; vel_out[2] = a->s.vel[2]; }
        return 1;
    }
    if (t >= b->t) {
        float over = t - b->t;
        if (over > 0.25f) { over = 0.25f; g_extrapolating = 1; }
        else if (over > 0.001f) g_extrapolating = 1;
        *out = b->s;
        out->pos[0] = b->s.pos[0] + (float)b->s.vel[0] * over;
        out->pos[1] = b->s.pos[1] + (float)b->s.vel[1] * over;
        out->pos[2] = b->s.pos[2] + (float)b->s.vel[2] * over;
        if (vel_out) { vel_out[0] = b->s.vel[0]; vel_out[1] = b->s.vel[1]; vel_out[2] = b->s.vel[2]; }
        return 1;
    }

    lo = 0; hi = g_bufN - 1;
    while (hi - lo > 1) {
        mid = (lo + hi) >> 1;
        if (sample_at_index(mid)->t <= t) lo = mid; else hi = mid;
    }
    a = sample_at_index(lo);
    b = sample_at_index(hi);
    dt = b->t - a->t;
    if (dt <= 0.0001f) { *out = b->s; return 1; }
    f = (t - a->t) / dt;

    *out = (f >= 0.5f) ? b->s : a->s;

    h00 = 2.0f * f * f * f - 3.0f * f * f + 1.0f;
    h10 = f * f * f - 2.0f * f * f + f;
    h01 = -2.0f * f * f * f + 3.0f * f * f;
    h11 = f * f * f - f * f;
    for (i = 0; i < 3; i++) {
        float p0 = a->s.pos[i], p1 = b->s.pos[i];
        float m0 = (float)a->s.vel[i] * dt, m1 = (float)b->s.vel[i] * dt;
        out->pos[i] = h00 * p0 + h10 * m0 + h01 * p1 + h11 * m1;
        out->vel[i] = (short)((1.0f - f) * a->s.vel[i] + f * b->s.vel[i]);
        out->rot[i] = rot_lerp(a->s.rot[i], b->s.rot[i], f);
        if (vel_out) vel_out[i] = out->vel[i];
    }
    return 1;
}

void on_state_packet(const CoopState *s, float remote_t, float local_t) {
    clock_update(remote_t, local_t);
    state_push(remote_t, s);
    g_peerState = *s;
    g_peerLastT = remote_t;
    if (!g_peerStateValid) {
        g_peerStateValid = 1;
        coop_log("coop: premier etat recu du pair");
    }
}

void state_apply(AObj g, const CoopState *s) {
    unsigned char cur[AGP_BLOCKA_LEN];
    int i;

    if (!g || !s) return;

    if (A->read_raw(g, O_AGP_BLOCKA, cur, AGP_BLOCKA_LEN)) {
        for (i = 0; i < AGP_BLOCKA_LEN; i++) {
            if (s->blkA[i] < BLKA_MAX[i]) cur[i] = s->blkA[i];
            else g_rejects++;
        }
        A->write_raw(g, O_AGP_BLOCKA, cur, AGP_BLOCKA_LEN);
    }
    if (A->read_raw(g, O_AP_BLOCKB, cur, AP_BLOCKB_LEN)) {
        for (i = 0; i < AP_BLOCKB_LEN; i++) {
            if (BLKB_LOCAL[i]) continue;
            if (s->blkB[i] < BLKB_MAX[i]) cur[i] = s->blkB[i];
            else g_rejects++;
        }
        A->write_raw(g, O_AP_BLOCKB, cur, AP_BLOCKB_LEN);
    }

    state_unpack_bits(g, s->bits);
    A->write_raw(g, O_AGP_SMFLAGS, &s->sm_flags, 4);

    if (g_ghost.mode == 0 && s->physics < 21)
        actor_set_physics(g, s->physics);

    {
        int hp = s->health, hpmax = s->health_max, hl = s->health_level;
        if (hpmax > 0) {
            A->write_raw(g, O_PAWN_HEALTH, &hp, 4);
            A->write_raw(g, O_PAWN_HEALTHMAX, &hpmax, 4);
        }
        A->write_raw(g, O_AP_CURHEALTHLEVEL, &hl, 4);
    }
    if (s->ledge_type < 16) A->write_raw(g, O_PAWN_LEDGETYPE, &s->ledge_type, 1);

    {
        int npc = s->npc_attached;
        A->write_raw(g, O_AP_NBATTACHEDNPC, &npc, 4);
    }
    if (s->draw_scale >= 10 && s->draw_scale <= 64000) {
        float ds = (float)s->draw_scale * 0.001f, cur = 0.0f;
        if (!A->read_raw(g, O_DRAWSCALE, &cur, 4) || cur != ds)
            A->write_raw(g, O_DRAWSCALE, &ds, 4);
    }
}
