#include "hysteria.h"
#include "mod_internal.h"

#define GL_CFG_MOD      "hysteria"
#define GL_CFG_ON       "gamelog"
#define GL_CFG_RATE     "gamelog_rate"
#define GL_RATE_DEFAULT 800
#define GL_RATE_MAX     5000
#define GL_DEPTH_MAX    4
#define GL_SLICE_MS     200
#define GL_SCAN_WIN     0x10000u
#define GL_MSG_MAX      512
#define GL_SRC_MAX      160
#define GL_TAG_MAX      48

typedef struct { WCHAR *data; int count; int max; } GStr;
typedef struct { int index; int number; } GName;

int g_gameLogWant = -1;
int g_gameLogRate = GL_RATE_DEFAULT;

static void    **g_gnTable;
static Native_t  g_origLog, g_origWarn;
static AppFree_t g_appFree;
static unsigned *g_ucFlags;
static int       g_installed;
static int       g_glFailed;
static AGameLogCb g_cb;

static volatile LONG g_glTid;
static volatile LONG g_glDepth;
static DWORD g_winStart, g_dropStart;
static int  g_winCount, g_winDropped;

static const unsigned char GL_PROLOGUE[6] = { 0x55, 0x8B, 0xEC, 0x6A, 0xFF, 0x68 };

static IMAGE_NT_HEADERS *image_nt(void){
    HMODULE m = GetModuleHandleA(NULL);
    IMAGE_DOS_HEADER *dos; IMAGE_NT_HEADERS *nt;
    if(!m) return 0;
    dos = (IMAGE_DOS_HEADER*)m;
    if(!mem_ok(dos,0x40) || dos->e_magic!=IMAGE_DOS_SIGNATURE) return 0;
    nt = (IMAGE_NT_HEADERS*)((char*)m + dos->e_lfanew);
    if(!mem_ok(nt,sizeof *nt) || nt->Signature!=IMAGE_NT_SIGNATURE) return 0;
    return nt;
}

static int code_ok(const void *p){
    const unsigned char *b = (const unsigned char*)p;
    return mem_ok(b,16) && b[0]==0x55 && b[1]==0x8B && b[2]==0xEC;
}

static int prologue_ok(const void *p){
    const unsigned char *b = (const unsigned char*)p;
    int i;
    if(!mem_ok(b,16)) return 0;
    for(i=0;i<6;i++) if(b[i]!=GL_PROLOGUE[i]) return 0;
    return 1;
}

static int table_ok(void **tbl, unsigned lo, unsigned hi){
    unsigned a = (unsigned)(ULONG_PTR)tbl;
    if(!tbl || (a&3) || a<lo || a+GNATIVES_COUNT*4>hi) return 0;
    if(!mem_ok(tbl,(NATIVE_WARNINTERNAL+1)*4)) return 0;
    if((unsigned)(ULONG_PTR)tbl[NATIVE_LOGINTERNAL]  != lo+RVA_EXEC_LOGINTERNAL)  return 0;
    if((unsigned)(ULONG_PTR)tbl[NATIVE_WARNINTERNAL] != lo+RVA_EXEC_WARNINTERNAL) return 0;
    if(!prologue_ok(tbl[NATIVE_LOGINTERNAL]) || !prologue_ok(tbl[NATIVE_WARNINTERNAL])) return 0;
    return 1;
}

static void **scan_window(const unsigned char *p, unsigned n, unsigned lo, unsigned hi){
    unsigned i, end = n - 17;
    for(i=0;i<end;i++){
        unsigned undef, tbl;
        if(p[i]!=0xB9 || p[i+1]!=0x00 || p[i+2]!=0x10 || p[i+3]!=0x00 || p[i+4]!=0x00) continue;
        if(p[i+5]!=0xB8 || p[i+10]!=0xBF || p[i+15]!=0xF3 || p[i+16]!=0xAB) continue;
        undef = *(const unsigned*)(p+i+6);
        tbl   = *(const unsigned*)(p+i+11);
        if(undef<lo || undef>=hi) continue;
        if(table_ok((void**)(ULONG_PTR)tbl, lo, hi)) return (void**)(ULONG_PTR)tbl;
    }
    return 0;
}

