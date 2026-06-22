# Hysteria — ready-to-use build

Drop-in mods for **Alice: Madness Returns** (Steam, Win32), built on the Hysteria framework
(a `dinput8.dll` proxy + a reflective modding API).

## Install

1. Copy **`dinput8.dll`** into the game's Win32 folder:
   `...\EA Games\Alice Madness Returns\Game\Alice2\Binaries\Win32\`
2. Create a **`Mods`** folder there and drop in the `.dll` of each mod you want.
3. Launch the game. Press **Insert** (or **²**) to open the overlay menu — every mod has its own tab.

Each mod writes its settings to `Mods\<mod>.cfg` next to its dll (auto-created).

## Mods

| Mod | What it does |
|-----|--------------|
| **action** | Full character-action overhaul: combo juggling, DMC-style rank (D→SSS) with style-scaled damage, mana + spells (Hysteria Nova on `X`, Heal on `G`), Hysteria Mode overdrive on `V`, XP/leveling with 10 passives, and a gothic HUD that replaces the native health bar. |
| **rngloot** | Randomize everything: loot amounts, damage, enemy HP/size, hysteria duration, game-speed & gravity chaos, pickup magnet — and the **weapon-unlock order** (the 4 weapons handed to you in a random order). |
| **trainer** | Classic trainer: god mode, fly, noclip, freeze, teleport + savestates, world speed, gravity, FOV, jump height, heal. |
| **abilities** | Extra movement/combat moves: air-jump, dash, blink, slow-mo, speed, shockwave. |
| **autoplay** | Autopilot: approaches enemies, fights, and jumps on its own. |
| **alice** | Toggles for Alice's own systems: unlock abilities, hysteria anytime, shrink / sense. |
| **input** | Mouse fix — kills the native turn-acceleration ramp and mouse smoothing so keyboard+mouse aiming feels right. |
| **fpsunlock** | Raises the 30 FPS cap (smoothed-framerate unlock). |
| **dlcunlock** | Unlocks the Complete Edition content + all DLC (weapons / dresses). |

## Notes

- Mods are independent — run any subset. `action` and `abilities` both bind movement keys, so pick one.
- Source code, the modding API (C / C++ / Rust) and the modding guide are in the main repo.
