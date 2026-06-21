#include "hysteria.h"

static int writable(const char *path){
    HANDLE h=CreateFileA(path,FILE_APPEND_DATA,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(h==INVALID_HANDLE_VALUE) return 0;
    CloseHandle(h); return 1;
}
const char *log_path(void){
    static char path[MAX_PATH]; static int init=0;
    if(init) return path;
    init=1;
    if(writable("C:\\hysteria.log")){ lstrcpyA(path,"C:\\hysteria.log"); return path; }
    HMODULE self=NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS|GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,(LPCSTR)&log_path,&self);
    char dir[MAX_PATH]; DWORD n=GetModuleFileNameA(self,dir,MAX_PATH);
    while(n>0 && dir[n-1]!='\\' && dir[n-1]!='/') n--; dir[n]=0;
    wsprintfA(path,"%shysteria.log",dir);
    if(writable(path)) return path;
    char tmp[MAX_PATH]; DWORD t=GetTempPathA(MAX_PATH,tmp);
    if(t>0){ wsprintfA(path,"%shysteria.log",tmp); if(writable(path)) return path; }
    lstrcpyA(path,"C:\\hysteria.log");
    return path;
}
void logmsg(const char *fmt, ...){
    char b[512]; va_list ap; va_start(ap,fmt); int n=wvsprintfA(b,fmt,ap); va_end(ap);
    HANDLE h=CreateFileA(log_path(),FILE_APPEND_DATA,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(h!=INVALID_HANDLE_VALUE){DWORD w;SetFilePointer(h,0,NULL,FILE_END);WriteFile(h,b,n,&w,NULL);CloseHandle(h);}
    console_push(b);
}

static HMODULE g_realdi;
static FARPROC p_DI8C,p_Can,p_Get,p_Reg,p_Unreg;
static void ensure_real(void){
    if(g_realdi)return;
    char sys[MAX_PATH]; UINT n=GetSystemDirectoryA(sys,MAX_PATH);
    if(n>0 && n<MAX_PATH-16){ char p[MAX_PATH]; wsprintfA(p,"%s\\dinput8.dll",sys); g_realdi=LoadLibraryA(p); }
    if(!g_realdi) g_realdi=LoadLibraryA("C:\\windows\\syswow64\\dinput8.dll");
    p_DI8C=GetProcAddress(g_realdi,"DirectInput8Create");
    p_Can=GetProcAddress(g_realdi,"DllCanUnloadNow");
    p_Get=GetProcAddress(g_realdi,"DllGetClassObject");
    p_Reg=GetProcAddress(g_realdi,"DllRegisterServer");
    p_Unreg=GetProcAddress(g_realdi,"DllUnregisterServer");
}
static void hook_vt(void *obj,int idx,void *hook,void **orig){
    void **vt=*(void***)obj; DWORD op;
    VirtualProtect(&vt[idx],sizeof(void*),PAGE_READWRITE,&op);
    if(orig)*orig=vt[idx];
    vt[idx]=hook;
    VirtualProtect(&vt[idx],sizeof(void*),op,&op);
}
typedef HRESULT (WINAPI *GetState_t)(void*,DWORD,void*);
typedef HRESULT (WINAPI *GetData_t)(void*,DWORD,void*,DWORD*,DWORD);
typedef HRESULT (WINAPI *CreateDev_t)(void*,const GUID*,void**,void*);
static GetState_t g_oGetState;
static GetData_t g_oGetData;
static CreateDev_t g_oCreateDev;
static int g_devHooked, g_di8Hooked;

long g_mouseDX=0, g_mouseDY=0;
int g_mouseCapture=0;
static HRESULT WINAPI my_GetState(void *self,DWORD cb,void *data){
    HRESULT hr=g_oGetState(self,cb,data);
    if(data && (cb==16 || cb==20)){
        long *ax=(long*)data;
        if(g_uiVisible){ unsigned char *p=data; for(DWORD i=0;i<cb;i++) p[i]=0; }
        else { g_mouseDX+=ax[0]; g_mouseDY+=ax[1]; if(g_mouseCapture){ ax[0]=0; ax[1]=0; } }
    }
    return hr;
}
static HRESULT WINAPI my_GetData(void *self,DWORD cb,void *rgdod,DWORD *inout,DWORD flags){
    HRESULT hr=g_oGetData(self,cb,rgdod,inout,flags);
    if((hr==0||hr==1) && rgdod && inout && cb>=8){
        DWORD n=*inout;
        for(DWORD i=0;i<n;i++){
            unsigned char *e=(unsigned char*)rgdod + (size_t)i*cb;
            DWORD ofs=*(DWORD*)e; long *data=(long*)(e+4);
            if(ofs!=0 && ofs!=4) continue;                 // mouse X / Y only
            if(g_uiVisible){ *data=0; continue; }
            if(ofs==0) g_mouseDX+=*data; else g_mouseDY+=*data;
            if(g_mouseCapture) *data=0;
        }
    }
    return hr;
}
static int g_mouseHooked;
static HRESULT WINAPI my_CreateDev(void *self,const GUID *g,void **dev,void *outer){
    HRESULT hr=g_oCreateDev(self,g,dev,outer);
    if(hr==0 && dev && *dev && g){
        if(g->Data1==0x6F1D2B60 && !g_mouseHooked){      // GUID_SysMouse
            g_mouseHooked=1;
            hook_vt(*dev,9,(void*)my_GetState,(void**)&g_oGetState);
            hook_vt(*dev,10,(void*)my_GetData,(void**)&g_oGetData);
        }
    }
    (void)g_devHooked;
    return hr;
}
int g_mouseSuppress=1;
HRESULT WINAPI DirectInput8Create(HINSTANCE h,DWORD v,REFIID r,LPVOID*o,LPUNKNOWN u){
    ensure_real();
    HRESULT hr=((HRESULT(WINAPI*)(HINSTANCE,DWORD,REFIID,LPVOID*,LPUNKNOWN))p_DI8C)(h,v,r,o,u);
    if(g_mouseSuppress && hr==0 && o && *o && !g_di8Hooked){
        g_di8Hooked=1;
        hook_vt(*o,3,(void*)my_CreateDev,(void**)&g_oCreateDev);
        logmsg("[hysteria] IDirectInput8 CreateDevice hooked\r\n");
    }
    return hr;
}
HRESULT WINAPI DllCanUnloadNow(void){ensure_real();return ((HRESULT(WINAPI*)(void))p_Can)();}
HRESULT WINAPI DllGetClassObject(REFCLSID c,REFIID r,LPVOID*p){ensure_real();return ((HRESULT(WINAPI*)(REFCLSID,REFIID,LPVOID*))p_Get)(c,r,p);}
HRESULT WINAPI DllRegisterServer(void){ensure_real();return ((HRESULT(WINAPI*)(void))p_Reg)();}
HRESULT WINAPI DllUnregisterServer(void){ensure_real();return ((HRESULT(WINAPI*)(void))p_Unreg)();}

EndScene_t g_origEndScene;
Reset_t    g_origReset;

// A game may render through a plain Direct3DCreate9 device (typical under Wine) or a
// Direct3DCreate9Ex device (UE3 on Vista+/real Windows). Those are different C++ classes
// with DIFFERENT vtables, so we hook both and remember the original EndScene/Reset per vtable.
#define MAX_HOOKVT 4
static struct { void **vt; void *origES; void *origReset; } g_hookvt[MAX_HOOKVT];
static int g_hookvtN;

static void* find_orig(IDirect3DDevice9 *dev, int reset){
    void **vt=*(void***)dev;
    for(int i=0;i<g_hookvtN;i++) if(g_hookvt[i].vt==vt) return reset?g_hookvt[i].origReset:g_hookvt[i].origES;
    return reset?(void*)g_origReset:(void*)g_origEndScene;
}

// Re-entrancy guards: the vtable hook (works under Wine) and the inline function hook (needed
// on real Windows where an overlay/wrapper gives each device its OWN vtable) can both be in the
// call chain for one frame. The guard makes frame_render / device-reset run exactly once.
static volatile LONG g_inFrame, g_inReset;
static EndScene_t g_esTramp;
static Reset_t    g_resetTramp;

static void reset_lost(void){ if(g_font) ID3DXFont_OnLostDevice(g_font); if(g_line) ID3DXLine_OnLostDevice(g_line); }
static void reset_restore(void){ if(g_line) ID3DXLine_OnResetDevice(g_line); if(g_font) ID3DXFont_OnResetDevice(g_font); }

static HRESULT WINAPI my_EndScene(IDirect3DDevice9 *dev){
    int top=InterlockedExchange(&g_inFrame,1)==0;
    if(top){ static int once=0; if(!once){ once=1; logmsg("[hysteria] my_EndScene CALLED (vtable) - D3D9 rendering active\r\n"); } frame_render(dev); }
    EndScene_t o=(EndScene_t)find_orig(dev,0);
    HRESULT hr=o?o(dev):D3D_OK;
    if(top) InterlockedExchange(&g_inFrame,0);
    return hr;
}
static HRESULT WINAPI my_es_inline(IDirect3DDevice9 *dev){
    int top=InterlockedExchange(&g_inFrame,1)==0;
    if(top){ static int once=0; if(!once){ once=1; logmsg("[hysteria] my_EndScene CALLED (inline fn hook) - D3D9 rendering active\r\n"); } frame_render(dev); }
    HRESULT hr=g_esTramp ? g_esTramp(dev) : D3D_OK;
    if(top) InterlockedExchange(&g_inFrame,0);
    return hr;
}
static HRESULT WINAPI my_Reset(IDirect3DDevice9 *dev, D3DPRESENT_PARAMETERS *pp){
    int top=InterlockedExchange(&g_inReset,1)==0;
    if(top) reset_lost();
    Reset_t o=(Reset_t)find_orig(dev,1);
    HRESULT hr=o?o(dev,pp):D3D_OK;
    if(top){ reset_restore(); InterlockedExchange(&g_inReset,0); logmsg("[hysteria] device Reset hr=0x%08x\r\n", hr); }
    return hr;
}
static HRESULT WINAPI my_reset_inline(IDirect3DDevice9 *dev, D3DPRESENT_PARAMETERS *pp){
    int top=InterlockedExchange(&g_inReset,1)==0;
    if(top) reset_lost();
    HRESULT hr=g_resetTramp ? g_resetTramp(dev,pp) : D3D_OK;
    if(top){ reset_restore(); InterlockedExchange(&g_inReset,0); }
    return hr;
}

static void hook_device_vtable(IDirect3DDevice9 *dev, const char *tag){
    if(!dev) return;
    void **vtbl=*(void***)dev;
    if(vtbl[42]==(void*)my_EndScene) return;                       // this vtable already ours
    for(int i=0;i<g_hookvtN;i++) if(g_hookvt[i].vt==vtbl) return;  // already recorded
    if(g_hookvtN>=MAX_HOOKVT) return;
    void *oES=vtbl[42], *oReset=vtbl[16];
    g_hookvt[g_hookvtN].vt=vtbl; g_hookvt[g_hookvtN].origES=oES; g_hookvt[g_hookvtN].origReset=oReset; g_hookvtN++;
    if(!g_origEndScene){ g_origEndScene=(EndScene_t)oES; g_origReset=(Reset_t)oReset; }
    DWORD op;
    VirtualProtect(&vtbl[16],sizeof(void*),PAGE_READWRITE,&op); vtbl[16]=(void*)my_Reset; VirtualProtect(&vtbl[16],sizeof(void*),op,&op);
    VirtualProtect(&vtbl[42],sizeof(void*),PAGE_READWRITE,&op); vtbl[42]=(void*)my_EndScene; VirtualProtect(&vtbl[42],sizeof(void*),op,&op);
    FlushInstructionCache(GetCurrentProcess(),NULL,0);
    logmsg("[hysteria] hooked EndScene+Reset [%s] (es=%p reset=%p vt=%p)\r\n", tag, oES, oReset, vtbl);
}

static DWORD WINAPI setup_thread(LPVOID a){(void)a;
    log_mod_paths();
    HMODULE d3d9mod=NULL;
    for(int i=0;i<600 && !d3d9mod;i++){ d3d9mod=GetModuleHandleA("d3d9.dll"); Sleep(50); }
    if(!d3d9mod){ logmsg("[hysteria] d3d9 never loaded\r\n"); return 0; }
    typedef IDirect3D9* (WINAPI *D3DC9_t)(UINT);
    typedef HRESULT (WINAPI *D3DC9Ex_t)(UINT, IDirect3D9Ex**);
    D3DC9_t   pCreate  =(D3DC9_t)  GetProcAddress(d3d9mod,"Direct3DCreate9");
    D3DC9Ex_t pCreateEx=(D3DC9Ex_t)GetProcAddress(d3d9mod,"Direct3DCreate9Ex");
    if(!pCreate && !pCreateEx){ logmsg("[hysteria] no Direct3DCreate9/Ex\r\n"); return 0; }
    Sleep(1500);
    HWND hwnd=CreateWindowExA(0,"STATIC","ov",WS_OVERLAPPED,0,0,8,8,NULL,NULL,GetModuleHandleA(NULL),NULL);
    if(!hwnd) hwnd=GetDesktopWindow();
    // explicit, wrapper-strict-safe present params (DXVK/dgVoodoo reject UNKNOWN format / 0-size)
    static const DWORD BF[3]={
        D3DCREATE_SOFTWARE_VERTEXPROCESSING|D3DCREATE_NOWINDOWCHANGES,
        D3DCREATE_HARDWARE_VERTEXPROCESSING|D3DCREATE_NOWINDOWCHANGES,
        D3DCREATE_MIXED_VERTEXPROCESSING|D3DCREATE_NOWINDOWCHANGES};

    if(pCreate){
        IDirect3D9 *d3d=pCreate(D3D_SDK_VERSION);
        if(d3d){
            D3DDISPLAYMODE dm; ZeroMemory(&dm,sizeof dm);
            IDirect3D9_GetAdapterDisplayMode(d3d,D3DADAPTER_DEFAULT,&dm);
            D3DFORMAT fmt=dm.Format?dm.Format:D3DFMT_X8R8G8B8;
            D3DPRESENT_PARAMETERS pp; ZeroMemory(&pp,sizeof pp);
            pp.Windowed=TRUE; pp.SwapEffect=D3DSWAPEFFECT_DISCARD; pp.hDeviceWindow=hwnd;
            pp.BackBufferWidth=2; pp.BackBufferHeight=2; pp.BackBufferCount=1; pp.BackBufferFormat=fmt;
            IDirect3DDevice9 *dev=NULL; HRESULT hr=(HRESULT)0x8876086c;
            for(int i=0;i<3 && !(SUCCEEDED(hr)&&dev);i++)
                hr=IDirect3D9_CreateDevice(d3d,D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,hwnd,BF[i],&pp,&dev);
            if(SUCCEEDED(hr)&&dev){ hook_device_vtable(dev,"d3d9"); IDirect3DDevice9_Release(dev); }
            else logmsg("[hysteria] plain dummy device failed hr=0x%08x fmt=%d\r\n",hr,fmt);
            IDirect3D9_Release(d3d);
        } else logmsg("[hysteria] create9 failed\r\n");
    }

    if(pCreateEx){
        IDirect3D9Ex *d3dex=NULL;
        if(pCreateEx(D3D_SDK_VERSION,&d3dex)==D3D_OK && d3dex){
            D3DDISPLAYMODE dm; ZeroMemory(&dm,sizeof dm);
            IDirect3D9_GetAdapterDisplayMode((IDirect3D9*)d3dex,D3DADAPTER_DEFAULT,&dm);
            D3DFORMAT fmt=dm.Format?dm.Format:D3DFMT_X8R8G8B8;
            D3DPRESENT_PARAMETERS pp; ZeroMemory(&pp,sizeof pp);
            pp.Windowed=TRUE; pp.SwapEffect=D3DSWAPEFFECT_DISCARD; pp.hDeviceWindow=hwnd;
            pp.BackBufferWidth=2; pp.BackBufferHeight=2; pp.BackBufferCount=1; pp.BackBufferFormat=fmt;
            IDirect3DDevice9Ex *devx=NULL; HRESULT hr=(HRESULT)0x8876086c;
            for(int i=0;i<3 && !(SUCCEEDED(hr)&&devx);i++)
                hr=IDirect3D9Ex_CreateDeviceEx(d3dex,D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,hwnd,BF[i],&pp,NULL,&devx);
            if(SUCCEEDED(hr)&&devx){ hook_device_vtable((IDirect3DDevice9*)devx,"d3d9ex"); IDirect3DDevice9Ex_Release(devx); }
            else logmsg("[hysteria] ex dummy device failed hr=0x%08x fmt=%d\r\n",hr,fmt);
            IDirect3D9Ex_Release(d3dex);
        } else logmsg("[hysteria] create9ex failed\r\n");
    }

    if(g_hookvtN==0) logmsg("[hysteria] WARNING: no device vtable hooked\r\n");

    // Inline-hook the EndScene/Reset FUNCTIONS themselves. On real Windows a Steam-overlay /
    // d3d9 wrapper gives the game's device a private heap vtable we never see, so patching our
    // dummy's vtable misses it; but every device still calls the same underlying EndScene
    // function, which an inline detour catches regardless of vtable.
    if(g_origEndScene){
        void *tr=detour((void*)g_origEndScene,(void*)my_es_inline);
        if(tr){ g_esTramp=(EndScene_t)tr; logmsg("[hysteria] inline-hooked EndScene fn @%p\r\n",(void*)g_origEndScene); }
        else logmsg("[hysteria] EndScene inline-hook FAILED (prologue undecodable)\r\n");
    }
    if(g_origReset){
        void *tr=detour((void*)g_origReset,(void*)my_reset_inline);
        if(tr){ g_resetTramp=(Reset_t)tr; logmsg("[hysteria] inline-hooked Reset fn @%p\r\n",(void*)g_origReset); }
        else logmsg("[hysteria] Reset inline-hook FAILED (prologue undecodable)\r\n");
    }

    DestroyWindow(hwnd);
    return 0;
}

static DWORD WINAPI diag_thread(LPVOID a){(void)a;
    char exe[MAX_PATH]={0}; GetModuleFileNameA(NULL,exe,sizeof exe);
    logmsg("[hysteria][diag] exe=%s\r\n", exe);
    int diagged=0;
    for(int i=0;i<180;i++){
        Sleep(1000);
        scan_gnames();
        (void)diagged;
        if(g_gnames){
            int cnt=mem_ok((void*)(ULONG_PTR)g_gnames,8)?*(int*)(g_gnames+4):-1;
            logmsg("[hysteria][diag] GNames @ %08x cnt=%d nameOff=0x%x\r\n", g_gnames, cnt, g_nameOff);
            if(!g_gobjects) g_gobjects=g_gnames+0x54;
            scan_gobjects();
            probe_engine_offsets();
            if(g_oName!=0x2C || g_oClass!=0x34)
                logmsg("[hysteria][diag] non-UE3 offsets: name=0x%x class=0x%x outer=0x%x gobjects=%08x\r\n", g_oName,g_oClass,g_oOuter,g_gobjects);
            break;
        }
    }
    return 0;
}
BOOL WINAPI DllMain(HINSTANCE h,DWORD reason,LPVOID r){(void)r;
    if(reason==DLL_PROCESS_ATTACH){ DisableThreadLibraryCalls(h);
        logmsg("\r\n==== hysteria ATTACH pid=%lu ====\r\n", GetCurrentProcessId());
        CreateThread(NULL,0,setup_thread,NULL,0,NULL);
        CreateThread(NULL,0,diag_thread,NULL,0,NULL);
    }
    return TRUE;
}