static void **scan_section(const unsigned char *p, unsigned n, unsigned lo, unsigned hi){
    unsigned off = 0;
    while(n >= 24 && off <= n - 24){
        unsigned win = n - off;
        void **tbl;
        if(win > GL_SCAN_WIN) win = GL_SCAN_WIN;
        while(win >= 24 && !mem_ok(p + off, win)) win >>= 1;
        if(win < 24){ off += GL_SCAN_WIN; continue; }
        tbl = scan_window(p + off, win, lo, hi);
        if(tbl) return tbl;
        off += win - 17;
    }
    return 0;
}

static void **table_scan(IMAGE_NT_HEADERS *nt, unsigned lo, unsigned hi){
    IMAGE_SECTION_HEADER *sec = IMAGE_FIRST_SECTION(nt);
    unsigned count = nt->FileHeader.NumberOfSections, i;
    if(!mem_ok(sec, count*(unsigned)sizeof *sec)) return 0;
    for(i=0;i<count;i++){
        void **tbl;
        if(!(sec[i].Characteristics & IMAGE_SCN_MEM_EXECUTE)) continue;
        if(!sec[i].Misc.VirtualSize || lo + sec[i].VirtualAddress + sec[i].Misc.VirtualSize > hi) continue;
        tbl = scan_section((const unsigned char*)(ULONG_PTR)(lo + sec[i].VirtualAddress),
                           sec[i].Misc.VirtualSize, lo, hi);
        if(tbl) return tbl;
    }
    return 0;
}

static void gl_step(void *frame, void *result){
    unsigned char **pc = (unsigned char**)((char*)frame + FF_CODE);
    void *ctx = *(void**)((char*)frame + FF_OBJECT);
    unsigned op = **pc;
    (*pc)++;
    ((Native_t)g_gnTable[op])(ctx, 0, frame, result);
}

static void gl_finish(void *frame){
    unsigned char **pc = (unsigned char**)((char*)frame + FF_CODE);
    (*pc)++;
    if(**pc == EX_DEBUGINFO) gl_step(frame, 0);
}

static void gl_text(const GStr *s, char *out, int cap){
    int n, room, w, i;
    out[0] = 0;
    if(!s->data || s->count<=0 || s->max<s->count || s->count>0x8000) return;
    if(!mem_ok(s->data, s->count*2)) return;
    n = s->count;
    while(n>0 && s->data[n-1]==0) n--;
    if(!n) return;
    room = (cap-1)/3;
    if(n>room) n = room;
    if(n<=0) return;
    w = WideCharToMultiByte(CP_UTF8, 0, s->data, n, out, cap-1, NULL, NULL);
    if(w<=0){ out[0]=0; return; }
    out[w] = 0;
    for(i=0;i<w;i++){
        unsigned char c = (unsigned char)out[i];
        if(c<0x20 || c==0x7F) out[i] = ' ';
    }
}

static void gl_release(GStr *s){
    if(s->data && g_appFree) g_appFree(s->data, 1);
    s->data = 0; s->count = 0; s->max = 0;
}

static void gl_tag(int index, char *out, int cap){
    const char *s = uname(index);
    int i = 0, room = cap - 1;
    while(room > 3 && !mem_ok(s, room)) room >>= 1;
    if(room > 3)
        for(; i < room && s[i]; i++){
            unsigned char c = (unsigned char)s[i];
            out[i] = (c < 0x20 || c >= 0x7F) ? '?' : (char)c;
        }
    if(!i) out[i++] = '?';
    out[i] = 0;
}

static void gl_source(void *frame, char *out, int cap){
    void *node = *(void**)((char*)frame + FF_NODE);
    out[0] = 0;
    if(mem_ok(node, O_OUTER+4)) obj_full_name(node, out, cap);
}

static int gl_budget(void){
    DWORD now = GetTickCount();
    int quota = g_gameLogRate / (1000 / GL_SLICE_MS);
    if(quota < 1) quota = 1;
    if(now - g_winStart >= GL_SLICE_MS){ g_winStart = now; g_winCount = 0; }
    if(g_winDropped && now - g_dropStart >= 1000){
        logmsg("[jeu] %d lignes ignorees (limite %d/s)\r\n", g_winDropped, g_gameLogRate);
        g_winDropped = 0;
    }
    if(g_winCount >= quota){
        if(!g_winDropped) g_dropStart = now;
        g_winDropped++;
        return 0;
    }
    g_winCount++;
    return 1;
}

