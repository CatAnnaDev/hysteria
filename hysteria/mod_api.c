#include "hysteria.h"
#include "mod_internal.h"

static HysteriaAPI g_api;

static void *class_of(void *o){ return mem_ok(o,O_CLASS+4)?*(void**)((char*)o+O_CLASS):NULL; }
static int is_class(void *o){ const char *c=obj_class_name(o); return c && lstrcmpA(c,"Class")==0; }

static int g_superOff=-1;
static void calib_super(void){
    if(g_superOff>=0 || !g_pc) return;
    void *cls=class_of(g_pc);
    if(!is_class(cls)) return;
    for(int off=0x28; off<=0x4c; off+=4){
        void *chain=cls; int steps=0, ok=1, reached=0;
        for(int i=0;i<20;i++){
            if(!mem_ok((char*)chain+off,4)){ ok=0; break; }
            void *sup=*(void**)((char*)chain+off);
            if(!sup) break;
            if(!is_class(sup)){ ok=0; break; }
            chain=sup; steps++;
            if(lstrcmpA(obj_name(sup),"Object")==0){ reached=1; break; }
        }
        if(ok && reached && steps>=2){ g_superOff=off; logmsg("[hysteria][mod] super off=0x%x\r\n",off); return; }
    }
}
static int is_a_ptr(void *cls, const char *name){
    for(int i=0;i<24 && is_class(cls);i++){
        if(lstrcmpA(obj_name(cls),name)==0) return 1;
        if(g_superOff<0) break;
        cls=*(void**)((char*)cls+g_superOff);
        if(!cls) break;
    }
    return 0;
}

typedef struct { void *owner; unsigned h; int off; char typ; unsigned mask; } MCache;
static MCache g_mc[512]; static int g_mcN=0;
static unsigned shash(const char *s){ unsigned h=5381; while(*s) h=h*33u+(unsigned char)*s++; return h; }

static int prop_in(void *owner, const char *name, int *off, char *typ, unsigned *mask){
    unsigned h=shash(name);
    for(int i=0;i<g_mcN;i++) if(g_mc[i].owner==owner && g_mc[i].h==h){
        *off=g_mc[i].off; if(typ)*typ=g_mc[i].typ; if(mask)*mask=g_mc[i].mask; return g_mc[i].off>=0; }
    int rOff=-1; char rTyp=0; unsigned rMask=0;
    if(g_gobjects && owner){
        void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0; if(cnt>2000000)cnt=2000000;
        for(int i=0;i<cnt;i++){ void *o=data[i];
            if(!mem_ok(o,O_OUTER+4) || !is_property(o)) continue;
            if(*(void**)((char*)o+O_OUTER)!=owner) continue;
            if(lstrcmpA(obj_name(o),name)!=0) continue;
            rOff=(M_POFF>=0 && mem_ok((char*)o+M_POFF,4))?*(int*)((char*)o+M_POFF):-1;
            const char *cn=obj_class_name(o); rTyp=cn?cn[0]:0;
            if(cn && cn[0]=='B' && lstrcmpA(cn,"BoolProperty")==0 && M_BITMASK>=0 && mem_ok((char*)o+M_BITMASK,4))
                rMask=*(unsigned*)((char*)o+M_BITMASK);
            break;
        }
    }
    if(g_mcN<512){ g_mc[g_mcN].owner=owner; g_mc[g_mcN].h=h; g_mc[g_mcN].off=rOff; g_mc[g_mcN].typ=rTyp; g_mc[g_mcN].mask=rMask; g_mcN++; }
    *off=rOff; if(typ)*typ=rTyp; if(mask)*mask=rMask; return rOff>=0;
}
static int resolve_member(void *o, const char *name, void **base, int *off, char *typ, unsigned *mask){
    void *cls=class_of(o);
    for(int i=0;i<24 && is_class(cls);i++){
        if(prop_in(cls,name,off,typ,mask)){ *base=o; return 1; }
        if(g_superOff<0) break;
        cls=*(void**)((char*)cls+g_superOff); if(!cls) break;
    }
    return 0;
}

