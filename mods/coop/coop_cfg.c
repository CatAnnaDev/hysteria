#include "coop.h"

CoopCfg g_cfg;
static int g_cfgDirty;

static void nickname_load(void) {
    char dir[MAX_PATH], path[MAX_PATH];
    HMODULE self = NULL;
    DWORD n;
    FILE *f;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                       GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       (LPCSTR)&nickname_load, &self);
    n = GetModuleFileNameA(self, dir, MAX_PATH);
    while (n > 0 && dir[n - 1] != '\\' && dir[n - 1] != '/') n--;
    dir[n] = 0;
    wsprintfA(path, "%scoop_name.txt", dir);
    f = fopen(path, "rb");
    if (!f) return;
    if (fgets(g_cfg.nickname, sizeof g_cfg.nickname, f)) {
        int i;
        for (i = 0; g_cfg.nickname[i]; i++)
            if (g_cfg.nickname[i] == '\r' || g_cfg.nickname[i] == '\n') { g_cfg.nickname[i] = 0; break; }
    }
    fclose(f);
    if (!g_cfg.nickname[0]) lstrcpynA(g_cfg.nickname, "ALICE", sizeof g_cfg.nickname);
}

static void nickname_save(void) {
    char dir[MAX_PATH], path[MAX_PATH];
    HMODULE self = NULL;
    DWORD n;
    FILE *f;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                       GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       (LPCSTR)&nickname_load, &self);
    n = GetModuleFileNameA(self, dir, MAX_PATH);
    while (n > 0 && dir[n - 1] != '\\' && dir[n - 1] != '/') n--;
    dir[n] = 0;
    wsprintfA(path, "%scoop_name.txt", dir);
    f = fopen(path, "wb");
    if (!f) return;
    fputs(g_cfg.nickname, f);
    fputc('\n', f);
    fclose(f);
}

