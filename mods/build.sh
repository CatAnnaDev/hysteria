#!/bin/bash
cd "$(dirname "$0")"
API="$(cd ../hysteria && pwd)"
BOTTLE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c"
if [ -n "$MODS_DIR" ]; then
  TARGETS=("$MODS_DIR")
else
  TARGETS=(
    "$BOTTLE/users/crossover/Desktop/AMR/Binaries/Win32/Mods"
    "$BOTTLE/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32/Mods"
  )
fi
for t in "${TARGETS[@]}"; do
  [ -d "$(dirname "$t")" ] && mkdir -p "$t"
done
deploy(){ local ok=1; for t in "${TARGETS[@]}"; do [ -d "$t" ] && { cp "$1" "$t/$2" || ok=0; }; done; return $((1-ok)); }
GCC=i686-w64-mingw32-gcc
GXX=i686-w64-mingw32-g++

ACTIVE_LIST=" $(tr -d '\r' < ACTIVE 2>/dev/null | tr '\n' ' ') "
is_active(){ case "$ACTIVE_LIST" in *" $1 "*) return 0;; esac; return 1; }

for dir in */; do
  name=$(basename "$dir")
  if [ -n "${ACTIVE_LIST// /}" ] && ! is_active "$name"; then continue; fi
  if [ -f "$dir/Cargo.toml" ]; then
    ( cd "$dir" && cargo +nightly build --release --quiet -Z build-std=std,panic_abort --target i686-pc-windows-gnu ) || { echo "rust FAIL: $name"; continue; }
    out="$dir/target/i686-pc-windows-gnu/release/$name.dll"
    [ -f "$out" ] && deploy "$out" "$name.dll" && echo "rust  mod: $name.dll"
  elif [ -f "$dir/$name.cpp" ]; then
    $GXX -O2 -std=c++17 -shared -I"$API" -o "$dir/$name.dll" "$dir/$name.cpp" -Wl,--kill-at -static -static-libgcc -static-libstdc++ -lkernel32 -luser32 -lws2_32 2>/dev/null \
      && deploy "$dir/$name.dll" "$name.dll" && echo "c++   mod: $name.dll" || echo "c++ FAIL: $name"
  elif [ -f "$dir/$name.c" ]; then
    $GCC -O2 -shared -I"$API" -o "$dir/$name.dll" "$dir"/*.c -Wl,--kill-at -lkernel32 -luser32 -lws2_32 -lm \
      && deploy "$dir/$name.dll" "$name.dll" && echo "c     mod: $name.dll" || echo "c FAIL: $name"
  fi
done
for t in "${TARGETS[@]}"; do [ -d "$t" ] && echo "Mods -> $t"; done

MODS_PEER="/Volumes/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32/Mods"
SRC_MODS="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32/Mods"
if [ -d "$MODS_PEER" ]; then
  for n in $ACTIVE_LIST; do
    if [ -f "$SRC_MODS/$n.dll" ]; then
      cp "$SRC_MODS/$n.dll" "$MODS_PEER/$n.dll"
      echo "  -> 2e mac: $n.dll"
    fi
  done
else
  echo "  !! 2e mac NON MONTE, mods deployes seulement en local"
fi
