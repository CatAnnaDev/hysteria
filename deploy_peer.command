#!/bin/bash
set -e
cd "$(dirname "$0")"

W="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32"
OUT="${1:-$HOME/Desktop/alice_coop_payload.tgz}"

tmp=$(mktemp -d)
mkdir -p "$tmp/Win32/Mods"
cp "$W/dinput8.dll" "$tmp/Win32/dinput8.dll"
for m in coop input cheats; do
  [ -f "$W/Mods/$m.dll" ] && cp "$W/Mods/$m.dll" "$tmp/Win32/Mods/$m.dll"
done
cp play_amr.command play_amr2.command "$tmp/" 2>/dev/null || true

cat > "$tmp/INSTALLER.txt" <<'TXT'
Deposer dinput8.dll et le dossier Mods dans le dossier du jeu :
  .../AMR/Binaries/Win32/

Puis regler l adresse du pair dans Mods/coop.cfg :
  peer_ip0=192
  peer_ip1=168
  peer_ip2=1
  peer_ip3=<dernier octet de l AUTRE mac>
  listen_port=7777
  discover_lan=1

Sur CHAQUE mac, autoriser l UDP entrant ou couper le pare-feu le temps du test.
TXT

tar -czf "$OUT" -C "$tmp" .
rm -rf "$tmp"
echo "paquet pret : $OUT"
tar -tzf "$OUT" | sed 's/^/  /'