static int gl_enter(void *frame){
    LONG tid;
    if(!g_installed || g_gameLogWant <= 0) return 0;
    if(!mem_ok(frame, FF_SIZE)) return 0;
    if(!mem_ok(*(void**)((char*)frame+FF_CODE), 2)) return 0;
    tid = (LONG)GetCurrentThreadId();
    if(g_glTid != tid){
        if(InterlockedCompareExchange(&g_glTid, tid, 0) != 0) return 0;
        g_glDepth = 0;
    }
    if(g_glDepth >= GL_DEPTH_MAX || !gl_budget()){
        if(!g_glDepth) InterlockedExchange(&g_glTid, 0);
        return 0;
    }
    g_glDepth++;
    return 1;
}

static void gl_leave(void){
    if(g_glDepth <= 0) return;
    if(!--g_glDepth) InterlockedExchange(&g_glTid, 0);
}

static const char *const GL_MUTE[] = {
    "shouldDefaultInvertControls", "shouldPromptVideoConfig",
    "getIsJPNSKU", "AtTimeTick"};

static int gl_muted(const char *msg, const char *src){
    int i;
    for(i=0;i<4;i++){
        if(contains(msg, GL_MUTE[i])) return 1;
        if(src && contains(src, GL_MUTE[i])) return 1;
    }
    return 0;
}

static void gl_emit(const char *tag, const char *msg, const char *src){
    if(gl_muted(msg, src)) return;
    if(src[0]) logmsg("[jeu][%s] %s   <%s>\r\n", tag, msg, src);
    else       logmsg("[jeu][%s] %s\r\n", tag, msg);
    if(g_cb) g_cb(tag, msg, src);
}

static void __fastcall gl_hook_log(void *obj, void *edx, void *frame, void *result){
    GStr s; GName tag; char msg[GL_MSG_MAX], src[GL_SRC_MAX], tg[GL_TAG_MAX];
    if(!gl_enter(frame)){ g_origLog(obj, edx, frame, result); return; }
    s.data = 0; s.count = 0; s.max = 0;
    gl_step(frame, &s);
    *g_ucFlags &= ~(unsigned)RUC_SKIPPEDOPTIONALPARM;
    tag.index = NAME_SCRIPTLOG; tag.number = 0;
    gl_step(frame, &tag);
    gl_finish(frame);
    gl_text(&s, msg, sizeof msg);
    gl_release(&s);
    gl_source(frame, src, sizeof src);
    gl_tag(tag.index, tg, sizeof tg);
    gl_emit(tg, msg, src);
    gl_leave();
}

static void __fastcall gl_hook_warn(void *obj, void *edx, void *frame, void *result){
    GStr s; char msg[GL_MSG_MAX], src[GL_SRC_MAX];
    if(!gl_enter(frame)){ g_origWarn(obj, edx, frame, result); return; }
    s.data = 0; s.count = 0; s.max = 0;
    gl_step(frame, &s);
    gl_finish(frame);
    gl_text(&s, msg, sizeof msg);
    gl_release(&s);
    gl_source(frame, src, sizeof src);
    gl_emit("ScriptWarning", msg, src);
    gl_leave();
}

