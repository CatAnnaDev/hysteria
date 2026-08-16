class CameraModifier extends Object
    native
    notplaceable;

var bool bDisabled;
var bool bPendingDisable;
var bool bGamePlayCamera;
var bool bExclusive;
var(Debug) bool bDebug;
var Camera CameraOwner;
var byte Priority;
var float AlphaInTime;
var float AlphaOutTime;
var transient float Alpha;
var transient float TargetAlpha;

native function UpdateAlpha(Camera Camera, float DeltaTime)
{
    Camera;
    DeltaTime;
}

simulated function bool ProcessViewRotation(Actor ViewTarget, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
}

function ToggleModifier()
{
    if (bDebug)
    {
        LogInternal(string(self) @ "ToggleModifier");
    }
    if (bDisabled)
    {
        EnableModifier();
    }
    else
    {
        DisableModifier();
    }
}

function EnableModifier()
{
    if (bDebug)
    {
        LogInternal(string(self) @ "EnableModifier");
    }
    bDisabled = false;
    bPendingDisable = false;
}

event DisableModifier(optional bool bImmediate)
{
    if (bDebug)
    {
        LogInternal(string(self) @ "DisableModifier" @ string(bImmediate));
    }
    if (bImmediate)
    {
        bDisabled = true;
        bPendingDisable = false;
    }
    else if (!bDisabled)
    {
        bPendingDisable = true;
    }
}

function bool RemoveCameraModifier(Camera Camera)
{
    local int ModifierIdx;
    
    if (bDebug)
    {
        LogInternal(string(self) @ "RemoveModifier");
    }
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx] == self)
        {
            Camera.ModifierList.Remove(ModifierIdx, 1);
            return true;
        }
    }
    return false;
}

function bool AddCameraModifier(Camera Camera)
{
    local int BestIdx, ModifierIdx;
    local CameraModifier Modifier;
    
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx] == self)
        {
            return false;
        }
    }
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx].Class == Class)
        {
            LogInternal("AddCameraModifier found existing modifier in list, replacing with new one" @ string(self));
            Camera.ModifierList[ModifierIdx] = self;
            CameraOwner = Camera;
            return true;
        }
    }
    BestIdx = 0;
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        Modifier = Camera.ModifierList[ModifierIdx];
        if (Modifier == none)
        {
            continue;
        }
        if (Priority <= Modifier.Priority)
        {
            if (bExclusive && Priority == Modifier.Priority)
            {
                return false;
            }
            break;
        }
        BestIdx++;
    }
    Camera.ModifierList.Insert(BestIdx, 1);
    Camera.ModifierList[BestIdx] = self;
    CameraOwner = Camera;
    if (bDebug)
    {
        LogInternal("AddModifier" @ string(BestIdx) @ string(self));
        for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
        {
            LogInternal(string(Camera.ModifierList[ModifierIdx]) @ "Idx" @ string(ModifierIdx) @ "Pri" @ string(Camera.ModifierList[ModifierIdx].Priority));
        }
        LogInternal("****************");
    }
    return true;
}

native function bool IsDisabled()
{
}

native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    Camera;
    DeltaTime;
    OutPOV;
}

function Init()
{
}

defaultproperties
{
    Priority=127
}
