#include "hysteria_api.h"
#include <windows.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

static HysteriaAPI *A;
static int g_added;
static int g_reqAdd;
static int g_reqSummon;
static int g_reqConsole;
static unsigned g_lastTry;
static int g_pawnCount;

static void emit(const char *fmt, ...) {
  char buf[512];
  va_list ap;
  va_start(ap, fmt);
  vsnprintf(buf, sizeof buf, fmt, ap);
  va_end(ap);
  A->log(buf);
}

static void count_cb(AObj o) {
  const char *n = A->name_of(o);
  if (!n || strncmp(n, "Default__", 9) == 0) return;
  if (strstr(n, "ArcheType") || strstr(n, "Archetype")) return;
  g_pawnCount++;
}

static int alice_pawns(void) {
  g_pawnCount = 0;
  A->iter_objects("AlicePawn", count_cb);
  return g_pawnCount;
}

static AObj cheat_manager(void) {
  AObj pc = A->player_controller();
  return pc ? A->get_obj(pc, "CheatManager") : 0;
}

static void add_cheats(void) {
  AObj pc = A->player_controller();
  AObj cm;
  ACall c;

  if (!pc) return;
  cm = A->get_obj(pc, "CheatManager");
  if (cm) {
    if (!g_added) {
      g_added = 1;
      emit("cheats: CheatManager deja present -> %s", A->class_of(cm));
    }
    return;
  }

  c = A->call_begin(pc, "AddCheats");
  if (!c) {
    A->log("cheats: AddCheats non resolue sur le PlayerController");
    return;
  }
  A->call_invoke(c);

  cm = A->get_obj(pc, "CheatManager");
  if (cm) {
    g_added = 1;
    emit("cheats: AddCheats OK -> CheatManager = %s (%s)", A->name_of(cm),
         A->class_of(cm));
  } else {
    emit("cheats: AddCheats appelee, CheatManager toujours nul (essai %u)",
         GetTickCount() / 1000u);
  }
}

static AObj g_found;
static void find_new_cb(AObj o) {
  const char *n = A->name_of(o);
  if (g_found || !n || strncmp(n, "Default__", 9) == 0) return;
  if (strstr(n, "ArcheType") || strstr(n, "Archetype")) return;
  if (o == A->player_pawn()) return;
  g_found = o;
}

static void describe_new_pawn(void) {
  AObj p, mesh, ctl;
  float loc[3] = {0, 0, 0}, scale = 0.0f;
  int hidden = -1, phys = -1, health = 0;
  char full[256];

  g_found = 0;
  A->iter_objects("AlicePawn", find_new_cb);
  p = g_found;
  if (!p) { A->log("cheats: aucune seconde AlicePawn trouvee"); return; }

  A->full_name(p, full, sizeof full);
  A->get_vec(p, "Location", loc);
  A->get_bool(p, "bHidden", &hidden);
  A->get_byte(p, "Physics", &phys);
  A->get_int(p, "Health", &health);
  A->get_float(p, "DrawScale", &scale);
  mesh = A->get_obj(p, "Mesh");
  ctl = A->get_obj(p, "Controller");

  emit("cheats: SECONDE ALICE %s", full);
  emit("cheats:   position %.0f %.0f %.0f  bHidden=%d Physics=%d Health=%d DrawScale=%.2f",
       loc[0], loc[1], loc[2], hidden, phys, health, scale);
  emit("cheats:   Mesh=%s Controller=%s InvManager=%s",
       mesh ? A->class_of(mesh) : "nul",
       ctl ? A->class_of(ctl) : "nul",
       A->get_obj(p, "InvManager") ? "present" : "nul");
  if (mesh) {
    AObj sk = A->get_obj(mesh, "SkeletalMesh");
    AObj at = A->get_obj(mesh, "AnimTreeTemplate");
    emit("cheats:   SkeletalMesh=%s AnimTree=%s Animations=%s",
         sk ? A->name_of(sk) : "nul", at ? A->name_of(at) : "nul",
         A->get_obj(mesh, "Animations") ? "present" : "nul");
  }
}

