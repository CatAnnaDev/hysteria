#include <windows.h>
#include "hysteria_api.h"

static HysteriaAPI *A;

static void tick(void){
    if(A->key_pressed(VK_F11)) A->console(A->player_controller(), "God");
    if(A->key_pressed(VK_F12)) A->console(A->player_controller(), "fullhealth");
}

__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A = api;
    api->log("quickcheat: F11=God  F12=full health");
    api->on_tick(tick);
}
