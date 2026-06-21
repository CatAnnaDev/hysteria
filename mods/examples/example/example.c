#include "hysteria_api.h"
#include <windows.h>

static HysteriaAPI *A;
static int g_shown;

static void on_tick(AEvent *e) {
  if (g_shown)
    return;
  g_shown = 1;
  A->log("example: PlayerTick intercepted -> dispatch OK");
  AObj pawn = A->player_pawn();
  if (pawn) {
    char b[120];
    int hp = -1, max = -1, hysteria = 0;
    A->get_int(pawn, "Health", &hp);
    A->get_int(pawn, "HealthMax", &max);
    wsprintfA(b, "example: player Health=%d / %d (get_int via super-chain)", hp,
              max);
    A->log(b);
  }
}

static int g_jumps;
static void on_jump(AEvent *e) {
  if (g_jumps < 3) {
    g_jumps++;
    A->log("example: Alice jumped (event from mod DLL)");
  }
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  api->log("example mod loaded, API v"
#define STR(x) #x
#define XSTR(x) STR(x)
           XSTR(HYSTERIA_API_VERSION));
  api->on("PlayerTick", on_tick);
  api->on("DoJump", on_jump);
}
