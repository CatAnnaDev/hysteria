#include "coop.h"

CoopNet g_net;

unsigned long long fnv1a64(const char *s) {
    unsigned long long h = FNV64_BASIS;
    if (!s) return 0;
    while (*s) {
        h ^= (unsigned char)*s++;
        h *= FNV64_PRIME;
    }
    return h;
}

unsigned long long fnv1a64_mix(unsigned long long h, const void *p, int n) {
    const unsigned char *b = (const unsigned char *)p;
    int i;
    for (i = 0; i < n; i++) {
        h ^= b[i];
        h *= FNV64_PRIME;
    }
    return h;
}

#define REL_SLOTS       64
#define RESEND_BURST    8
#define RESEND_MAX      20
#define RESEND_VOID_MAX 200
#define RESEND_KEEP_MAX 400
#define LANE_SESSION_GAP_MS 30000u
#define LANE_HOLD       8
#define LANE_PAYLOAD    64
#define SUBN            24

static SOCKET g_sock = INVALID_SOCKET;
static unsigned g_seqOut;
static unsigned g_seqIn;
static unsigned g_relNext = 1;
static unsigned g_rxHi;
static unsigned long long g_rxBits;
static unsigned g_lastHelloMs;
static unsigned g_helloSentMs;
static unsigned g_lastStateMs;
static unsigned g_openedMs;

typedef struct {
    int      used;
    int      keep;
    int      voided;
    unsigned id;
    unsigned tries;
    unsigned next_ms;
    int      len;
    unsigned char buf[COOP_MTU];
} RelSlot;

static RelSlot g_rel[REL_SLOTS];

typedef struct {
    unsigned short ord;
    unsigned char  used;
    unsigned char  len;
    CoopEvent      ev;
    unsigned char  buf[LANE_PAYLOAD];
} LaneHold;

typedef struct {
    unsigned short next_ord;
    unsigned char  n;
    unsigned char  started;
    unsigned       gap_ms;
    LaneHold       hold[LANE_HOLD];
} CoopLane;

static CoopLane      g_lane[LANE_COUNT];
static unsigned short g_ordOut[LANE_COUNT];

typedef struct { int type; CoopEvCb cb; } EvSub;
static EvSub g_sub[SUBN];
static int   g_subN;

static unsigned char g_batch[COOP_MTU];
static int g_batchN;
static int g_batchKeep;
static int g_batchDepth;
static int g_deferRun;

static unsigned long long make_self_id(void) {
    unsigned long long h = fnv1a64(g_cfg.nickname);
    unsigned a = GetCurrentProcessId(), b = GetTickCount();
    h = fnv1a64_mix(h, &a, 4);
    h = fnv1a64_mix(h, &b, 4);
    return h ? h : 1;
}

static void lanes_reset(int all) {
    int i, last = all ? LANE_COUNT : LANE_SESSION;
    for (i = 0; i < last; i++) {
        memset(&g_lane[i], 0, sizeof g_lane[i]);
        g_ordOut[i] = 0;
    }
}

void net_close(void) {
    if (g_sock != INVALID_SOCKET) closesocket(g_sock);
    g_sock = INVALID_SOCKET;
    g_net.up = 0;
    g_net.pinned = 0;
    g_net.peer_id = 0;
    memset(g_rel, 0, sizeof g_rel);
    lanes_reset(1);
    g_batchN = 0;
    g_batchKeep = 0;
    g_batchDepth = 0;
    g_rxHi = 0;
    g_rxBits = 0;
    g_seqIn = 0;
}