void cfg_load_all(void) {
    g_cfg.role         = A->cfg_get_int("coop", "role", 0);
    g_cfg.listen_port  = A->cfg_get_int("coop", "listen_port", 7777);
    g_cfg.peer_ip[0]   = A->cfg_get_int("coop", "peer_ip0", 127);
    g_cfg.peer_ip[1]   = A->cfg_get_int("coop", "peer_ip1", 0);
    g_cfg.peer_ip[2]   = A->cfg_get_int("coop", "peer_ip2", 0);
    g_cfg.peer_ip[3]   = A->cfg_get_int("coop", "peer_ip3", 1);
    g_cfg.peer_port    = A->cfg_get_int("coop", "peer_port", 0);
    g_cfg.discover_lan = A->cfg_get_bool("coop", "discover_lan", 0);
    g_cfg.ghost_mode   = A->cfg_get_int("coop", "ghost_mode", 2);
    g_cfg.delay_ms     = A->cfg_get_int("coop", "delay_ms", 100);
    g_cfg.rate_hz      = A->cfg_get_int("coop", "rate_hz", 30);
    g_cfg.plate        = A->cfg_get_bool("coop", "plate", 1);
    g_cfg.plate_max_m  = A->cfg_get_float("coop", "plate_max_m", 250.0f);
    g_cfg.mirror_world = A->cfg_get_bool("coop", "mirror_world", 0);
    g_cfg.z_adjust     = A->cfg_get_float("coop", "zadjust", 0.0f);
    g_cfg.safe_mode    = A->cfg_get_bool("coop", "safe_mode", 0);
    g_cfg.diag         = A->cfg_get_bool("coop", "diag", 1);
    g_cfg.key_repair   = A->cfg_get_bool("coop", "key_repair", 0);
    g_cfg.defer_ttl_ms = A->cfg_get_int("coop", "defer_ttl_ms", 5000);
    g_cfg.lane_gap_ms  = A->cfg_get_int("coop", "lane_gap_ms", 2000);
    g_cfg.echo_ttl_ms  = A->cfg_get_int("coop", "echo_ttl_ms", 1500);

    g_cfg.mirror_kismet  = A->cfg_get_bool("coop", "mirror_kismet", 0);
    g_cfg.mirror_trigger = A->cfg_get_bool("coop", "mirror_trigger", 0);
    g_cfg.kismet_probe   = A->cfg_get_bool("coop", "kismet_probe", 0);
    g_cfg.kismet_force   = A->cfg_get_bool("coop", "kismet_force", 0);
    g_cfg.mirror_decor   = A->cfg_get_bool("coop", "mirror_decor", 0);
    g_cfg.mirror_mover   = A->cfg_get_bool("coop", "mirror_mover", 0);
    g_cfg.mirror_npc     = A->cfg_get_bool("coop", "mirror_npc", 0);
    g_cfg.mirror_loot    = A->cfg_get_bool("coop", "mirror_loot", 0);
    g_cfg.mirror_vo      = A->cfg_get_bool("coop", "mirror_vo", 0);
    g_cfg.mirror_msg     = A->cfg_get_bool("coop", "mirror_msg", 0);
    g_cfg.vo_dedup_ms    = A->cfg_get_int("coop", "vo_dedup_ms", 4000);
    g_cfg.log_events     = A->cfg_get_bool("coop", "log_events", 1);

    g_cfg.mirror_cine     = A->cfg_get_bool("coop", "mirror_cine", 0);
    g_cfg.cine_ghost      = A->cfg_get_bool("coop", "cine_ghost", 0);
    g_cfg.cine_force      = A->cfg_get_bool("coop", "cine_force", 0);
    g_cfg.cine_sync_ms    = A->cfg_get_int("coop", "cine_sync_ms", 1000);
    g_cfg.cine_drift_ms   = A->cfg_get_int("coop", "cine_drift_ms", 250);
    g_cfg.travel_sync     = A->cfg_get_bool("coop", "travel_sync", 0);
    g_cfg.travel_follow   = A->cfg_get_bool("coop", "travel_follow", 0);
    g_cfg.travel_grace_ms = A->cfg_get_int("coop", "travel_grace_ms", 8000);
    g_cfg.ckpt_follow     = A->cfg_get_bool("coop", "ckpt_follow", 0);
    g_cfg.death_notify    = A->cfg_get_bool("coop", "death_notify", 1);
    g_cfg.peer_timeout_ms = A->cfg_get_int("coop", "peer_timeout_ms", 8000);
    g_cfg.ghost_drop_ms   = A->cfg_get_int("coop", "ghost_drop_ms", 15000);
    g_cfg.desync_tol      = A->cfg_get_int("coop", "desync_tol", 3);
    g_cfg.prog_beat_ms    = A->cfg_get_int("coop", "prog_beat_ms", 1000);

    if (g_cfg.listen_port < 1024 || g_cfg.listen_port > 65000) g_cfg.listen_port = 7777;
    if (g_cfg.rate_hz < 5 || g_cfg.rate_hz > 90) g_cfg.rate_hz = 30;
    if (g_cfg.delay_ms < 0 || g_cfg.delay_ms > 500) g_cfg.delay_ms = 100;
    if (g_cfg.ghost_mode < 0 || g_cfg.ghost_mode > 4) g_cfg.ghost_mode = 2;
    if (g_cfg.plate_max_m < 10.0f) g_cfg.plate_max_m = 250.0f;
    if (g_cfg.defer_ttl_ms < 500 || g_cfg.defer_ttl_ms > 60000) g_cfg.defer_ttl_ms = 5000;
    if (g_cfg.lane_gap_ms < 200 || g_cfg.lane_gap_ms > 30000) g_cfg.lane_gap_ms = 2000;
    if (g_cfg.echo_ttl_ms < 200 || g_cfg.echo_ttl_ms > 30000) g_cfg.echo_ttl_ms = 1500;
    if (g_cfg.vo_dedup_ms < 0 || g_cfg.vo_dedup_ms > 60000) g_cfg.vo_dedup_ms = 4000;
    if (g_cfg.cine_sync_ms < 0 || g_cfg.cine_sync_ms > 30000) g_cfg.cine_sync_ms = 1000;
    if (g_cfg.cine_drift_ms < 50 || g_cfg.cine_drift_ms > 10000) g_cfg.cine_drift_ms = 250;
    if (g_cfg.travel_grace_ms < 1000 || g_cfg.travel_grace_ms > 120000) g_cfg.travel_grace_ms = 8000;
    if (g_cfg.peer_timeout_ms < 2000 || g_cfg.peer_timeout_ms > 120000) g_cfg.peer_timeout_ms = 8000;
    if (g_cfg.ghost_drop_ms < 3000 || g_cfg.ghost_drop_ms > 600000) g_cfg.ghost_drop_ms = 15000;
    if (g_cfg.desync_tol < 0 || g_cfg.desync_tol > 200) g_cfg.desync_tol = 3;
    if (g_cfg.prog_beat_ms < 250 || g_cfg.prog_beat_ms > 30000) g_cfg.prog_beat_ms = 1000;

    lstrcpynA(g_cfg.nickname, "ALICE", sizeof g_cfg.nickname);
    nickname_load();
    g_cfgDirty = 0;
}

