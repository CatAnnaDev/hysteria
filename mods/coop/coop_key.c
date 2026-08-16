#include "coop.h"
#include <stdlib.h>

#define COOP_KEY_DEPTH 12
#define KEYCACHE       512
#define KEYMAP         1024
#define KEYPROBE       8
#define DEFERN         32
#define DEFER_PAYLOAD  48

typedef struct { AObj obj; unsigned stamp[2]; unsigned long long key; } KeyCache;
typedef struct { unsigned long long key; AObj obj; } KeyMap;

static KeyCache g_kc[KEYCACHE];
static KeyMap   g_km[KEYMAP];

typedef struct {
    unsigned long long key;
    unsigned           deadline_ms;
    CoopEvent          ev;
    unsigned char      len;
    unsigned char      payload[DEFER_PAYLOAD];
} CoopDefer;

static CoopDefer g_defer[DEFERN];
static int       g_deferN;
static unsigned  g_lastSweepMs;
static unsigned  g_lastTryMs;
static int       g_sweepClass;
static int       g_sweepHits;

static const char *const SWEEP_CLASSES[4] = { "Actor", "SequenceOp", "SoundCue", "InterpGroupInst" };

unsigned long long coop_key_raw(AObj o) {
    const char        *seg[COOP_KEY_DEPTH];
    int                num[COOP_KEY_DEPTH];
    int                sp = 0;
    AObj               cur = o;
    unsigned long long h = FNV64_BASIS;

    if (!o) return 0;
    while (cur && sp < COOP_KEY_DEPTH) {
        const char *nm = A->name_of(cur);
        if (!nm || !nm[0] || nm[0] == '?' || nm[0] == '<') return 0;
        seg[sp] = nm;
        num[sp] = 0;
        A->read_raw(cur, O_UOBJ_NAMENUM, &num[sp], 4);
        sp++;
        cur = A->get_outer(cur);
    }
    while (sp--) {
        const char *s = seg[sp];
        int len = 0;
        while (s[len]) len++;
        h = fnv1a64_mix(h, s, len);
        h = fnv1a64_mix(h, &num[sp], 4);
        h = fnv1a64_mix(h, ".", 1);
    }
    return h ? h : 1;
}

static unsigned map_slot(unsigned long long key) {
    return (unsigned)((key ^ (key >> 32)) & (KEYMAP - 1));
}

void coop_key_remember(AObj o, unsigned long long key) {
    unsigned slot, i;
    if (!o || !key) return;
    slot = map_slot(key);
    for (i = 0; i < KEYPROBE; i++) {
        KeyMap *m = &g_km[(slot + i) & (KEYMAP - 1)];
        if (m->key == key || !m->key) { m->key = key; m->obj = o; return; }
    }
    g_km[slot].key = key;
    g_km[slot].obj = o;
}

unsigned long long coop_key(AObj o) {
    unsigned base, i, st[2];
    KeyCache *dst = 0;

    if (!o) return 0;
    if (!A->read_raw(o, O_UOBJ_NAMEIDX, st, 8)) return 0;
    base = ((unsigned)(ULONG_PTR)o >> 4) & (KEYCACHE - 1);
    for (i = 0; i < 4; i++) {
        KeyCache *k = &g_kc[(base + i) & (KEYCACHE - 1)];
        if (k->obj == o) {
            if (k->stamp[0] == st[0] && k->stamp[1] == st[1]) return k->key;
            dst = k;
            break;
        }
        if (!k->obj && !dst) dst = k;
    }
    if (!dst) dst = &g_kc[base];
    dst->obj = o;
    dst->stamp[0] = st[0];
    dst->stamp[1] = st[1];
    dst->key = coop_key_raw(o);
    coop_key_remember(o, dst->key);
    return dst->key;
}

void coop_key_flush(void) {
    memset(g_kc, 0, sizeof g_kc);
    memset(g_km, 0, sizeof g_km);
}

