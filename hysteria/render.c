#include "hysteria.h"

typedef HRESULT (WINAPI *D3DXCreateFontA_t)(IDirect3DDevice9*,INT,UINT,UINT,UINT,BOOL,DWORD,DWORD,DWORD,DWORD,LPCSTR,LPD3DXFONT*);
typedef HRESULT (WINAPI *D3DXCreateLine_t)(IDirect3DDevice9*,LPD3DXLINE*);
static D3DXCreateFontA_t pD3DXCreateFontA;
static D3DXCreateLine_t  pD3DXCreateLine;
LPD3DXFONT g_font;
LPD3DXLINE g_line;
static int g_fontDone, g_lineTried;

void ensure_gfx(IDirect3DDevice9 *dev){
    if(g_font || g_fontDone) return;
    g_fontDone=1;
    if(!pD3DXCreateFontA){
        HMODULE m=LoadLibraryA("d3dx9_43.dll");
        if(!m) m=GetModuleHandleA("d3dx9_43.dll");
        if(m) pD3DXCreateFontA=(D3DXCreateFontA_t)GetProcAddress(m,"D3DXCreateFontA");
    }
    if(pD3DXCreateFontA){
        HRESULT hr=pD3DXCreateFontA(dev, 20,0, FW_BOLD, 1, FALSE, DEFAULT_CHARSET,
            OUT_DEFAULT_PRECIS, ANTIALIASED_QUALITY, DEFAULT_PITCH|FF_DONTCARE, "Consolas", &g_font);
        logmsg("[hysteria] font create hr=0x%08x font=%p\r\n", hr, g_font);
    } else logmsg("[hysteria] no D3DXCreateFontA\r\n");
}

void ensure_line(IDirect3DDevice9 *dev){
    if(g_line || g_lineTried) return;
    g_lineTried=1;
    if(!pD3DXCreateLine){
        HMODULE m=GetModuleHandleA("d3dx9_43.dll");
        if(m) pD3DXCreateLine=(D3DXCreateLine_t)GetProcAddress(m,"D3DXCreateLine");
    }
    if(pD3DXCreateLine){
        HRESULT hr=pD3DXCreateLine(dev,&g_line);
        if(g_line){ ID3DXLine_SetWidth(g_line,1.6f); ID3DXLine_SetAntialias(g_line,TRUE); }
        logmsg("[hysteria] line create hr=0x%08x line=%p\r\n", hr, g_line);
    }
}

void draw_text(IDirect3DDevice9 *dev, int x, int y, D3DCOLOR col, const char *s){
    (void)dev;
    if(!g_font) return;
    RECT rc; rc.left=x; rc.top=y; rc.right=x+600; rc.bottom=y+24;
    RECT sh=rc; sh.left+=1; sh.top+=1;
    ID3DXFont_DrawTextA(g_font, NULL, s, -1, &sh, DT_LEFT|DT_NOCLIP, D3DCOLOR_XRGB(0,0,0));
    ID3DXFont_DrawTextA(g_font, NULL, s, -1, &rc, DT_LEFT|DT_NOCLIP, col);
}

const char* phys_name(unsigned char p){
    static const char *n[]={"None","Walking","Falling","Swimming","Flying","Rotating",
        "Projectile","Interp","Spider","Ladder","RigidBody","SoftBody","NavMesh","Unused","Custom"};
    return p<15?n[p]:"?";
}