void cfg_flush(void) {
    A->cfg_set_int("coop", "role", g_cfg.role);
    A->cfg_set_int("coop", "listen_port", g_cfg.listen_port);
    A->cfg_set_int("coop", "peer_ip0", g_cfg.peer_ip[0]);
    A->cfg_set_int("coop", "peer_ip1", g_cfg.peer_ip[1]);
    A->cfg_set_int("coop", "peer_ip2", g_cfg.peer_ip[2]);
    A->cfg_set_int("coop", "peer_ip3", g_cfg.peer_ip[3]);
    A->cfg_set_int("coop", "peer_port", g_cfg.peer_port);
    A->cfg_set_bool("coop", "discover_lan", g_cfg.discover_lan);
    A->cfg_set_int("coop", "ghost_mode", g_cfg.ghost_mode);
    A->cfg_set_int("coop", "delay_ms", g_cfg.delay_ms);
    A->cfg_set_int("coop", "rate_hz", g_cfg.rate_hz);
    A->cfg_set_bool("coop", "plate", g_cfg.plate);
    A->cfg_set_float("coop", "plate_max_m", g_cfg.plate_max_m);
    A->cfg_set_bool("coop", "mirror_world", g_cfg.mirror_world);
    A->cfg_set_float("coop", "zadjust", g_cfg.z_adjust);
    A->cfg_set_bool("coop", "safe_mode", g_cfg.safe_mode);
    A->cfg_set_bool("coop", "diag", g_cfg.diag);
    A->cfg_set_bool("coop", "key_repair", g_cfg.key_repair);
    A->cfg_set_int("coop", "defer_ttl_ms", g_cfg.defer_ttl_ms);
    A->cfg_set_int("coop", "lane_gap_ms", g_cfg.lane_gap_ms);
    A->cfg_set_int("coop", "echo_ttl_ms", g_cfg.echo_ttl_ms);
    A->cfg_set_bool("coop", "mirror_kismet", g_cfg.mirror_kismet);
    A->cfg_set_bool("coop", "mirror_trigger", g_cfg.mirror_trigger);
    A->cfg_set_bool("coop", "kismet_probe", g_cfg.kismet_probe);
    A->cfg_set_bool("coop", "kismet_force", g_cfg.kismet_force);
    A->cfg_set_bool("coop", "mirror_decor", g_cfg.mirror_decor);
    A->cfg_set_bool("coop", "mirror_mover", g_cfg.mirror_mover);
    A->cfg_set_bool("coop", "mirror_npc", g_cfg.mirror_npc);
    A->cfg_set_bool("coop", "mirror_loot", g_cfg.mirror_loot);
    A->cfg_set_bool("coop", "mirror_vo", g_cfg.mirror_vo);
    A->cfg_set_bool("coop", "mirror_msg", g_cfg.mirror_msg);
    A->cfg_set_int("coop", "vo_dedup_ms", g_cfg.vo_dedup_ms);
    A->cfg_set_bool("coop", "log_events", g_cfg.log_events);
    A->cfg_set_bool("coop", "mirror_cine", g_cfg.mirror_cine);
    A->cfg_set_bool("coop", "cine_ghost", g_cfg.cine_ghost);
    A->cfg_set_bool("coop", "cine_force", g_cfg.cine_force);
    A->cfg_set_int("coop", "cine_sync_ms", g_cfg.cine_sync_ms);
    A->cfg_set_int("coop", "cine_drift_ms", g_cfg.cine_drift_ms);
    A->cfg_set_bool("coop", "travel_sync", g_cfg.travel_sync);
    A->cfg_set_bool("coop", "travel_follow", g_cfg.travel_follow);
    A->cfg_set_int("coop", "travel_grace_ms", g_cfg.travel_grace_ms);
    A->cfg_set_bool("coop", "ckpt_follow", g_cfg.ckpt_follow);
    A->cfg_set_bool("coop", "death_notify", g_cfg.death_notify);
    A->cfg_set_int("coop", "peer_timeout_ms", g_cfg.peer_timeout_ms);
    A->cfg_set_int("coop", "ghost_drop_ms", g_cfg.ghost_drop_ms);
    A->cfg_set_int("coop", "desync_tol", g_cfg.desync_tol);
    A->cfg_set_int("coop", "prog_beat_ms", g_cfg.prog_beat_ms);
    A->cfg_save("coop");
    if (g_cfgDirty) { nickname_save(); g_cfgDirty = 0; }
}

void cfg_set_nickname(const char *s) {
    if (!s || !s[0]) return;
    lstrcpynA(g_cfg.nickname, s, sizeof g_cfg.nickname);
    g_cfgDirty = 1;
    cfg_flush();
}
