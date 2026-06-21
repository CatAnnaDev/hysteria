#include "hysteria.h"
#include <setjmp.h>

unsigned int g_gnames = 0;
unsigned int g_gobjects = 0;
int g_nameOff = 0x10;
int g_oOuter = 0x28, g_oName = 0x2C, g_oClass = 0x34;
void *g_pc = NULL;

static unsigned int cache_b[16], cache_e[16];
static int cache_idx;

void mem_ok_reset(void){
    for(int i=0;i<16;i++){ cache_b[i]=0; cache_e[i]=0; }
    cache_idx=0;
}

static int ptr_ok(const void *p){
    unsigned int v=(unsigned int)(ULONG_PTR)p;
    return v>=0x10000u && v<0x7ff00000u;
}

int mem_ok(const void *p, int n){
    if(!ptr_ok(p)) return 0;
    unsigned int a=(unsigned int)(ULONG_PTR)p, e=a+n;
    for(int i=0;i<16;i++){ if(cache_b[i] && a>=cache_b[i] && e<=cache_e[i]) return 1; }
    MEMORY_BASIC_INFORMATION mbi;
    if(!VirtualQuery(p,&mbi,sizeof mbi)) return 0;
    if(mbi.State!=MEM_COMMIT) return 0;
    DWORD pr=mbi.Protect & 0xFF;
    if(!(pr==PAGE_READONLY||pr==PAGE_READWRITE||pr==PAGE_WRITECOPY||pr==PAGE_EXECUTE_READ||pr==PAGE_EXECUTE_READWRITE||pr==PAGE_EXECUTE_WRITECOPY)) return 0;
    if(mbi.Protect & PAGE_GUARD) return 0;
    unsigned int base=(unsigned int)(ULONG_PTR)mbi.BaseAddress, end=base+mbi.RegionSize;
    if(e>end) return 0;
    cache_b[cache_idx&15]=base; cache_e[cache_idx&15]=end; cache_idx++;
    return 1;
}

int contains(const char *h, const char *n){
    if(!h||!n) return 0;
    for(;*h;h++){ const char *a=h,*b=n; while(*a&&*b&&*a==*b){a++;b++;} if(!*b) return 1; }
    return 0;
}

static int entry_name_off(void *entry, const char *want){
    static const int offs[]={0x10,0x0c,0x14,0x18,0x08,0x0a};
    for(unsigned k=0;k<sizeof(offs)/sizeof(offs[0]);k++){
        const char *nm=(const char*)entry+offs[k];
        if(mem_ok(nm,8) && lstrcmpA(nm,want)==0) return offs[k];
    }
    return -1;
}

void scan_gnames(void){
    if(g_gnames) return;
    static DWORD lastTry=0; DWORD now=GetTickCount();
    if(lastTry && now-lastTry<500) return;
    lastTry=now;
    int cand=0, dataok=0; MEMORY_BASIC_INFORMATION mbi;
    unsigned int a=0x400000;
    while(a<0x20000000 && VirtualQuery((void*)a,&mbi,sizeof mbi)){
        unsigned int base=(unsigned int)(ULONG_PTR)mbi.BaseAddress, sz=mbi.RegionSize;
        if(!sz) break;
        DWORD pr=mbi.Protect & 0xFF;
        int rd=(mbi.State==MEM_COMMIT) && !(mbi.Protect&PAGE_GUARD) &&
               (pr==PAGE_READWRITE||pr==PAGE_READONLY||pr==PAGE_WRITECOPY||pr==PAGE_EXECUTE_READ||pr==PAGE_EXECUTE_READWRITE);
        if(rd && sz>=12 && sz<0x4000000){
            for(unsigned int p=base; p+12<=base+sz; p+=4){
                int cnt=*(int*)(p+4), mx=*(int*)(p+8);
                if(cnt<200 || cnt>400000 || mx<cnt || mx>cnt*4+16) continue;
                void **data=*(void***)p;
                if(!mem_ok(data,8)) continue;
                cand++;
                void *e0=data[0];
                if(!mem_ok(e0,0x20)) continue;
                dataok++;
                int off=entry_name_off(e0,"None");
                if(off<0) continue;
                g_gnames=p; g_nameOff=off;
                logmsg("[hysteria] GNames FOUND @%07X cnt=%d nameOff=0x%x\r\n",p,cnt,off);
                return;
            }
        }
        a=base+sz;
    }
    static int warned=0;
    if(!warned){ warned=1; logmsg("[hysteria] GNames not ready (cand=%d dataok=%d), retrying...\r\n",cand,dataok); }
}

