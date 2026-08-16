class CameraModifier_CameraShake extends CameraModifier
    native
    notplaceable
    config(Camera);

struct native CameraShakeInstance
{
    var CameraShake SourceShake;
    var float OscillatorTimeRemaining;
    var bool bBlendingIn;
    var float CurrentBlendInTime;
    var bool bBlendingOut;
    var float CurrentBlendOutTime;
    var Vector LocSinOffset;
    var Vector RotSinOffset;
    var float FOVSinOffset;
    var float Scale;
    var CameraAnimInst AnimInst;
    var ECameraAnimPlaySpace PlaySpace;
    var Matrix UserPlaySpaceMatrix;
};

var array<CameraShakeInstance> ActiveShakes;
var() const float SplitScreenShakeScale;

native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    Camera;
    DeltaTime;
    OutPOV;
}

native function UpdateCameraShake(float DeltaTime, out CameraShakeInstance Shake, out TPOV OutPOV)
{
    DeltaTime;
    Shake;
    OutPOV;
}

function RemoveAllCameraShakes()
{
    local int Idx;
    local CameraAnimInst AnimInst;
    
    for (Idx = 0; Idx < ActiveShakes.Length; ++Idx)
    {
        AnimInst = ActiveShakes[Idx].AnimInst;
        if (AnimInst != none && !AnimInst.bFinished)
        {
            CameraOwner.StopCameraAnim(AnimInst, true);
        }
    }
    ActiveShakes.Length = 0;
}

function RemoveCameraShake(CameraShake Shake)
{
    local int Idx;
    local CameraAnimInst AnimInst;
    
    Idx = ActiveShakes.Find('SourceShake', Shake);
    if (Idx != -1)
    {
        AnimInst = ActiveShakes[Idx].AnimInst;
        if (AnimInst != none && !AnimInst.bFinished)
        {
            CameraOwner.StopCameraAnim(AnimInst, true);
        }
        ActiveShakes.Remove(Idx, 1);
    }
}

function RemoveCameraShakesWithOuter(name Outermost)
{
    local int Idx;
    local CameraAnimInst AnimInst;
    
    for (Idx = 0; Idx < ActiveShakes.Length; Idx++)
    {
        if (ActiveShakes[Idx].SourceShake.GetPackageName() == Outermost)
        {
            AnimInst = ActiveShakes[Idx].AnimInst;
            if (AnimInst != none && !AnimInst.bFinished)
            {
                CameraOwner.StopCameraAnim(AnimInst, true);
            }
            ActiveShakes.Remove(Idx, 1);
            Idx--;
        }
    }
}

function AddCameraShake(CameraShake NewShake, float Scale, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    local int ShakeIdx, NumShakes;
    
    if (NewShake != none)
    {
        if (NewShake.bSingleInstance)
        {
            ShakeIdx = ActiveShakes.Find('SourceShake', NewShake);
            if (ShakeIdx != -1)
            {
                ReinitShake(ShakeIdx, Scale);
                return;
            }
        }
        NumShakes = ActiveShakes.Length;
        ActiveShakes[NumShakes] = InitializeShake(NewShake, Scale, PlaySpace, UserPlaySpaceRot);
    }
}

