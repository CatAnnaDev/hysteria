#include "hysteria_api.h"
#include <math.h>
#include <windows.h>

static HysteriaAPI *A;

static int god, fly, noclip, freeze;
static float flySpeed = 3000.0f, jumpPower = 1200.0f, jumpZ = 0.0f,
             groundSpeed = 0.0f, airControl = 0.0f;
static float gameSpeed = 1.0f, gravity = 0.0f, fov = 85.0f;
static int fovOn = 0;
static float tpX, tpY, tpZ;
static int saveReq, goReq, healReq, copyReq;
static int slotSave = -1, slotLoad = -1, ssSave = -1, ssLoad = -1;

static float savePos[3];
static int haveSave;
static float slots[3][3];
static int slotHave[3];
static struct {
  float pos[3], vel[3];
  int rot[3], hp;
  int phys;
  int have;
} ss[3];
static int godHP, haveFreezePos;
static float freezePos[3];

static void player_panel(void) {
  A->ui_checkbox("God", &god);
  A->ui_checkbox("Fly", &fly);
  A->ui_checkbox("Noclip", &noclip);
  A->ui_checkbox("Freeze pos", &freeze);
  A->ui_slider_float("Fly speed", &flySpeed, 300, 12000, 100);
  A->ui_slider_float("Jump power", &jumpPower, 200, 8000, 100);
  A->ui_slider_float("JumpZ (0=off)", &jumpZ, 0, 3000, 50);
  A->ui_slider_float("Ground spd (0=off)", &groundSpeed, 0, 4000, 50);
  A->ui_slider_float("Air control (0=off)", &airControl, 0, 2.0f, 0.05f);
  if (A->ui_button("Heal full"))
    healReq = 1;
  A->ui_label("God F7  Fly F8  Noclip F4  Jump F9  Heal F11");
}
static void world_panel(void) {
  A->ui_slider_float("Game speed", &gameSpeed, 0.05f, 3.0f, 0.05f);
  A->ui_slider_float("Gravity (0=off)", &gravity, -3000, 1000, 50);
  A->ui_checkbox("FOV override", &fovOn);
  A->ui_slider_float("FOV", &fov, 30, 150, 1);
}
static void tp_panel(void) {
  if (A->ui_button("Save pos (F5)"))
    saveReq = 1;
  if (A->ui_button("Go to saved (F6)"))
    goReq = 1;
  A->ui_label("Slots");
  if (A->ui_button("Save 1"))
    slotSave = 0;
  if (A->ui_button("Load 1"))
    slotLoad = 0;
  if (A->ui_button("Save 2"))
    slotSave = 1;
  if (A->ui_button("Load 2"))
    slotLoad = 1;
  if (A->ui_button("Save 3"))
    slotSave = 2;
  if (A->ui_button("Load 3"))
    slotLoad = 2;
  A->ui_label("Go to coords");
  A->ui_slider_float("X", &tpX, -500000, 500000, 100);
  A->ui_slider_float("Y", &tpY, -500000, 500000, 100);
  A->ui_slider_float("Z", &tpZ, -500000, 500000, 100);
  if (A->ui_button("Copy current"))
    copyReq = 1;
  if (A->ui_button("Go"))
    goReq = 1;
  A->ui_label("Savestates (pos+vel+rot+hp+phys)");
  if (A->ui_button("Save A"))
    ssSave = 0;
  if (A->ui_button("Load A"))
    ssLoad = 0;
  if (A->ui_button("Save B"))
    ssSave = 1;
  if (A->ui_button("Load B"))
    ssLoad = 1;
  if (A->ui_button("Save C"))
    ssSave = 2;
  if (A->ui_button("Load C"))
    ssLoad = 2;
}

static void apply_movement(AObj pawn, AObj pc) {
  if (freeze || (!fly && !noclip))
    return;
  A->set_byte(pawn, "Physics", 4);
  int rot[3];
  if (!A->get_rot(pc, "Rotation", rot))
    return;
  double yaw = rot[1] * (3.14159265358979 / 32768.0);
  double fx = cos(yaw), fy = sin(yaw), rx = sin(yaw), ry = -cos(yaw);
  double mx = 0, my = 0, mz = 0;
  if (A->key_down('W')) {
    mx += fx;
    my += fy;
  }
  if (A->key_down('S')) {
    mx -= fx;
    my -= fy;
  }
  if (A->key_down('A')) {
    mx += rx;
    my += ry;
  }
  if (A->key_down('D')) {
    mx -= rx;
    my -= ry;
  }
  if (A->key_down(VK_SPACE))
    mz += 1;
  if (A->key_down(VK_CONTROL))
    mz -= 1;
  double len = sqrt(mx * mx + my * my + mz * mz);
  float v[3] = {0, 0, 0};
  if (len > 0.01) {
    v[0] = (float)(mx / len * flySpeed);
    v[1] = (float)(my / len * flySpeed);
    v[2] = (float)(mz / len * flySpeed);
  }
  A->set_vec(pawn, "Velocity", v);
}

