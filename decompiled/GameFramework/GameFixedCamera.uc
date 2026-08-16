class GameFixedCamera extends GameCameraBase
    notplaceable
    config(Camera);

var() const float DefaultFOV;

function OnBecomeActive(GameCameraBase OldCamera)
{
    bResetCameraInterpolation = true;
    OnBecomeActive(OldCamera);
}

simulated function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
    local CameraActor CamActor;
    
    CamActor = CameraActor(OutVT.Target);
    if (CamActor != none)
    {
        OutVT.POV.FOV = CamActor.FOVAngle;
    }
    else
    {
        OutVT.POV.FOV = DefaultFOV;
    }
    if (OutVT.Target != none)
    {
        OutVT.POV.Location = CamActor.Location;
        OutVT.POV.Rotation = CamActor.Rotation;
    }
    PlayerCamera.ApplyCameraModifiers(DeltaTime, OutVT.POV);
    bResetCameraInterpolation = false;
}

defaultproperties
{
    DefaultFOV=80.0
}