static int api_get_int(AObj o,const char*p,int*out){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,4))return 0; *out=*(int*)((char*)b+off); return 1; }
static int api_set_int(AObj o,const char*p,int v){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,4))return 0; *(int*)((char*)b+off)=v; return 1; }
static int api_get_float(AObj o,const char*p,float*out){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,4))return 0; *out=*(float*)((char*)b+off); return 1; }
static int api_set_float(AObj o,const char*p,float v){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,4))return 0; *(float*)((char*)b+off)=v; return 1; }
static int api_get_bool(AObj o,const char*p,int*out){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!m||!mem_ok((char*)b+off,4))return 0; *out=(*(unsigned*)((char*)b+off)&m)?1:0; return 1; }
static int api_set_bool(AObj o,const char*p,int v){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!m||!mem_ok((char*)b+off,4))return 0;
    if(v)*(unsigned*)((char*)b+off)|=m; else *(unsigned*)((char*)b+off)&=~m; return 1; }
static AObj api_get_obj(AObj o,const char*p){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,4))return 0; return *(void**)((char*)b+off); }
static int api_get_byte(AObj o,const char*p,int*out){ void*b;int off;char t;unsigned m;
    if(!o||!out||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,1))return 0; *out=*(unsigned char*)((char*)b+off); return 1; }
static int api_set_byte(AObj o,const char*p,int v){ void*b;int off;char t;unsigned m;
    if(!o||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,1))return 0; *(unsigned char*)((char*)b+off)=(unsigned char)v; return 1; }
static int api_get_vec(AObj o,const char*p,float out[3]){ void*b;int off;char t;unsigned m;
    if(!o||!out||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,12))return 0; float*f=(float*)((char*)b+off); out[0]=f[0];out[1]=f[1];out[2]=f[2]; return 1; }
static int api_set_vec(AObj o,const char*p,const float v[3]){ void*b;int off;char t;unsigned m;
    if(!o||!v||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,12))return 0; float*f=(float*)((char*)b+off); f[0]=v[0];f[1]=v[1];f[2]=v[2]; return 1; }
static int api_get_rot(AObj o,const char*p,int out[3]){ void*b;int off;char t;unsigned m;
    if(!o||!out||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,12))return 0; int*r=(int*)((char*)b+off); out[0]=r[0];out[1]=r[1];out[2]=r[2]; return 1; }
static int api_set_rot(AObj o,const char*p,const int v[3]){ void*b;int off;char t;unsigned m;
    if(!o||!v||!resolve_member(o,p,&b,&off,&t,&m)||!mem_ok((char*)b+off,12))return 0; int*r=(int*)((char*)b+off); r[0]=v[0];r[1]=v[1];r[2]=v[2]; return 1; }
static AObj api_world_info(void){ return g_worldInfo; }
static int api_mouse_delta(int *dx,int *dy){ if(dx)*dx=(int)g_mouseDX; if(dy)*dy=(int)g_mouseDY; g_mouseDX=0; g_mouseDY=0; return 1; }
static void api_mouse_capture(int on){ g_mouseCapture=on?1:0; }
static int api_read_raw(AObj o,int off,void*buf,int n){ if(!o||!buf||n<=0||off<0||!mem_ok((char*)o+off,n))return 0; for(int i=0;i<n;i++)((char*)buf)[i]=((char*)o+off)[i]; return 1; }
static int api_write_raw(AObj o,int off,const void*buf,int n){ if(!o||!buf||n<=0||off<0||!mem_ok((char*)o+off,n))return 0; for(int i=0;i<n;i++)((char*)o+off)[i]=((const char*)buf)[i]; return 1; }