int net_open(void) {
    struct sockaddr_in ba;
    unsigned long nb = 1;
    int bcast = 1, i;

    net_close();
    g_sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (g_sock == INVALID_SOCKET) {
        coop_log("coop: socket() echec %d", WSAGetLastError());
        return 0;
    }
    ioctlsocket(g_sock, FIONBIO, &nb);
    setsockopt(g_sock, SOL_SOCKET, SO_BROADCAST, (const char *)&bcast, sizeof bcast);

    for (i = 0; i < 8; i++) {
        memset(&ba, 0, sizeof ba);
        ba.sin_family = AF_INET;
        ba.sin_addr.s_addr = htonl(INADDR_ANY);
        ba.sin_port = htons((unsigned short)(g_cfg.listen_port + i));
        if (bind(g_sock, (struct sockaddr *)&ba, sizeof ba) == 0) {
            g_net.bound_port = g_cfg.listen_port + i;
            break;
        }
    }
    if (i == 8) {
        coop_log("coop: aucun port libre de %d a %d", g_cfg.listen_port, g_cfg.listen_port + 7);
        net_close();
        return 0;
    }

    g_net.self_id = make_self_id();
    g_net.up = 1;
    g_net.host = (g_cfg.role == 1) ? 1 : 0;
    g_openedMs = GetTickCount();
    g_seqOut = 0;
    g_relNext = 1;

    memset(&g_net.peer, 0, sizeof g_net.peer);
    g_net.peer.sin_family = AF_INET;
    g_net.peer.sin_addr.s_addr = htonl(((unsigned)g_cfg.peer_ip[0] << 24) |
                                       ((unsigned)g_cfg.peer_ip[1] << 16) |
                                       ((unsigned)g_cfg.peer_ip[2] << 8) |
                                       (unsigned)g_cfg.peer_ip[3]);
    g_net.peer.sin_port = htons((unsigned short)(g_cfg.peer_port ? g_cfg.peer_port : g_net.bound_port));

    coop_log("coop: ecoute sur %d, role %s, id %08x%08x", g_net.bound_port,
             g_cfg.role == 1 ? "HOTE force" : g_cfg.role == 2 ? "CLIENT force" : "auto",
             (unsigned)(g_net.self_id >> 32), (unsigned)g_net.self_id);
    return 1;
}

void net_set_peer(const char *ip, int port) {
    unsigned long a;
    if (!ip) return;
    a = inet_addr(ip);
    if (a == INADDR_NONE) return;
    g_cfg.peer_ip[0] = (int)((ntohl(a) >> 24) & 0xff);
    g_cfg.peer_ip[1] = (int)((ntohl(a) >> 16) & 0xff);
    g_cfg.peer_ip[2] = (int)((ntohl(a) >> 8) & 0xff);
    g_cfg.peer_ip[3] = (int)(ntohl(a) & 0xff);
    if (port > 0) g_cfg.peer_port = port;
    g_net.peer.sin_addr.s_addr = a;
    if (port > 0) g_net.peer.sin_port = htons((unsigned short)port);
    g_net.pinned = 0;
    cfg_flush();
}

static void hdr_fill(CoopHdr *h, int msg, int len, unsigned rel_id, float world_time) {
    h->magic = COOP_MAGIC;
    h->version = COOP_VERSION;
    h->msg = (unsigned char)msg;
    h->len = (unsigned short)len;
    h->seq = ++g_seqOut;
    h->rel_id = rel_id;
    h->rel_ack = g_rxHi;
    h->rel_mask = g_rxBits;
    h->epoch = g_epoch;
    h->pad = 0;
    h->world_time = world_time;
}

static int raw_send(const void *buf, int n, const struct sockaddr_in *to) {
    if (g_sock == INVALID_SOCKET) return 0;
    return sendto(g_sock, (const char *)buf, n, 0, (const struct sockaddr *)to, sizeof *to) == n;
}

static void hello_to(const struct sockaddr_in *to, float world_time) {
    unsigned char pkt[sizeof(CoopHdr) + sizeof(CoopHello)];
    CoopHdr *h = (CoopHdr *)pkt;
    CoopHello *b = (CoopHello *)(pkt + sizeof(CoopHdr));
    memset(pkt, 0, sizeof pkt);
    hdr_fill(h, COOP_HELLO, (int)sizeof pkt, 0, world_time);
    b->id = g_net.self_id;
    memcpy(b->nick, g_cfg.nickname, sizeof b->nick);
    raw_send(pkt, (int)sizeof pkt, to);
}

