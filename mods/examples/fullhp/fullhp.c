#include <windows.h>
#include "hysteria_api.h"

static HysteriaAPI *A;

static void on_tick(AEvent *e){
    AObj p=A->player_pawn();
    if(!p) return;
    int mx, hysteria;
    if(A->get_int(p,"HealthMax",&mx) && mx>0) A->set_int(p,"Health",mx);
    if (A->get_bool(p, "bActivateHysterialAnytime", &hysteria)) A->set_bool(p, "bActivateHysterialAnytime", 1);
}

__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A=api;
    api->log("fullhp: Health pinned to HealthMax each tick");
    api->on("PlayerTick", on_tick);
}