static int api_pget_int(AEvent*e,const char*n,int*out){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!mem_ok((char*)e->params+off,4))return 0; *out=*(int*)((char*)e->params+off); return 1; }
static int api_pset_int(AEvent*e,const char*n,int v){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!mem_ok((char*)e->params+off,4))return 0; *(int*)((char*)e->params+off)=v; return 1; }
static int api_pget_float(AEvent*e,const char*n,float*out){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!mem_ok((char*)e->params+off,4))return 0; *out=*(float*)((char*)e->params+off); return 1; }
static int api_pset_float(AEvent*e,const char*n,float v){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!mem_ok((char*)e->params+off,4))return 0; *(float*)((char*)e->params+off)=v; return 1; }
static AObj api_pget_obj(AEvent*e,const char*n){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!mem_ok((char*)e->params+off,4))return 0; return *(void**)((char*)e->params+off); }
static int api_pget_bool(AEvent*e,const char*n,int*out){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!m||!mem_ok((char*)e->params+off,4))return 0; *out=(*(unsigned*)((char*)e->params+off)&m)?1:0; return 1; }
static int api_pset_bool(AEvent*e,const char*n,int v){ int off;char t;unsigned m;
    if(!e||!e->params||!prop_in(e->func,n,&off,&t,&m)||!m||!mem_ok((char*)e->params+off,4))return 0;
    if(v)*(unsigned*)((char*)e->params+off)|=m; else *(unsigned*)((char*)e->params+off)&=~m; return 1; }

static const char* api_name_of(AObj o){ return obj_name(o); }
static const char* api_class_of(AObj o){ return obj_class_name(o); }
static void api_full_name(AObj o,char*out,int cap){ obj_full_name(o,out,cap); }
static int api_is_a(AObj o,const char*name){ return is_a_ptr(class_of(o),name); }
static AObj api_find_class(const char*name){ if(!g_gobjects)return 0; void**data=*(void***)g_gobjects;int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;if(cnt>2000000)cnt=2000000;
    for(int i=0;i<cnt;i++){void*o=data[i]; if(mem_ok(o,O_CLASS+4)&&is_class(o)&&lstrcmpA(obj_name(o),name)==0)return o;} return 0; }
static AObj api_find_object(const char*name){ if(!g_gobjects)return 0; void**data=*(void***)g_gobjects;int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;if(cnt>2000000)cnt=2000000;
    char fn[320];
    for(int i=0;i<cnt;i++){void*o=data[i]; if(!mem_ok(o,O_NAME+4))continue;
        if(lstrcmpA(obj_name(o),name)==0)return o;
        obj_full_name(o,fn,sizeof fn); if(lstrcmpA(fn,name)==0)return o; } return 0; }
static void api_iter(const char*className,AIterCb cb){ if(!g_gobjects||!cb)return; void**data=*(void***)g_gobjects;int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;if(cnt>2000000)cnt=2000000;
    for(int i=0;i<cnt;i++){void*o=data[i]; if(mem_ok(o,O_CLASS+4)&&is_a_ptr(class_of(o),className))cb(o);} }
static AObj api_pc(void){ return g_pc; }
static AObj api_pawn(void){ return g_modPawn; }
static void api_log(const char*m){ logmsg("[hysteria][mod] %s\r\n", m?m:""); }

static void *find_function(void *o, const char *name){
    if(!g_gobjects||!o)return 0;
    void *chain[24]; int nc=0; void *cls=class_of(o);
    for(int i=0;i<24 && is_class(cls);i++){ chain[nc++]=cls; if(g_superOff<0)break; cls=*(void**)((char*)cls+g_superOff); if(!cls)break; }
    void **data=*(void***)g_gobjects;int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;if(cnt>2000000)cnt=2000000;
    for(int j=0;j<cnt;j++){ void *f=data[j];
        if(!mem_ok(f,O_OUTER+4))continue;
        const char *fc=obj_class_name(f); if(!fc||fc[0]!='F'||lstrcmpA(fc,"Function")!=0)continue;
        if(lstrcmpA(obj_name(f),name)!=0)continue;
        void *ow=*(void**)((char*)f+O_OUTER);
        for(int k=0;k<nc;k++) if(chain[k]==ow) return f;
    }
    return 0;
}
static void api_call(AObj o,const char*func,void*params){
    if(!g_modFound||!g_peTramp||!o)return;
    void *f=find_function(o,func); if(!f)return;
    g_peTramp(o,0,f,params,0);
}
static void api_call_str(AObj o,const char*func,const char*arg){
    if(!o||!func)return;
    WCHAR w[512]; int wl=MultiByteToWideChar(CP_ACP,0,arg?arg:"",-1,w,512); if(wl<=0)return;
    unsigned char block[160]; for(int i=0;i<160;i++)block[i]=0;
    *(void**)(block+0)=w; *(int*)(block+4)=wl; *(int*)(block+8)=wl;
    api_call(o,func,block);
}
static void api_console(AObj pc,const char*cmd){ if(!pc)pc=g_pc; api_call_str(pc,"ConsoleCommand",cmd); }