static void summon_direct(const char *cls) {
  AObj cm = cheat_manager();
  ACall c;
  int before, after;

  if (!cm) {
    A->log("cheats: pas de CheatManager, Summon impossible");
    return;
  }
  before = alice_pawns();
  c = A->call_begin(cm, "Summon");
  if (!c) {
    A->log("cheats: Summon non resolue sur le CheatManager");
    return;
  }
  A->call_arg_str(c, "ClassName", cls);
  A->call_invoke(c);
  after = alice_pawns();
  emit("cheats: Summon(\"%s\") -> AlicePawn %d->%d  %s", cls, before, after,
       after > before ? "CREE" : "rien");
  if (after > before) describe_new_pawn();
}

static void summon_console(const char *cls) {
  AObj pc = A->player_controller();
  char cmd[160];
  int before, after;

  if (!pc) return;
  before = alice_pawns();
  snprintf(cmd, sizeof cmd, "Summon %s", cls);
  A->console(pc, cmd);
  after = alice_pawns();
  emit("cheats: console \"%s\" -> AlicePawn %d->%d  %s", cmd, before, after,
       after > before ? "CREE" : "rien");
}

static void gamelog_toggle(void) {
  int on;
  if (A->version < 19 || !A->gamelog) {
    A->log("cheats: capture des logs du jeu indisponible (API < 19)");
    return;
  }
  on = A->gamelog_active() ? 0 : 1;
  if (A->gamelog(on))
    emit("cheats: capture des logs du jeu %s", on ? "ACTIVEE" : "coupee");
  else
    A->log("cheats: la capture a refuse de s installer");
}

static void hud_state(void) {
  AObj pc = A->player_controller();
  AObj hud = pc ? A->get_obj(pc, "myHUD") : 0;
  int on = -1, txt = -1;
  if (!hud) { A->log("cheats: myHUD introuvable sur le PlayerController"); return; }
  A->get_bool(hud, "bShowDebugInfo", &on);
  A->get_bool(hud, "bShowDebugText", &txt);
  emit("cheats: HUD=%s bShowDebugInfo=%d bShowDebugText=%d", A->class_of(hud), on, txt);
}

static AObj g_alice2;
static int g_follow;

static AObj second_alice(void) {
  g_found = 0;
  A->iter_objects("AlicePawn", find_new_cb);
  return g_found;
}

static void awaken_gt(void *user) {
  AObj p = second_alice();
  int nc = -1, phys = -1;
  (void)user;
  if (!p) { A->log("cheats: pas de seconde Alice a reveiller"); return; }

  A->set_bool(p, "bRunPhysicsWithNoController", 1);
  A->get_bool(p, "bRunPhysicsWithNoController", &nc);
  if (nc != 1) {
    emit("cheats: bRunPhysicsWithNoController refuse (%d), on reste en PHYS_None", nc);
    A->set_byte(p, "Physics", 0);
    g_alice2 = p;
    g_follow = 2;
    return;
  }

  A->set_bool(p, "bCollideActors", 0);
  A->set_bool(p, "bBlockActors", 0);
  A->set_bool(p, "bHidden", 0);
  A->set_byte(p, "Physics", 1);
  A->get_byte(p, "Physics", &phys);
  g_alice2 = p;
  g_follow = 1;
  emit("cheats: seconde Alice reveillee, bRunPhysicsWithNoController=%d Physics=%d", nc, phys);
}

static void awaken(void) { A->run_on_game_thread(awaken_gt, 0); }

static void follow_gt(void *user) {
  AObj me = A->player_pawn();
  (void)user;
  float mp[3], hp[3], d[3], dist, acc[3];
  int rot[3];

  if (!g_follow || !g_alice2 || !me) return;
  if (!A->get_vec(me, "Location", mp) || !A->get_vec(g_alice2, "Location", hp)) {
    g_follow = 0;
    g_alice2 = 0;
    return;
  }
  d[0] = mp[0] - hp[0];
  d[1] = mp[1] - hp[1];
  d[2] = 0.0f;
  dist = d[0] * d[0] + d[1] * d[1];
  if (dist < 40000.0f) {
    acc[0] = 0.0f; acc[1] = 0.0f; acc[2] = 0.0f;
    A->set_vec(g_alice2, "Acceleration", acc);
    return;
  }
  dist = (float)__builtin_sqrt(dist);
  rot[0] = 0;
  rot[2] = 0;
  rot[1] = (int)(__builtin_atan2(d[1], d[0]) * 32768.0 / 3.14159265);
  A->set_rot(g_alice2, "Rotation", rot);
  if (g_follow == 1) {
    acc[0] = d[0] / dist * 1500.0f;
    acc[1] = d[1] / dist * 1500.0f;
    acc[2] = 0.0f;
    A->set_vec(g_alice2, "Acceleration", acc);
  } else {
    hp[0] += d[0] / dist * 12.0f;
    hp[1] += d[1] / dist * 12.0f;
    A->set_vec(g_alice2, "Location", hp);
  }
}

