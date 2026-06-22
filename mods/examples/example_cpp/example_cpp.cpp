#include "hysteria.hpp"
using namespace hysteria;

static int g_clicks = 0;
static int g_mode = 0;
static int g_amount = 10;
static bool g_godmode = false;
static float g_speed = 1.0f;
static int g_spawns = 0;
static int g_bgTicks = 0;

HYSTERIA_MOD() {
    log("example_cpp: v13 ergonomics demo");

    on("TakeDamage", [](Event &e) {
        if (g_godmode && e.self() == player_pawn()) e.block();
    });

    when_ready([](Obj pawn) {
        (void)pawn; log("example_cpp: player pawn ready");
    });

    on_spawn("Pawn", [](Obj o) {
        (void)o; g_spawns++;
    });

    every(1000, [] {
        if (g_godmode) log("example_cpp: still invincible");
    });

    thread([] {
        for (int i = 0; i < 5; i++) {
            sleep_ms(500);
            on_game_thread([] { g_bgTicks++; });
        }
    });

    on_tick([] {
        if (key_pressed(VK_F8)) g_godmode = !g_godmode;
    });

    ui::panel("Example C++", [] {
        ui::text(0xFFB0A0FFu, "v13 builder demo");
        ui::separator();

        ui::checkbox("Godmode (F8)", g_godmode);
        if (ui::button("Click me")) g_clicks++;
        char b[64]; wsprintfA(b, "clicks: %d", g_clicks);
        ui::label(b);

        ui::spacing();
        const char *modes[] = { "Off", "Low", "High", "Max" };
        ui::combo("Mode", g_mode, { modes[0], modes[1], modes[2], modes[3] });
        ui::input_int("Amount", g_amount, 5, 0, 1000);
        ui::slider("Speed", g_speed, 0.1f, 4.0f, 0.1f);

        if (ui::tree("Stats")) {
            char s[64];
            wsprintfA(s, "spawns seen: %d", g_spawns); ui::label(s);
            wsprintfA(s, "bg ticks: %d", g_bgTicks); ui::label(s);
            ui::progress("amount", g_amount / 1000.0f);
        }
    });
}
