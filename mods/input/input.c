#include "hysteria_api.h"
#include <windows.h>

static HysteriaAPI *A;

static int killAccel = 1;
static int killSmoothing = 1;
static float accelHold = 10.0f;

static void input_panel(void) {
  A->ui_checkbox("Kill mouse acceleration", &killAccel);
  A->ui_checkbox("Kill mouse smoothing", &killSmoothing);
  A->ui_slider_float("Accel hold (10 = flat)", &accelHold, 0.0f, 30.0f, 0.5f);
  A->ui_label("Keeps the native camera. No bypass.");
  A->ui_label("aTurnElapsedTime / aLookUpElapsedTime forced flat.");
}

static void tick(void) {
  AObj pc = A->player_controller();
  if (!pc)
    return;

  if (killAccel) {
    A->set_float(pc, "aTurnElapsedTime", accelHold);
    A->set_float(pc, "aLookUpElapsedTime", accelHold);
  }

  if (killSmoothing) {
    AObj pin = A->get_obj(pc, "PlayerInput");
    if (pin)
      A->set_bool(pin, "bEnableMouseSmoothing", 0);
  }
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  A->log("input mod loaded (native accel/smoothing kill)");
  A->ui_panel("Input", input_panel);
  A->on_tick(tick);
}