typedef struct { float x,y,z,rhw; D3DCOLOR c; } LVERT;
#define LFVF (D3DFVF_XYZRHW|D3DFVF_DIFFUSE)
#define MAXLV 8192
static LVERT g_lv[MAXLV];
static int g_nlv=0;
static void line2(float x0,float y0,float x1,float y1,D3DCOLOR col){
    if(g_nlv+2>MAXLV) return;
    g_lv[g_nlv].x=x0; g_lv[g_nlv].y=y0; g_lv[g_nlv].z=0; g_lv[g_nlv].rhw=1; g_lv[g_nlv].c=col; g_nlv++;
    g_lv[g_nlv].x=x1; g_lv[g_nlv].y=y1; g_lv[g_nlv].z=0; g_lv[g_nlv].rhw=1; g_lv[g_nlv].c=col; g_nlv++;
}
static void flush_lines(IDirect3DDevice9 *dev){
    if(g_nlv<2){ g_nlv=0; return; }
    IDirect3DDevice9_SetTexture(dev,0,NULL);
    IDirect3DDevice9_SetVertexShader(dev,NULL);
    IDirect3DDevice9_SetPixelShader(dev,NULL);
    IDirect3DDevice9_SetFVF(dev,LFVF);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ZENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_LIGHTING,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_CULLMODE,D3DCULL_NONE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_FOGENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ALPHABLENDENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_STENCILENABLE,FALSE);
    IDirect3DDevice9_DrawPrimitiveUP(dev,D3DPT_LINELIST,g_nlv/2,g_lv,sizeof(LVERT));
    g_nlv=0;
}

#define MAXTV 8192
static LVERT g_tv[MAXTV];
static int g_ntv=0;
static int proj_pt(float *P, float *sx, float *sy){
    double cr,cu,cd; cam_xform(P,&cr,&cu,&cd);
    if(cd<14.0) return 0;
    return cam_screen(cr,cu,cd,sx,sy);
}
static void tri(float *A,float *B,float *C,D3DCOLOR col){
    float ax,ay,bx,by,cx,cy;
    if(!proj_pt(A,&ax,&ay)||!proj_pt(B,&bx,&by)||!proj_pt(C,&cx,&cy)) return;
    if(g_ntv+3>MAXTV) return;
    g_tv[g_ntv].x=ax;g_tv[g_ntv].y=ay;g_tv[g_ntv].z=0;g_tv[g_ntv].rhw=1;g_tv[g_ntv].c=col;g_ntv++;
    g_tv[g_ntv].x=bx;g_tv[g_ntv].y=by;g_tv[g_ntv].z=0;g_tv[g_ntv].rhw=1;g_tv[g_ntv].c=col;g_ntv++;
    g_tv[g_ntv].x=cx;g_tv[g_ntv].y=cy;g_tv[g_ntv].z=0;g_tv[g_ntv].rhw=1;g_tv[g_ntv].c=col;g_ntv++;
}
static void quad(float *a,float *b,float *c,float *d,D3DCOLOR col){ tri(a,b,c,col); tri(a,c,d,col); }
static void draw_fill_box(float cx,float cy,float cz,float ex,float ey,float ez,D3DCOLOR col){
    float c[8][3]; float ox[2]={-ex,ex}, oy[2]={-ey,ey}, oz[2]={-ez,ez}; int k=0;
    for(int zi=0;zi<2;zi++)for(int yi=0;yi<2;yi++)for(int xi=0;xi<2;xi++){ c[k][0]=cx+ox[xi];c[k][1]=cy+oy[yi];c[k][2]=cz+oz[zi];k++; }
    quad(c[0],c[1],c[3],c[2],col);
    quad(c[4],c[5],c[7],c[6],col);
    quad(c[0],c[1],c[5],c[4],col);
    quad(c[2],c[3],c[7],c[6],col);
    quad(c[0],c[2],c[6],c[4],col);
    quad(c[1],c[3],c[7],c[5],col);
}
static void flush_tris(IDirect3DDevice9 *dev){
    if(g_ntv<3){ g_ntv=0; return; }
    IDirect3DDevice9_SetTexture(dev,0,NULL);
    IDirect3DDevice9_SetVertexShader(dev,NULL);
    IDirect3DDevice9_SetPixelShader(dev,NULL);
    IDirect3DDevice9_SetFVF(dev,LFVF);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ZENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_LIGHTING,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_CULLMODE,D3DCULL_NONE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_FOGENABLE,FALSE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_ALPHABLENDENABLE,TRUE);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_SRCBLEND,D3DBLEND_SRCALPHA);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA);
    IDirect3DDevice9_SetRenderState(dev,D3DRS_BLENDOP,D3DBLENDOP_ADD);
    IDirect3DDevice9_DrawPrimitiveUP(dev,D3DPT_TRIANGLELIST,g_ntv/3,g_tv,sizeof(LVERT));
    g_ntv=0;
}
static void world_line(float *A, float *B, D3DCOLOR col){
    double ar,au,ad, br,bu,bd;
    cam_xform(A,&ar,&au,&ad); cam_xform(B,&br,&bu,&bd);
    const double ZN=12.0;
    if(ad<ZN && bd<ZN) return;
    if(ad<ZN){ double t=(ZN-ad)/(bd-ad); ar+=(br-ar)*t; au+=(bu-au)*t; ad=ZN; }
    else if(bd<ZN){ double t=(ZN-bd)/(ad-bd); br+=(ar-br)*t; bu+=(au-bu)*t; bd=ZN; }
    float sx0,sy0,sx1,sy1;
    cam_screen(ar,au,ad,&sx0,&sy0); cam_screen(br,bu,bd,&sx1,&sy1);
    line2(sx0,sy0,sx1,sy1,col);
}
static void draw_box(float cx,float cy,float cz,float ex,float ey,float ez,D3DCOLOR col){
    float ox[4]={-ex,ex,ex,-ex}, oy[4]={-ey,-ey,ey,ey};
    float c[8][3];
    for(int i=0;i<4;i++){
        c[i][0]=cx+ox[i]; c[i][1]=cy+oy[i]; c[i][2]=cz-ez;
        c[i+4][0]=cx+ox[i]; c[i+4][1]=cy+oy[i]; c[i+4][2]=cz+ez;
    }
    for(int i=0;i<4;i++){ int j=(i+1)&3;
        world_line(c[i],c[j],col);
        world_line(c[i+4],c[j+4],col);
        world_line(c[i],c[i+4],col);
    }
}

