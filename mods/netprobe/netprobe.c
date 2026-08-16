#include "hysteria_api.h"
#include <windows.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

static HysteriaAPI *A;
static AObj found_engine;
static AObj found_game;
static int listed;
static int map_idx;
static int armed;

static const char *const MAPS[] = {
    "AliceEntry", "Chapter1_L1_Alley_01", "CC_Combats", "CC_Riddles"};

static void emit(const char *fmt, ...) {
  char buf[512];
  va_list ap;
  va_start(ap, fmt);
  vsnprintf(buf, sizeof buf, fmt, ap);
  va_end(ap);
  A->log(buf);
}

static int is_default(AObj o) {
  const char *n = A->name_of(o);
  return !n || strncmp(n, "Default__", 9) == 0;
}

static const char *role_name(int r) {
  static const char *const n[] = {"None", "SimulatedProxy", "AutonomousProxy",
                                  "Authority"};
  return (r >= 0 && r < 4) ? n[r] : "?";
}

static const char *netmode_name(int m) {
  static const char *const n[] = {"Standalone", "DedicatedServer",
                                  "ListenServer", "Client"};
  return (m >= 0 && m < 4) ? n[m] : "?";
}

static void list_instance(AObj o) {
  char full[256];
  if (is_default(o)) return;
  listed++;
  A->full_name(o, full, sizeof full);
  emit("    [%d] %-24s %s", listed, A->class_of(o), full);
}

static int list_real(const char *className) {
  listed = 0;
  A->iter_objects(className, list_instance);
  if (!listed) emit("    aucune instance reelle");
  return listed;
}

static void take_engine(AObj o) { if (!found_engine && !is_default(o)) found_engine = o; }
static void take_game(AObj o) { if (!found_game && !is_default(o)) found_game = o; }

static AObj engine(void) {
  if (!found_engine) A->iter_objects("GameEngine", take_engine);
  return found_engine;
}

static AObj game_info(void) {
  found_game = 0;
  A->iter_objects("GameInfo", take_game);
  return found_game;
}

static void dump_roles(AObj o, const char *label) {
  int r = 0, rr = 0;
  if (!o) { emit("%-17s: absent", label); return; }
  A->get_byte(o, "Role", &r);
  A->get_byte(o, "RemoteRole", &rr);
  emit("%-17s: %-22s Role=%s RemoteRole=%s", label, A->class_of(o),
       role_name(r), role_name(rr));
}

static void probe(void) {
  static const char *const NET_CLASSES[] = {"TcpNetDriver", "TcpipConnection",
                                            "NetDriver", "NetConnection",
                                            "OnlineSubsystemPC"};
  AObj wi = A->world_info();
  AObj gi;
  int v = 0, i;

  A->log("---------- netprobe ----------");

  if (wi && A->get_byte(wi, "NetMode", &v))
    emit("%-17s: %d (%s)", "NetMode", v, netmode_name(v));
  else
    emit("%-17s: illisible", "NetMode");

  gi = game_info();
  if (gi) {
    int mx = 0, np = 0;
    char full[256];
    A->get_int(gi, "MaxPlayers", &mx);
    A->get_int(gi, "NumPlayers", &np);
    A->full_name(gi, full, sizeof full);
    emit("%-17s: %s  MaxPlayers=%d NumPlayers=%d", "GameInfo", A->class_of(gi),
         mx, np);
    emit("                   %s", full);
  } else {
    emit("%-17s: aucune instance vivante", "GameInfo");
  }

  dump_roles(A->player_controller(), "PlayerController");
  dump_roles(A->player_pawn(), "Pawn");

  for (i = 0; i < 5; i++)
    emit("classe %-18s: %s", NET_CLASSES[i],
         A->find_class(NET_CLASSES[i]) ? "CHARGEE" : "absente");
  emit("paquet IpDrv     : %s", A->find_object("IpDrv") ? "CHARGE" : "absent");

  emit("PlayerStart reels:");
  list_real("PlayerStart");
  emit("NetDriver reels  :");
  list_real("NetDriver");
  emit("NetConnection    :");
  list_real("NetConnection");

  found_engine = 0;
  emit("%-17s: %s", "GameEngine", engine() ? A->class_of(found_engine) : "introuvable");
  A->log("------------------------------");
}

static void redump(void *user) { (void)user; A->log("netprobe: re-dump differe"); probe(); }
static void schedule_redump(void) { A->after_ms(4000, redump, 0); }