static void tick(void) {
  AObj pawn = A->player_pawn(), pc = A->player_controller();
  if (!pawn || !pc)
    return;

  if (A->key_pressed(VK_F7))
    god = !god;
  if (A->key_pressed(VK_F8))
    fly = !fly;
  if (A->key_pressed(VK_F4))
    noclip = !noclip;
  if (A->key_pressed(VK_F11))
    healReq = 1;

  static int pf = 0, pn = 0, pg = 0, pfr = 0;
  if (god && !pg)
    A->get_int(pawn, "Health", &godHP);
  if (freeze && !pfr) {
    A->get_vec(pawn, "Location", freezePos);
    haveFreezePos = 1;
  }
  if (!fly && pf && !noclip) {
    A->set_byte(pawn, "Physics", 2);
    float z[3] = {0, 0, 0};
    A->set_vec(pawn, "Velocity", z);
  }
  if (!noclip && pn) {
    A->set_bool(pawn, "bCollideWorld", 1);
  }
  pg = god;
  pf = fly;
  pn = noclip;
  pfr = freeze;

  if (god) {
    A->set_int(pawn, "Health", godHP);
  }
  if (healReq) {
    healReq = 0;
    int mx = 0;
    if (!A->get_int(pawn, "HealthMax", &mx) || mx <= 0)
      mx = 999;
    A->set_int(pawn, "Health", mx);
  }
  if (noclip)
    A->set_bool(pawn, "bCollideWorld", 0);

  if (jumpZ > 1.0f)
    A->set_float(pawn, "JumpZ", jumpZ);
  if (groundSpeed > 1.0f)
    A->set_float(pawn, "GroundSpeed", groundSpeed);
  if (airControl > 0.001f)
    A->set_float(pawn, "AirControl", airControl);

  if (A->key_pressed(VK_F9)) {
    float v[3];
    if (A->get_vec(pawn, "Velocity", v)) {
      v[2] = jumpPower;
      A->set_vec(pawn, "Velocity", v);
    }
  }

  if (freeze && haveFreezePos) {
    A->set_vec(pawn, "Location", freezePos);
    float z[3] = {0, 0, 0};
    A->set_vec(pawn, "Velocity", z);
  }
  apply_movement(pawn, pc);

  if (A->key_pressed(VK_F5))
    saveReq = 1;
  if (A->key_pressed(VK_F6))
    goReq = 1;
  if (saveReq) {
    saveReq = 0;
    A->get_vec(pawn, "Location", savePos);
    haveSave = 1;
  }
  if (copyReq) {
    copyReq = 0;
    float L[3];
    if (A->get_vec(pawn, "Location", L)) {
      tpX = L[0];
      tpY = L[1];
      tpZ = L[2];
    }
  }
  if (goReq) {
    goReq = 0;
    float L[3];
    if (haveSave) {
      L[0] = savePos[0];
      L[1] = savePos[1];
      L[2] = savePos[2];
    } else {
      L[0] = tpX;
      L[1] = tpY;
      L[2] = tpZ;
    }
    A->set_vec(pawn, "Location", L);
    float z[3] = {0, 0, 0};
    A->set_vec(pawn, "Velocity", z);
  }

  if (slotSave >= 0) {
    int s = slotSave;
    slotSave = -1;
    A->get_vec(pawn, "Location", slots[s]);
    slotHave[s] = 1;
  }
  if (slotLoad >= 0) {
    int s = slotLoad;
    slotLoad = -1;
    if (slotHave[s]) {
      A->set_vec(pawn, "Location", slots[s]);
      float z[3] = {0, 0, 0};
      A->set_vec(pawn, "Velocity", z);
    }
  }

  if (ssSave >= 0) {
    int s = ssSave;
    ssSave = -1;
    A->get_vec(pawn, "Location", ss[s].pos);
    A->get_vec(pawn, "Velocity", ss[s].vel);
    A->get_rot(pc, "Rotation", ss[s].rot);
    A->get_int(pawn, "Health", &ss[s].hp);
    A->get_byte(pawn, "Physics", &ss[s].phys);
    ss[s].have = 1;
  }
  if (ssLoad >= 0) {
    int s = ssLoad;
    ssLoad = -1;
    if (ss[s].have) {
      A->set_vec(pawn, "Location", ss[s].pos);
      A->set_vec(pawn, "Velocity", ss[s].vel);
      A->set_rot(pc, "Rotation", ss[s].rot);
      A->set_int(pawn, "Health", ss[s].hp);
      A->set_byte(pawn, "Physics", ss[s].phys);
    }
  }

  AObj wi = A->world_info();
  if (wi) {
    if (gameSpeed < 0.05f)
      gameSpeed = 0.05f;
    if (gameSpeed > 1.001f || gameSpeed < 0.999f)
      A->set_float(wi, "TimeDilation", gameSpeed);
    if (gravity < -0.5f || gravity > 0.5f)
      A->set_float(wi, "WorldGravityZ", gravity);
  }
  if (fovOn)
    A->write_raw(pc, 0x400, &fov, 4);
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  A->log("trainer mod loaded");
  A->ui_panel("Player", player_panel);
  A->ui_panel("World", world_panel);
  A->ui_panel("Teleport", tp_panel);
  A->on_tick(tick);
}
