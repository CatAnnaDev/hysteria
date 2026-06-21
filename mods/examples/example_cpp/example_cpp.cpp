#include "hysteria.hpp"
using namespace hysteria;

HYSTERIA_MOD() {
    log("c++ example mod loaded");
    on("DoJump", [](Event &e) { log("c++ mod: jump intercepted (DoJump)"); });
    on_tick([] {
        if (key_pressed(VK_F10)) console("fly");
        if (key_pressed(VK_F9))
            call(player_pawn(), "Suicide").invoke();   // any function, by name, typed args
    });
}
