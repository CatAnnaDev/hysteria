# Hysteria

A from-scratch modding stack for **Alice: Madness Returns** (Unreal Engine 3, D3D9).
Zero hardcoded addresses, zero heavy dependencies — everything is discovered at runtime.
It runs natively on Windows and under CrossOver/Wine on macOS.

Three pieces:

- **`hysteria/`** — the framework: a `dinput8.dll` proxy that hooks into the running game,
  exposes its whole UnrealScript object model, and loads mods.
- **`mods/`** — mods are tiny DLLs (C, C++, or Rust) built on the framework's API.
- **`studio/`** — Hysteria Studio: a cross-platform desktop app (Rust + egui) to open,
  inspect, edit, preview and export the game's `.upk` assets (textures, sounds, properties).

## What it can do

- Read and write **any** property on **any** live object, by name, through the class hierarchy.
- Intercept, modify, block or override the return of **any** of the game's ~8000 functions.
- Call any function, spawn/destroy actors, run console commands, draw an in-game overlay.
- A proper **keyboard + mouse fix** (Alice was built for a gamepad — see below).
- A standalone asset tool that loads all ~1700 cooked packages and lets you edit them.

The full game surface — 1861 classes, ~13900 properties, 8272 functions — is mapped in
`hysteria_reference.txt` (generated). Nothing is out of reach.

## The mouse fix

Alice: Madness Returns is gamepad-first; its keyboard+mouse aim has acceleration, smoothing
and a deadzone that eats small movements. The `input` mod fixes it **the clean way** — it keeps
the game's native camera and just neutralizes the bad parts: it forces the camera-input accel
timers (`aTurnElapsedTime` / `aLookUpElapsedTime`) flat and disables `bEnableMouseSmoothing`.
No input bypass, no camera fighting, menus still work.

## Layout

```
hysteria/        the framework (compiles to the injected dinput8.dll)
  proxy.c         dll proxy + D3D9 EndScene/Reset hooks + raw-input plumbing + logmsg
  mem.c           GNames/GObjects discovery, name/class/property reflection
  props.c         runtime offset calibration (UProperty tables)
  mod_hook.c      ProcessEvent finder + inline detour + dispatch + per-frame ticks
  mod_api.c       the HysteriaAPI implementation + mod loader
  hysteria_api.h  the PUBLIC header mods compile against
  hysteria.hpp    C++ wrapper (lambdas, std::string, HYSTERIA_MOD macro)
  hysteria_sdk.h  GENERATED typed offset accessors (tools/gen_sdk.py) — not committed
  console.c       in-game log console;  ui.c  Nuklear overlay
  camera.c render.c entities.c dump.c   built-in overlay tools (freecam/ESP/actors/dump)
  frame.c         per-frame orchestrator;  build.sh  cross-compile + deploy
mods/
  trainer/        god / fly / noclip / freeze / teleport / savestates / world / heal
  alice/          Alice abilities, hysteria, shrink-sense
  input/          the keyboard+mouse fix
  examples/       reference mods in C, C++ and Rust (+ older demos)
  build.sh        builds every top-level mod -> Win32/Mods/<name>.dll
studio/           Hysteria Studio (Rust + egui) — the asset tool
tools/            gen_sdk.py, gen_reference.py, gen_ccmds.py, upk.py, lzo1x.py
```

## Build & run

```
hysteria/build.sh     # build the framework, auto-deploy dinput8.dll to the game folder
mods/build.sh         # build the mods, deploy to Win32/Mods/
bash play.command     # launch windowed   (RES=1920x1080 bash play.command to resize)
```

Toolchain: `i686-w64-mingw32-gcc/g++` (Homebrew `mingw-w64`); Rust mods need nightly +
`rustup target add i686-pc-windows-gnu` + `rustup component add rust-src`. On macOS the game
runs from the CrossOver bottle via `cxstart`.

In game: `` ` `` toggles the overlay. The ProcessEvent hook installs itself; mods load from
`Mods/` (hit "Reload mods" in the Modding tab to hot-reload).

## Writing a mod

**C** — `mods/<name>/<name>.c`:
```c
#include <windows.h>
#include "hysteria_api.h"
static HysteriaAPI *A;
static void on_damage(AEvent *e){ if(e->self == A->player_pawn()) e->block = 1; } // godmode
__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A = api;
    api->log("my mod loaded");
    api->on("TakeDamage", on_damage);
    api->set_bool(A->player_pawn(), "bCanFly", 1);
}
```

**C++** (`hysteria.hpp` — lambdas + std::string):
```cpp
#include "hysteria.hpp"
using namespace hysteria;
HYSTERIA_MOD() {
    log("my mod loaded");
    on("TakeDamage", [](Event &e){ if (e.self() == player_pawn()) e.block(); });
    on_tick([]{ if (key_pressed(VK_F11)) console("God"); });
}
```

**Rust** (closures, no unsafe in your mod):
```rust
mod hysteria_api; mod hysteria; use hysteria::*;
#[no_mangle] pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    on("TakeDamage", |e| if e.this() == player_pawn() { e.block(); });
    on_tick(|| if key_pressed(0x7A) { console("God"); });
}
```

See **MODDING.md** for the full guide. The API (`hysteria_api.h`, version 7) covers:
reflection, typed property get/set (int/float/bool/byte/vector/rotator), event hooks with
param + return editing, a generic typed call builder (`call_begin → call_arg_* → call_invoke
→ call_out_*`), spawn/destroy/console, per-frame `on_tick` + `key_down`/`key_pressed`,
overlay panels (`ui_panel` + widgets), `world_info()`, raw memory access, and raw mouse.

## Hysteria Studio

A standalone, cross-platform (Windows/macOS/Linux) asset tool — no game required.

```
cd studio && cargo run --release
```

It ships its own from-scratch LZO1X decompressor, UE3 package parser and DXT (BC1/BC3)
codec. It loads every cooked `.upk`, browses objects, edits int/float/bool/byte properties
in place, previews and exports textures to PNG (reading streamed mips from `.tfc`), replaces
textures from PNG, exports and replaces sounds (OGG/WAV), and writes a game-loadable package
back out.

## Notes

- Everything is discovered at runtime — GNames/GObjects, property/bitmask/super-class
  offsets, the ProcessEvent vtable index. No build-specific addresses are baked in.
- `tools/gen_sdk.py` turns an in-game F2 dump into typed offset accessors; `gen_reference.py`
  turns it into the browsable `hysteria_reference.txt` API map.
