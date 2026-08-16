#!/bin/bash
CXBIN="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/bin"
GAMEDIR="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/Binaries/Win32"
EXE='C:\users\crossover\Desktop\AMR\Binaries\Win32\AliceMadnessReturns.exe'
RES="${RES:-1280x720}"
INST="${INST:-1}"
CFGSUB="${CFGSUB:-1}"

ARGS=(-windowed -ResX="${RES%x*}" -ResY="${RES#*x}")
if [ "$INST" != "1" ]; then
  ARGS+=(-hysteria-multi)
  [ "$CFGSUB" = "1" ] && ARGS+=(-CONFIGSUBDIR="P$INST")
fi

cd "$GAMEDIR" || { echo "dossier du jeu introuvable"; exit 1; }
echo "AMR — instance $INST — $RES — cwd=$(pwd | sed 's#.*/##')"
[ "$INST" != "1" ] && echo "mutex UnrealEngine3_3 contourne"
exec "$CXBIN/wine" --bottle Steam --cx-app "$EXE" "${ARGS[@]}"
