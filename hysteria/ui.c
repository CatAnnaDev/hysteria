#include "hysteria.h"

#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#define NK_IMPLEMENTATION
#define NK_D3D9_IMPLEMENTATION
#include "nuklear.h"
#include "nuklear_d3d9.h"

int g_uiVisible=0;
static struct nk_context *g_nk;
static int g_uiInit=0;
static WNDPROC g_origWndProc;
static HWND g_uiHwnd;
static struct nk_font_atlas *g_atlas;

static LRESULT CALLBACK ui_wndproc(HWND h, UINT m, WPARAM w, LPARAM l){
    if(g_uiVisible && g_nk) nk_d3d9_handle_event(h,m,w,l);
    return CallWindowProcA(g_origWndProc,h,m,w,l);
}

void ui_init(IDirect3DDevice9 *dev, int W, int H){
    if(g_uiInit) return;
    g_uiInit=1;
    g_nk=nk_d3d9_init(dev,W,H);
    nk_d3d9_font_stash_begin(&g_atlas);
    nk_d3d9_font_stash_end();
    if(g_atlas) nk_style_load_all_cursors(g_nk,g_atlas->cursors);
    nk_input_begin(g_nk);
    D3DDEVICE_CREATION_PARAMETERS cp;
    if(IDirect3DDevice9_GetCreationParameters(dev,&cp)==D3D_OK && cp.hFocusWindow){
        g_uiHwnd=cp.hFocusWindow;
        g_origWndProc=(WNDPROC)(LONG_PTR)SetWindowLongPtrA(g_uiHwnd,GWLP_WNDPROC,(LONG_PTR)ui_wndproc);
    }
    ui_install_api();
    logmsg("[hysteria] ui init nk=%p hwnd=%p\r\n", g_nk, g_uiHwnd);
}

typedef struct { char title[48]; void(*draw)(void); } ModPanel;
static ModPanel g_panels[32]; static int g_panelN=0;
void ui_panels_clear(void){ g_panelN=0; }

static void ui_panel_impl(const char *title, void(*draw)(void)){
    if(g_panelN<32 && title && draw){ lstrcpynA(g_panels[g_panelN].title,title,sizeof g_panels[g_panelN].title); g_panels[g_panelN].draw=draw; g_panelN++; }
}
static int  ui_button_impl(const char *l){ nk_layout_row_dynamic(g_nk,26,1); return nk_button_label(g_nk,l?l:""); }
static void ui_checkbox_impl(const char *l,int *v){ nk_layout_row_dynamic(g_nk,22,1); nk_checkbox_label(g_nk,l?l:"",v); }
static void ui_slideri_impl(const char *l,int *v,int mn,int mx){ nk_layout_row_dynamic(g_nk,24,1); nk_property_int(g_nk,l?l:"",mn,v,mx,1,1); }
static void ui_sliderf_impl(const char *l,float *v,float mn,float mx,float st){ nk_layout_row_dynamic(g_nk,24,1); nk_property_float(g_nk,l?l:"",mn,v,mx,st,st); }
static void ui_label_impl(const char *t){ nk_layout_row_dynamic(g_nk,18,1); nk_label(g_nk,t?t:"",NK_TEXT_LEFT); }

void ui_install_api(void){
    HysteriaAPI *a=hysteria_api_get(); if(!a) return;
    a->ui_panel=ui_panel_impl; a->ui_button=ui_button_impl; a->ui_checkbox=ui_checkbox_impl;
    a->ui_slider_int=ui_slideri_impl; a->ui_slider_float=ui_sliderf_impl; a->ui_label=ui_label_impl;
}
void ui_mods_render(void){
    for(int i=0;i<g_panelN;i++){
        if(g_panels[i].draw && nk_tree_push_id(g_nk,NK_TREE_TAB,g_panels[i].title,NK_MINIMIZED,5000+i)){
            g_panels[i].draw();
            nk_tree_pop(g_nk);
        }
    }
}

