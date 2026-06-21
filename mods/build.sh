#!/bin/bash
cd "$(dirname "$0")"
API="$(cd ../hysteria && pwd)"
BOTTLE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam"
MODS="$BOTTLE/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32/Mods"
mkdir -p "$MODS"
GCC=i686-w64-mingw32-gcc
GXX=i686-w64-mingw32-g++

for dir in */; do
  name=$(basename "$dir")
  if [ -f "$dir/Cargo.toml" ]; then
    ( cd "$dir" && cargo +nightly build --release --quiet -Z build-std=std,panic_abort --target i686-pc-windows-gnu ) || { echo "rust FAIL: $name"; continue; }
    out="$dir/target/i686-pc-windows-gnu/release/$name.dll"
    [ -f "$out" ] && cp "$out" "$MODS/$name.dll" && echo "rust  mod: $name.dll"
  elif [ -f "$dir/$name.cpp" ]; then
    $GXX -O2 -std=c++17 -shared -I"$API" -o "$dir/$name.dll" "$dir/$name.cpp" -Wl,--kill-at -static -static-libgcc -static-libstdc++ -lkernel32 -luser32 2>/dev/null \
      && cp "$dir/$name.dll" "$MODS/$name.dll" && echo "c++   mod: $name.dll" || echo "c++ FAIL: $name"
  elif [ -f "$dir/$name.c" ]; then
    $GCC -O2 -shared -I"$API" -o "$dir/$name.dll" "$dir/$name.c" -Wl,--kill-at -lkernel32 -luser32 2>/dev/null \
      && cp "$dir/$name.dll" "$MODS/$name.dll" && echo "c     mod: $name.dll" || echo "c FAIL: $name"
  fi
done
echo "Mods -> $MODS"
