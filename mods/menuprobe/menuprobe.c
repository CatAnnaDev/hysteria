#include "hysteria_api.h"
#include <windows.h>
#include <stdarg.h>
#include <stdio.h>

static HysteriaAPI *A;

#define MENU_SLOTS 32
static int menu_seen[MENU_SLOTS];
static int menu_order[MENU_SLOTS];
static int menu_order_len;
static int callback_seen[MENU_SLOTS];
static int callback_order[MENU_SLOTS];
static int callback_order_len;
static int fscommand_hits;

static void emit(const char *fmt, ...) {
  char buf[512];
  va_list ap;
  va_start(ap, fmt);
  vsnprintf(buf, sizeof buf, fmt, ap);
  va_end(ap);
  A->log(buf);
}

static void note(int v, int *seen, int *order, int *len) {
  if (v < 0 || v >= MENU_SLOTS) return;
  if (seen[v]++) return;
  order[(*len)++] = v;
}

static void on_menu_name(AEvent *e) {
  int i = -1;
  if (!A->param_get_int(e, "I", &i)) return;
  if (i >= 0 && i < MENU_SLOTS && !menu_seen[i])
    emit("menuprobe: getMenuName(I=%d) — nouvelle entree demandee", i);
  note(i, menu_seen, menu_order, &menu_order_len);
}

static void on_game_callback(AEvent *e) {
  int t = -1;
  if (!A->param_get_int(e, "CallbackType", &t)) return;
  emit("menuprobe: GameCallback(CallbackType=%d)", t);
  note(t, callback_seen, callback_order, &callback_order_len);
}

static void on_fscommand(AEvent *e) {
  (void)e;
  if (!fscommand_hits) A->log("menuprobe: FSCommand declenchee pour la 1re fois");
  fscommand_hits++;
}

static void on_gate(AEvent *e) {
  int r = -1;
  A->ret_get_int(e, &r);
  emit("menuprobe: %s -> %d", e->func_name, r);
}

static void summary(void) {
  char line[512];
  int n = 0, i;
  A->log("---------- menuprobe ----------");
  n = snprintf(line, sizeof line, "indices getMenuName demandes (%d) :",
               menu_order_len);
  for (i = 0; i < menu_order_len && n < (int)sizeof line - 8; i++)
    n += snprintf(line + n, sizeof line - n, " %d", menu_order[i]);
  A->log(line);
  n = snprintf(line, sizeof line, "CallbackType vus (%d) :", callback_order_len);
  for (i = 0; i < callback_order_len && n < (int)sizeof line - 8; i++)
    n += snprintf(line + n, sizeof line - n, " %d", callback_order[i]);
  A->log(line);
  emit("FSCommand declenchees : %d", fscommand_hits);
  A->log("-------------------------------");
}

static void reset(void) {
  int i;
  for (i = 0; i < MENU_SLOTS; i++) {
    menu_seen[i] = 0;
    callback_seen[i] = 0;
  }
  menu_order_len = 0;
  callback_order_len = 0;
  fscommand_hits = 0;
  A->log("menuprobe: compteurs remis a zero");
}

static void panel(void) {
  A->ui_label("Sonde du menu Flash (lecture seule)");
  A->ui_label("Navigue dans le menu, puis:");
  if (A->ui_button("Resume dans le log")) summary();
  if (A->ui_button("Remettre a zero")) reset();
  A->ui_separator();
  A->ui_progress("entrees vues", menu_order_len / 12.0f);
}

static int last_reported;

static void autopulse(void *user) {
  int total = menu_order_len + callback_order_len + fscommand_hits;
  (void)user;
  if (total == last_reported) return;
  last_reported = total;
  summary();
}

__declspec(dllexport) void ModMain(HysteriaAPI *api) {
  A = api;
  A->log("menuprobe v3 charge — resume automatique, aucune touche");
  A->on("getMenuName", on_menu_name);
  A->on("GameCallback", on_game_callback);
  A->on("FSCommand", on_fscommand);
  A->on_post("getIsSpecialPCEdition", on_gate);
  A->on_post("isFinishGameOnHard", on_gate);
  A->on_post("getChapterUnlocked", on_gate);
  A->on_post("shouldShowAutoSaveWarning", on_gate);
  A->ui_panel("Menu Probe", panel);
  A->every_ms(8000, autopulse, 0);
}