void ui_render(IDirect3DDevice9 *dev, int W, int H){
    (void)dev; (void)W; (void)H;
    if(!g_uiInit || !g_nk || !g_uiVisible) return;
    nk_input_end(g_nk);
    if(nk_begin(g_nk,"HYSTERIA MODDING TOOLS", nk_rect(30,30,330,560),
        NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_TITLE|NK_WINDOW_SCALABLE|NK_WINDOW_MINIMIZABLE)){

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Freecam",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,22,1);
            nk_checkbox_label(g_nk,"Freecam",&g_freecam);
            nk_label(g_nk,"WASD move, arrows look, Spc/Ctrl up/dn, Shift x4",NK_TEXT_LEFT);
            nk_layout_row_dynamic(g_nk,26,1);
            nk_property_float(g_nk,"Freecam speed",500,&g_fcSpeed,20000,500,50);
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Visuals",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,22,2);
            nk_checkbox_label(g_nk,"Hitboxes (F3)",&g_showHB);
            nk_checkbox_label(g_nk,"Labels",&g_labels);
            nk_checkbox_label(g_nk,"Enemies",&g_fEnemy);
            nk_checkbox_label(g_nk,"Triggers",&g_fTrigger);
            nk_checkbox_label(g_nk,"Pickups",&g_fPickup);
            nk_checkbox_label(g_nk,"Nodes",&g_fNode);
            nk_checkbox_label(g_nk,"Walls",&g_fWall);
            nk_checkbox_label(g_nk,"Other",&g_fOther);
            nk_layout_row_dynamic(g_nk,26,1);
            nk_property_float(g_nk,"Distance",1000,&g_hbDist,20000,500,50);
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Actors",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,18,1);
            nk_labelf(g_nk,NK_TEXT_LEFT,"%d nearby (click = TP)",g_actorN);
            nk_layout_row_dynamic(g_nk,220,1);
            if(nk_group_begin(g_nk,"actlist",NK_WINDOW_BORDER)){
                nk_layout_row_dynamic(g_nk,20,1);
                static const char tags[6]={'.','E','T','P','N'};
                for(int i=0;i<g_actorN;i++){
                    int k=g_actors[i].kind;
                    char t = (k==5)?'W':(k>=0&&k<5)?tags[k]:'.';
                    char row[96];
                    wsprintfA(row,"[%c] %-22s d:%d",t,g_actors[i].name,g_actors[i].dist/100);
                    if(nk_button_label(g_nk,row)){ g_tpX=g_actors[i].x; g_tpY=g_actors[i].y; g_tpZ=g_actors[i].z; g_uiGoReq=1; }
                }
                nk_group_end(g_nk);
            }
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Enemies",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,24,1);
            if(nk_button_label(g_nk,"Kill nearby enemies")) g_killEnemiesReq=1;
            nk_checkbox_label(g_nk,"Freeze enemies",&g_freezeEnemies);
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Modding (exp)",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,18,1);
            nk_labelf(g_nk,NK_TEXT_LEFT,"ProcessEvent: %s",g_modFound?"HOOKED":(g_modFind?"searching...":"off"));
            nk_layout_row_dynamic(g_nk,22,1);
            nk_checkbox_label(g_nk,"Find + hook ProcessEvent",&g_modFind);
            nk_checkbox_label(g_nk,"Log player events -> C:\\hysteria_events.log",&g_modLog);
            nk_label(g_nk,"events = fonctions appelees sur PC + pawn",NK_TEXT_LEFT);
            nk_layout_row_dynamic(g_nk,22,1);
            nk_checkbox_label(g_nk,"Live log console (in-game)",&g_consoleVisible);
            nk_layout_row_dynamic(g_nk,24,1);
            if(nk_button_label(g_nk,"Reload mods (Mods/*.dll)")) g_modReloadReq=1;
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Live Editor",NK_MINIMIZED)){
            static char filter[64]; static int flen=0;
            static void *objs[256]; static int objN=0;
            static void *sel=NULL;
            static AEditProp props[256]; static int propN=0;
            nk_layout_row_dynamic(g_nk,24,1);
            nk_edit_string(g_nk,NK_EDIT_SIMPLE,filter,&flen,63,nk_filter_default); filter[flen]=0;
            nk_layout_row_dynamic(g_nk,24,2);
            if(nk_button_label(g_nk,"Search")){ objN=editor_list(filter,objs,256); sel=NULL; propN=0; }
            if(nk_button_label(g_nk,"Player")){ objs[0]=g_pc; objs[1]=g_modPawn; objN=(g_modPawn?2:1); sel=NULL; propN=0; }
            nk_layout_row_dynamic(g_nk,16,1);
            nk_labelf(g_nk,NK_TEXT_LEFT,"%d objects (click to inspect)",objN);
            nk_layout_row_dynamic(g_nk,130,1);
            if(nk_group_begin(g_nk,"ed_objs",NK_WINDOW_BORDER)){
                nk_layout_row_dynamic(g_nk,18,1);
                for(int i=0;i<objN;i++){ if(!objs[i])continue;
                    char row[100]; wsprintfA(row,"%s : %s",obj_class_name(objs[i]),obj_name(objs[i]));
                    if(nk_button_label(g_nk,row)){ sel=objs[i]; propN=editor_props(sel,props,256); }
                }
                nk_group_end(g_nk);
            }
            if(sel){
                nk_layout_row_dynamic(g_nk,16,1);
                nk_labelf(g_nk,NK_TEXT_LEFT,"%s  (%d props)",obj_name(sel),propN);
                nk_layout_row_dynamic(g_nk,260,1);
                if(nk_group_begin(g_nk,"ed_props",NK_WINDOW_BORDER)){
                    for(int i=0;i<propN;i++){ AEditProp*p=&props[i];
                        void *a=(char*)sel+p->off;
                        if(!mem_ok(a,4)){ continue; }
                        nk_layout_row_dynamic(g_nk,22,1);
                        if(p->typ=='i'){ int v=*(int*)a; nk_property_int(g_nk,p->name,-2000000000,&v,2000000000,1,1); *(int*)a=v; }
                        else if(p->typ=='f'){ float v=*(float*)a; nk_property_float(g_nk,p->name,-1e9f,&v,1e9f,0.5f,0.05f); *(float*)a=v; }
                        else if(p->typ=='y'){ int v=*(unsigned char*)a; nk_property_int(g_nk,p->name,0,&v,255,1,1); *(unsigned char*)a=(unsigned char)v; }
                        else if(p->typ=='b'&&p->mask){ int v=(*(unsigned*)a&p->mask)?1:0,o=v; nk_checkbox_label(g_nk,p->name,&v); if(v!=o){ if(v)*(unsigned*)a|=p->mask; else *(unsigned*)a&=~p->mask; } }
                        else nk_labelf(g_nk,NK_TEXT_LEFT,"%s  [%c] +0x%x",p->name,p->typ,p->off);
                    }
                    nk_group_end(g_nk);
                }
            }
            nk_tree_pop(g_nk);
        }

        if(nk_tree_push(g_nk,NK_TREE_TAB,"Info",NK_MINIMIZED)){
            nk_layout_row_dynamic(g_nk,18,1);
            nk_labelf(g_nk,NK_TEXT_LEFT,"Map: %s",g_uiMap);
            nk_labelf(g_nk,NK_TEXT_LEFT,"Pos: %d %d %d",(int)g_uiPos[0],(int)g_uiPos[1],(int)g_uiPos[2]);
            nk_labelf(g_nk,NK_TEXT_LEFT,"Vel: %d %d %d",(int)g_uiVel[0],(int)g_uiVel[1],(int)g_uiVel[2]);
            nk_labelf(g_nk,NK_TEXT_LEFT,"Speed: %d   HP: %d",(int)g_uiSpeed,g_uiHP);
            nk_layout_row_dynamic(g_nk,24,1);
            if(nk_button_label(g_nk,"Dump level (F1)")) g_uiDumpReq=1;
            if(nk_button_label(g_nk,"Dump EVERYTHING (F2)")) g_uiDumpAllReq=1;
            nk_tree_pop(g_nk);
        }

        ui_mods_render();
    }
    nk_end(g_nk);
    nk_d3d9_render(NK_ANTI_ALIASING_ON);
    nk_input_begin(g_nk);
}