static void follow_step(void) {
  if (!g_follow || !g_alice2) return;
  A->run_on_game_thread(follow_gt, 0);
}

static const char *const LE_FLAGS[] = {
    "bEnabled", "bDynamic", "bCastShadows", "bSynthesizeSHLight",
    "bSynthesizeDirectionalLight", "bIsCharacterLightEnvironment",
    "bForceCompositeAllLights", "bCompositeShadowsFromDynamicLights"};

static void light_report(const char *who, AObj pawn) {
  AObj le, mesh;
  int i, v;
  char line[256];
  int n = 0;

  if (!pawn) { emit("cheats: %s absent", who); return; }
  le = A->get_obj(pawn, "LightEnvironment");
  mesh = A->get_obj(pawn, "Mesh");
  if (!le) { emit("cheats: %s LightEnvironment=nul", who); }
  else {
    n = snprintf(line, sizeof line, "cheats: %s LE(%s)", who, A->class_of(le));
    for (i = 0; i < 8; i++) {
      v = -1;
      A->get_bool(le, LE_FLAGS[i], &v);
      n += snprintf(line + n, sizeof line - n, " %s=%d", LE_FLAGS[i], v);
      if (n > 200) break;
    }
    A->log(line);
  }
  if (mesh) {
    int a = -1, b = -1, c = -1;
    A->get_bool(mesh, "bAcceptsLights", &a);
    A->get_bool(mesh, "bAcceptsDynamicLights", &b);
    A->get_bool(mesh, "bCastShadow", &c);
    emit("cheats: %s Mesh bAcceptsLights=%d bAcceptsDynamicLights=%d bCastShadow=%d",
         who, a, b, c);
  }
}

static void light_compare(void *user) {
  (void)user;
  A->log("---------- eclairage ----------");
  light_report("Alice locale", A->player_pawn());
  light_report("Alice 2     ", second_alice());
  A->log("-------------------------------");
}

static void light_align(void *user) {
  AObj p = second_alice();
  AObj le = p ? A->get_obj(p, "LightEnvironment") : 0;
  ACall c;
  int v = -1;
  (void)user;

  if (!le) { A->log("cheats: pas d environnement lumineux sur Alice 2"); return; }

  c = A->call_begin(le, "SetEnabled");
  if (!c) {
    A->log("cheats: SetEnabled non resolue, on ne touche a rien");
    return;
  }
  A->call_arg_bool(c, "bNewEnabled", 1);
  A->call_invoke(c);
  A->get_bool(le, "bEnabled", &v);
  emit("cheats: SetEnabled(true) appele -> bEnabled=%d", v);

  c = A->call_begin(p, "ForceUpdateComponents");
  if (c) {
    A->call_arg_bool(c, "bCollisionUpdate", 0);
    A->call_arg_bool(c, "bTransformOnly", 0);
    A->call_invoke(c);
    A->log("cheats: ForceUpdateComponents appele");
  }
  light_report("Alice 2 apres", p);
}

static void light_off(void *user) {
  AObj p = second_alice();
  AObj le = p ? A->get_obj(p, "LightEnvironment") : 0;
  ACall c;
  (void)user;
  if (!le) { A->log("cheats: pas d environnement lumineux"); return; }
  c = A->call_begin(le, "SetEnabled");
  if (!c) { A->log("cheats: SetEnabled non resolue"); return; }
  A->call_arg_bool(c, "bNewEnabled", 0);
  A->call_invoke(c);
  A->log("cheats: environnement lumineux desactive par SetEnabled");
}