AObj coop_key_resolve(unsigned long long key) {
    unsigned slot, i;
    if (!key) return 0;
    slot = map_slot(key);
    for (i = 0; i < KEYPROBE; i++) {
        KeyMap *m = &g_km[(slot + i) & (KEYMAP - 1)];
        if (!m->key) return 0;
        if (m->key != key) continue;
        if (m->obj && guard_obj_ok(m->obj) && coop_key_raw(m->obj) == key) return m->obj;
        m->obj = 0;
        return 0;
    }
    return 0;
}

unsigned short coop_class_tag(AObj o) {
    const char *cn = o ? A->class_of(o) : 0;
    if (!cn || !cn[0]) return 0;
    return (unsigned short)(fnv1a64(cn) & 0xffffu);
}

void coop_witness_make(AObj o, CoopWitness *w) {
    float pos[3] = {0.0f, 0.0f, 0.0f};
    int i;
    if (!w) return;
    w->class_tag = coop_class_tag(o);
    if (o && A->is_a(o, "Actor")) A->read_raw(o, O_LOCATION, pos, 12);
    for (i = 0; i < 3; i++) {
        float q = pos[i] / 16.0f;
        if (q > 32767.0f) q = 32767.0f;
        if (q < -32768.0f) q = -32768.0f;
        w->qpos[i] = (short)(q >= 0.0f ? q + 0.5f : q - 0.5f);
    }
}

unsigned long long coop_emit_obj(int type, AObj o, int lane, unsigned flags,
                                 const void *payload, int n) {
    unsigned char buf[64];
    unsigned long long k;

    if (!o) return 0;
    k = coop_key(o);
    if (!k) return 0;
    if (n < 0) n = 0;
    if (n + (int)sizeof(CoopWitness) > (int)sizeof buf) return 0;
    coop_witness_make(o, (CoopWitness *)buf);
    if (n) memcpy(buf + sizeof(CoopWitness), payload, (size_t)n);
    if (!net_ev_add(type, k, lane, flags | EF_WITNESS, buf, n + (int)sizeof(CoopWitness)))
        return 0;
    return k;
}

int coop_witness_check(const CoopEvent *e, const void *payload, int n, AObj o, float max_uu) {
    CoopWitness w;
    float pos[3], d, dd = 0.0f;
    int i;

    if (!o) return 0;
    if (!coop_witness_read(e, payload, n, &w)) return 1;
    if (w.class_tag && coop_class_tag(o) != w.class_tag) return 0;
    if (!(max_uu > 0.0f) || !A->is_a(o, "Actor")) return 1;
    if (!A->read_raw(o, O_LOCATION, pos, 12)) return 1;
    for (i = 0; i < 3; i++) {
        d = pos[i] - (float)w.qpos[i] * 16.0f;
        dd += d * d;
    }
    return dd <= max_uu * max_uu;
}

int coop_witness_read(const CoopEvent *e, const void *payload, int n, CoopWitness *w) {
    if (!e || !(e->flags & EF_WITNESS) || n < (int)sizeof(CoopWitness)) return 0;
    if (w) memcpy(w, payload, sizeof(CoopWitness));
    return (int)sizeof(CoopWitness);
}

static CoopWitness g_repairWant;
static AObj        g_repairFound;
static float       g_repairBest;

static void repair_cb(AObj o) {
    float pos[3], want[3], d, dd;
    int i;
    if (coop_class_tag(o) != g_repairWant.class_tag) return;
    if (!A->read_raw(o, O_LOCATION, pos, 12)) return;
    dd = 0.0f;
    for (i = 0; i < 3; i++) {
        want[i] = (float)g_repairWant.qpos[i] * 16.0f;
        d = pos[i] - want[i];
        dd += d * d;
    }
    if (dd < g_repairBest) { g_repairBest = dd; g_repairFound = o; }
}

static AObj witness_repair(const CoopWitness *w) {
    if (!g_cfg.key_repair || !w->class_tag) return 0;
    g_repairWant = *w;
    g_repairFound = 0;
    g_repairBest = 64.0f * 64.0f;
    A->iter_objects("Actor", repair_cb);
    return g_repairFound;
}

static void defer_drop(int i) {
    g_defer[i] = g_defer[--g_deferN];
}

