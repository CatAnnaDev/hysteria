#include "hysteria.h"

static DWORD g_lastTick; static int g_frameAccum; static float g_fps;
float g_uiPos[3], g_uiVel[3], g_uiSpeed;
int g_uiHP;
char g_uiMap[64];
int g_uiXP, g_uiWeaponLvl, g_uiUpgHealth, g_uiMemDone;
int g_uiAddXP=0, g_uiSetWeaponLvl=0;

char g_renderer[80]="";

#define MAXHUD 96
static struct { int x,y; D3DCOLOR c; char t[96]; } g_hud[MAXHUD];
static int g_hudN=0;
void api_hud_text(int x,int y,unsigned argb,const char *t){
    if(g_hudN>=MAXHUD) return;
    g_hud[g_hudN].x=x; g_hud[g_hudN].y=y; g_hud[g_hudN].c=(D3DCOLOR)argb;
    lstrcpynA(g_hud[g_hudN].t, t?t:"", sizeof g_hud[g_hudN].t);
    g_hudN++;
}
#define MAXHUDR 192
static struct { float x,y,w,h; D3DCOLOR c; } g_hudr[MAXHUDR];
static int g_hudrN=0;
void api_hud_rect(int x,int y,int w,int h,unsigned argb){
    if(g_hudrN>=MAXHUDR) return;
    g_hudr[g_hudrN].x=(float)x; g_hudr[g_hudrN].y=(float)y; g_hudr[g_hudrN].w=(float)w; g_hudr[g_hudrN].h=(float)h;
    g_hudr[g_hudrN].c=(D3DCOLOR)argb; g_hudrN++;
}
static void detect_renderer(void){
    if(g_renderer[0]) return;
    if(GetModuleHandleA("vulkan-1.dll")||GetModuleHandleA("winevulkan.dll"))
        lstrcpynA(g_renderer,"D3D9 -> Vulkan (DXVK)",sizeof g_renderer);
    else if(GetModuleHandleA("dgVoodoo.dll")||GetModuleHandleA("d3d11.dll"))
        lstrcpynA(g_renderer,"D3D9 -> D3D11 (dgVoodoo/wrapper)",sizeof g_renderer);
    else
        lstrcpynA(g_renderer,"D3D9 (native DirectX)",sizeof g_renderer);
    if(GetModuleHandleA("ReShade32.dll")||GetModuleHandleA("ReShade64.dll")||GetModuleHandleA("dxgi.dll"))
        lstrcatA(g_renderer," + ReShade?");
    logmsg("[hysteria] renderer: %s\r\n", g_renderer);
}

