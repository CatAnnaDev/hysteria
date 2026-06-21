#!/bin/bash
set -e
cd "$(dirname "$0")"

SRC="proxy.c mem.c props.c camera.c render.c cheats.c dump.c entities.c alice.c mod_hook.c mod_api.c console.c ui.c ui_d3d11.c frame.c d3d11hook.c"
CC=i686-w64-mingw32-gcc
$CC -O2 -shared -o dinput8.dll $SRC dinput8.def -Wl,--kill-at -lkernel32 -luser32 -lgdi32
echo "built dinput8.dll ($(ls -la dinput8.dll | awk '{print $5}') bytes)"

BOTTLE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam"
WIN32="$BOTTLE/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32"
if [ -d "$WIN32" ]; then
  cp dinput8.dll "$WIN32/dinput8.dll"
  echo "deployed to bottle"
fi