protected function CameraShakeInstance InitializeShake(CameraShake NewShake, float Scale, ECameraAnimPlaySpace PlaySpace, optional Rotator UserPlaySpaceRot)
{
    local CameraShakeInstance Inst;
    local float Duration;
    local bool bRandomStart, bLoop;
    
    Inst.SourceShake = NewShake;
    Inst.Scale = Scale;
    if (class'Engine'.static.IsSplitScreen())
    {
        Scale *= SplitScreenShakeScale;
    }
    if (NewShake.OscillationDuration != 0.0)
    {
        Inst.RotSinOffset.X = InitializeOffset(NewShake.RotOscillation.Pitch);
        Inst.RotSinOffset.Y = InitializeOffset(NewShake.RotOscillation.Yaw);
        Inst.RotSinOffset.Z = InitializeOffset(NewShake.RotOscillation.Roll);
        Inst.LocSinOffset.X = InitializeOffset(NewShake.LocOscillation.X);
        Inst.LocSinOffset.Y = InitializeOffset(NewShake.LocOscillation.Y);
        Inst.LocSinOffset.Z = InitializeOffset(NewShake.LocOscillation.Z);
        Inst.FOVSinOffset = InitializeOffset(NewShake.FOVOscillation);
        Inst.OscillatorTimeRemaining = NewShake.OscillationDuration;
        if (NewShake.OscillationBlendInTime > 0.0)
        {
            Inst.bBlendingIn = true;
            Inst.CurrentBlendInTime = 0.0;
        }
    }
    if (NewShake.Anim != none)
    {
        if (NewShake.bRandomAnimSegment)
        {
            bLoop = true;
            bRandomStart = true;
            Duration = NewShake.RandomAnimSegmentDuration;
        }
        if (Scale > 0.0)
        {
            Inst.AnimInst = CameraOwner.PlayCameraAnim(NewShake.Anim, NewShake.bGamePlayCamera, NewShake.AnimPlayRate, Scale, NewShake.AnimBlendInTime, NewShake.AnimBlendOutTime, bLoop, bRandomStart, Duration, NewShake.bSingleInstance);
            if (PlaySpace != 0 && Inst.AnimInst != none)
            {
                Inst.AnimInst.SetPlaySpace(PlaySpace, UserPlaySpaceRot);
            }
        }
    }
    Inst.PlaySpace = PlaySpace;
    if (Inst.PlaySpace == 2)
    {
        Inst.UserPlaySpaceMatrix = MakeRotationMatrix(UserPlaySpaceRot);
    }
    return Inst;
}

protected function ReinitShake(int ActiveShakeIdx, float Scale)
{
    local CameraShake SourceShake;
    local float Duration;
    local bool bRandomStart, bLoop;
    
    if (class'Engine'.static.IsSplitScreen())
    {
        Scale *= SplitScreenShakeScale;
    }
    ActiveShakes[ActiveShakeIdx].Scale = Scale;
    SourceShake = ActiveShakes[ActiveShakeIdx].SourceShake;
    if (SourceShake.OscillationDuration != 0.0)
    {
        ActiveShakes[ActiveShakeIdx].OscillatorTimeRemaining = SourceShake.OscillationDuration;
        if (ActiveShakes[ActiveShakeIdx].bBlendingOut)
        {
            ActiveShakes[ActiveShakeIdx].bBlendingOut = false;
            ActiveShakes[ActiveShakeIdx].CurrentBlendOutTime = 0.0;
            ActiveShakes[ActiveShakeIdx].bBlendingIn = true;
            ActiveShakes[ActiveShakeIdx].CurrentBlendInTime = ActiveShakes[ActiveShakeIdx].SourceShake.OscillationBlendInTime * (1.0 - ActiveShakes[ActiveShakeIdx].CurrentBlendOutTime / ActiveShakes[ActiveShakeIdx].SourceShake.OscillationBlendOutTime);
        }
    }
    if (SourceShake.Anim != none)
    {
        if (SourceShake.bRandomAnimSegment)
        {
            bLoop = true;
            bRandomStart = true;
            Duration = SourceShake.RandomAnimSegmentDuration;
        }
        ActiveShakes[ActiveShakeIdx].AnimInst = CameraOwner.PlayCameraAnim(SourceShake.Anim, SourceShake.bGamePlayCamera, SourceShake.AnimPlayRate, Scale, SourceShake.AnimBlendInTime, SourceShake.AnimBlendOutTime, bLoop, bRandomStart, Duration, true);
    }
}

protected static function float InitializeOffset(out const FOscillator Param)
{
    switch (Param.InitialOffset)
    {
        case 0:
            return FRand() * float(2) * 3.1415927;
            break;
        case 1:
            return 0.0;
            break;
        default:
    }
    return 0.0;
}

defaultproperties
{
    SplitScreenShakeScale=0.5
}