static void show_debug(const char *type) {
  AObj pc = A->player_controller();
  AObj hud = pc ? A->get_obj(pc, "myHUD") : 0;
  ACall c;
  int on = -1;

  if (!hud) { A->log("cheats: myHUD introuvable"); return; }
  c = A->call_begin(hud, "ShowDebug");
  if (!c) { A->log("cheats: ShowDebug non resolue sur le HUD"); return; }
  if (A->version >= 15 && A->call_arg_name)
    A->call_arg_name(c, "DebugType", type);
  A->call_invoke(c);
  A->get_bool(hud, "bShowDebugInfo", &on);
  emit("cheats: ShowDebug(%s) -> bShowDebugInfo=%d",
       (type && type[0]) ? type : "None", on);
}

static void show_debug_gt(void *user) { show_debug((const char *)user); }

static AObj g_gameinfo;
static void take_gi(AObj o) {
  const char *n = A->name_of(o);
  if (g_gameinfo || !n || strncmp(n, "Default__", 9) == 0) return;
  g_gameinfo = o;
}

static void spawn_with_archetype(void *user) {
  static const char *const ARCH[] = {"ArcheType_AliceWonderland",
                                     "ArcheType_AliceLondon"};
  AObj me = A->player_pawn();
  AObj cls = A->find_class("AlicePawn");
  AObj gi, tmpl = 0;
  ACall c;
  AObj res;
  float loc[3];
  int rot[3], before, after, i, idv = -1;
  const char *used = "aucun";
  (void)user;

  if (!me || !cls) { A->log("cheats: pawn local ou classe AlicePawn introuvable"); return; }

  g_gameinfo = 0;
  A->iter_objects("GameInfo", take_gi);
  gi = g_gameinfo;

  for (i = 0; i < 2 && !tmpl; i++) {
    AObj t = A->find_object(ARCH[i]);
    const char *cn = t ? A->class_of(t) : 0;
    if (!t) continue;
    if (!cn || strcmp(cn, "AlicePawn") != 0) {
      emit("cheats: %s est un %s, rejete (le moteur exige la classe exacte)",
           ARCH[i], cn ? cn : "?");
      continue;
    }
    tmpl = t;
    used = ARCH[i];
  }
  emit("cheats: archetype retenu = %s   GameInfo=%s", used,
       gi ? A->class_of(gi) : "nul");

  if (gi) {
    if (!A->set_int(gi, "AliceArcheTypeID", (used[0] && strstr(used, "Wonderland")) ? 1 : 0))
      A->set_byte(gi, "AliceArcheTypeID", (used[0] && strstr(used, "Wonderland")) ? 1 : 0);
    A->get_int(gi, "AliceArcheTypeID", &idv);
    emit("cheats: AliceArcheTypeID = %d", idv);
  }

  if (!A->get_vec(me, "Location", loc)) return;
  A->get_rot(me, "Rotation", rot);
  rot[0] = 0;
  rot[2] = 0;
  loc[0] += 120.0f;

  before = alice_pawns();
  c = A->call_begin(me, "Spawn");
  if (!c) { A->log("cheats: Spawn non resolue"); return; }
  A->call_arg_obj(c, "SpawnClass", cls);
  A->call_arg_vec(c, "SpawnLocation", loc);
  A->call_arg_rot(c, "SpawnRotation", rot);
  if (tmpl) A->call_arg_obj(c, "ActorTemplate", tmpl);
  A->call_arg_bool(c, "bNoCollisionFail", 1);
  A->call_invoke(c);
  res = A->call_out_obj(c, "ReturnValue");
  after = alice_pawns();

  emit("cheats: Spawn(AlicePawn, template=%s, bNoCollisionFail=1) -> retour=%s  AlicePawn %d->%d  %s",
       used, res ? A->class_of(res) : "nul", before, after,
       after > before ? "CREE" : "rien");
  if (after > before) describe_new_pawn();
}