const char* uname(int id){
    if(!g_gnames || id<0) return "<no-gnames>";
    void **gn=*(void***)g_gnames; int cnt=*(int*)(g_gnames+4);
    if(!mem_ok(gn,8) || id>=cnt) return "<?>";
    void *entry=gn[id];
    if(!mem_ok(entry, g_nameOff+2)) return "<?>";
    return (const char*)entry+g_nameOff;
}

void probe_engine_offsets(void){
    static int done=0;
    if(done || !g_gobjects) return;
    void **data=*(void***)g_gobjects;
    if(!mem_ok(data,8)) return;
    int cnt=*(int*)(g_gobjects+4);
    if(cnt<200) return;
    if(cnt>20000) cnt=20000;
    int nameCount=mem_ok((void*)(ULONG_PTR)g_gnames,8)?*(int*)(g_gnames+4):0;
    if(nameCount<10) return;
    static const int nameC[]={0x2C,0x28,0x30,0x24,0x20,0x34,0x0C,0x10,0x14,0x18,0x1C,0x38};
    static const int classC[]={0x34,0x30,0x2C,0x28,0x38,0x3C,0x40,0x24,0x44,0x48,0x20};
    int bestN=-1,bestC=-1,bestHits=0;
    for(unsigned ai=0;ai<sizeof nameC/sizeof*nameC;ai++)
    for(unsigned bi=0;bi<sizeof classC/sizeof*classC;bi++){
        int oN=nameC[ai], oC=classC[bi];
        if(oN==oC) continue;
        int wide=(oN>oC?oN:oC)+8, hits=0, tries=0, step=cnt/300+1;
        for(int i=0;i<cnt && tries<300;i+=step){
            void *o=data[i];
            if(!mem_ok(o,wide)) continue;
            tries++;
            void *cls=*(void**)((char*)o+oC);
            if(!mem_ok(cls,wide)) continue;
            void *cc=*(void**)((char*)cls+oC);
            if(!mem_ok(cc,oN+4)) continue;
            int ci=*(int*)((char*)cc+oN);
            if(ci<0||ci>=nameCount) continue;
            const char *nm=uname(ci);
            if(nm && lstrcmpA(nm,"Class")==0) hits++;
        }
        if(hits>bestHits){ bestHits=hits; bestN=oN; bestC=oC; }
    }
    if(bestHits>=8){
        g_oName=bestN; g_oClass=bestC;
        static const int outC[]={0x28,0x24,0x20,0x2C,0x30,0x1C,0x18};
        for(unsigned k=0;k<sizeof outC/sizeof*outC;k++){
            int oO=outC[k]; if(oO==g_oClass||oO==g_oName) continue;
            int ok=0,tr=0,step=cnt/120+1;
            for(int i=0;i<cnt && tr<120;i+=step){
                void *o=data[i]; if(!mem_ok(o,oO+4)) continue; tr++;
                void *ou=*(void**)((char*)o+oO);
                if(!ou){ ok++; continue; }
                if(mem_ok(ou,g_oName+4)){ int ni=*(int*)((char*)ou+g_oName); if(ni>=0&&ni<nameCount) ok++; }
            }
            if(tr>0 && ok>=tr*9/10){ g_oOuter=oO; break; }
        }
        done=1;
        logmsg("[hysteria] engine offsets probed: name=0x%x class=0x%x outer=0x%x (hits=%d)\r\n",g_oName,g_oClass,g_oOuter,bestHits);
    }
}

static jmp_buf g_sj;
static volatile int g_scanning=0;
static DWORD g_scanTid=0;
static LONG CALLBACK hysteria_veh(EXCEPTION_POINTERS *ep){
    if(g_scanning && GetCurrentThreadId()==g_scanTid && ep->ExceptionRecord->ExceptionCode==(DWORD)0xC0000005){ longjmp(g_sj,1); }
    return EXCEPTION_CONTINUE_SEARCH;
}
void scan_init(void){
    static int done=0;
    if(!done){ done=1; AddVectoredExceptionHandler(1,(PVECTORED_EXCEPTION_HANDLER)hysteria_veh); }
}
static unsigned int g_selfLo, g_selfHi, g_stackBase;
static void scan_setup_skips(void){
    g_scanTid=GetCurrentThreadId();
    HMODULE self=NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS|GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,(LPCSTR)&scan_setup_skips,&self);
    g_selfLo=(unsigned int)(ULONG_PTR)self;
    g_selfHi=g_selfLo+0x900000;
    MEMORY_BASIC_INFORMATION smb; int local=0;
    if(VirtualQuery(&local,&smb,sizeof smb)) g_stackBase=(unsigned int)(ULONG_PTR)smb.BaseAddress;
}
static int skip_region(unsigned int base){
    if(base>=0x70000000) return 1;
    if(base>=g_selfLo && base<g_selfHi) return 1;
    if(g_stackBase && base==g_stackBase) return 1;
    return 0;
}

