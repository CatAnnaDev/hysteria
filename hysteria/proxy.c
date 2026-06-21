#include "hysteria.h"

void logmsg(const char *fmt, ...){
    char b[512]; va_list ap; va_start(ap,fmt); int n=wvsprintfA(b,fmt,ap); va_end(ap);
    HANDLE h=CreateFileA("C:\\hysteria.log",FILE_APPEND_DATA,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(h!=INVALID_HANDLE_VALUE){DWORD w;SetFilePointer(h,0,NULL,FILE_END);WriteFile(h,b,n,&w,NULL);CloseHandle(h);}
    console_push(b);
}

static HMODULE g_realdi;
static FARPROC p_DI8C,p_Can,p_Get,p_Reg,p_Unreg;
static void ensure_real(void){
    if(g_realdi)return;
    g_realdi=LoadLibraryA("C:\\windows\\syswow64\\dinput8.dll");
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

static HRESULT WINAPI my_EndScene(IDirect3DDevice9 *dev){
    static int once=0; if(!once){ once=1; logmsg("[hysteria] my_EndScene CALLED by game (D3D9 rendering active)\r\n"); }
    frame_render(dev);
    return g_origEndScene(dev);
}
static HRESULT WINAPI my_Reset(IDirect3DDevice9 *dev, D3DPRESENT_PARAMETERS *pp){
    if(g_font) ID3DXFont_OnLostDevice(g_font);
    if(g_line) ID3DXLine_OnLostDevice(g_line);
    HRESULT hr=g_origReset(dev,pp);
    if(g_line) ID3DXLine_OnResetDevice(g_line);
    if(g_font) ID3DXFont_OnResetDevice(g_font);
    logmsg("[hysteria] device Reset hr=0x%08x\r\n", hr);
    return hr;
}

static DWORD WINAPI setup_thread(LPVOID a){(void)a;
    HMODULE d3d9mod=NULL;
    for(int i=0;i<600 && !d3d9mod;i++){ d3d9mod=GetModuleHandleA("d3d9.dll"); Sleep(50); }
    if(!d3d9mod){ logmsg("[hysteria] d3d9 never loaded\r\n"); return 0; }
    typedef IDirect3D9* (WINAPI *D3DC9_t)(UINT);
    D3DC9_t pCreate=(D3DC9_t)GetProcAddress(d3d9mod,"Direct3DCreate9");
    if(!pCreate){ logmsg("[hysteria] no Direct3DCreate9\r\n"); return 0; }
    Sleep(1500);
    IDirect3D9 *d3d=pCreate(D3D_SDK_VERSION);
    if(!d3d){ logmsg("[hysteria] create9 failed\r\n"); return 0; }
    HWND hwnd=CreateWindowExA(0,"STATIC","ov",WS_OVERLAPPED,0,0,8,8,NULL,NULL,GetModuleHandleA(NULL),NULL);
    D3DPRESENT_PARAMETERS pp; ZeroMemory(&pp,sizeof pp);
    pp.Windowed=TRUE; pp.SwapEffect=D3DSWAPEFFECT_DISCARD; pp.hDeviceWindow=hwnd; pp.BackBufferFormat=D3DFMT_UNKNOWN;
    IDirect3DDevice9 *dev=NULL;
    HRESULT hr=IDirect3D9_CreateDevice(d3d,D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,hwnd,
        D3DCREATE_SOFTWARE_VERTEXPROCESSING|D3DCREATE_NOWINDOWCHANGES,&pp,&dev);
    if(FAILED(hr)||!dev){ logmsg("[hysteria] dummy device failed hr=0x%08x\r\n",hr); IDirect3D9_Release(d3d); return 0; }
    void **vtbl=*(void***)dev;
    DWORD op;
    g_origReset=(Reset_t)vtbl[16];
    g_origEndScene=(EndScene_t)vtbl[42];
    VirtualProtect(&vtbl[16],sizeof(void*),PAGE_READWRITE,&op); vtbl[16]=(void*)my_Reset; VirtualProtect(&vtbl[16],sizeof(void*),op,&op);
    VirtualProtect(&vtbl[42],sizeof(void*),PAGE_READWRITE,&op); vtbl[42]=(void*)my_EndScene; VirtualProtect(&vtbl[42],sizeof(void*),op,&op);
    FlushInstructionCache(GetCurrentProcess(),NULL,0);
    logmsg("[hysteria] hooked EndScene+Reset (es=%p reset=%p)\r\n", g_origEndScene, g_origReset);
    IDirect3DDevice9_Release(dev); IDirect3D9_Release(d3d); DestroyWindow(hwnd);
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
        CreateThread(NULL,0,setup_d3d11_hook,NULL,0,NULL);
        CreateThread(NULL,0,diag_thread,NULL,0,NULL);
    }
    return TRUE;
}