static int attach_part(AObj mesh, AObj comp, const char *bone, const char *label) {
  ACall c;
  if (!comp) { emit("cheats:   %s absent", label); return 0; }
  c = A->call_begin(mesh, "AttachComponent");
  if (!c) { A->log("cheats: AttachComponent non resolue"); return 0; }
  A->call_arg_obj(c, "Component", comp);
  A->call_arg_name(c, "BoneName", bone);
  A->call_invoke(c);
  emit("cheats:   %s attache sur %s", label, bone);
  return 1;
}

static void copy_part(AObj me, AObj p, AObj mesh2, const char *prop,
                      const char *bone, const char *label) {
  AObj src = A->get_obj(me, prop);
  AObj dst = A->get_obj(p, prop);
  AObj srcMesh = src ? A->get_obj(src, "SkeletalMesh") : 0;
  AObj dstMesh = dst ? A->get_obj(dst, "SkeletalMesh") : 0;
  ACall c;

  emit("cheats:   %-9s src=%s(%s) dst=%s(%s)", label,
       src ? A->class_of(src) : "nul", srcMesh ? A->name_of(srcMesh) : "sans maillage",
       dst ? A->class_of(dst) : "nul", dstMesh ? A->name_of(dstMesh) : "sans maillage");

  if (!dst || !mesh2) return;

  c = A->call_begin(mesh2, "DetachComponent");
  if (c) { A->call_arg_obj(c, "Component", dst); A->call_invoke(c); }

  if (srcMesh && !dstMesh) {
    c = A->call_begin(dst, "DeleteSimulator");
    if (c) A->call_invoke(c);
    c = A->call_begin(dst, "SetSkeletalMesh");
    if (!c) { emit("cheats:   %s SetSkeletalMesh non resolue", label); }
    else {
      A->call_arg_obj(c, "NewMesh", srcMesh);
      A->call_invoke(c);
      dstMesh = A->get_obj(dst, "SkeletalMesh");
      emit("cheats:   %-9s maillage -> %s", label,
           dstMesh ? A->name_of(dstMesh) : "toujours nul");
    }
  }

  c = A->call_begin(mesh2, "AttachComponent");
  if (c) {
    A->call_arg_obj(c, "Component", dst);
    A->call_arg_name(c, "BoneName", bone);
    A->call_invoke(c);
  }
}

static const char *const CLOTH_INT[] = {"FixedTargetNodeIndex", "FixedNodeIndex",
                                        "boneNodeCount"};
static const char *const CLOTH_NAME[] = {"ClothName", "FixedTargetBone",
                                         "FixedTargetClothName", "FixedBone"};

static void cloth_report(const char *who, AObj comp) {
  char line[256];
  int i, v, n;
  if (!comp) { emit("cheats: %s tissu absent", who); return; }
  n = snprintf(line, sizeof line, "cheats: %s", who);
  for (i = 0; i < 3; i++) {
    v = -1; A->get_int(comp, CLOTH_INT[i], &v);
    n += snprintf(line + n, sizeof line - n, " %s=%d", CLOTH_INT[i], v);
  }
  for (i = 0; i < 4; i++) {
    v = -1; A->get_int(comp, CLOTH_NAME[i], &v);
    n += snprintf(line + n, sizeof line - n, " %s#%d", CLOTH_NAME[i], v);
    if (n > 200) break;
  }
  A->log(line);
  {
    int r = -1, j = -1;
    A->get_bool(comp, "bPendingReset", &r);
    A->get_bool(comp, "bJustAttached", &j);
    emit("cheats: %s bPendingReset=%d bJustAttached=%d", who, r, j);
  }
}

static const char *const CLOTH_FLAGS[] = {
    "bEnableClothSimulation", "bAttachClothVertsToBaseBody", "bClothFrozen",
    "bAutoFreezeClothWhenNotRendered", "bIsClothOnStaticObject",
    "bClothAwakeOnStartup", "bDisableClothCollision", "bUpdatedFixedClothVerts"};

