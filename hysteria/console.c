#include "hysteria.h"

#define CON_LINES 48
#define CON_W 180
#define CON_TTL  12000u
#define CON_FADE 2500u

int g_consoleVisible=1;
static char g_con[CON_LINES][CON_W];
static DWORD g_conTime[CON_LINES];
static int g_conHead=0, g_conCount=0;

void console_push(const char *s){
    if(!s) return;
    DWORD t=GetTickCount();
    while(*s){
        while(*s=='\r'||*s=='\n') s++;
        if(!*s) break;
        char *d=g_con[g_conHead]; int n=0;
        for(; s[n] && s[n]!='\r' && s[n]!='\n' && n<CON_W-1; n++) d[n]=s[n];
        d[n]=0; s+=n;
        g_conTime[g_conHead]=t;
        g_conHead=(g_conHead+1)%CON_LINES;
        if(g_conCount<CON_LINES) g_conCount++;
    }
}

typedef struct { float x,y,z,rhw; D3DCOLOR c; } TLV;

static void fill_rect(IDirect3DDevice9 *dev,float x,float y,float w,float h,D3DCOLOR col){
    TLV v[4]={ {x,y,0,1,col},{x+w,y,0,1,col},{x,y+h,0,1,col},{x+w,y+h,0,1,col} };
    DWORD fvf,ab,sb,db,ze,lt;
    IDirect3DDevice9_GetFVF(dev,&fvf);
    IDirect3DDevice9_GetRenderState(dev,D3DRS_ALPHABLENDENABLE,&ab);
    IDirect3DDevice9_GetRenderState(dev,D3DRS_SRCBLEND,&sb);
    IDirect3DDevice9_GetRenderState(dev,D3DRS_DESTBLEND,&db);
    IDirect3DDevice9_GetRenderState(dev,D3DRS_ZENABLE,&ze);
    IDirect3DDevice9_GetRenderState(dev,D3DRS_LIGHTING,&lt);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ALPHABLENDENABLE,TRUE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_SRCBLEND,D3DBLEND_SRCALPHA);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ZENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_LIGHTING,FALSE);
    IDirect3DDevice9_SetTexture(dev,0,NULL);
    IDirect3DDevice9_SetPixelShader(dev,NULL);
    IDirect3DDevice9_SetFVF(dev,D3DFVF_XYZRHW|D3DFVF_DIFFUSE);
    IDirect3DDevice9_DrawPrimitiveUP(dev,D3DPT_TRIANGLESTRIP,2,v,sizeof(TLV));
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ALPHABLENDENABLE,ab);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_SRCBLEND,sb);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_DESTBLEND,db);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ZENABLE,ze);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_LIGHTING,lt);
    IDirect3DDevice9_SetFVF(dev,fvf);
}

void console_render(IDirect3DDevice9 *dev){
    if(!g_consoleVisible || !g_conCount) return;
    DWORD now=GetTickCount();
    int order[CON_LINES], on=0;
    for(int i=0;i<g_conCount;i++){
        int idx=(g_conHead-g_conCount+i+CON_LINES*8)%CON_LINES;
        if(now-g_conTime[idx] < CON_TTL) order[on++]=idx;
    }
    if(!on) return;
    const int lh=15, pad=6, boxW=880, x=8, y0=20;
    int boxH=on*lh+2*pad;
    fill_rect(dev,(float)x,(float)y0,(float)boxW,(float)boxH,D3DCOLOR_ARGB(115,6,6,12));
    for(int i=0;i<on;i++){
        int idx=order[i];
        DWORD age=now-g_conTime[idx];
        int a=255;
        if(age>CON_TTL-CON_FADE) a=(int)(255u*(CON_TTL-age)/CON_FADE);
        if(a<30) a=30;
        draw_text(dev,x+6,y0+pad+i*lh,D3DCOLOR_ARGB(a,150,240,170),g_con[idx]);
    }
}
