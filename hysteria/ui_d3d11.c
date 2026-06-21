#include "hysteria.h"
#include <d3d11.h>
#include <dxgi.h>

#include <string.h>
#include <stdlib.h>
#include <math.h>
#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#define NK_ASSERT(x)
#define NK_MEMSET memset
#define NK_MEMCPY memcpy
#define NK_SQRT sqrt
#define NK_SIN sinf
#define NK_COS cosf
#define NK_D3D11_IMPLEMENTATION
#include "nuklear.h"
#include "nuklear_d3d11.h"

static const GUID K_IID_ID3D11Device   = {0xdb6f6ddb,0xac77,0x4e88,{0x82,0x53,0x81,0x9d,0xf9,0xbb,0xf1,0x40}};
static const GUID K_IID_ID3D11Texture2D= {0x6f15aaf2,0xd208,0x4e89,{0x9a,0xb4,0x48,0x95,0x35,0xd3,0x4f,0x9c}};

static struct nk_context *g_nk11;
static int g_d11init;
static ID3D11Device *g_dev11;
static ID3D11DeviceContext *g_ctx11;
static WNDPROC g_origWndProc11;
static HWND g_hwnd11;

static LRESULT CALLBACK wndproc11(HWND h,UINT m,WPARAM w,LPARAM l){
    if(g_uiVisible && g_nk11) nk_d3d11_handle_event(h,m,w,l);
    return CallWindowProcA(g_origWndProc11,h,m,w,l);
}

void d3d11_overlay(IDXGISwapChain *sc){
    if(!g_d11init){
        if(FAILED(IDXGISwapChain_GetDevice(sc,&K_IID_ID3D11Device,(void**)&g_dev11)) || !g_dev11) return;
        ID3D11Device_GetImmediateContext(g_dev11,&g_ctx11);
        DXGI_SWAP_CHAIN_DESC sd; IDXGISwapChain_GetDesc(sc,&sd);
        g_nk11=nk_d3d11_init(g_dev11, sd.BufferDesc.Width, sd.BufferDesc.Height, 512*1024, 128*1024);
        struct nk_font_atlas *atlas;
        nk_d3d11_font_stash_begin(&atlas);
        nk_d3d11_font_stash_end();
        if(atlas) nk_style_load_all_cursors(g_nk11,atlas->cursors);
        nk_input_begin(g_nk11);
        g_hwnd11=sd.OutputWindow;
        if(g_hwnd11) g_origWndProc11=(WNDPROC)(LONG_PTR)SetWindowLongPtrA(g_hwnd11,GWLP_WNDPROC,(LONG_PTR)wndproc11);
        g_d11init=1;
        logmsg("[hysteria] d3d11 overlay init %dx%d nk=%p hwnd=%p\r\n", sd.BufferDesc.Width, sd.BufferDesc.Height, g_nk11, g_hwnd11);
    }
    if(!g_nk11) return;

    ID3D11Texture2D *bb=NULL; ID3D11RenderTargetView *rtv=NULL;
    if(SUCCEEDED(IDXGISwapChain_GetBuffer(sc,0,&K_IID_ID3D11Texture2D,(void**)&bb)) && bb){
        ID3D11Device_CreateRenderTargetView(g_dev11,(ID3D11Resource*)bb,NULL,&rtv);
        ID3D11Texture2D_Release(bb);
    }
    if(rtv) ID3D11DeviceContext_OMSetRenderTargets(g_ctx11,1,&rtv,NULL);

    nk_input_end(g_nk11);
    if(nk_begin(g_nk11,"HYSTERIA (D3D11)", nk_rect(40,40,300,160),
        NK_WINDOW_BORDER|NK_WINDOW_TITLE|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE)){
        nk_layout_row_dynamic(g_nk11,22,1);
        nk_label(g_nk11,"D3D11 overlay OK !",NK_TEXT_LEFT);
        nk_labelf(g_nk11,NK_TEXT_LEFT,"GNames: %s", g_gnames?"found":"scanning (UE2.5 todo)");
        nk_checkbox_label(g_nk11,"God",&g_god);
        nk_checkbox_label(g_nk11,"Hitboxes",&g_showHB);
    }
    nk_end(g_nk11);
    nk_d3d11_render(g_ctx11, NK_ANTI_ALIASING_ON);
    nk_input_begin(g_nk11);

    if(rtv) ID3D11RenderTargetView_Release(rtv);
}