static void discovery(unsigned now, float world_time) {
    struct sockaddr_in to;
    int i;
    if (g_net.pinned || now - g_lastHelloMs < 1000) return;
    g_lastHelloMs = now;
    g_helloSentMs = now;

    hello_to(&g_net.peer, world_time);

    memset(&to, 0, sizeof to);
    to.sin_family = AF_INET;
    to.sin_addr.s_addr = inet_addr("127.0.0.1");
    for (i = 0; i < 8; i++) {
        int p = g_cfg.listen_port + i;
        if (p == g_net.bound_port) continue;
        to.sin_port = htons((unsigned short)p);
        hello_to(&to, world_time);
    }
    if (g_cfg.discover_lan) {
        to.sin_addr.s_addr = htonl(INADDR_BROADCAST);
        for (i = 0; i < 8; i++) {
            to.sin_port = htons((unsigned short)(g_cfg.listen_port + i));
            hello_to(&to, world_time);
        }
    }
}

static unsigned rel_backoff(unsigned tries, unsigned rtt) {
    unsigned base = rtt ? rtt * 2 : 120;
    if (base < 60) base = 60;
    if (base > 400) base = 400;
    base += base * (tries < 6 ? tries : 6) / 4;
    return base > 1500 ? 1500 : base;
}

static void rel_purge(unsigned ack, unsigned long long mask) {
    int i;
    for (i = 0; i < REL_SLOTS; i++) {
        RelSlot *r = &g_rel[i];
        unsigned d;
        if (!r->used) continue;
        if (r->id <= ack) { r->used = 0; continue; }
        d = r->id - ack;
        if (d <= 64 && (mask & (1ull << (d - 1)))) r->used = 0;
    }
}

static void rel_make_void(RelSlot *r) {
    CoopHdr *h = (CoopHdr *)r->buf;
    CoopEvent *e = (CoopEvent *)(r->buf + sizeof(CoopHdr));
    r->len = (int)sizeof(CoopHdr) + (int)sizeof(CoopEvent);
    memset(r->buf, 0, (size_t)r->len);
    hdr_fill(h, COOP_EVENT, r->len, r->id, g_worldTime);
    e->type = CEV_VOID;
    e->flags = LANE_LOOSE;
    r->voided = 1;
    r->tries = 0;
}

static void rel_pump(unsigned now) {
    int due[REL_SLOTS], k = 0, i, j, burst;
    if (!g_net.pinned) return;

    for (i = 0; i < REL_SLOTS; i++) {
        RelSlot *r = &g_rel[i];
        if (!r->used || (int)(now - r->next_ms) < 0) continue;
        if (r->keep && r->tries >= RESEND_KEEP_MAX) {
            r->used = 0;
            g_net.dropped++;
            guard_note("canal fiable: creneau de session abandonne, le pair ne repond plus");
            continue;
        }
        if (r->tries >= RESEND_MAX && !r->keep && !r->voided) {
            rel_make_void(r);
            g_net.dropped++;
        } else if (r->voided && r->tries >= RESEND_VOID_MAX) {
            r->used = 0;
            guard_note("canal fiable: un creneau abandonne, le pair ne repond plus");
            continue;
        }
        due[k++] = i;
    }
    if (!k) return;

    burst = k < RESEND_BURST ? k : RESEND_BURST;
    for (j = 0; j < burst; j++) {
        int best = j;
        RelSlot *r;
        for (i = j + 1; i < k; i++)
            if (g_rel[due[i]].id < g_rel[due[best]].id) best = i;
        i = due[j]; due[j] = due[best]; due[best] = i;

        r = &g_rel[due[j]];
        r->tries++;
        r->next_ms = now + rel_backoff(r->tries, g_net.rtt_ms);
        ((CoopHdr *)r->buf)->rel_ack = g_rxHi;
        ((CoopHdr *)r->buf)->rel_mask = g_rxBits;
        if (raw_send(r->buf, r->len, &g_net.peer)) g_net.resent++;
    }
}

static int echo_tag(int type, unsigned flags, const void *payload, int n) {
    int off = (flags & EF_WITNESS) ? (int)sizeof(CoopWitness) : 0;
    if (!payload || n <= off) return type;
    return type | ((int)((const unsigned char *)payload)[off] << 8);
}

