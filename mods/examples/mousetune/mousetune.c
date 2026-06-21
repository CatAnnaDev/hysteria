#include <windows.h>
#include "hysteria_api.h"

static HysteriaAPI *A;
static int g_smoothOff=1;
static float g_sens=1.0f;

static AObj pinput(void){ AObj pc=A->player_controller(); return pc?A->get_obj(pc,"PlayerInput"):0; }

static void on_tick(AEvent *e){
    if(g_smoothOff){ AObj pi=pinput(); if(pi) A->set_bool(pi,"bEnableMouseSmoothing",0); }
}
static void on_move(AEvent *e){
    if(g_sens>0.99f && g_sens<1.01f) return;
    AObj pi=pinput(); if(!pi) return;
    float t,l;
    if(A->get_float(pi,"aTurn",&t))   A->set_float(pi,"aTurn",t*g_sens);
    if(A->get_float(pi,"aLookUp",&l)) A->set_float(pi,"aLookUp",l*g_sens);
}
static void draw_panel(void){
    A->ui_checkbox("Disable mouse smoothing", &g_smoothOff);
    A->ui_slider_float("Look sensitivity", &g_sens, 0.1f, 5.0f, 0.05f);
    A->ui_label("smoothing off + live sensitivity scale");
}

__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A=api;
    api->log("mousetune: UI panel + live mouse tuning");
    api->on("PlayerTick", on_tick);
    api->on("PlayerMove", on_move);
    api->ui_panel("Mouse", draw_panel);
}