#define MAXHB 128
static struct { float cx,cy,cz,ex,ey,ez; int kind; int hp; char name[40]; } g_hb[MAXHB];
static int g_hbN=0;
int g_fEnemy=1, g_fTrigger=1, g_fPickup=1, g_fNode=1, g_fWall=1, g_fOther=1, g_labels=1;
int hb_classify(const char *cn, const char *on){
    if((cn&&contains(cn,"Blocking"))||(on&&contains(on,"Blocking"))) return 5;
    if((cn&&contains(cn,"Pickup"))||(on&&contains(on,"Pickup"))) return 3;
    if(cn&&contains(cn,"Trigger")) return 2;
    if(cn&&contains(cn,"Pawn")) return 1;
    if((cn&&contains(cn,"Node"))||(on&&contains(on,"Path"))||(on&&contains(on,"Node"))) return 4;
    return 0;
}
static int hb_enabled(int k){
    return (k==1&&g_fEnemy)||(k==2&&g_fTrigger)||(k==3&&g_fPickup)||(k==4&&g_fNode)||(k==5&&g_fWall)||(k==0&&g_fOther);
}
static void scan_hitboxes(float *pl){
    if(!g_gobjects || OFF_COLLCOMP<0 || OFF_BOUNDS<0){ g_hbN=0; return; }
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    float d=g_hbDist;
    int n=0;
    for(int i=0;i<cnt && n<MAXHB;i++){
        void *o=data[i];
        if(!mem_ok(o,0x70)) continue;
        float *L=(float*)((char*)o+A_LOC);
        float dx=L[0]-pl[0],dy=L[1]-pl[1],dz=L[2]-pl[2];
        if(dx<-d||dx>d||dy<-d||dy>d||dz<-d||dz>d||!(dx||dy||dz)) continue;
        void *cc=*(void**)((char*)o+OFF_COLLCOMP);
        if(!mem_ok(cc,OFF_BOUNDS+28)) continue;
        float *bo=(float*)((char*)cc+OFF_BOUNDS);
        float *be=(float*)((char*)cc+OFF_BOUNDS+12);
        if(be[0]<=0||be[1]<=0||be[2]<=0||be[0]>22000||be[1]>22000||be[2]>22000) continue;
        int kind=hb_classify(obj_class_name(o), obj_name(o));
        if(!hb_enabled(kind)) continue;
        if(kind==5){ float wd=g_hbDist*0.35f; if(wd>3500.0f) wd=3500.0f;
            if(dx<-wd||dx>wd||dy<-wd||dy>wd||dz<-wd||dz>wd) continue; }
        g_hb[n].cx=bo[0];g_hb[n].cy=bo[1];g_hb[n].cz=bo[2];
        g_hb[n].ex=be[0];g_hb[n].ey=be[1];g_hb[n].ez=be[2];g_hb[n].kind=kind;
        g_hb[n].hp = (kind==1 && OFF_HEALTH>0 && mem_ok((char*)o+OFF_HEALTH,4)) ? *(int*)((char*)o+OFF_HEALTH) : -1;
        lstrcpynA(g_hb[n].name, obj_name(o), sizeof g_hb[n].name);
        n++;
    }
    g_hbN=n;
}