static void cloth_flags(const char *who, AObj comp) {
  char line[256];
  int i, v, n;
  float w = -1.0f;
  if (!comp) return;
  n = snprintf(line, sizeof line, "cheats: %s", who);
  for (i = 0; i < 8; i++) {
    v = -1;
    A->get_bool(comp, CLOTH_FLAGS[i], &v);
    n += snprintf(line + n, sizeof line - n, " %.14s=%d", CLOTH_FLAGS[i] + 1, v);
    if (n > 210) break;
  }
  A->log(line);
  A->get_float(comp, "ClothBlendWeight", &w);
  emit("cheats: %s ClothBlendWeight=%.2f", who, w);
}

static void cloth_align(void *user) {
  static const char *const PARTS[] = {"SkirtComponent", "BowComponent",
                                      "RibbonComponent"};
  AObj me = A->player_pawn();
  AObj p = second_alice();
  int i, j, v;
  (void)user;

  if (!me || !p) return;
  A->log("---------- drapeaux de tissu ----------");
  cloth_flags("jupe locale", A->get_obj(me, "SkirtComponent"));
  cloth_flags("jupe clone ", A->get_obj(p, "SkirtComponent"));

  for (i = 0; i < 3; i++) {
    AObj src = A->get_obj(me, PARTS[i]);
    AObj dst = A->get_obj(p, PARTS[i]);
    float w;
    if (!src || !dst) continue;
    for (j = 0; j < 8; j++) {
      v = -1;
      if (A->get_bool(src, CLOTH_FLAGS[j], &v) && v >= 0)
        A->set_bool(dst, CLOTH_FLAGS[j], v);
    }
    w = -1.0f;
    if (A->get_float(src, "ClothBlendWeight", &w) && w >= 0.0f)
      A->set_float(dst, "ClothBlendWeight", w);
  }
  cloth_flags("jupe apres ", A->get_obj(p, "SkirtComponent"));
  A->log("---------------------------------------");
}

static void change_dress(void *user) {
  AObj p = second_alice();
  ACall c;
  int r = -1, cur = -1;
  (void)user;

  if (!p) { A->log("cheats: pas de seconde Alice"); return; }
  A->get_int(p, "CurWonderlandDress", &cur);
  emit("cheats: robe actuelle = %d, rechargement force", cur);

  c = A->call_begin(p, "ChangeWonderlandDress");
  if (!c) { A->log("cheats: ChangeWonderlandDress non resolue"); return; }
  A->call_arg_int(c, "NewDress", 0);
  A->call_arg_bool(c, "bShouldBlock", 1);
  A->call_arg_bool(c, "bWithoutDressCheck", 1);
  A->call_invoke(c);
  A->call_out_int(c, "ReturnValue", &r);
  emit("cheats: ChangeWonderlandDress -> %d", r);

  c = A->call_begin(p, "UpdateAliceDressLoading");
  if (c) { A->call_invoke(c); A->log("cheats: UpdateAliceDressLoading appele"); }

  c = A->call_begin(p, "ForceUpdateComponents");
  if (c) {
    A->call_arg_bool(c, "bCollisionUpdate", 0);
    A->call_arg_bool(c, "bTransformOnly", 0);
    A->call_invoke(c);
  }
  A->get_int(p, "CurWonderlandDress", &cur);
  emit("cheats: robe apres = %d", cur);
}

static void cloth_fix(void *user) {
  static const char *const PARTS[] = {"SkirtComponent", "BowComponent",
                                      "RibbonComponent"};
  AObj me = A->player_pawn();
  AObj p = second_alice();
  int i;
  (void)user;

  if (!me || !p) { A->log("cheats: il faut les deux Alice"); return; }
  A->log("---------- tissu ----------");
  cloth_report("jupe locale ", A->get_obj(me, "SkirtComponent"));
  cloth_report("jupe clone  ", A->get_obj(p, "SkirtComponent"));

  for (i = 0; i < 3; i++) {
    AObj src = A->get_obj(me, PARTS[i]);
    AObj dst = A->get_obj(p, PARTS[i]);
    int j, v;
    if (!src || !dst) continue;
    for (j = 0; j < 4; j++) {
      v = -1;
      if (A->get_int(src, CLOTH_NAME[j], &v) && v >= 0)
        A->set_int(dst, CLOTH_NAME[j], v);
    }
    for (j = 0; j < 3; j++) {
      v = -1;
      if (A->get_int(src, CLOTH_INT[j], &v) && v >= 0)
        A->set_int(dst, CLOTH_INT[j], v);
    }
    A->set_bool(dst, "bJustAttached", 1);
    A->set_bool(dst, "bPendingReset", 1);
  }
  cloth_report("jupe apres  ", A->get_obj(p, "SkirtComponent"));
  A->log("---------------------------");
}

