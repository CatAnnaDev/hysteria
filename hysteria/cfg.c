#include "hysteria.h"
#include <stdio.h>
#include <stdlib.h>

// Per-mod config: key=value text files living next to each mod DLL (Mods/<mod>.cfg).
// Mods read defaults at load and write changes back; the framework does the file I/O.

#define CFG_MAX 1024
typedef struct { char mod[32]; char key[48]; char val[64]; } CfgEntry;
static CfgEntry g_cfg[CFG_MAX];
static int g_cfgN;
#define CFG_MODS 64
static char g_loadedMod[CFG_MODS][32];
static int  g_dirty[CFG_MODS];
static int  g_loadedN;

static void mods_dir(char *out) {
    HMODULE self = NULL;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, (LPCSTR)&mods_dir, &self);
    char dir[MAX_PATH]; DWORD n = GetModuleFileNameA(self, dir, MAX_PATH);
    while (n > 0 && dir[n - 1] != '\\' && dir[n - 1] != '/') n--; dir[n] = 0;  // framework dll dir = Win32
    wsprintfA(out, "%sMods", dir);
}
static void cfg_path(const char *mod, char *out) {
    char d[MAX_PATH]; mods_dir(d);
    wsprintfA(out, "%s\\%s.cfg", d, mod);
}
static int mod_slot(const char *mod) {
    for (int i = 0; i < g_loadedN; i++) if (lstrcmpiA(g_loadedMod[i], mod) == 0) return i;
    return -1;
}

static void cfg_load(const char *mod) {
    if (mod_slot(mod) >= 0) return;  // already loaded
    int slot = (g_loadedN < CFG_MODS) ? g_loadedN++ : CFG_MODS - 1;
    lstrcpynA(g_loadedMod[slot], mod, sizeof g_loadedMod[slot]);
    g_dirty[slot] = 0;
    char path[MAX_PATH]; cfg_path(mod, path);
    FILE *f = fopen(path, "rb");
    if (!f) return;
    char line[160];
    while (fgets(line, sizeof line, f)) {
        char *eq = line; while (*eq && *eq != '=') eq++;
        if (*eq != '=') continue;
        *eq = 0; char *k = line, *v = eq + 1;
        char *e = v; while (*e && *e != '\r' && *e != '\n') e++; *e = 0;
        if (g_cfgN < CFG_MAX) {
            lstrcpynA(g_cfg[g_cfgN].mod, mod, sizeof g_cfg[g_cfgN].mod);
            lstrcpynA(g_cfg[g_cfgN].key, k, sizeof g_cfg[g_cfgN].key);
            lstrcpynA(g_cfg[g_cfgN].val, v, sizeof g_cfg[g_cfgN].val);
            g_cfgN++;
        }
    }
    fclose(f);
}

static const char *cfg_get(const char *mod, const char *key) {
    cfg_load(mod);
    for (int i = 0; i < g_cfgN; i++)
        if (lstrcmpiA(g_cfg[i].mod, mod) == 0 && lstrcmpiA(g_cfg[i].key, key) == 0) return g_cfg[i].val;
    return NULL;
}
static void cfg_set(const char *mod, const char *key, const char *val) {
    cfg_load(mod);
    int slot = mod_slot(mod);
    for (int i = 0; i < g_cfgN; i++)
        if (lstrcmpiA(g_cfg[i].mod, mod) == 0 && lstrcmpiA(g_cfg[i].key, key) == 0) {
            if (lstrcmpA(g_cfg[i].val, val) != 0) { lstrcpynA(g_cfg[i].val, val, sizeof g_cfg[i].val); if (slot >= 0) g_dirty[slot] = 1; }
            return;
        }
    if (g_cfgN < CFG_MAX) {
        lstrcpynA(g_cfg[g_cfgN].mod, mod, sizeof g_cfg[g_cfgN].mod);
        lstrcpynA(g_cfg[g_cfgN].key, key, sizeof g_cfg[g_cfgN].key);
        lstrcpynA(g_cfg[g_cfgN].val, val, sizeof g_cfg[g_cfgN].val);
        g_cfgN++; if (slot >= 0) g_dirty[slot] = 1;
    }
}

int   cfg_get_int(const char *mod, const char *key, int def)     { const char *v = cfg_get(mod, key); return v ? atoi(v) : def; }
float cfg_get_float(const char *mod, const char *key, float def) { const char *v = cfg_get(mod, key); return v ? (float)atof(v) : def; }
int   cfg_get_bool(const char *mod, const char *key, int def)    { const char *v = cfg_get(mod, key); return v ? (atoi(v) != 0) : def; }
void  cfg_set_int(const char *mod, const char *key, int val)     { char b[32]; wsprintfA(b, "%d", val); cfg_set(mod, key, b); }
void  cfg_set_bool(const char *mod, const char *key, int val)    { cfg_set(mod, key, val ? "1" : "0"); }
void  cfg_set_float(const char *mod, const char *key, float val) { char b[40]; snprintf(b, sizeof b, "%.4f", val); cfg_set(mod, key, b); }

void cfg_save(const char *mod) {
    int slot = mod_slot(mod);
    if (slot < 0 || !g_dirty[slot]) return;
    char path[MAX_PATH]; cfg_path(mod, path);
    FILE *f = fopen(path, "wb");
    if (!f) return;
    for (int i = 0; i < g_cfgN; i++)
        if (lstrcmpiA(g_cfg[i].mod, mod) == 0) fprintf(f, "%s=%s\n", g_cfg[i].key, g_cfg[i].val);
    fclose(f);
    g_dirty[slot] = 0;
}
