#ifndef HYSTERIA_H
#define HYSTERIA_H

#include <windows.h>
#define CINTERFACE
#define COBJMACROS
#include <d3d9.h>
#include <d3dx9.h>
#include <math.h>

extern int g_oOuter, g_oName, g_oClass;
#define O_OUTER   g_oOuter
#define O_NAME    g_oName
#define O_CLASS   g_oClass
void probe_engine_offsets(void);
void scan_gobjects(void);
void dump_name_layout(const char *s);
#define C_PAWN    0x22C
#define A_LOC     0x64
#define CYL_H     0x1d4
#define CYL_R     0x1d8
#define PC_CAMERA 0x3c8
#define PC_FOV    0x400

typedef HRESULT (WINAPI *EndScene_t)(IDirect3DDevice9*);
typedef HRESULT (WINAPI *Reset_t)(IDirect3DDevice9*, D3DPRESENT_PARAMETERS*);

void logmsg(const char *fmt, ...);

extern unsigned int g_gnames, g_gobjects;
extern int g_nameOff;
extern void *g_pc;
extern void *g_worldInfo;
void find_worldinfo(void);
int find_name(const char *s);
void mem_ok_reset(void);
int  mem_ok(const void *p, int n);
int  contains(const char *h, const char *n);
void scan_gnames(void);
const char* uname(int id);
const char* obj_name(void *o);
const char* obj_class_name(void *o);
void* outermost(void *o);
void find_pc(void);

extern int M_POFF, g_propCal, g_calTries;
extern int OFF_VEL, OFF_PHYS, OFF_HEALTH, OFF_JUMPZ, OFF_ACCEL, OFF_COLLCOMP;
extern int OFF_HEALTHMAX, OFF_TD, OFF_BOUNDS;
extern int OFF_GROUNDSPEED, OFF_AIRCONTROL, OFF_GRAVITY, OFF_CAMSTYLE, OFF_CUSTOMTD;
extern int OFF_XPVALUE, OFF_WEAPONLEVEL, OFF_UPGRADEHEALTH, OFF_MEMCOMPLETED;
extern int g_uiXP, g_uiWeaponLvl, g_uiUpgHealth, g_uiMemDone;
extern int g_uiAddXP, g_uiSetWeaponLvl;
extern int OFF_BCOLLWORLD, OFF_BDELETEME, M_BITMASK;
extern unsigned MASK_COLLWORLD, MASK_BDELETEME;
int resolve_bool(const char *name, const char *cls, unsigned *mask);
int  is_property(void *o);
void* find_prop(const char *name, const char *declClass);
int  prop_off(const char *name, const char *declClass);
void calibrate_props(void);

int hb_classify(const char *cn, const char *on);
void obj_full_name(void *o, char *out, int cap);

extern int g_modFind, g_modLog, g_modFound, g_modReloadReq;
extern void *g_modPawn;
void mod_tick(void);
void mod_run_ticks(void);

extern long g_mouseDX, g_mouseDY;
extern int g_mouseCapture, g_mouseSuppress;

extern int g_consoleVisible;
void console_push(const char *s);
void console_render(IDirect3DDevice9 *dev);

typedef struct { char name[48]; int off; char typ; unsigned mask; } AEditProp;
int editor_list(const char *filter, void **out, int max);
int editor_props(void *obj, AEditProp *out, int max);

#include "hysteria_api.h"
HysteriaAPI* hysteria_api_get(void);
void ui_panels_clear(void);
void ui_install_api(void);
void ui_mods_render(void);

extern int g_aliceCal;
extern int g_alUnlockAll, g_alHystAnytime, g_alForceHyst, g_alHystGod;
extern int g_alInfRegen, g_alShrinkSense, g_alFillEndurance;
extern float g_alDmgBonus;
void alice_calibrate(void);
void alice_tick(void *pawn, void *pc);

typedef struct { char name[40]; int kind; float x,y,z; int dist; } ActInfo;
extern ActInfo g_actors[];
extern int g_actorN;
void scan_actors(float *pl);

extern int g_freezeEnemies, g_killEnemiesReq;
void enemies_tick(float *pl, void *playerPawn);

extern int g_camLocOff;
extern float g_fov;
void calibrate_camera(void *pc, float *pl);
int  project(void *cam, float *P, int W, int H, float *sx, float *sy);

typedef struct { double cx,cy,cz, fx,fy,fz, rx,ry,rz, ux,uy,uz, tanH,aspect; int W,H,ok; } ViewProj;
extern ViewProj g_view;
void view_setup(void *cam, int W, int H);
void cam_xform(float *P, double *cr, double *cu, double *cd);
int  cam_screen(double cr, double cu, double cd, float *sx, float *sy);

extern LPD3DXFONT g_font;
extern LPD3DXLINE g_line;
void ensure_gfx(IDirect3DDevice9 *dev);
void ensure_line(IDirect3DDevice9 *dev);
void draw_text(IDirect3DDevice9 *dev, int x, int y, D3DCOLOR col, const char *s);
const char* phys_name(unsigned char p);
void render_hitboxes(IDirect3DDevice9 *dev, void *pawn, float *L);

int  key_edge(int vk);
void cheats_update(IDirect3DDevice9 *dev, void *pawn, float *L, float *V, int hp, int pawnFull, int isMenu);
extern int g_god, g_fly, g_noclip, g_godHP, g_showHB, g_stable, g_freeze, g_freecam;
extern float g_savePos[3];
extern int g_haveSave;
extern float g_flySpeed, g_hbDist, g_gameSpeed, g_jumpZ, g_jumpPower, g_fcSpeed;
extern float g_groundSpeed, g_airControl, g_gravity, g_fovVal;
extern int g_fovOverride, g_labels;
extern int g_uiSaveReq, g_uiTpReq, g_uiHealReq, g_uiDumpReq, g_uiGoReq;
extern int g_uiSaveSlot, g_uiLoadSlot;
extern int g_tasPause, g_uiStepReq, g_uiSSsave, g_uiSSload, g_tasStepFrames;
extern float g_tpX, g_tpY, g_tpZ;
extern int g_fEnemy, g_fTrigger, g_fPickup, g_fNode, g_fWall, g_fOther;

extern float g_uiPos[3], g_uiVel[3], g_uiSpeed;
extern int g_uiHP;
extern char g_uiMap[64];

extern int g_uiVisible;
void ui_init(IDirect3DDevice9 *dev, int W, int H);
void ui_render(IDirect3DDevice9 *dev, int W, int H);

extern int g_dumped;
void dump_all(void *pc, void *pawn, const char *map);
extern int g_uiDumpAllReq;
void dump_everything(void);
void dump_everything_async(void);

DWORD WINAPI setup_d3d11_hook(LPVOID a);
extern int g_dxgiActive;
void frame_render(IDirect3DDevice9 *dev);
extern EndScene_t g_origEndScene;
extern Reset_t    g_origReset;

#endif
