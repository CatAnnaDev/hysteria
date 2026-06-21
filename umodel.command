#!/bin/bash
# Hysteria — launch UModel (UE Viewer) 3D mesh browser on Alice: Madness Returns.
# Browse packages, view SkeletalMesh/StaticMesh in 3D, export OBJ/glTF/textures.
# Controls: drag = rotate, wheel = zoom, PageUp/PageDown = cycle objects,
#           O = export current, Esc = back to package list.
CXROOT="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver"
CKW="C:\\Program Files (x86)\\EA Games\\Alice Madness Returns\\Game\\Alice2\\AliceGame\\CookedPC"
exe="C:\\umodel\\umodel_64.exe"
# optional args: <packageName> <objectName>  e.g.  bash umodel.command CH_Alice_Doll_SF SK_Alice_Doll
"$CXROOT/bin/cxstart" --bottle Steam "$exe" -path="$CKW" -game=ue3 "$@"