static D3DCOLOR kind_color(int k){
    switch(k){
        case 1: return D3DCOLOR_XRGB(255,70,70);
        case 2: return D3DCOLOR_XRGB(90,220,255);
        case 3: return D3DCOLOR_XRGB(80,255,90);
        case 4: return D3DCOLOR_XRGB(255,170,60);
        case 5: return D3DCOLOR_XRGB(230,90,255);
        default:return D3DCOLOR_XRGB(195,195,195);
    }
}
void render_hitboxes(IDirect3DDevice9 *dev, void *pawn, float *L){
    if(!g_showHB){ g_hbN=0; return; }
    calibrate_camera(g_pc, L);
    D3DVIEWPORT9 vp; IDirect3DDevice9_GetViewport(dev,&vp);
    int W=vp.Width, H=vp.Height;
    void *cam=mem_ok(g_pc,PC_CAMERA+4)?*(void**)((char*)g_pc+PC_CAMERA):NULL;
    view_setup(cam,W,H);
    if(!(g_view.ok && g_stable>=120)){ flush_lines(dev); return; }

    static int tick=0; if(++tick>=10){ tick=0; scan_hitboxes(L); }
    for(int i=0;i<g_hbN;i++){
        if(g_hb[i].kind==5){
            draw_fill_box(g_hb[i].cx,g_hb[i].cy,g_hb[i].cz,g_hb[i].ex,g_hb[i].ey,g_hb[i].ez,D3DCOLOR_ARGB(60,255,80,210));
            draw_box(g_hb[i].cx,g_hb[i].cy,g_hb[i].cz,g_hb[i].ex,g_hb[i].ey,g_hb[i].ez,D3DCOLOR_ARGB(150,255,120,230));
        } else {
            draw_box(g_hb[i].cx,g_hb[i].cy,g_hb[i].cz,g_hb[i].ex,g_hb[i].ey,g_hb[i].ez,kind_color(g_hb[i].kind));
        }
    }
    float pr=40,ph=44; void *pcc=(OFF_COLLCOMP>0)?*(void**)((char*)pawn+OFF_COLLCOMP):NULL;
    if(mem_ok(pcc,CYL_R+4)){ float rr=*(float*)((char*)pcc+CYL_R),hh=*(float*)((char*)pcc+CYL_H); if(rr>0&&rr<1200){pr=rr;ph=hh;} }
    draw_box(L[0],L[1],L[2],pr,pr,ph,D3DCOLOR_XRGB(255,255,0));
    flush_tris(dev);
    flush_lines(dev);

    if(g_labels) for(int i=0;i<g_hbN;i++){
        float top[3]={g_hb[i].cx,g_hb[i].cy,g_hb[i].cz+g_hb[i].ez};
        double cr,cu,cd; cam_xform(top,&cr,&cu,&cd);
        float sx,sy;
        if(cam_screen(cr,cu,cd,&sx,&sy) && sx>-40 && sx<W && sy>-10 && sy<H){
            char lbl[64];
            if(g_hb[i].hp>=0) wsprintfA(lbl,"%s  HP:%d",g_hb[i].name,g_hb[i].hp);
            else lstrcpynA(lbl,g_hb[i].name,sizeof lbl);
            draw_text(dev,(int)sx-10,(int)sy-20,kind_color(g_hb[i].kind),lbl);
        }
    }
}