static int gamelog_install(void){
    IMAGE_NT_HEADERS *nt = image_nt();
    unsigned lo, hi;
    void **tbl, **guess;
    DWORD old;
    if(g_installed) return 1;
    if(!nt){ logmsg("[jeu] installation refusee: image introuvable\r\n"); return 0; }
    lo = (unsigned)(ULONG_PTR)GetModuleHandleA(NULL);
    hi = lo + nt->OptionalHeader.SizeOfImage;

    guess = (void**)(ULONG_PTR)(lo + RVA_GNATIVES);
    tbl = table_ok(guess, lo, hi) ? guess : table_scan(nt, lo, hi);
    if(!tbl){
        logmsg("[jeu] installation refusee: GNatives introuvable (attendu %08x, [231]=%08x [232]=%08x)\r\n",
               (unsigned)(ULONG_PTR)guess,
               mem_ok(&guess[NATIVE_LOGINTERNAL],4)?(unsigned)(ULONG_PTR)guess[NATIVE_LOGINTERNAL]:0u,
               mem_ok(&guess[NATIVE_WARNINTERNAL],4)?(unsigned)(ULONG_PTR)guess[NATIVE_WARNINTERNAL]:0u);
        return 0;
    }

    g_appFree = (AppFree_t)(ULONG_PTR)(lo + RVA_APPFREE);
    g_ucFlags = (unsigned*)(ULONG_PTR)(lo + RVA_GRUNTIMEUCFLAGS);
    if(!code_ok((void*)g_appFree) || !mem_ok(g_ucFlags,4)){
        logmsg("[jeu] installation refusee: appFree/GRuntimeUCFlags illisibles\r\n");
        g_appFree = 0; g_ucFlags = 0;
        return 0;
    }

    g_origLog  = (Native_t)tbl[NATIVE_LOGINTERNAL];
    g_origWarn = (Native_t)tbl[NATIVE_WARNINTERNAL];
    g_gnTable  = tbl;

    if(!VirtualProtect(&tbl[NATIVE_LOGINTERNAL], 8, PAGE_READWRITE, &old)){
        logmsg("[jeu] installation refusee: GNatives non inscriptible\r\n");
        g_gnTable = 0; g_origLog = 0; g_origWarn = 0;
        return 0;
    }
    tbl[NATIVE_LOGINTERNAL]  = (void*)gl_hook_log;
    tbl[NATIVE_WARNINTERNAL] = (void*)gl_hook_warn;
    VirtualProtect(&tbl[NATIVE_LOGINTERNAL], 8, old, &old);

    g_winStart = g_dropStart = GetTickCount(); g_winCount = 0; g_winDropped = 0;
    g_installed = 1;
    logmsg("[jeu] capture des logs du script ACTIVE (GNatives=%08x log=%08x warn=%08x limite=%d/s)\r\n",
           (unsigned)(ULONG_PTR)tbl, (unsigned)(ULONG_PTR)g_origLog,
           (unsigned)(ULONG_PTR)g_origWarn, g_gameLogRate);
    return 1;
}

void gamelog_uninstall(void){
    DWORD old;
    if(!g_installed || !g_gnTable) { g_installed = 0; return; }
    if(VirtualProtect(&g_gnTable[NATIVE_LOGINTERNAL], 8, PAGE_READWRITE, &old)){
        if(g_gnTable[NATIVE_LOGINTERNAL]  == (void*)gl_hook_log)  g_gnTable[NATIVE_LOGINTERNAL]  = (void*)g_origLog;
        if(g_gnTable[NATIVE_WARNINTERNAL] == (void*)gl_hook_warn) g_gnTable[NATIVE_WARNINTERNAL] = (void*)g_origWarn;
        VirtualProtect(&g_gnTable[NATIVE_LOGINTERNAL], 8, old, &old);
    }
    g_installed = 0;
    logmsg("[jeu] capture des logs du script arretee\r\n");
}

int gamelog_active(void){ return g_installed; }

static int gamelog_apply(int on){
    if(!on){ if(g_installed) gamelog_uninstall(); return 0; }
    if(g_installed) return 1;
    if(g_glFailed) return 0;
    if(!gamelog_install()){ g_glFailed = 1; return 0; }
    return 1;
}

int gamelog_enable(int on){
    g_gameLogWant = gamelog_apply(on);
    return g_gameLogWant;
}

int gamelog_set(int on){
    int active = gamelog_enable(on);
    cfg_set_bool(GL_CFG_MOD, GL_CFG_ON, active);
    cfg_save(GL_CFG_MOD);
    return active;
}

int gamelog_rate(int linesPerSecond){
    if(linesPerSecond > 0)
        g_gameLogRate = linesPerSecond > GL_RATE_MAX ? GL_RATE_MAX : linesPerSecond;
    return g_gameLogRate;
}

void gamelog_set_cb(AGameLogCb cb){ g_cb = cb; }

void gamelog_update(void){
    if(g_gameLogWant < 0){
        g_gameLogRate = cfg_get_int(GL_CFG_MOD, GL_CFG_RATE, GL_RATE_DEFAULT);
        if(g_gameLogRate < 1) g_gameLogRate = 1;
        if(g_gameLogRate > GL_RATE_MAX) g_gameLogRate = GL_RATE_MAX;
        g_gameLogWant = cfg_get_bool(GL_CFG_MOD, GL_CFG_ON, 0) ? gamelog_apply(1) : 0;
        return;
    }
    if(key_edge(VK_F4) && !(GetAsyncKeyState(VK_MENU) & 0x8000)
                       && !(GetAsyncKeyState(VK_CONTROL) & 0x8000)){
        gamelog_set(!g_installed);
        return;
    }
    if(g_gameLogWant != g_installed) g_gameLogWant = gamelog_apply(g_gameLogWant);
}
