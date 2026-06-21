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
        if(op==0xE9){ n+=5; continue; }
        if(op==0x8B && (p[n+1]==0xEC||p[n+1]==0xFF)){ n+=2; continue; }
        if(op==0x89 && p[n+1]==0xE5){ n+=2; continue; }
        if(op==0x83 && (p[n+1]&0xC0)==0xC0){ n+=3; continue; }
        if(op==0x81 && (p[n+1]&0xC0)==0xC0){ n+=6; continue; }
        if(op==0x64 && p[n+1]==0xA1){ n+=6; continue; }
        return 0;
    }
    return n;
}

static void *detour(void *target, void *hook){
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
static void undetour(void *target, unsigned char *saved5){
    DWORD op;
    if(!VirtualProtect(target,5,PAGE_EXECUTE_READWRITE,&op)) return;
    for(int i=0;i<5;i++) ((unsigned char*)target)[i]=saved5[i];
    VirtualProtect(target,5,op,&op);
    FlushInstructionCache(GetCurrentProcess(),NULL,0);
}

PE_t g_peTramp=NULL;
static void *g_peTarget=NULL;
static volatile int g_calHits=0, g_calBad=0;

static void pe_emit(void *obj, void *fn){
    static HANDLE h=NULL;
    if(!h){ h=CreateFileA("C:\\hysteria_events.log",FILE_APPEND_DATA,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
            if(h==INVALID_HANDLE_VALUE){ h=NULL; return; } SetFilePointer(h,0,NULL,FILE_END); }
    char of[320], line[512];
    obj_full_name(obj, of, sizeof of);
    int n=wsprintfA(line,"%s :: %s\r\n", of, obj_name(fn));
    DWORD w; WriteFile(h,line,n,&w,NULL);
}

static void __fastcall pe_hook(void* obj, void* edx, void* fn, void* parms, void* res){
    if(mem_ok(fn,O_CLASS+4)){
        const char *cn=obj_class_name(fn);
        if(cn && cn[0]=='F' && lstrcmpA(cn,"Function")==0){
            g_calHits++;
            if(g_modFound){
                if(g_modLog && (obj==g_pc || (g_modPawn && obj==g_modPawn))) pe_emit(obj, fn);
                if(dispatch_event(obj,fn,parms,res)) return;
                g_peTramp(obj,edx,fn,parms,res);
                dispatch_post(obj,fn,parms,res);
                return;
            }
        } else g_calBad++;
    } else g_calBad++;
    g_peTramp(obj,edx,fn,parms,res);
}

void mod_tick(void){
    if(g_modReloadReq){ g_modReloadReq=0; if(g_modFound) mod_do_reload(); }
    if(g_modFound || !g_modFind) return;
    if(!g_pc || !mem_ok(g_pc,4)) return;
    mod_module_range();
    if(!g_modHi) return;
    void **vt=*(void***)g_pc;
    if(!mem_ok(vt,4)) return;

    static int idx=0, frames=0;
    static unsigned char saved[5];

    if(g_peTarget){
        frames++;
        if(g_calBad>0){ undetour(g_peTarget,saved); g_peTarget=NULL; idx++; frames=0; g_calHits=g_calBad=0; return; }
        if(g_calHits>=8){ g_modFound=1; logmsg("[hysteria][mod] ProcessEvent @ vt[%d]=%p hooked\r\n", idx, g_peTarget); load_mods(); return; }
        if(frames>40){ undetour(g_peTarget,saved); g_peTarget=NULL; idx++; frames=0; g_calHits=g_calBad=0; }
        return;
    }
    if(idx>=200){ idx=0; return; }
    void *cand=mem_ok(&vt[idx],4)?vt[idx]:NULL;
    if(!cand || !in_text(cand)){ idx++; return; }
    for(int i=0;i<5;i++) saved[i]=((unsigned char*)cand)[i];
    void *tr=detour(cand,(void*)pe_hook);
    if(!tr){ idx++; return; }
    g_peTramp=(PE_t)tr; g_peTarget=cand; frames=0; g_calHits=g_calBad=0;
}
