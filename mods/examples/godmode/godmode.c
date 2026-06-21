#include "hysteria_api.h"
#include <windows.h>

static HysteriaAPI *A;

static void on_damage(AEvent *e) {
  if (e->self == A->player_pawn())
    e->block = 1; /* skip TakeDamage on Alice only */
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  api->log("godmode: blocking TakeDamage on player");
  api->on("TakeDamage", on_damage);
}