typedef struct { int used; AObj o; void *fn; unsigned char blk[1024]; WCHAR sb[4][512]; int sbN; } CallSlot;
static CallSlot g_calls[8]; static int g_callRR=0;
static ACall api_call_begin(AObj o,const char*func){
    if(!g_modFound||!g_peTramp||!o||!func)return 0;
    void*f=find_function(o,func); if(!f)return 0;
    CallSlot*s=&g_calls[g_callRR]; g_callRR=(g_callRR+1)&7;
    for(int i=0;i<1024;i++)s->blk[i]=0; s->sbN=0; s->o=o; s->fn=f; s->used=1; return (ACall)s;
}
static void api_call_arg_int(ACall c,const char*p,int v){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+4<=1024)*(int*)(s->blk+off)=v; }
static void api_call_arg_float(ACall c,const char*p,float v){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+4<=1024)*(float*)(s->blk+off)=v; }
static void api_call_arg_bool(ACall c,const char*p,int v){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&m&&off+4<=1024){ if(v)*(unsigned*)(s->blk+off)|=m; else *(unsigned*)(s->blk+off)&=~m; } }
static void api_call_arg_obj(ACall c,const char*p,AObj v){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+4<=1024)*(void**)(s->blk+off)=v; }
static void api_call_arg_str(ACall c,const char*p,const char*v){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||s->sbN>=4||!prop_in(s->fn,p,&off,&t,&m)||off<0||off+12>1024)return;
    WCHAR*w=s->sb[s->sbN]; int wl=MultiByteToWideChar(CP_ACP,0,v?v:"",-1,w,512); if(wl<=0)return;
    s->sbN++; *(void**)(s->blk+off)=w; *(int*)(s->blk+off+4)=wl; *(int*)(s->blk+off+8)=wl; }
static void api_call_arg_vec(ACall c,const char*p,const float v[3]){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&v&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+12<=1024){ float*f=(float*)(s->blk+off); f[0]=v[0];f[1]=v[1];f[2]=v[2]; } }
static void api_call_arg_rot(ACall c,const char*p,const int v[3]){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&v&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+12<=1024){ int*r=(int*)(s->blk+off); r[0]=v[0];r[1]=v[1];r[2]=v[2]; } }
static void api_call_arg_raw(ACall c,const char*p,const void*d,int n){ CallSlot*s=c; int off;char t;unsigned m;
    if(s&&s->used&&d&&n>0&&prop_in(s->fn,p,&off,&t,&m)&&off>=0&&off+n<=1024){ for(int i=0;i<n;i++)((char*)s->blk)[off+i]=((const char*)d)[i]; } }
static int api_call_out_vec(ACall c,const char*p,float out[3]){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||!out||!prop_in(s->fn,p,&off,&t,&m)||off<0||off+12>1024)return 0; float*f=(float*)(s->blk+off); out[0]=f[0];out[1]=f[1];out[2]=f[2]; return 1; }
static void api_call_invoke(ACall c){ CallSlot*s=c; if(s&&s->used&&g_peTramp)g_peTramp(s->o,0,s->fn,s->blk,0); }
static int api_call_out_int(ACall c,const char*p,int*out){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||!prop_in(s->fn,p,&off,&t,&m)||off<0||off+4>1024)return 0; *out=*(int*)(s->blk+off); return 1; }
static int api_call_out_float(ACall c,const char*p,float*out){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||!prop_in(s->fn,p,&off,&t,&m)||off<0||off+4>1024)return 0; *out=*(float*)(s->blk+off); return 1; }
static int api_call_out_bool(ACall c,const char*p,int*out){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||!prop_in(s->fn,p,&off,&t,&m)||off<0||!m||off+4>1024)return 0; *out=(*(unsigned*)(s->blk+off)&m)?1:0; return 1; }
static AObj api_call_out_obj(ACall c,const char*p){ CallSlot*s=c; int off;char t;unsigned m;
    if(!s||!s->used||!prop_in(s->fn,p,&off,&t,&m)||off<0||off+4>1024)return 0; return *(void**)(s->blk+off); }