void dump_name_layout(const char *s){
    scan_init();
    scan_setup_skips();
    int slen=lstrlenA(s);
    MEMORY_BASIC_INFORMATION mbi; unsigned int a=0x10000; int found=0; unsigned int hit=0;
    while(a<0x7f000000 && VirtualQuery((void*)(ULONG_PTR)a,&mbi,sizeof mbi)){
        unsigned int base=(unsigned int)(ULONG_PTR)mbi.BaseAddress, sz=mbi.RegionSize;
        if(!sz) break;
        DWORD pr=mbi.Protect & 0xFF;
        int rd=(mbi.State==MEM_COMMIT)&&!(mbi.Protect&PAGE_GUARD)&&(pr==PAGE_READWRITE||pr==PAGE_READONLY||pr==PAGE_WRITECOPY||pr==PAGE_EXECUTE_READ);
        if(rd && !skip_region(base) && sz<0x8000000 && found<2){
            for(unsigned int pg=base; pg+0x1000<=base+sz && found<2; pg+=0x1000){
                if(setjmp(g_sj)){ g_scanning=0; continue; }
                g_scanning=1;
                for(unsigned int p=pg; p+slen+1<=pg+0x1000; p++){
                    char *cp=(char*)(ULONG_PTR)p;
                    if(cp[0]!=s[0]) continue;
                    int m=1; for(int k=1;k<=slen;k++){ if(cp[k]!=s[k]){m=0;break;} }
                    if(!m || cp[slen]!=0) continue;
                    hit=p; found++;
                    unsigned int h0=(p>=16)?p-16:p;
                    logmsg("[hysteria][diag] '%s' @%08x  pre16: %08x %08x %08x %08x\r\n", s, p,
                        *(unsigned*)(ULONG_PTR)h0,*(unsigned*)(ULONG_PTR)(h0+4),*(unsigned*)(ULONG_PTR)(h0+8),*(unsigned*)(ULONG_PTR)(h0+12));
                    break;
                }
                g_scanning=0;
            }
        }
        a=base+sz;
    }
    if(!hit){ logmsg("[hysteria][diag] '%s' not found\r\n", s); return; }
    a=0x10000; int ptrs=0;
    while(a<0x7f000000 && VirtualQuery((void*)(ULONG_PTR)a,&mbi,sizeof mbi) && ptrs<4){
        unsigned int base=(unsigned int)(ULONG_PTR)mbi.BaseAddress, sz=mbi.RegionSize;
        if(!sz) break;
        DWORD pr=mbi.Protect & 0xFF;
        int rd=(mbi.State==MEM_COMMIT)&&!(mbi.Protect&PAGE_GUARD)&&(pr==PAGE_READWRITE||pr==PAGE_READONLY);
        if(rd && !skip_region(base) && sz<0x8000000){
            for(unsigned int pg=base; pg+0x1000<=base+sz && ptrs<4; pg+=0x1000){
                if(setjmp(g_sj)){ g_scanning=0; continue; }
                g_scanning=1;
                for(unsigned int p=pg; p+4<=pg+0x1000; p+=4){
                    unsigned v=*(unsigned*)(ULONG_PTR)p;
                    if(v==hit||(hit>=16&&v==hit-16)||(hit>=12&&v==hit-12)||(hit>=8&&v==hit-8)){
                        logmsg("[hysteria][diag] ptr @%08x -> entry %08x (delta %d)\r\n", p, v, (int)(hit-v)); ptrs++;
                    }
                }
                g_scanning=0;
            }
        }
        a=base+sz;
    }
}