static void batch_discard(void) {
    int off = 0;
    while (off + (int)sizeof(CoopEvent) <= g_batchN) {
        const CoopEvent *e = (const CoopEvent *)(g_batch + off);
        int lane = (int)(e->flags & EF_LANE_MASK);
        if (lane > LANE_LOOSE && lane < LANE_COUNT) g_ordOut[lane]--;
        off += (int)sizeof(CoopEvent) + (int)e->payload_len;
    }
    g_batchN = 0;
    g_batchKeep = 0;
}

void net_ev_begin(void) { g_batchDepth++; }

void net_ev_flush(void) {
    int i, len;
    CoopHdr *h;

    if (g_batchDepth > 0) g_batchDepth--;
    if (!g_batchN) return;
    if (!g_net.up || !g_net.pinned) { batch_discard(); return; }

    for (i = 0; i < REL_SLOTS && g_rel[i].used; i++) ;
    if (i == REL_SLOTS) {
        g_net.dropped++;
        batch_discard();
        guard_note("canal fiable sature, evenement perdu");
        return;
    }

    len = (int)sizeof(CoopHdr) + g_batchN;
    h = (CoopHdr *)g_rel[i].buf;
    if (!g_relNext) g_relNext = 1;
    hdr_fill(h, COOP_EVENT, len, g_relNext, g_worldTime);
    memcpy(g_rel[i].buf + sizeof(CoopHdr), g_batch, (size_t)g_batchN);

    g_rel[i].used = 1;
    g_rel[i].keep = g_batchKeep;
    g_rel[i].voided = 0;
    g_rel[i].id = g_relNext++;
    g_rel[i].tries = 1;
    g_rel[i].next_ms = GetTickCount() + rel_backoff(1, g_net.rtt_ms);
    g_rel[i].len = len;
    if (raw_send(g_rel[i].buf, len, &g_net.peer)) g_net.sent++;

    g_batchN = 0;
    g_batchKeep = 0;
}

int net_ev_add(int type, unsigned long long key, int lane, unsigned flags,
               const void *payload, int n) {
    CoopEvent *ev;
    int need;

    if (!g_net.up || !g_net.pinned) return 0;
    if (g_replayDepth) return 0;
    if (type <= 0 || type >= CEV_MAX) return 0;
    if (n < 0) n = 0;
    if (n > COOP_EV_PAYLOAD_MAX) return 0;
    if (lane < 0 || lane >= LANE_COUNT) lane = LANE_LOOSE;
    if ((flags & EF_ONCE) && done_test(key, type)) return 0;
    if (key && !(flags & EF_NOECHO) && echo_take(key, echo_tag(type, flags, payload, n))) {
        g_net.echo_swallowed++;
        return 0;
    }

    need = (int)sizeof(CoopEvent) + n;
    if (g_batchN + need > COOP_MTU - (int)sizeof(CoopHdr)) {
        g_batchDepth++;
        net_ev_flush();
    }

    ev = (CoopEvent *)(g_batch + g_batchN);
    ev->type = (unsigned char)type;
    ev->flags = (unsigned char)((flags & ~EF_LANE_MASK) | (unsigned)lane);
    ev->ord = (lane == LANE_LOOSE) ? 0 : g_ordOut[lane]++;
    ev->payload_len = (unsigned short)n;
    ev->epoch = g_epoch;
    ev->key = key;
    if (n) memcpy(g_batch + g_batchN + sizeof(CoopEvent), payload, (size_t)n);
    g_batchN += need;
    if (lane == LANE_SESSION) g_batchKeep = 1;
    if (flags & EF_ONCE) done_mark(key, type);
    g_net.evsent++;

    if (!g_batchDepth) {
        g_batchDepth++;
        net_ev_flush();
    }
    return 1;
}

int net_ev_now(int type, unsigned long long key, int lane, unsigned flags,
               const void *payload, int n) {
    int r;
    net_ev_begin();
    r = net_ev_add(type, key, lane, flags, payload, n);
    net_ev_flush();
    return r;
}

void net_send_event(int type, unsigned long long key, const void *payload, int n) {
    net_ev_now(type, key, LANE_LOOSE, 0, payload, n);
}

int net_ev_subscribe(int type, CoopEvCb cb) {
    if (!cb || g_subN >= SUBN) return 0;
    g_sub[g_subN].type = type;
    g_sub[g_subN].cb = cb;
    g_subN++;
    return 1;
}