static void dress_copy(void *user) {
  AObj me = A->player_pawn();
  AObj p = second_alice();
  AObj mesh2;
  ACall c;
  (void)user;

  if (!me || !p) { A->log("cheats: il faut les deux Alice"); return; }
  mesh2 = A->get_obj(p, "Mesh");
  A->log("---------- copie de la tenue ----------");
  copy_part(me, p, mesh2, "SkirtComponent", "Bip01-Pelvis", "jupe");
  copy_part(me, p, mesh2, "BowComponent", "Bip01-Pelvis", "noeud");
  copy_part(me, p, mesh2, "RibbonComponent", "Bip01-Pelvis", "ruban");
  copy_part(me, p, mesh2, "EarComponent", "Bip01-Head", "oreilles");
  copy_part(me, p, mesh2, "HairComponent", "Bip01-Head", "cheveux");

  c = A->call_begin(p, "SetMaterialsIntoAliceSkelComponents");
  if (c) A->call_invoke(c);
  c = A->call_begin(p, "ForceUpdateComponents");
  if (c) {
    A->call_arg_bool(c, "bCollisionUpdate", 0);
    A->call_arg_bool(c, "bTransformOnly", 0);
    A->call_invoke(c);
  }
  A->log("---------------------------------------");
}

static void dress_up(void *user) {
  AObj p = second_alice();
  AObj mesh;
  ACall c;
  (void)user;

  if (!p) { A->log("cheats: pas de seconde Alice"); return; }
  mesh = A->get_obj(p, "Mesh");
  if (!mesh) { A->log("cheats: pas de Mesh"); return; }

  A->log("---------- habillage ----------");
  attach_part(mesh, A->get_obj(p, "SkirtComponent"), "Bip01-Pelvis", "jupe");
  attach_part(mesh, A->get_obj(p, "BowComponent"), "Bip01-Pelvis", "noeud");
  attach_part(mesh, A->get_obj(p, "RibbonComponent"), "Bip01-Pelvis", "ruban");
  attach_part(mesh, A->get_obj(p, "HairComponent"), "Bip01-Head", "cheveux");
  attach_part(mesh, A->get_obj(p, "EarComponent"), "Bip01-Head", "oreilles");

  c = A->call_begin(p, "SetMaterialsIntoAliceSkelComponents");
  if (c) { A->call_invoke(c); A->log("cheats:   materiaux appliques"); }
  else A->log("cheats:   SetMaterialsIntoAliceSkelComponents non resolue");

  c = A->call_begin(p, "ForceUpdateComponents");
  if (c) {
    A->call_arg_bool(c, "bCollisionUpdate", 0);
    A->call_arg_bool(c, "bTransformOnly", 0);
    A->call_invoke(c);
  }
  A->log("-------------------------------");
}

