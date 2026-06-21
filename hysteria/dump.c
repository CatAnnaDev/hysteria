#include "hysteria.h"

int g_dumped=0;

static void dlog(HANDLE h, const char *fmt, ...){
    char b[1024]; va_list ap; va_start(ap,fmt); int n=wvsprintfA(b,fmt,ap); va_end(ap);
    DWORD w; WriteFile(h,b,n,&w,NULL);
}

static void dump_props_of(HANDLE h, const char *className){
    dlog(h,"  CLASS %s\r\n", className);
    if(M_POFF<0){ dlog(h,"    (POFF non calibre)\r\n"); return; }
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    int n=0;
    for(int i=0;i<cnt;i++){
        void *o=data[i];
        if(!mem_ok(o,O_CLASS+4) || !is_property(o)) continue;
        const char *on=obj_name(*(void**)((char*)o+O_OUTER));
        if(!on || lstrcmpA(on,className)!=0) continue;
        dlog(h,"    +0x%-4x %-30s %s\r\n", *(int*)((char*)o+M_POFF), obj_name(o), obj_class_name(o));
        n++;
    }
    if(!n) dlog(h,"    (aucune)\r\n");
}

void dump_all(void *pc, void *pawn, const char *map){
    HANDLE h=CreateFileA("C:\\hysteria_dump.txt",GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(h==INVALID_HANDLE_VALUE) return;
    dlog(h,"=== HYSTERIA DUMP  map=%s ===\r\n",map);
    dlog(h,"GNames=%08x GObjects=%08x  POFF=0x%x\r\n", g_gnames,g_gobjects,M_POFF);
    dlog(h,"PC   = %s  class=%s\r\n", obj_name(pc), obj_class_name(pc));
    dlog(h,"Pawn = %s  class=%s\r\n", obj_name(pawn), obj_class_name(pawn));
    dlog(h,"resolved: Location=0x64 Velocity=0x%x Physics=0x%x Health=0x%x JumpZ=0x%x Accel=0x%x CollComp=0x%x\r\n",
        OFF_VEL,OFF_PHYS,OFF_HEALTH,OFF_JUMPZ,OFF_ACCEL,OFF_COLLCOMP);

    dlog(h,"\r\n--- key class property tables ---\r\n");
    static const char *cls[]={"Object","Actor","Pawn","AlicePawn","Controller","PlayerController",
        "AlicePlayerController","PrimitiveComponent","CylinderComponent","Trigger","PlayerInput","AlicePlayerInput",
        "Camera","PlayerCameraManager","AlicePlayerCamera"};
    for(unsigned i=0;i<sizeof cls/sizeof*cls;i++) dump_props_of(h, cls[i]);

    dlog(h,"\r\n--- Objects whose outermost == %s ---\r\n", map);
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    int n=0;
    for(int i=0;i<cnt && n<6000;i++){
        void *o=data[i];
        if(!mem_ok(o,O_CLASS+4)) continue;
        const char *on=obj_name(outermost(o));
        if(on && lstrcmpA(on,map)==0){ dlog(h,"  %-44s %s\r\n", obj_name(o), obj_class_name(o)); n++; }
    }
    dlog(h,"total in-level objects=%d (of %d GObjects)\r\n", n, cnt);
    CloseHandle(h);
    logmsg("[hysteria] DUMP written (%d in-level objs)\r\n", n);
}

int g_uiDumpAllReq=0;

typedef struct { HANDLE h; char *buf; int len, cap; } Out;
static void out_flush(Out *o){ if(o->len){ DWORD w; WriteFile(o->h,o->buf,o->len,&w,NULL); o->len=0; } }
static void out_raw(Out *o, const char *s, int n){
    if(n<=0) return;
    if(o->len+n>o->cap) out_flush(o);
    if(n>o->cap){ DWORD w; WriteFile(o->h,s,n,&w,NULL); return; }
    for(int i=0;i<n;i++) o->buf[o->len++]=s[i];
}
static void ow(Out *o, const char *fmt, ...){
    char b[1024]; va_list ap; va_start(ap,fmt); int n=wvsprintfA(b,fmt,ap); va_end(ap);
    out_raw(o,b,n);
}

static void full_name(void *o, char *out, int cap){
    const char *stack[12]; int sp=0;
    void *cur=o;
    for(int i=0;i<12 && mem_ok(cur,O_OUTER+4);i++){
        stack[sp++]=obj_name(cur);
        void *ou=*(void**)((char*)cur+O_OUTER);
        if(!mem_ok(ou,O_NAME+4)) break;
        cur=ou;
    }
    int p=0; out[0]=0;
    for(int i=sp-1;i>=0;i--){
        const char *s=stack[i];
        while(*s && p<cap-2) out[p++]=*s++;
        if(i>0 && p<cap-2) out[p++]='.';
    }
    out[p]=0;
}

void dump_everything(void){
    if(!g_gnames || !g_gobjects){ logmsg("[hysteria] dump_all: no engine\r\n"); return; }
    HANDLE h=CreateFileA("C:\\hysteria_dump_all.txt",GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(h==INVALID_HANDLE_VALUE){ logmsg("[hysteria] dump_all: file open fail\r\n"); return; }
    char *big=(char*)HeapAlloc(GetProcessHeap(),0,1<<18);
    if(!big){ CloseHandle(h); return; }
    Out o; o.h=h; o.buf=big; o.len=0; o.cap=1<<18;

    int nameCount=mem_ok((void*)(ULONG_PTR)g_gnames,8)?*(int*)(g_gnames+4):0;
    void **data=*(void***)g_gobjects;
    int objCount=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(nameCount<0||nameCount>800000) nameCount=0;
    if(objCount<0||objCount>2000000) objCount=2000000;

    ow(&o,"=== HYSTERIA FULL DUMP ===\r\n");
    ow(&o,"GNames=%08x (%d names)  GObjects=%08x (%d objs)  POFF=0x%x bitmask=0x%x\r\n",
        g_gnames,nameCount,g_gobjects,objCount,M_POFF,M_BITMASK);
    ow(&o,"offsets: name=0x%x class=0x%x outer=0x%x\r\n\r\n",O_NAME,O_CLASS,O_OUTER);

    ow(&o,"=== GNAMES (%d) ===\r\n",nameCount);
    for(int i=0;i<nameCount;i++) ow(&o,"[%d] %s\r\n",i,uname(i));

    ow(&o,"\r\n=== GOBJECTS (%d) ===\r\n",objCount);
    char fn[512];
    int live=0;
    for(int i=0;i<objCount;i++){
        void *ob=data[i];
        if(!mem_ok(ob,O_CLASS+4)) continue;
        full_name(ob,fn,sizeof fn);
        ow(&o,"[%d] %s  (%s)\r\n",i,fn,obj_class_name(ob));
        live++;
    }

    ow(&o,"\r\n=== PROPERTIES (offset / type / bitmask, grouped by owner) ===\r\n");
    void *lastOwner=(void*)1;
    int props=0;
    for(int i=0;i<objCount;i++){
        void *ob=data[i];
        if(!mem_ok(ob,O_CLASS+4) || !is_property(ob)) continue;
        if(M_POFF<0) break;
        void *owner=mem_ok((char*)ob+O_OUTER,4)?*(void**)((char*)ob+O_OUTER):NULL;
        if(owner!=lastOwner){
            lastOwner=owner;
            full_name(owner,fn,sizeof fn);
            ow(&o,"\r\n%s  (%s)\r\n",fn,obj_class_name(owner));
        }
        const char *pt=obj_class_name(ob);
        int off=mem_ok((char*)ob+M_POFF,4)?*(int*)((char*)ob+M_POFF):-1;
        if(pt && contains(pt,"Bool") && M_BITMASK>=0 && mem_ok((char*)ob+M_BITMASK,4))
            ow(&o,"  +0x%-5x %-32s %s mask=0x%x\r\n",off,obj_name(ob),pt,*(unsigned*)((char*)ob+M_BITMASK));
        else
            ow(&o,"  +0x%-5x %-32s %s\r\n",off,obj_name(ob),pt);
        props++;
    }

    ow(&o,"\r\n=== END (objs=%d props=%d) ===\r\n",live,props);
    out_flush(&o);
    HeapFree(GetProcessHeap(),0,big);
    CloseHandle(h);
    logmsg("[hysteria] FULL DUMP written: %d objs, %d props, %d names\r\n",live,props,nameCount);
}

static volatile LONG g_dumpRunning=0;
static DWORD WINAPI dump_all_thread(LPVOID p){ (void)p; dump_everything(); InterlockedExchange(&g_dumpRunning,0); return 0; }
void dump_everything_async(void){
    if(InterlockedCompareExchange(&g_dumpRunning,1,0)!=0) return;
    HANDLE t=CreateThread(NULL,0,dump_all_thread,NULL,0,NULL);
    if(t) CloseHandle(t); else InterlockedExchange(&g_dumpRunning,0);
}