static int api_ret_get_int(AEvent*e,int*out){ return api_pget_int(e,"ReturnValue",out); }
static int api_ret_set_int(AEvent*e,int v){ return api_pset_int(e,"ReturnValue",v); }
static int api_ret_set_float(AEvent*e,float v){ return api_pset_float(e,"ReturnValue",v); }

static void api_destroy(AObj o){
    if(!o)return; void*f=find_function(o,"Destroy"); if(!f)return;
    unsigned char blk[16]; for(int i=0;i<16;i++)blk[i]=0;
    g_peTramp(o,0,f,blk,0);
}
static AObj api_spawn(const char*className,float x,float y,float z){
    if(!g_modFound||!g_peTramp)return 0;
    AObj cls=api_find_class(className); if(!cls)return 0;
    AObj spawner=g_modPawn?g_modPawn:g_pc; if(!spawner)return 0;
    void*f=find_function(spawner,"Spawn"); if(!f)return 0;
    unsigned char blk[256]; for(int i=0;i<256;i++)blk[i]=0;
    int off; char t; unsigned m;
    if(prop_in(f,"SpawnClass",&off,&t,&m)) *(void**)(blk+off)=cls;
    if((x||y||z) && prop_in(f,"SpawnLocation",&off,&t,&m)){ float*L=(float*)(blk+off); L[0]=x;L[1]=y;L[2]=z; }
    g_peTramp(spawner,0,f,blk,0);
    if(prop_in(f,"ReturnValue",&off,&t,&m)) return *(void**)(blk+off);
    return 0;
}

typedef struct { char name[64]; int nameId; int phase; AEventCb cb; void *target; } Reg;
static Reg g_reg[256]; static int g_regN=0;
static volatile int g_reloading=0;
static void add_hook(const char*funcName,AEventCb cb,int phase,void *target){
    if(g_regN>=256||!cb||!funcName)return;
    lstrcpynA(g_reg[g_regN].name,funcName,sizeof g_reg[g_regN].name);
    g_reg[g_regN].nameId=find_name(funcName);
    g_reg[g_regN].phase=phase; g_reg[g_regN].cb=cb; g_reg[g_regN].target=target; g_regN++;
    logmsg("[hysteria][mod] hook %s '%s' (id=%d)\r\n",phase?"post":"pre",funcName,g_reg[g_regN-1].nameId);
}
static void api_on(const char*funcName,AEventCb cb){ add_hook(funcName,cb,0,0); }
static void api_on_post(const char*funcName,AEventCb cb){ add_hook(funcName,cb,1,0); }
static void api_on_object(AObj target,const char*funcName,AEventCb cb){ add_hook(funcName,cb,0,target); }
static void api_on_object_post(AObj target,const char*funcName,AEventCb cb){ add_hook(funcName,cb,1,target); }

static int dispatch_phase(void *obj, void *fn, void *parms, void *res, int phase){
    if(g_reloading || !g_regN || !mem_ok((char*)fn+O_NAME,4)) return 0;
    int fid=*(int*)((char*)fn+O_NAME);
    const char *fname=NULL; int blocked=0;
    for(int i=0;i<g_regN;i++){
        if(g_reg[i].phase!=phase) continue;
        int match;
        if(g_reg[i].nameId>=0) match=(g_reg[i].nameId==fid);
        else { if(!fname) fname=obj_name(fn); match=(lstrcmpA(g_reg[i].name,fname)==0); if(match) g_reg[i].nameId=fid; }
        if(!match) continue;
        if(g_reg[i].target && g_reg[i].target!=obj) continue;
        if(!fname) fname=obj_name(fn);
        AEvent e; e.self=obj; e.func=fn; e.params=parms; e.result=res; e.block=0; e.func_name=fname;
        g_reg[i].cb(&e);
        if(e.block) blocked=1;
    }
    return blocked;
}
int dispatch_event(void *obj, void *fn, void *parms, void *res){ return dispatch_phase(obj,fn,parms,res,0); }
void dispatch_post(void *obj, void *fn, void *parms, void *res){ dispatch_phase(obj,fn,parms,res,1); }