static unsigned echo_ttl_for(int type) {
    switch (type) {
    case CEV_KISMET: case CEV_TRIGGER: case CEV_MATINEE: case CEV_BINK:
    case CEV_CTXACT: case CEV_BLOCKPIECE:
        return 3000;
    default:
        return (unsigned)g_cfg.echo_ttl_ms;
    }
}

void net_ev_dispatch(const CoopEvent *e, const void *payload, int n) {
    int i;

    if (!e) return;
    if (!g_deferRun && (e->flags & EF_ONCE) && done_test(e->key, e->type)) return;
    if (e->flags & EF_ONCE) done_mark(e->key, e->type);
    if (e->key && !(e->flags & EF_NOECHO))
        echo_arm(e->key, echo_tag(e->type, e->flags, payload, n), echo_ttl_for(e->type));

    COOP_REPLAY_BEGIN();
    for (i = 0; i < g_subN; i++)
        if (!g_sub[i].type || g_sub[i].type == (int)e->type) g_sub[i].cb(e, payload, n);
    COOP_REPLAY_END();
    g_net.replayed++;
}

void net_ev_dispatch_deferred(const CoopEvent *e, const void *payload, int n) {
    g_deferRun = 1;
    net_ev_dispatch(e, payload, n);
    g_deferRun = 0;
}

void net_epoch_reset(void) {
    int i;
    for (i = 0; i < REL_SLOTS; i++)
        if (g_rel[i].used && !g_rel[i].keep) g_rel[i].used = 0;
    batch_discard();
    lanes_reset(0);
}

static void lane_drain(CoopLane *L) {
    int i, found = 1;
    while (found && L->n) {
        found = 0;
        for (i = 0; i < LANE_HOLD; i++) {
            LaneHold *hd = &L->hold[i];
            if (!hd->used || hd->ord != L->next_ord) continue;
            hd->used = 0;
            L->n--;
            L->next_ord++;
            net_ev_dispatch(&hd->ev, hd->buf, hd->len);
            g_net.reordered++;
            found = 1;
        }
    }
    if (!L->n) L->gap_ms = 0;
}

static void lane_route(int lane, const CoopEvent *e, const void *p, int n) {
    CoopLane *L = &g_lane[lane];
    LaneHold *hd = 0;
    short d;
    int i;

    if (!L->started) { L->started = 1; L->next_ord = e->ord; }
    d = (short)((unsigned short)(e->ord - L->next_ord));
    if (d < 0) return;
    if (d == 0) {
        L->next_ord++;
        net_ev_dispatch(e, p, n);
        lane_drain(L);
        return;
    }
    if (n <= LANE_PAYLOAD) {
        for (i = 0; i < LANE_HOLD; i++) {
            if (L->hold[i].used && L->hold[i].ord == e->ord) return;
            if (!L->hold[i].used && !hd) hd = &L->hold[i];
        }
    }
    if (!hd) {
        L->next_ord = (unsigned short)(e->ord + 1);
        g_net.lane_skip++;
        net_ev_dispatch(e, p, n);
        lane_drain(L);
        return;
    }
    hd->used = 1;
    hd->ord = e->ord;
    hd->len = (unsigned char)n;
    hd->ev = *e;
    if (n) memcpy(hd->buf, p, (size_t)n);
    L->n++;
    if (!L->gap_ms) L->gap_ms = GetTickCount();
}

static void lane_pump(unsigned now) {
    int lane, i;
    for (lane = LANE_WORLD; lane < LANE_COUNT; lane++) {
        CoopLane *L = &g_lane[lane];
        unsigned wait = (lane == LANE_SESSION) ? LANE_SESSION_GAP_MS
                                               : (unsigned)g_cfg.lane_gap_ms;
        unsigned short best = 0;
        int have = 0;
        if (!L->n) continue;
        if (!L->gap_ms || now - L->gap_ms < wait) continue;
        for (i = 0; i < LANE_HOLD; i++) {
            if (!L->hold[i].used) continue;
            if (!have || (short)(L->hold[i].ord - best) < 0) { best = L->hold[i].ord; have = 1; }
        }
        if (!have) { L->gap_ms = 0; continue; }
        coop_log("coop: voie %d, saut de l'ordre %u vers %u", lane,
                 (unsigned)L->next_ord, (unsigned)best);
        L->next_ord = best;
        L->gap_ms = 0;
        g_net.lane_skip++;
        lane_drain(L);
    }
}

