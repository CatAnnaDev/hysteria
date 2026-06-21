#!/bin/bash


CXROOT="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver"
BOTTLE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam"
GAME="$BOTTLE/drive_c/Program Files (x86)/EA Games/Alice Madness Returns/Game/Alice2/Binaries/Win32"
EXE="${1:-AliceMadnessReturns.exe}"
RES="${RES:-1600x900}"

if [ ! -f "$GAME/$EXE" ]; then
  echo "exe introuvable: $GAME/$EXE"
  echo "exe dispo dans le dossier du jeu :"
  ls "$GAME"/*.exe 2>/dev/null | sed 's#.*/##'
  echo "Appuie sur Entrée pour fermer."; read _
  exit 1
fi

echo "=============================================="
echo " Alice: Madness Returns — bottle CrossOver"
echo " exe : $EXE   fenêtre : $RES"
echo "=============================================="
echo "Lancement..."

"$CXROOT/bin/cxstart" --bottle Steam "$GAME/$EXE" \
  -windowed -ResX="${RES%x*}" -ResY="${RES#*x}"
RC=$?
echo
echo "Le jeu a quitté (code $RC)."
echo "Astuce: log moteur UE3 -> Game/Alice2/AliceGame/Logs/Launch.log s'il a été créé."
echo "Appuie sur Entrée pour fermer."; read _