static void load_ipdrv(void) {
  static const char *const TARGETS[] = {"IpDrv.TcpNetDriver",
                                        "IpDrv.TcpipConnection"};
  AObj klass = A->find_class("Class");
  AObj host = A->world_info();
  int i;
  if (!klass) { A->log("netprobe: UClass 'Class' introuvable"); return; }
  if (!host) host = A->player_controller();
  if (!host) { A->log("netprobe: aucun objet hote pour l'appel"); return; }

  for (i = 0; i < 2; i++) {
    ACall c = A->call_begin(host, "DynamicLoadObject");
    AObj r;
    if (!c) { A->log("netprobe: DynamicLoadObject introuvable"); return; }
    A->call_arg_str(c, "ObjectName", TARGETS[i]);
    A->call_arg_obj(c, "ObjectClass", klass);
    A->call_arg_bool(c, "MayFail", 1);
    A->call_invoke(c);
    r = A->call_out_obj(c, "ReturnValue");
    emit("DynamicLoadObject(\"%s\") -> %s", TARGETS[i],
         r ? A->name_of(r) : "NULL");
  }

  emit("apres chargement : TcpNetDriver=%s TcpipConnection=%s IpDrv=%s",
       A->find_class("TcpNetDriver") ? "CHARGEE" : "absente",
       A->find_class("TcpipConnection") ? "CHARGEE" : "absente",
       A->find_object("IpDrv") ? "CHARGE" : "absent");
}

static void create_driver(void) {
  ACall c;
  int ok = 0;
  if (!engine()) { A->log("netprobe: GameEngine introuvable"); return; }
  c = A->call_begin(found_engine, "CreateNamedNetDriver");
  if (!c) { A->log("netprobe: CreateNamedNetDriver introuvable"); return; }
  A->call_arg_str(c, "NetDriverName", "GameNetDriver");
  A->call_invoke(c);
  A->call_out_bool(c, "ReturnValue", &ok);
  emit("CreateNamedNetDriver -> %d", ok);
  emit("classe TcpNetDriver apres appel : %s",
       A->find_class("TcpNetDriver") ? "CHARGEE" : "toujours absente");
  emit("NetDriver reels apres appel:");
  list_real("NetDriver");
}

static void travel_listen(void) {
  AObj wi = A->world_info();
  ACall c;
  if (!wi) return;
  c = A->call_begin(wi, "ServerTravel");
  if (!c) { A->log("netprobe: ServerTravel introuvable"); return; }
  A->call_arg_str(c, "URL", "?listen");
  A->call_arg_bool(c, "bAbsolute", 0);
  A->call_arg_bool(c, "bShouldSkipGameNotify", 0);
  A->call_invoke(c);
  A->log("netprobe: ServerTravel(\"?listen\") emis");
  schedule_redump();
}

static void run_console(const char *cmd) {
  A->console(A->player_controller(), cmd);
  emit("netprobe: console -> %s", cmd);
  schedule_redump();
}

static void panel(void) {
  char cmd[160];
  A->ui_label("Reconnaissance de la pile reseau UE3");
  if (A->ui_button("Dump etat reseau  (Ctrl+Maj+N)")) probe();
  A->ui_separator();
  A->ui_label("Sans risque :");
  if (A->ui_button("Charger IpDrv  (Ctrl+Maj+I)")) load_ipdrv();
  if (A->ui_button("GameEngine.CreateNamedNetDriver")) create_driver();
  A->ui_separator();
  A->ui_checkbox("Armer les actions qui font planter", &armed);
  if (!armed) {
    A->ui_label("open / ServerTravel desarmes");
    return;
  }
  A->ui_combo("Map", &map_idx, MAPS, 4);
  if (A->ui_button("console: open <map>?listen")) {
    snprintf(cmd, sizeof cmd, "open %s?listen", MAPS[map_idx]);
    run_console(cmd);
  }
  if (A->ui_button("WorldInfo.ServerTravel(\"?listen\")")) travel_listen();
  if (A->ui_button("console: open 127.0.0.1")) run_console("open 127.0.0.1");
  if (A->ui_button("console: disconnect")) run_console("disconnect");
}

static void tick(void) {
  if (!A->key_down(VK_CONTROL) || !A->key_down(VK_SHIFT)) return;
  if (A->key_pressed('I')) load_ipdrv();
  if (A->key_pressed('N')) probe();
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  A->log("netprobe v5 charge — Ctrl+Maj+I = charger IpDrv, Ctrl+Maj+N = dump");
  A->ui_panel("Net Probe", panel);
  A->on_tick(tick);
}