static void ev_receive(const CoopEvent *e, const void *p, int n) {
    int lane = (int)(e->flags & EF_LANE_MASK);
    if (e->type == CEV_VOID) return;
    if (e->type >= CEV_MAX) { g_net.bad++; return; }
    g_net.evrecv++;
    if (lane != LANE_SESSION && e->type != CEV_NAME && e->type != CEV_EPOCH &&
        e->epoch != g_epoch) {
        g_net.stale++;
        return;
    }
    if (e->type == CEV_EPOCH) {
        unsigned short want = 0;
        if (n >= 2) memcpy(&want, p, 2);
        coop_epoch_adopt(want);
        return;
    }
    if (lane == LANE_LOOSE) { net_ev_dispatch(e, p, n); return; }
    lane_route(lane, e, p, n);
}

void net_send_bye(void) {
    CoopHdr h;
    if (!g_net.up || !g_net.pinned) return;
    hdr_fill(&h, COOP_BYE, (int)sizeof h, 0, g_worldTime);
    raw_send(&h, (int)sizeof h, &g_net.peer);
}

void net_send_digest(const void *body, int n) {
    unsigned char pkt[COOP_MTU];
    CoopHdr *h = (CoopHdr *)pkt;
    int len = (int)sizeof(CoopHdr) + n;
    if (!g_net.up || !g_net.pinned || n <= 0 || len > COOP_MTU) return;
    hdr_fill(h, COOP_DIGEST, len, 0, g_worldTime);
    memcpy(pkt + sizeof(CoopHdr), body, (size_t)n);
    if (raw_send(pkt, len, &g_net.peer)) g_net.sent++;
}

int net_send_state(const CoopState *s, float world_time) {
    unsigned char pkt[sizeof(CoopHdr) + sizeof(CoopState)];
    CoopHdr *h = (CoopHdr *)pkt;
    unsigned now = GetTickCount();
    int hz = g_cfg.rate_hz;

    if (!g_net.up || !g_net.pinned) return 0;
    if (g_safe || g_cfg.safe_mode) hz = 20;
    else if (g_net.rtt_ms && g_net.rtt_ms < 10 && hz < 60) hz = 60;
    if (hz < 5) hz = 5;
    if (now - g_lastStateMs < (unsigned)(1000 / hz)) return 0;
    g_lastStateMs = now;

    hdr_fill(h, COOP_STATE, (int)sizeof pkt, 0, world_time);
    memcpy(pkt + sizeof(CoopHdr), s, sizeof *s);
    if (!raw_send(pkt, (int)sizeof pkt, &g_net.peer)) return 0;
    g_net.sent++;
    return 1;
}

static int rel_seen(unsigned id) {
    unsigned long long m;
    if (!id) return 0;
    if (id <= g_rxHi) return 1;
    if (id - g_rxHi <= 64) {
        m = 1ull << ((id - g_rxHi) - 1);
        if (g_rxBits & m) return 1;
        g_rxBits |= m;
        while (g_rxBits & 1ull) { g_rxHi++; g_rxBits >>= 1; }
        return 0;
    }
    g_rxHi = id;
    g_rxBits = 0;
    return 0;
}

