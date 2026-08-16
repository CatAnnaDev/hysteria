#!/bin/bash
set -e
cd "$(dirname "$0")"

SRC="proxy.c instance.c mem.c props.c camera.c render.c cheats.c dump.c entities.c alice.c mod_hook.c mod_api.c console.c ui.c frame.c cfg.c gamelog.c"
CC=i686-w64-mingw32-gcc
$CC -O2 -shared -o dinput8.dll $SRC dinput8.def -Wl,--kill-at -lkernel32 -luser32 -lgdi32
echo "built dinput8.dll ($(ls -la dinput8.dll | awk '{print $5}') bytes)"

TARGETS=(
  "/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32"
  "/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32"
)
for WIN32 in "${TARGETS[@]}"; do
  if [ -d "$WIN32" ]; then
    cp dinput8.dll "$WIN32/dinput8.dll"
    echo "deployed -> $WIN32"
  fi
done

PEER_WIN32="/Volumes/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32"
if [ -d "$PEER_WIN32" ]; then
  cp dinput8.dll "$PEER_WIN32/dinput8.dll"
  echo "deployed -> 2e mac ($PEER_WIN32)"
else
  echo "!! 2e mac NON MONTE, framework deploye seulement en local"
fi