void frame_render(IDirect3DDevice9 *dev){
    if(IDirect3DDevice9_TestCooperativeLevel(dev)!=D3D_OK) return;  // skip overlay during device-lost/reset windows
    { IDirect3DSurface9 *rt=NULL,*bb=NULL;
      if(IDirect3DDevice9_GetRenderTarget(dev,0,&rt)!=D3D_OK) rt=NULL;
      if(IDirect3DDevice9_GetBackBuffer(dev,0,0,D3DBACKBUFFER_TYPE_MONO,&bb)!=D3D_OK) bb=NULL;
      int isbb=(rt&&bb&&rt==bb);
      if(rt) IDirect3DSurface9_Release(rt);
      if(bb) IDirect3DSurface9_Release(bb);
      static int everBb=0, fr=0; fr++;
      if(isbb) everBb=1;
      if(!isbb && (everBb || fr<600)) return;
    }
    DWORD now=GetTickCount(); g_frameAccum++;
    if(g_lastTick==0) g_lastTick=now;
    if(now-g_lastTick>=500){ g_fps=g_frameAccum*1000.0f/(now-g_lastTick); g_frameAccum=0; g_lastTick=now; }

    mem_ok_reset();
    ensure_gfx(dev);
    detect_renderer();

    D3DVIEWPORT9 vp; IDirect3DDevice9_GetViewport(dev,&vp);
    int W=vp.Width, H=vp.Height;
    extern int g_scrW, g_scrH; g_scrW=W; g_scrH=H;
    ui_init(dev,W,H);

    if(key_edge(VK_OEM_3) || key_edge(VK_INSERT)) g_uiVisible=!g_uiVisible;

    char buf[200];
    int hud=g_uiVisible;
    if(hud){
        D3DRECT bg={14,14,640,170};
        IDirect3DDevice9_Clear(dev,1,&bg,D3DCLEAR_TARGET,D3DCOLOR_ARGB(255,15,15,20),1.0f,0);
        draw_text(dev,22,18,D3DCOLOR_XRGB(150,120,255),"HYSTERIA MODDING TOOLS");
        wsprintfA(buf,"FPS %d   [ Inser ou ` = menu ]",(int)(g_fps+0.5f));
        draw_text(dev,22,42,D3DCOLOR_XRGB(255,230,120),buf);
    } else {
        draw_text(dev,14,H-24,D3DCOLOR_ARGB(190,120,220,170),"HYSTERIA actif  -  [Inser] ou [\xb2] = menu");
    }

    scan_gnames();
    if(g_gnames && !g_gobjects) g_gobjects=g_gnames+0x54;
    if(!g_gnames){ if(hud) draw_text(dev,22,66,D3DCOLOR_XRGB(120,220,255),"Engine: scanning..."); goto done; }
    probe_engine_offsets();

    { static int pcTick=0;
      int bad=!mem_ok(g_pc,C_PAWN+4)||!contains(obj_class_name(g_pc),"PlayerController");
      if(bad){ g_pc=NULL; if(++pcTick>=20){ pcTick=0; find_pc(); } } }

    void *pawn=g_pc?*(void**)((char*)g_pc+C_PAWN):NULL;
    if(!mem_ok(pawn,A_LOC+12)) pawn=NULL;

    if(pawn && !g_propCal){
        static int calTick=0;
        if(g_calTries<40 && ++calTick>=15){ calTick=0; g_calTries++; calibrate_props(); }
    }
    if(pawn && g_propCal && !g_worldInfo){
        static int wt=0; if(++wt>=30){ wt=0; find_worldinfo(); }
    }
    if(pawn && g_propCal && !g_aliceCal) alice_calibrate();

    if(!pawn){
        if(hud) draw_text(dev,22,66,D3DCOLOR_XRGB(180,180,180),"Joueur: menu / chargement...");
        goto done;
    }

    int pawnFull=mem_ok(pawn,0x400);
    float *L=(float*)((char*)pawn+A_LOC);
    float *V=(OFF_VEL>0&&pawnFull)?(float*)((char*)pawn+OFF_VEL):NULL;
    int hp=(OFF_HEALTH>0&&pawnFull)?*(int*)((char*)pawn+OFF_HEALTH):-1;
    unsigned char phys=(OFF_PHYS>0&&pawnFull)?*(unsigned char*)((char*)pawn+OFF_PHYS):0;
    const char *mp=obj_name(outermost(pawn));

    { static void *prevPawn=NULL;
      if(pawn!=prevPawn){ prevPawn=pawn; g_freecam=0; g_worldInfo=NULL; g_camLocOff=-1; g_stable=0; g_dumped=0; } }
    if(g_stable<100000) g_stable++;
    int isMenu=(mp&&contains(mp,"Entry"));

    cheats_update(dev,pawn,L,V,hp,pawnFull,isMenu);
    g_modPawn=pawn;
    mod_tick();
    mod_run_ticks();
    mod_pump();

    if(key_edge(VK_F1)||g_uiDumpReq||(!g_dumped && g_stable>120 && mp&&mp[0])){ g_uiDumpReq=0; g_dumped=1; dump_all(g_pc,pawn,mp); }
    if(key_edge(VK_F2)||g_uiDumpAllReq){ g_uiDumpAllReq=0; dump_everything_async(); }

    g_uiPos[0]=L[0];g_uiPos[1]=L[1];g_uiPos[2]=L[2];
    if(V){ g_uiVel[0]=V[0];g_uiVel[1]=V[1];g_uiVel[2]=V[2]; g_uiSpeed=__builtin_sqrtf(V[0]*V[0]+V[1]*V[1]+V[2]*V[2]); }
    g_uiHP=hp; lstrcpynA(g_uiMap,mp,sizeof g_uiMap);

    if(g_uiVisible){ static int at=0; if(++at>=15){ at=0; scan_actors(L); } }
    enemies_tick(L, pawn);

    if(hud){
        wsprintfA(buf,"Pos %d %d %d   HP %d   %s",(int)L[0],(int)L[1],(int)L[2],hp,mp);
        draw_text(dev,22,66,D3DCOLOR_XRGB(255,180,120),buf);
    }

    render_hitboxes(dev,pawn,L);

done:
    for(int i=0;i<g_hudrN;i++) fill_rect(dev,g_hudr[i].x,g_hudr[i].y,g_hudr[i].w,g_hudr[i].h,g_hudr[i].c);
    g_hudrN=0;
    for(int i=0;i<g_hudN;i++) draw_text(dev,g_hud[i].x,g_hud[i].y,g_hud[i].c,g_hud[i].t);
    g_hudN=0;
    console_render(dev);
    ui_render(dev,W,H);
}