static void on_hello(const CoopHdr *h, const CoopHello *b, const struct sockaddr_in *from,
                     unsigned now, float world_time) {
    char nick[24];
    int wasPinned = g_net.pinned;
    (void)h;
    if (!b->id || b->id == g_net.self_id) return;

    memcpy(nick, b->nick, sizeof b->nick);
    nick[sizeof nick - 1] = 0;

    if (!g_net.pinned) {
        g_net.peer = *from;
        g_net.pinned = 1;
        g_net.peer_id = b->id;
        lstrcpynA(g_net.peer_name, nick[0] ? nick : "PAIR", sizeof g_net.peer_name);
        if (g_cfg.role == 1)      g_net.host = 1;
        else if (g_cfg.role == 2) g_net.host = 0;
        else                      g_net.host = (g_net.self_id < b->id) ? 1 : 0;
        if (g_helloSentMs && now >= g_helloSentMs) g_net.rtt_ms = now - g_helloSentMs;
        g_net.last_rx_ms = now;
        coop_log("coop: pair '%s' sur %s:%d - je suis %s", g_net.peer_name,
                 inet_ntoa(from->sin_addr), (int)ntohs(from->sin_port),
                 g_net.host ? "HOTE" : "CLIENT");
    }
    if (!wasPinned) hello_to(from, world_time);
}

static int same_peer(const struct sockaddr_in *a) {
    return a->sin_addr.s_addr == g_net.peer.sin_addr.s_addr && a->sin_port == g_net.peer.sin_port;
}

static void net_poll(unsigned now, float world_time) {
    unsigned char pkt[COOP_MTU];
    struct sockaddr_in from;
    int flen, n, guard;
    CoopHdr *h;

    for (guard = 0; guard < 64; guard++) {
        flen = (int)sizeof from;
        n = recvfrom(g_sock, (char *)pkt, (int)sizeof pkt, 0, (struct sockaddr *)&from, &flen);
        if (n <= 0) break;
        if (n < (int)sizeof(CoopHdr)) { g_net.bad++; continue; }
        h = (CoopHdr *)pkt;
        if (h->magic != COOP_MAGIC) { g_net.bad++; continue; }
        if (h->version != COOP_VERSION) { g_net.bad++; continue; }
        if (h->len != (unsigned short)n) { g_net.bad++; continue; }

        if (h->msg == COOP_HELLO) {
            if (n < (int)(sizeof(CoopHdr) + sizeof(CoopHello))) { g_net.bad++; continue; }
            on_hello(h, (CoopHello *)(pkt + sizeof(CoopHdr)), &from, now, world_time);
            continue;
        }
        if (!g_net.pinned || !same_peer(&from)) { g_net.bad++; continue; }

        rel_purge(h->rel_ack, h->rel_mask);
        g_net.last_rx_ms = now;
        g_net.recvd++;
        g_net.peer_epoch = h->epoch;
        if ((short)(h->epoch - g_epoch) > 0) coop_epoch_adopt(h->epoch);

        switch (h->msg) {
        case COOP_STATE:
            if (n < (int)(sizeof(CoopHdr) + sizeof(CoopState))) { g_net.bad++; break; }
            if (h->seq <= g_seqIn) break;
            g_seqIn = h->seq;
            on_state_packet((CoopState *)(pkt + sizeof(CoopHdr)), h->world_time, world_time);
            break;
        case COOP_EVENT: {
            int off = (int)sizeof(CoopHdr);
            if (rel_seen(h->rel_id)) break;
            while (off + (int)sizeof(CoopEvent) <= n) {
                CoopEvent *e = (CoopEvent *)(pkt + off);
                int pl = (int)e->payload_len;
                if (off + (int)sizeof(CoopEvent) + pl > n) { g_net.bad++; break; }
                ev_receive(e, pkt + off + sizeof(CoopEvent), pl);
                off += (int)sizeof(CoopEvent) + pl;
            }
            break;
        }
        case COOP_DIGEST:
            on_digest_packet(pkt + sizeof(CoopHdr), n - (int)sizeof(CoopHdr));
            break;
        case COOP_BYE:
            coop_log("coop: le pair s'est deconnecte");
            g_net.pinned = 0;
            g_net.peer_id = 0;
            state_reset();
            break;
        default:
            g_net.bad++;
            break;
        }
    }
}

void net_pump(unsigned now, float world_time) {
    if (!g_net.up) return;
    net_poll(now, world_time);
    discovery(now, world_time);
    lane_pump(now);
    rel_pump(now);
    if (!g_net.pinned && now - g_openedMs > 30000 && now - g_lastHelloMs < 1100)
        coop_log_rate("coop: aucun pair apres 30 s, toujours en ecoute sur %d", g_net.bound_port);
}
