#include "hysteria.h"
#include "mod_internal.h"

int g_modFind=1, g_modLog=0, g_modFound=0, g_modReloadReq=0;
void *g_modPawn=NULL;

static unsigned g_modLo=0, g_modHi=0;
static void mod_module_range(void){
    if(g_modLo) return;
    HMODULE m=GetModuleHandleA(NULL);
    if(!m) return;
    IMAGE_DOS_HEADER *dos=(IMAGE_DOS_HEADER*)m;
    if(!mem_ok(dos,0x40) || dos->e_magic!=IMAGE_DOS_SIGNATURE) return;
    IMAGE_NT_HEADERS *nt=(IMAGE_NT_HEADERS*)((char*)m+dos->e_lfanew);
    if(!mem_ok(nt,sizeof *nt) || nt->Signature!=IMAGE_NT_SIGNATURE) return;
    g_modLo=(unsigned)(ULONG_PTR)m;
    g_modHi=g_modLo+nt->OptionalHeader.SizeOfImage;
}
static int in_text(void *p){ unsigned v=(unsigned)(ULONG_PTR)p; return g_modHi && v>=g_modLo && v<g_modHi; }

static int copy_len(unsigned char *p){
    if(!mem_ok(p,16)) return 0;
    int n=0;
    while(n<5){
        unsigned char op=p[n];
        if(op>=0x50&&op<=0x5F){ n+=1; continue; }
        if(op==0x68){ n+=5; continue; }
        if(op==0x6A){ n+=2; continue; }
        if(op==0x90){ n+=1; continue; }
        if(op==0xB8){ n+=5; continue; }
        if(op==0x8B && p[n+1]>=0xC0){ n+=2; continue; }
        if(op==0x89 && p[n+1]>=0xC0){ n+=2; continue; }
        if(op==0x83 && (p[n+1]&0xC0)==0xC0){ n+=3; continue; }
        if(op==0x81 && (p[n+1]&0xC0)==0xC0){ n+=6; continue; }
        if(op==0x64 && p[n+1]==0xA1){ n+=6; continue; }
        return 0;
    }
    return n;
}

void *detour(void *target, void *hook){
    unsigned char *t=(unsigned char*)target;
    int len=copy_len(t);
    if(!len) return NULL;
    unsigned char *tr=(unsigned char*)VirtualAlloc(NULL,32,MEM_COMMIT|MEM_RESERVE,PAGE_EXECUTE_READWRITE);
    if(!tr) return NULL;
    for(int i=0;i<len;i++) tr[i]=t[i];
    tr[len]=0xE9; *(int*)(tr+len+1)=(int)((t+len)-(tr+len+5));
    DWORD op; if(!VirtualProtect(t,5,PAGE_EXECUTE_READWRITE,&op)){ VirtualFree(tr,0,MEM_RELEASE); return NULL; }
    t[0]=0xE9; *(int*)(t+1)=(int)((unsigned char*)hook-(t+5));
    VirtualProtect(t,5,op,&op);
    FlushInstructionCache(GetCurrentProcess(),NULL,0);
    return tr;
}

PE_t  g_peTramp=NULL;
void *g_peTarget=NULL;

static void pe_emit(void *obj, void *fn){
    static HANDLE h=NULL;
    if(!h){ h=CreateFileA("C:\\hysteria_events.log",FILE_APPEND_DATA,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
            if(h==INVALID_HANDLE_VALUE){ h=NULL; return; } SetFilePointer(h,0,NULL,FILE_END); }
    char of[320], line[512];
    obj_full_name(obj, of, sizeof of);
    int n=wsprintfA(line,"%s :: %s\r\n", of, obj_name(fn));
    DWORD w; WriteFile(h,line,n,&w,NULL);
}

static void *g_fnClass=NULL;
static int   g_ptFid=-1;
static volatile DWORD g_pumpTid=0;

static void __fastcall pe_hook(void* obj, void* edx, void* fn, void* parms, void* res){
    void *fc;
    if(!mem_ok(fn,O_CLASS+4)){ g_peTramp(obj,edx,fn,parms,res); return; }
    fc=*(void**)((char*)fn+O_CLASS);
    if(!g_fnClass){
        const char *cn=obj_class_name(fn);
        if(cn && cn[0]=='F' && lstrcmpA(cn,"Function")==0) g_fnClass=fc;
    }
    if(fc!=g_fnClass || !g_modFound){ g_peTramp(obj,edx,fn,parms,res); return; }

    if(obj==g_pc && mem_ok((char*)fn+O_NAME,4)){
        if(g_ptFid<0) g_ptFid=find_name("PlayerTick");
        if(g_ptFid>=0 && *(int*)((char*)fn+O_NAME)==g_ptFid){
            DWORD tid=GetCurrentThreadId();
            if(g_pumpTid!=tid){ g_pumpTid=tid; mod_pump_game(); g_pumpTid=0; }
        }
    }
    if(g_modLog && (obj==g_pc || (g_modPawn && obj==g_modPawn))) pe_emit(obj,fn);
    if(dispatch_event(obj,fn,parms,res)) return;
    g_peTramp(obj,edx,fn,parms,res);
    dispatch_post(obj,fn,parms,res);
}

static const unsigned char PE_SIG[5]={0x55,0x8B,0xEC,0x6A,0xFF};

static void *pe_known_target(void){
    mod_module_range();
    if(!g_modLo) return NULL;
    unsigned char *p=(unsigned char*)(ULONG_PTR)(g_modLo+RVA_UOBJECT_PROCESSEVENT);
    if(!in_text(p) || !mem_ok(p,16)) return NULL;
    for(int i=0;i<5;i++) if(p[i]!=PE_SIG[i]) return NULL;
    return p;
}

void mod_tick(void){
    static int tried=0;
    void *k, *tr, *cand; void **vt;

    if(g_modReloadReq){ g_modReloadReq=0; if(g_modFound) mod_do_reload(); }
    if(g_modFound || !g_modFind) return;
    if(!g_pc || !mem_ok(g_pc,4)) return;
    mod_module_range();
    if(!g_modHi) return;

    if(!tried){
        tried=1;
        k=pe_known_target();
        if(k){
            tr=detour(k,(void*)pe_hook);
            if(tr){
                g_peTramp=(PE_t)tr; g_peTarget=k; g_modFound=1;
                logmsg("[hysteria][mod] UObject::ProcessEvent @%p hooke (signature RVA)\r\n",k);
                load_mods();
                return;
            }
            logmsg("[hysteria][mod] detour ProcessEvent ECHEC, repli vt[67]\r\n");
        } else logmsg("[hysteria][mod] signature RVA absente, repli vt[67]\r\n");
    }

    vt=*(void***)g_pc;
    if(!mem_ok(vt,(VT_PROCESSEVENT+1)*4)) return;
    cand=vt[VT_PROCESSEVENT];
    if(!cand || !in_text(cand)) return;
    if((unsigned)(ULONG_PTR)cand!=ADDR_AACTOR_PROCESSEVENT &&
       (unsigned)(ULONG_PTR)cand!=ADDR_UOBJECT_PROCESSEVENT){
        logmsg("[hysteria][mod] vt[67]=%p inattendu, hook annule\r\n",cand);
        g_modFind=0; return;
    }
    tr=detour(cand,(void*)pe_hook);
    if(!tr){ logmsg("[hysteria][mod] detour vt[67] ECHEC\r\n"); g_modFind=0; return; }
    g_peTramp=(PE_t)tr; g_peTarget=cand; g_modFound=1;
    logmsg("[hysteria][mod] ProcessEvent @ vt[67]=%p hooke\r\n",cand);
    load_mods();
}
