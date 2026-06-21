#include "hysteria.h"

static DWORD g_lastTick; static int g_frameAccum; static float g_fps;
float g_uiPos[3], g_uiVel[3], g_uiSpeed;
int g_uiHP;
char g_uiMap[64];
int g_uiXP, g_uiWeaponLvl, g_uiUpgHealth, g_uiMemDone;
int g_uiAddXP=0, g_uiSetWeaponLvl=0;

void frame_render(IDirect3DDevice9 *dev){
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

    D3DVIEWPORT9 vp; IDirect3DDevice9_GetViewport(dev,&vp);
    int W=vp.Width, H=vp.Height;
    ui_init(dev,W,H);

    char buf[200];
    int hud=g_uiVisible;
    if(hud){
        D3DRECT bg={14,14,640,170};
        IDirect3DDevice9_Clear(dev,1,&bg,D3DCLEAR_TARGET,D3DCOLOR_ARGB(255,15,15,20),1.0f,0);
        draw_text(dev,22,18,D3DCOLOR_XRGB(150,120,255),"HYSTERIA MODDING TOOLS");
        wsprintfA(buf,"FPS %d   [ ` = menu ]",(int)(g_fps+0.5f));
        draw_text(dev,22,42,D3DCOLOR_XRGB(255,230,120),buf);
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
    console_render(dev);
    ui_render(dev,W,H);
}
