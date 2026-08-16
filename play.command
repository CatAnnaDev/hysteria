#!/bin/bash

CXROOT="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver"
BOTTLE_NAME="${BOTTLE_NAME:-Steam}"
BOTTLE="/Users/anna/Library/Application Support/CrossOver/Bottles/$BOTTLE_NAME"
GAME="$BOTTLE/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32"
EXE="${1:-AliceMadnessReturns.exe}"
RES="${RES:-1280x720}"
INST="${INST:-1}"

if [ ! -f "$GAME/$EXE" ]; then
  echo "exe introuvable: $GAME/$EXE"
  ls "$GAME"/*.exe 2>/dev/null | sed 's#.*/##'
  echo "Appuie sur Entrée pour fermer."; read _
  exit 1
fi

ARGS=(-windowed -ResX="${RES%x*}" -ResY="${RES#*x}")
if [ "$INST" != "1" ]; then
  ARGS+=(-CONFIGSUBDIR="P$INST")
fi

echo "=============================================="
echo " Alice: Madness Returns"
echo " bottle : $BOTTLE_NAME   instance : $INST"
echo " exe    : $EXE   fenêtre : $RES (forcé)"
echo "=============================================="

"$CXROOT/bin/cxstart" --bottle "$BOTTLE_NAME" "$GAME/$EXE" "${ARGS[@]}"
RC=$?
echo
echo "Le jeu a quitté (code $RC)."
echo "Appuie sur Entrée pour fermer."; read _