typedef void (*TickCb)(void);
static TickCb g_ticks[64]; static int g_ticksN = 0;
static void api_on_tick(TickCb cb){ if(g_ticksN < 64 && cb) g_ticks[g_ticksN++] = cb; }
void mod_run_ticks(void){ if(g_reloading) return; for(int i=0;i<g_ticksN;i++) if(g_ticks[i]) g_ticks[i](); }
static int api_key_down(int vk){ return (GetAsyncKeyState(vk) & 0x8000) ? 1 : 0; }
static int api_key_pressed(int vk){
    static unsigned char prev[256]; vk &= 0xff;
    int d = (GetAsyncKeyState(vk) & 0x8000) ? 1 : 0;
    int e = d && !prev[vk]; prev[vk] = (unsigned char)d; return e;
}

static HysteriaAPI g_api = {
    .version=HYSTERIA_API_VERSION,
    .find_object=api_find_object, .find_class=api_find_class, .iter_objects=api_iter,
    .name_of=api_name_of, .class_of=api_class_of, .full_name=api_full_name, .is_a=api_is_a,
    .get_int=api_get_int, .set_int=api_set_int, .get_float=api_get_float, .set_float=api_set_float,
    .get_bool=api_get_bool, .set_bool=api_set_bool, .get_obj=api_get_obj,
    .on=api_on, .on_post=api_on_post,
    .param_get_int=api_pget_int, .param_set_int=api_pset_int,
    .param_get_float=api_pget_float, .param_set_float=api_pset_float,
    .param_get_bool=api_pget_bool, .param_set_bool=api_pset_bool, .param_get_obj=api_pget_obj,
    .ret_get_int=api_ret_get_int, .ret_set_int=api_ret_set_int, .ret_set_float=api_ret_set_float,
    .call=api_call, .call_str=api_call_str, .console=api_console, .spawn=api_spawn, .destroy=api_destroy,
    .player_controller=api_pc, .player_pawn=api_pawn, .log=api_log,
    .on_tick=api_on_tick, .key_down=api_key_down, .key_pressed=api_key_pressed,
    .call_begin=api_call_begin,
    .call_arg_int=api_call_arg_int, .call_arg_float=api_call_arg_float, .call_arg_bool=api_call_arg_bool,
    .call_arg_obj=api_call_arg_obj, .call_arg_str=api_call_arg_str, .call_invoke=api_call_invoke,
    .call_out_int=api_call_out_int, .call_out_float=api_call_out_float,
    .call_out_bool=api_call_out_bool, .call_out_obj=api_call_out_obj,
    .get_byte=api_get_byte, .set_byte=api_set_byte, .get_vec=api_get_vec, .set_vec=api_set_vec,
    .get_rot=api_get_rot, .set_rot=api_set_rot, .world_info=api_world_info,
    .read_raw=api_read_raw, .write_raw=api_write_raw,
    .mouse_delta=api_mouse_delta, .mouse_capture=api_mouse_capture,
    .on_object=api_on_object, .on_object_post=api_on_object_post,
    .call_arg_vec=api_call_arg_vec, .call_arg_rot=api_call_arg_rot,
    .call_arg_raw=api_call_arg_raw, .call_out_vec=api_call_out_vec,
};