static void tick(void) {
  follow_step();
  unsigned now = GetTickCount();

  if (!g_added && A->player_pawn() && now - g_lastTry > 1000) {
    g_lastTry = now;
    add_cheats();
  }

  if (g_reqAdd) {
    g_reqAdd = 0;
    g_added = 0;
    add_cheats();
  }
  if (g_reqSummon) {
    g_reqSummon = 0;
    summon_direct("AliceGame.AlicePawn");
  }
  if (g_reqConsole) {
    g_reqConsole = 0;
    summon_console("AliceGame.AlicePawn");
  }

  if (A->key_down(VK_CONTROL) && A->key_down(VK_SHIFT)) {
    if (A->key_pressed('7')) g_reqAdd = 1;
    if (A->key_pressed('8')) g_reqSummon = 1;
    if (A->key_pressed('9')) g_reqConsole = 1;
    if (A->key_pressed('6')) describe_new_pawn();
    if (A->key_pressed('D')) A->run_on_game_thread(show_debug_gt, (void *)"");
    if (A->key_pressed('A')) A->run_on_game_thread(show_debug_gt, (void *)"AI");
    if (A->key_pressed('P')) A->run_on_game_thread(show_debug_gt, (void *)"Physics");
    if (A->key_pressed('G')) gamelog_toggle();
    if (A->key_pressed('Z')) A->run_on_game_thread(spawn_with_archetype, 0);
    if (A->key_pressed('W')) A->run_on_game_thread(dress_copy, 0);
    if (A->key_pressed('Y')) A->run_on_game_thread(dress_up, 0);
    if (A->key_pressed('C')) A->run_on_game_thread(cloth_fix, 0);
    if (A->key_pressed('F')) A->run_on_game_thread(cloth_align, 0);
    if (A->key_pressed('E')) A->run_on_game_thread(change_dress, 0);
    if (A->key_pressed('L')) hud_state();
    if (A->key_pressed('5')) awaken();
    if (A->key_pressed('4')) { g_follow = 0; A->log("cheats: suivi arrete"); }
    if (A->key_pressed('B')) A->run_on_game_thread(light_compare, 0);
    if (A->key_pressed('N')) A->run_on_game_thread(light_align, 0);
    if (A->key_pressed('T')) A->run_on_game_thread(light_off, 0);
  }
}

static void panel(void) {
  AObj cm = cheat_manager();
  A->ui_label(cm ? A->class_of(cm) : "CheatManager absent");
  if (A->ui_button("AddCheats  (Ctrl+Maj+7)")) g_reqAdd = 1;
  if (A->ui_button("Spawn avec archetype  (Ctrl+Maj+Z)")) A->run_on_game_thread(spawn_with_archetype, 0);
  if (A->ui_button("Copier la tenue  (Ctrl+Maj+W)")) A->run_on_game_thread(dress_copy, 0);
  if (A->ui_button("Rattacher seulement  (Ctrl+Maj+Y)")) A->run_on_game_thread(dress_up, 0);
  if (A->ui_button("Reparer le tissu  (Ctrl+Maj+C)")) A->run_on_game_thread(cloth_fix, 0);
  if (A->ui_button("Drapeaux de tissu  (Ctrl+Maj+F)")) A->run_on_game_thread(cloth_align, 0);
  if (A->ui_button("Recharger la robe  (Ctrl+Maj+E)")) A->run_on_game_thread(change_dress, 0);
  if (A->ui_button("Summon AlicePawn  (Ctrl+Maj+8)")) g_reqSummon = 1;
  if (A->ui_button("Summon par console  (Ctrl+Maj+9)")) g_reqConsole = 1;
  if (A->ui_button("Decrire la 2e Alice  (Ctrl+Maj+6)")) describe_new_pawn();
  if (A->ui_button("ShowDebug  (Ctrl+Maj+D)")) A->run_on_game_thread(show_debug_gt, (void *)"");
  if (A->ui_button("ShowDebug AI  (Ctrl+Maj+A)")) A->run_on_game_thread(show_debug_gt, (void *)"AI");
  A->ui_label(A->version >= 19 && A->gamelog_active && A->gamelog_active()
                  ? "logs du jeu: captures"
                  : "logs du jeu: coupes");
  if (A->ui_button("Capturer les logs du jeu  (Ctrl+Maj+G)")) gamelog_toggle();
  if (A->ui_button("etat du HUD  (Ctrl+Maj+L)")) hud_state();
  if (A->ui_button("Reveiller la 2e Alice  (Ctrl+Maj+5)")) awaken();
  if (A->ui_button("Arreter le suivi  (Ctrl+Maj+4)")) g_follow = 0;
  if (A->ui_button("Comparer l eclairage  (Ctrl+Maj+B)")) A->run_on_game_thread(light_compare, 0);
  if (A->ui_button("Aligner l eclairage  (Ctrl+Maj+N)")) A->run_on_game_thread(light_align, 0);
  if (A->ui_button("Couper l env lumineux  (Ctrl+Maj+T)")) A->run_on_game_thread(light_off, 0);
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  A->log("cheats charge - AddCheats automatique, Ctrl+Maj+8 pour Summon AlicePawn");
  A->ui_panel("Cheats", panel);
  A->on_tick(tick);
}
