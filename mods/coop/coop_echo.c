#include "coop.h"

#define ECHON 32
#define DONEN 128

int            g_replayDepth;
unsigned short g_epoch = 1;

typedef struct {
    unsigned long long key;
    unsigned           expire_ms;
    unsigned short     tag;
    unsigned char      count;
} CoopEcho;

static CoopEcho g_echo[ECHON];

static unsigned long long g_done[DONEN];
static int                g_doneN;
static int                g_doneHead;

static unsigned long long done_key(unsigned long long key, int type) {
    unsigned long long k = key ^ ((unsigned long long)(unsigned)type * 0x9E3779B97F4A7C15ull);
    return k ? k : 1;
}

void echo_arm(unsigned long long key, int tag, unsigned ttl_ms) {
    unsigned now = GetTickCount();
    CoopEcho *slot = 0;
    int i;
    if (!key) return;
    if (ttl_ms < 200) ttl_ms = 200;
    for (i = 0; i < ECHON; i++) {
        CoopEcho *e = &g_echo[i];
        if (e->count && e->key == key && e->tag == (unsigned short)tag &&
            (int)(now - e->expire_ms) < 0) {
            if (e->count < 255) e->count++;
            e->expire_ms = now + ttl_ms;
            return;
        }
        if (!slot && (!e->count || (int)(now - e->expire_ms) >= 0)) slot = e;
    }
    if (!slot) return;
    slot->key = key;
    slot->tag = (unsigned short)tag;
    slot->count = 1;
    slot->expire_ms = now + ttl_ms;
}

int echo_take(unsigned long long key, int tag) {
    unsigned now = GetTickCount();
    int i;
    if (!key) return 0;
    for (i = 0; i < ECHON; i++) {
        CoopEcho *e = &g_echo[i];
        if (!e->count || e->key != key || e->tag != (unsigned short)tag) continue;
        if ((int)(now - e->expire_ms) >= 0) { e->count = 0; return 0; }
        e->count--;
        return 1;
    }
    return 0;
}

void echo_pump(unsigned now) {
    int i;
    for (i = 0; i < ECHON; i++)
        if (g_echo[i].count && (int)(now - g_echo[i].expire_ms) >= 0) g_echo[i].count = 0;
}

void echo_clear(void) {
    memset(g_echo, 0, sizeof g_echo);
}

int done_test(unsigned long long key, int type) {
    unsigned long long k = done_key(key, type);
    int i;
    for (i = 0; i < g_doneN; i++) if (g_done[i] == k) return 1;
    return 0;
}

void done_mark(unsigned long long key, int type) {
    unsigned long long k = done_key(key, type);
    int i;
    for (i = 0; i < g_doneN; i++) if (g_done[i] == k) return;
    if (g_doneN < DONEN) {
        g_done[g_doneN++] = k;
        return;
    }
    g_done[g_doneHead] = k;
    g_doneHead = (g_doneHead + 1) % DONEN;
}

void done_clear(void) {
    g_doneN = 0;
    g_doneHead = 0;
}

static void epoch_purge(void) {
    net_epoch_reset();
    coop_key_flush();
    coop_key_epoch_reset();
    echo_clear();
    done_clear();
    g_replayDepth = 0;
}

void coop_epoch_bump(const char *why) {
    unsigned short next = g_epoch;
    if ((short)(g_net.peer_epoch - next) > 0) next = g_net.peer_epoch;
    next++;
    if (!next) next = 1;
    g_epoch = next;
    epoch_purge();
    net_ev_now(CEV_EPOCH, 0, LANE_LOOSE, 0, &g_epoch, 2);
    coop_log("coop: epoque %u (%s)", (unsigned)g_epoch, why ? why : "");
}

void coop_epoch_adopt(unsigned short e) {
    if (!e || (short)(e - g_epoch) <= 0) return;
    g_epoch = e;
    epoch_purge();
    coop_log("coop: epoque du pair adoptee -> %u", (unsigned)g_epoch);
}