static HMODULE g_loaded[64]; static int g_loadedN=0;
static void scan_and_load(void){
    calib_super();
    char dir[MAX_PATH]; HMODULE self=NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS|GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,(LPCSTR)&scan_and_load,&self);
    DWORD n=GetModuleFileNameA(self,dir,MAX_PATH); while(n>0&&dir[n-1]!='\\'&&dir[n-1]!='/')n--; dir[n]=0;
    char pat[MAX_PATH]; wsprintfA(pat,"%sMods\\*.dll",dir);
    WIN32_FIND_DATAA fd; HANDLE h=FindFirstFileA(pat,&fd);
    if(h==INVALID_HANDLE_VALUE){ logmsg("[hysteria][mod] no Mods dll (%s)\r\n",pat); return; }
    do{
        char full[MAX_PATH]; wsprintfA(full,"%sMods\\%s",dir,fd.cFileName);
        HMODULE m=LoadLibraryA(full);
        if(!m){ logmsg("[hysteria][mod] load fail %s err=%lu\r\n",fd.cFileName,GetLastError()); continue; }
        ModMain_t mm=(ModMain_t)GetProcAddress(m,"ModMain");
        if(!mm){ logmsg("[hysteria][mod] %s: no ModMain\r\n",fd.cFileName); FreeLibrary(m); continue; }
        if(g_loadedN<64) g_loaded[g_loadedN++]=m;
        logmsg("[hysteria][mod] loading %s\r\n",fd.cFileName);
        mm(&g_api);
    } while(FindNextFileA(h,&fd));
    FindClose(h);
}
int editor_list(const char *filter, void **out, int max){
    if(!g_gobjects||!out) return 0;
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0; if(cnt>2000000)cnt=2000000;
    int n=0;
    for(int i=0;i<cnt && n<max;i++){ void *o=data[i];
        if(!mem_ok(o,O_CLASS+4)) continue;
        const char *cn=obj_class_name(o), *on=obj_name(o);
        if(!filter || !filter[0] || (cn&&contains(cn,filter)) || (on&&contains(on,filter))) out[n++]=o;
    }
    return n;
}
int editor_props(void *obj, AEditProp *out, int max){
    if(!obj||!out) return 0;
    void *cls=class_of(obj); int n=0;
    for(int d=0; d<24 && is_class(cls) && n<max; d++){
        if(g_gobjects){
            void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0; if(cnt>2000000)cnt=2000000;
            for(int i=0;i<cnt && n<max;i++){ void *o=data[i];
                if(!mem_ok(o,O_OUTER+4) || !is_property(o)) continue;
                if(*(void**)((char*)o+O_OUTER)!=cls) continue;
                const char *pn=obj_name(o); if(!pn) continue;
                int off=(M_POFF>=0&&mem_ok((char*)o+M_POFF,4))?*(int*)((char*)o+M_POFF):-1; if(off<0) continue;
                const char *pc=obj_class_name(o); char ty='x'; unsigned mask=0;
                if(pc){
                    if(!lstrcmpA(pc,"IntProperty")) ty='i';
                    else if(!lstrcmpA(pc,"FloatProperty")) ty='f';
                    else if(!lstrcmpA(pc,"BoolProperty")){ ty='b'; if(M_BITMASK>=0&&mem_ok((char*)o+M_BITMASK,4)) mask=*(unsigned*)((char*)o+M_BITMASK); }
                    else if(!lstrcmpA(pc,"ByteProperty")) ty='y';
                    else if(!lstrcmpA(pc,"ObjectProperty")) ty='o';
                }
                lstrcpynA(out[n].name,pn,sizeof out[n].name); out[n].off=off; out[n].typ=ty; out[n].mask=mask; n++;
            }
        }
        if(g_superOff<0) break;
        cls=*(void**)((char*)cls+g_superOff); if(!cls) break;
    }
    return n;
}
HysteriaAPI* hysteria_api_get(void){ return &g_api; }
void load_mods(void){ static int done=0; if(done)return; done=1; ui_install_api(); scan_and_load(); }
void mod_do_reload(void){
    g_reloading=1;
    g_regN=0;
    g_ticksN=0;
    ui_panels_clear();
    for(int i=0;i<g_loadedN;i++) if(g_loaded[i]) FreeLibrary(g_loaded[i]);
    g_loadedN=0;
    g_mcN=0;
    logmsg("[hysteria][mod] === reloading mods ===\r\n");
    scan_and_load();
    g_reloading=0;
}
