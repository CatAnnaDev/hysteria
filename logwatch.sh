#!/bin/bash
B="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam"
OURS="$B/drive_c/hysteria.log"
ALICE_UE="$B/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/AliceGame/Logs/Launch.log"
ALICE_STDOUT="/tmp/g.log"

C_OURS=$'\033[1;35m'; C_UE=$'\033[1;36m'; C_WINE=$'\033[0;90m'; C_OFF=$'\033[0m'

echo "==== HYSTERIA LOG CONSOLE (Alice) ===="
echo "  ${C_OURS}[HYSTERIA]${C_OFF} = notre dll   ${C_UE}[UE]${C_OFF} = log Unreal Alice   ${C_WINE}[wine]${C_OFF} = stdout/erreurs"
echo "  (Ctrl+C pour quitter)"
echo "====================================="

: > "$OURS" 2>/dev/null
touch "$ALICE_STDOUT" 2>/dev/null

tail -n0 -F "$OURS"         2>/dev/null | sed -u "s/^/${C_OURS}[HYSTERIA]${C_OFF} /" &
tail -n0 -F "$ALICE_UE"     2>/dev/null | sed -u "s/^/${C_UE}[UE-Alice]${C_OFF} /" &
tail -n0 -F "$ALICE_STDOUT" 2>/dev/null | sed -u "s/^/${C_WINE}[wine-Alice]${C_OFF} /" &

trap 'kill $(jobs -p) 2>/dev/null' EXIT
wait