static int looks_like_object(void *o){
    if(!g_gnames || !mem_ok(o,0x40)) return 0;
    int nc=*(int*)(g_gnames+4);
    static const int nc_off[]={0x2C,0x28,0x30,0x24,0x20,0x0C,0x10,0x34};
    for(unsigned k=0;k<sizeof nc_off/sizeof*nc_off;k++){
        int idx=*(int*)((char*)o+nc_off[k]);
        if(idx>0 && idx<nc){ const char *nm=uname(idx); if(mem_ok(nm,2) && nm[0]>32 && nm[0]<127) return 1; }
    }
    return 0;
}
void scan_gobjects(void){
    if(g_gobjects){
        void **data=*(void***)g_gobjects;
        if(mem_ok(data,8)){ int cnt=*(int*)(g_gobjects+4);
            if(cnt>100 && cnt<2000000 && mem_ok(data[0],0x40) && looks_like_object(data[0])) return; }
    }
    MEMORY_BASIC_INFORMATION mbi; unsigned int a=0x400000;
    while(a<0x40000000 && VirtualQuery((void*)a,&mbi,sizeof mbi)){
        unsigned int base=(unsigned int)(ULONG_PTR)mbi.BaseAddress, sz=mbi.RegionSize;
        if(!sz) break;
        DWORD pr=mbi.Protect & 0xFF;
        int rd=(mbi.State==MEM_COMMIT) && !(mbi.Protect&PAGE_GUARD) &&
               (pr==PAGE_READWRITE||pr==PAGE_READONLY||pr==PAGE_WRITECOPY);
        if(rd && sz>=12 && sz<0x4000000){
            for(unsigned int p=base; p+12<=base+sz; p+=4){
                int cnt=*(int*)(p+4), mx=*(int*)(p+8);
                if(cnt<200 || cnt>2000000 || mx<cnt || mx>cnt*2+1024) continue;
                void **data=*(void***)p;
                if(!mem_ok(data,32)) continue;
                int good=0;
                for(int k=0;k<8;k++) if(mem_ok(data[k],0x40) && looks_like_object(data[k])) good++;
                if(good>=6){ g_gobjects=p; logmsg("[hysteria] GObjects scanned @%08x cnt=%d\r\n",p,cnt); return; }
            }
        }
        a=base+sz;
    }
}

const char* obj_name(void *o){
    if(!mem_ok(o,O_NAME+4)) return "?";
    return uname(*(int*)((char*)o+O_NAME));
}
void obj_full_name(void *o, char *out, int cap){
    const char *stack[12]; int sp=0; void *cur=o;
    for(int i=0;i<12 && mem_ok(cur,O_OUTER+4);i++){
        stack[sp++]=obj_name(cur);
        void *ou=*(void**)((char*)cur+O_OUTER);
        if(!mem_ok(ou,O_NAME+4)) break;
        cur=ou;
    }
    int p=0; out[0]=0;
    for(int i=sp-1;i>=0;i--){ const char *s=stack[i]; while(*s&&p<cap-2)out[p++]=*s++; if(i>0&&p<cap-2)out[p++]='.'; }
    out[p]=0;
}
int find_name(const char *s){
    if(!g_gnames) return -1;
    void **gn=*(void***)g_gnames; int cnt=*(int*)(g_gnames+4);
    if(!mem_ok(gn,8)) return -1;
    if(cnt>400000) cnt=400000;
    for(int i=0;i<cnt;i++){
        void *e=gn[i];
        if(!mem_ok(e,g_nameOff+2)) continue;
        if(lstrcmpA((const char*)e+g_nameOff, s)==0) return i;
    }
    return -1;
}
const char* obj_class_name(void *o){
    if(!mem_ok(o,O_CLASS+4)) return "?";
    void *cls=*(void**)((char*)o+O_CLASS);
    if(!mem_ok(cls,O_NAME+4)) return "?";
    return uname(*(int*)((char*)cls+O_NAME));
}
void* outermost(void *o){
    for(int i=0;i<32 && mem_ok(o,O_OUTER+4);i++){
        void *ou=*(void**)((char*)o+O_OUTER);
        if(!mem_ok(ou,O_NAME+4)) break;
        o=ou;
    }
    return o;
}
void find_pc(void){
    if(!g_gobjects) return;
    void **data=*(void***)g_gobjects; int cnt=*(int*)(g_gobjects+4);
    if(!mem_ok(data,8)) return;
    if(cnt>400000) cnt=400000;
    for(int i=0;i<cnt;i++){
        void *o=data[i];
        if(!mem_ok(o,O_CLASS+4)) continue;
        if(!contains(obj_class_name(o),"PlayerController")) continue;
        const char *on=obj_name(o);
        if(on[0]=='D'&&on[1]=='e'&&on[2]=='f') continue;
        g_pc=o; return;
    }
}

void *g_worldInfo=NULL;
void find_worldinfo(void){
    if(!g_gobjects) return;
    void **data=*(void***)g_gobjects; int cnt=*(int*)(g_gobjects+4);
    if(!mem_ok(data,8)) return;
    if(cnt>400000) cnt=400000;
    for(int i=0;i<cnt;i++){
        void *o=data[i];
        if(!mem_ok(o,O_CLASS+4)) continue;
        const char *cn=obj_class_name(o);
        if(!cn || lstrcmpA(cn,"WorldInfo")!=0) continue;
        const char *on=obj_name(o);
        if(on[0]=='D'&&on[1]=='e'&&on[2]=='f') continue;
        g_worldInfo=o; return;
    }
}