static void defer_push(const CoopEvent *e, const void *payload, int n) {
    CoopDefer *d;
    int i;
    for (i = 0; i < g_deferN; i++)
        if (g_defer[i].key == e->key && g_defer[i].ev.type == e->type) return;
    if (g_deferN >= DEFERN || n > DEFER_PAYLOAD) { g_net.unresolved++; return; }
    d = &g_defer[g_deferN++];
    d->key = e->key;
    d->deadline_ms = GetTickCount() + (unsigned)g_cfg.defer_ttl_ms;
    d->ev = *e;
    d->len = (unsigned char)n;
    if (n) memcpy(d->payload, payload, (size_t)n);
    g_net.deferred++;
}

int coop_need_obj(const CoopEvent *e, const void *payload, int n, AObj *out) {
    CoopWitness w;
    AObj o;
    int haveW;

    if (out) *out = 0;
    if (!e || !e->key) return 0;
    haveW = coop_witness_read(e, payload, n, &w) != 0;
    o = coop_key_resolve(e->key);

    if (o && haveW && w.class_tag && coop_class_tag(o) != w.class_tag) {
        AObj fix = witness_repair(&w);
        if (fix) {
            coop_key_remember(fix, e->key);
            g_net.repaired++;
            o = fix;
        } else {
            g_net.mismatch++;
            o = 0;
        }
    }

    if (o) { if (out) *out = o; return 1; }
    defer_push(e, payload, n);
    return 0;
}

static void sweep_cb(AObj o) {
    unsigned long long k;
    int i;
    if (!g_deferN) return;
    k = coop_key_raw(o);
    if (!k) return;
    for (i = 0; i < g_deferN; i++) {
        if (g_defer[i].key != k) continue;
        coop_key_remember(o, k);
        g_sweepHits++;
        return;
    }
}

void coop_key_defer_pump(unsigned now) {
    int i;

    if (!g_deferN) return;
    if (now - g_lastTryMs < 250) return;
    g_lastTryMs = now;

    for (i = 0; i < g_deferN; ) {
        CoopDefer *d = &g_defer[i];
        AObj o = coop_key_resolve(d->key);
        if (o) {
            CoopEvent ev = d->ev;
            unsigned char buf[DEFER_PAYLOAD];
            int n = d->len;
            if (n) memcpy(buf, d->payload, (size_t)n);
            defer_drop(i);
            g_net.resolved++;
            net_ev_dispatch_deferred(&ev, buf, n);
            continue;
        }
        if ((int)(now - d->deadline_ms) < 0) { i++; continue; }
        {
            CoopWitness w;
            if (coop_witness_read(&d->ev, d->payload, d->len, &w)) {
                AObj rep = witness_repair(&w);
                if (rep) {
                    CoopEvent ev = d->ev;
                    unsigned char buf[DEFER_PAYLOAD];
                    int n = d->len;
                    if (n) memcpy(buf, d->payload, (size_t)n);
                    coop_key_remember(rep, d->key);
                    defer_drop(i);
                    g_net.repaired++;
                    coop_log("coop: cle %08x%08x reparee par temoin (classe %04x)",
                             (unsigned)(ev.key >> 32), (unsigned)ev.key, (unsigned)w.class_tag);
                    net_ev_dispatch_deferred(&ev, buf, n);
                    continue;
                }
                coop_log("coop: evenement %u abandonne, cle %08x%08x introuvable (classe %04x)",
                         (unsigned)d->ev.type, (unsigned)(d->key >> 32), (unsigned)d->key,
                         (unsigned)w.class_tag);
            } else {
                coop_log("coop: evenement %u abandonne, cle %08x%08x introuvable",
                         (unsigned)d->ev.type, (unsigned)(d->key >> 32), (unsigned)d->key);
            }
        }
        g_net.unresolved++;
        defer_drop(i);
    }

    if (!g_deferN || now - g_lastSweepMs < 1000) return;
    g_lastSweepMs = now;
    g_sweepHits = 0;
    A->iter_objects(SWEEP_CLASSES[g_sweepClass], sweep_cb);
    g_sweepClass = (g_sweepClass + 1) & 3;
}

void coop_key_epoch_reset(void) {
    g_deferN = 0;
    g_sweepClass = 0;
    g_lastSweepMs = 0;
    g_lastTryMs = 0;
}

