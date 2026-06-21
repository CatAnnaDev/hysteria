#include "hysteria.h"
#include <d3d11.h>
#include <dxgi.h>

typedef HRESULT (WINAPI *Present_t)(IDXGISwapChain*, UINT, UINT);
static Present_t g_origPresent;
int g_dxgiActive=0;
void d3d11_overlay(IDXGISwapChain *sc);

static HRESULT WINAPI my_Present(IDXGISwapChain *sc, UINT sync, UINT flags){
    static int once=0;
    if(!once){ once=1; g_dxgiActive=1; logmsg("[hysteria] DXGI Present CALLED (D3D11 rendering active)\r\n"); }
    d3d11_overlay(sc);
    return g_origPresent(sc, sync, flags);
}

DWORD WINAPI setup_d3d11_hook(LPVOID a){(void)a;
    HMODULE d11=NULL;
    for(int i=0;i<600 && !d11;i++){ d11=GetModuleHandleA("d3d11.dll"); Sleep(50); }
    if(!d11) return 0;
    typedef HRESULT (WINAPI *CreateDSC_t)(IDXGIAdapter*,D3D_DRIVER_TYPE,HMODULE,UINT,const D3D_FEATURE_LEVEL*,UINT,UINT,const DXGI_SWAP_CHAIN_DESC*,IDXGISwapChain**,ID3D11Device**,D3D_FEATURE_LEVEL*,ID3D11DeviceContext**);
    CreateDSC_t pC=(CreateDSC_t)GetProcAddress(d11,"D3D11CreateDeviceAndSwapChain");
    if(!pC){ logmsg("[hysteria] no D3D11CreateDeviceAndSwapChain\r\n"); return 0; }
    Sleep(1500);
    HWND hwnd=CreateWindowExA(0,"STATIC","ov11",WS_OVERLAPPED,0,0,8,8,NULL,NULL,GetModuleHandleA(NULL),NULL);
    DXGI_SWAP_CHAIN_DESC sd; ZeroMemory(&sd,sizeof sd);
    sd.BufferCount=1;
    sd.BufferDesc.Width=8; sd.BufferDesc.Height=8;
    sd.BufferDesc.Format=DXGI_FORMAT_R8G8B8A8_UNORM;
    sd.BufferUsage=DXGI_USAGE_RENDER_TARGET_OUTPUT;
    sd.OutputWindow=hwnd;
    sd.SampleDesc.Count=1;
    sd.Windowed=TRUE;
    IDXGISwapChain *sc=NULL; ID3D11Device *dev=NULL; ID3D11DeviceContext *ctx=NULL;
    D3D_FEATURE_LEVEL fl;
    HRESULT hr=pC(NULL,D3D_DRIVER_TYPE_HARDWARE,NULL,0,NULL,0,D3D11_SDK_VERSION,&sd,&sc,&dev,&fl,&ctx);
    if(FAILED(hr)||!sc){ logmsg("[hysteria] dummy swapchain failed hr=0x%08x\r\n",hr); if(hwnd)DestroyWindow(hwnd); return 0; }
    void **vt=*(void***)sc;
    DWORD op;
    g_origPresent=(Present_t)vt[8];
    VirtualProtect(&vt[8],sizeof(void*),PAGE_READWRITE,&op); vt[8]=(void*)my_Present; VirtualProtect(&vt[8],sizeof(void*),op,&op);
    FlushInstructionCache(GetCurrentProcess(),NULL,0);
    logmsg("[hysteria] hooked DXGI Present (orig=%p)\r\n", g_origPresent);
    IDXGISwapChain_Release(sc); ID3D11Device_Release(dev); ID3D11DeviceContext_Release(ctx); DestroyWindow(hwnd);
    return 0;
}
