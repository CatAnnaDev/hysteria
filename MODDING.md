# Writing Hysteria mods

A mod is a DLL with one C-ABI export: `ModMain(HysteriaAPI*)`. It can be written in **C, C++
or Rust** (anything that speaks the C ABI). Drop it in `mods/<name>/`, run `mods/build.sh`,
then in game open the menu (`` ` ``) → Modding → **Reload mods** (or relaunch).

The framework gives every mod the same `HysteriaAPI` — a table of functions to read/write any
property, intercept/modify/block any function call, invoke any function, spawn/destroy
actors, run console commands, and log. Objects are opaque handles (`AObj`).

## Quickstart

### C — `mods/hello/hello.c`
```c
#include <windows.h>
#include "hysteria_api.h"
static HysteriaAPI *A;
static void on_dmg(AEvent *e){ if(e->self==A->player_pawn()) e->block=1; }
__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A=api;
    api->log("hello from C");
    api->on("TakeDamage", on_dmg);
}
```

### C++ — `mods/hello_cpp/hello_cpp.cpp`  (use `hysteria.hpp` — lambdas + std::string)
```cpp
#include "hysteria.hpp"
using namespace hysteria;
HYSTERIA_MOD() {
    log("hello from C++");
    on("TakeDamage", [](Event& e){ if (e.self() == player_pawn()) e.block(); }); // godmode
    on_tick([]{ if (key_pressed(VK_F11)) console("God"); });
}
```

### Rust — `mods/hello_rust/`  (copy `hysteria_api.rs` + `hysteria.rs` into `src/`)
`Cargo.toml`: `crate-type=["cdylib"]`, `[profile.release] panic="abort"`.
```rust
mod hysteria_api; mod hysteria; use hysteria::*;
#[no_mangle] pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    log("hello from Rust");
    on("TakeDamage", |e| if e.this() == player_pawn() { e.block(); });   // godmode
    on_tick(|| if key_pressed(0x7A) { console("God"); });                 // 0x7A = VK_F11
}
```

The wrappers (`hysteria.hpp`, `hysteria.rs`) handle capturing lambdas/closures, strings and
all the unsafe FFI for you. Plain C uses the raw `hysteria_api.h` directly (see below).

### Editor setup
`compile_commands.json` (root, regenerate with `tools/gen_ccmds.py`) makes clangd/Neovide
resolve `windows.h` and the API headers via the mingw toolchain — no false errors.

## Build

```
mods/build.sh        # builds every mod: .c (gcc), .cpp (g++), Cargo.toml (cargo build-std)
```
Toolchains: `i686-w64-mingw32-gcc/g++` (Homebrew mingw-w64). Rust needs nightly +
`rustup target add i686-pc-windows-gnu` + `rustup component add rust-src` (build.sh uses
`-Z build-std=std,panic_abort`, which yields a self-contained DLL with no runtime deps).

## What you can do

Reflection — find and walk the live object graph (≈120k objects)
```c
AObj pc   = api->player_controller();
AObj pawn = api->player_pawn();
AObj wi   = api->find_object("WorldInfo");
api->iter_objects("AlicePawn", cb);     // cb(AObj) for every enemy/pawn
api->is_a(o, "Pawn"); api->class_of(o); api->name_of(o);
```

Read / write any property by name (resolved through the class hierarchy)
```c
int hp; api->get_int(pawn, "Health", &hp);
api->set_int(pawn, "Health", 999);
api->set_bool(pawn, "bCanFly", 1);
api->set_float(wi, "TimeDilation", 0.3f);   // slow-mo
```

Intercept any function call — pre-hooks can edit params and cancel the call;
post-hooks can edit the return value
```c
void on_take_damage(AEvent *e){
    if(e->self == A->player_pawn()) e->block = 1;        // godmode
    int amount; A->param_get_int(e, "Damage", &amount);  // read a param
    A->param_set_int(e, "Damage", amount/2);             // halve it
}
void on_get_score(AEvent *e){ A->ret_set_int(e, 9999); } // override return value
api->on("TakeDamage", on_take_damage);
api->on_post("GetScore", on_get_score);
```

Invoke anything the game can do — **any function, any typed params, by name**
```c
// generic typed call: build args by name, invoke, read out-params / return value
ACall c = api->call_begin(pawn, "TakeDamage");
api->call_arg_int(c, "Damage", 50);
api->call_arg_obj(c, "InstigatedBy", api->player_controller());
api->call_invoke(c);
int dealt; api->call_out_int(c, "ReturnValue", &dealt);

api->console(pc, "God");                 // any exec/console command
api->call_str(obj, "PlayBink", "Intro"); // shortcut: single string arg
api->call(obj, "SomeFunction", params);  // raw, hand-built param block
api->spawn("AliceClockworkBomb", x, y, z);
api->destroy(actor);
```
C++ and Rust get a fluent builder over the same thing:
```cpp
call(pawn, "TakeDamage").i("Damage", 50).o("InstigatedBy", player_controller()).invoke();
int dealt = call(pawn, "GetHealth").invoke().ret_int();
```
```rust
call(pawn, "TakeDamage").int("Damage", 50).obj("InstigatedBy", player_controller()).invoke();
let dealt = call(pawn, "GetHealth").invoke().ret_int();
```

Discover names live with the **Live Editor** (Modding → Live Editor): search objects,
click one, see and edit all its properties in real time. Use it to find property/function
names for your mod. Press **F2** in game to dump the full SDK to `C:\hysteria_dump_all.txt`,
and `tools/gen_sdk.py` to turn it into typed offset macros (`hysteria_sdk.h`).

## The whole game, mapped

`hysteria_reference.txt` (regenerate with `tools/gen_reference.py`) is the complete surface
the game exposes — **1861 classes, 13900 properties, 8272 functions** — every class with its
typed properties and every function with its parameter signature. All of it is reachable by
name through the API: `get_*/set_*` for any property, `on()` for any function, `console`/
`call` to invoke. Grep it to find anything:

```
grep -A40 '^=== AlicePawn ===' hysteria_reference.txt   # everything on the player
grep -ri 'health'             hysteria_reference.txt   # every health-related member
```

## Patterns

- **Toggle a cheat**: keep a `static int on` in your mod, flip it from a hook, gate behavior.
- **Per-frame logic**: hook `PlayerTick` (fires every frame on the controller).
- **Player-only effects**: compare `e->self == api->player_pawn()` / `player_controller()`.
- **Hot iteration**: edit your `.c`, `mods/build.sh`, click Reload mods — no relaunch.

## Coverage

- **Reflection**: every one of the ~120k live objects, 1861 classes, 13900 properties — read
  and write, by name, resolved through the class hierarchy. Nothing is out of reach.
- **Interception**: every one of the 8272 functions can be hooked with `on()`/`on_post()` —
  read/edit params, block the call, override the return value.
- **UI**: mods draw their own overlay panels (`ui_panel` + widgets) — see `mods/mousetune`.
- **Assets**: read/edit/replace/export via **Hysteria Studio** (textures, sounds, properties,
  package repack) — separate cross-platform app in `studio/`.

## Limits (today)

- Dispatch matches by function name (all objects); filter by `e->self` for one actor.
- `call_begin`/`call_arg_*` cover scalar params (int/float/bool/object/string) — the common
  case. Functions taking nested **structs or dynamic arrays** still need a hand-built param
  block via `call` (use the signature in `hysteria_reference.txt` to lay out the block).