static void u64_sort(unsigned long long *a, int n) {
    static const int gaps[8] = { 701, 301, 132, 57, 23, 10, 4, 1 };
    int g, i, j;
    for (g = 0; g < 8; g++) {
        int gap = gaps[g];
        if (gap >= n) continue;
        for (i = gap; i < n; i++) {
            unsigned long long v = a[i];
            for (j = i; j >= gap && a[j - gap] > v; j -= gap) a[j] = a[j - gap];
            a[j] = v;
        }
    }
}

static unsigned long long g_auditWorst[10];
static int                g_auditWorstN;

static void audit_report_names(void) {
    int cnt = A->object_count(), i, j, shown = 0;
    for (i = 0; i < cnt && shown < 20; i++) {
        AObj o = A->object_at(i);
        unsigned long long k;
        if (!o) continue;
        k = coop_key_raw(o);
        for (j = 0; j < g_auditWorstN; j++) {
            char full[320];
            int num = 0;
            if (g_auditWorst[j] != k) continue;
            A->full_name(o, full, sizeof full);
            A->read_raw(o, O_UOBJ_NAMENUM, &num, 4);
            coop_log("coop: collision %08x%08x  %s  Number=%d",
                     (unsigned)(k >> 32), (unsigned)k, full, num);
            shown++;
            break;
        }
    }
}

static const char *const AUDIT_CLASSES[5] = {
    "SequenceEvent", "SeqAct_Interp", "MemoryFragmentNormal",
    "GameBreakableActor", "AliceWeaponPickupFactory"
};

static unsigned long long *g_auditBuf;
static int                 g_auditN;
static int                 g_auditCap;

static void audit_class_cb(AObj o) {
    unsigned long long k;
    if (g_auditN >= g_auditCap) return;
    k = coop_key_raw(o);
    if (!k) return;
    g_auditBuf[g_auditN++] = k;
}

void coop_key_audit(void) {
    int cnt = A->object_count(), i, c;
    unsigned long long *keys;
    int n = 0, groups = 0, members = 0, zero = 0;

    if (cnt <= 0) { coop_log("coop: keyaudit impossible, GObjects illisible"); return; }
    keys = (unsigned long long *)malloc((size_t)cnt * sizeof *keys);
    if (!keys) { coop_log("coop: keyaudit impossible, memoire insuffisante"); return; }

    for (i = 0; i < cnt; i++) {
        AObj o = A->object_at(i);
        unsigned long long k;
        if (!o) continue;
        k = coop_key_raw(o);
        if (!k) { zero++; continue; }
        keys[n++] = k;
    }
    u64_sort(keys, n);

    g_auditWorstN = 0;
    for (i = 0; i < n; ) {
        int j = i + 1;
        while (j < n && keys[j] == keys[i]) j++;
        if (j - i > 1) {
            groups++;
            members += j - i;
            if (g_auditWorstN < 10) g_auditWorst[g_auditWorstN++] = keys[i];
        }
        i = j;
    }
    coop_log("coop: keyaudit COOP_KEY_V2 - %d objets, %d cles, %d groupes en collision, %d objets ambigus, %d sans nom",
             cnt, n, groups, members, zero);
    free(keys);
    if (groups) audit_report_names();

    g_auditCap = 4096;
    g_auditBuf = (unsigned long long *)malloc((size_t)g_auditCap * sizeof *g_auditBuf);
    if (!g_auditBuf) return;
    for (c = 0; c < 5; c++) {
        unsigned long long fp = FNV64_BASIS;
        g_auditN = 0;
        A->iter_objects(AUDIT_CLASSES[c], audit_class_cb);
        u64_sort(g_auditBuf, g_auditN);
        for (i = 0; i < g_auditN; i++) fp = fnv1a64_mix(fp, &g_auditBuf[i], 8);
        coop_log("coop: keyaudit %-26s %5d objets  empreinte %08x%08x",
                 AUDIT_CLASSES[c], g_auditN, (unsigned)(fp >> 32), (unsigned)fp);
    }
    free(g_auditBuf);
    g_auditBuf = 0;
    g_auditCap = 0;
    coop_log("coop: keyaudit termine - comparez ces lignes avec celles de l'autre instance");
}
