class GameCameraBase extends Object
    abstract
    native
    notplaceable
    config(Camera);

var transient GamePlayerCamera PlayerCamera;
var transient bool bResetCameraInterpolation;

event ModifyPostProcessSettings(out PostProcessSettings PP)
{
}

function Init()
{
}

function ProcessViewRotation(float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
}

function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
}

function ResetInterpolation()
{
    bResetCameraInterpolation = true;
}

function OnBecomeInActive(GameCameraBase NewCamera)
{
}

function OnBecomeActive(GameCameraBase OldCamera)
{
}

defaultproperties
{
}
