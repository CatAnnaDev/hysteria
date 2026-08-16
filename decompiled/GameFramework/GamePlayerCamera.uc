class GamePlayerCamera extends Camera
    native
    notplaceable
    transient
    config(Camera)
    hidecategories(Navigation);

var(Camera) transient editinline GameCameraBase ThirdPersonCam;
var(Camera) const class<GameCameraBase> ThirdPersonCameraClass;
var(Camera) transient editinline GameCameraBase FixedCam;
var(Camera) const class<GameCameraBase> FixedCameraClass;
var(Camera) transient editinline GameCameraBase FreeCam;
var(Camera) const class<GameCameraBase> FreeCameraClass;
var(Camera) transient editinline GameCameraBase CurrentCamera;
var transient bool bUseForcedCamFOV;
var transient bool bInterpolateCamChanges;
var transient bool bResetInterp;
var transient float ForcedCamFOV;
var transient Actor LastViewTarget;
var() const float SplitScreenShakeScale;
var transient Actor LastTargetBase;
var transient Matrix LastTargetBaseTM;

native protected final function float AdjustFOVForViewport(float inHorizFOV, Pawn CameraTargetPawn)
{
    inHorizFOV;
    CameraTargetPawn;
}

function bool GetActualLookatLocation(out Vector FocusLoc, Actor FocusActor)
{
}

function ClearFocusActor()
{
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    DeltaRotFromInput = out_DeltaRot;
    ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    if (CurrentCamera != none)
    {
        CurrentCamera.ProcessViewRotation(DeltaTime, ViewTarget.Target, out_ViewRotation, out_DeltaRot);
    }
}

simulated function ResetInterpolation()
{
    bResetInterp = true;
}

simulated function SetColorScale(Vector NewColorScale)
{
    if (bEnableColorScaling == true)
    {
        bEnableColorScaling = true;
        ColorScale = NewColorScale;
        bEnableColorScaleInterp = false;
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    
    DisplayDebug(HUD, out_YL, out_YPos);
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("\tThirdPersonCam CameraOrigin:" @ string(GameThirdPersonCamera(ThirdPersonCam).LastActualCameraOrigin) @ "LastViewOffset:" @ string(GameThirdPersonCamera(ThirdPersonCam).LastViewOffset));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
}

simulated function ExecCameraLensEffects(out Vector CamLoc, out Rotator CamRot, float CamFOVDeg)
{
    local int Idx;
    
    for (Idx = 0; Idx < CameraLensEffects.Length; ++Idx)
    {
        if (CameraLensEffects[Idx] != none)
        {
            CameraLensEffects[Idx].UpdateLocation(CamLoc, CamRot, CamFOVDeg);
        }
    }
}

simulated function UpdateCameraLensEffects(out const TViewTarget OutVT)
{
    local int Idx;
    
    for (Idx = 0; Idx < CameraLensEffects.Length; ++Idx)
    {
        if (CameraLensEffects[Idx] != none)
        {
            CameraLensEffects[Idx].UpdateLocation(OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
        }
    }
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Pawn P;
    local GameCameraBase NewCamera;
    local CameraActor CamActor;
    
    if (PendingViewTarget.Target != none && OutVT == ViewTarget && BlendParams.bLockOutgoing)
    {
        return;
    }
    if (OutVT.Target == none)
    {
        LogInternal("Camera::UpdateViewTarget OutVT.Target == None");
        return;
    }
    P = Pawn(OutVT.Target);
    NewCamera = FindBestCameraType(OutVT.Target);
    if (CurrentCamera != NewCamera)
    {
        if (CurrentCamera != none)
        {
            CurrentCamera.OnBecomeInActive(NewCamera);
        }
        if (NewCamera != none)
        {
            NewCamera.OnBecomeActive(CurrentCamera);
        }
        CurrentCamera = NewCamera;
    }
    if (CurrentCamera != none)
    {
        if (bResetInterp && !bInterpolateCamChanges)
        {
            CurrentCamera.ResetInterpolation();
        }
        CamActor = CameraActor(OutVT.Target);
        if (CamActor != none)
        {
            bNonGamePlayCamera = !CamActor.bGamePlayCamera;
            CamActor.GetCameraView(DeltaTime, OutVT.POV);
            if (CurrentCamera == FixedCam && CamActor.bConstrainAspectRatio)
            {
                bConstrainAspectRatio = true;
                OutVT.AspectRatio = CamActor.AspectRatio;
            }
            CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
            if (CamOverridePostProcessAlpha > 0.0)
            {
                CamPostProcessSettings = CamActor.CamOverridePostProcess;
            }
            ApplyCameraModifiers(DeltaTime, OutVT.POV);
            UpdateCameraControl(CamActor, OutVT);
        }
        else
        {
            bNonGamePlayCamera = false;
            AccumulatedRotFromInput = rotator(vect(0.0, 0.0, 0.0));
            CurrentCamera.UpdateCamera(P, self, DeltaTime, OutVT);
        }
        if (CameraStyle == 'FreeCam_Default')
        {
            UpdateViewTarget(OutVT, DeltaTime);
        }
    }
    else
    {
        UpdateViewTarget(OutVT, DeltaTime);
    }
    if (bUseForcedCamFOV)
    {
        OutVT.POV.FOV = ForcedCamFOV;
    }
    OutVT.POV.FOV = AdjustFOVForViewport(OutVT.POV.FOV, P);
    SetRotation(OutVT.POV.Rotation);
    SetLocation(OutVT.POV.Location);
    UpdateCameraLensEffects(OutVT);
    CacheLastTargetBaseInfo(OutVT.Target.Base);
    bResetInterp = false;
}

function bool ShouldConstrainAspectRatio()
{
    return false;
}

protected function GameCameraBase FindBestCameraType(Actor CameraTarget)
{
    local GameCameraBase BestCam;
    
    switch (CameraStyle)
    {
        case 'ThirdPerson':
            if (CameraActor(CameraTarget) != none)
            {
                BestCam = FixedCam;
            }
            else
            {
                BestCam = ThirdPersonCam;
            }
            break;
        case 'FreeCam':
            BestCam = FreeCam;
            break;
        default:
            BestCam = ThirdPersonCam;
            break;
    }
    return BestCam;
}

function Reset()
{
    bUseForcedCamFOV = false;
}

function PostBeginPlay()
{
    PostBeginPlay();
    if (ThirdPersonCam == none && ThirdPersonCameraClass != none)
    {
        ThirdPersonCam = CreateCamera(ThirdPersonCameraClass);
    }
    if (FixedCam == none && FixedCameraClass != none)
    {
        FixedCam = CreateCamera(FixedCameraClass);
    }
    if (FreeCam == none && FreeCameraClass != none)
    {
        FreeCam = CreateCamera(FreeCameraClass);
    }
}

native protected function CacheLastTargetBaseInfo(Actor TargetBase)
{
    TargetBase;
}

protected function GameCameraBase CreateCamera(class<GameCameraBase> CameraClass)
{
    local GameCameraBase NewCam;
    
    NewCam = new(Outer) CameraClass;
    NewCam.PlayerCamera = self;
    NewCam.Init();
    return NewCam;
}

defaultproperties
{
    ThirdPersonCameraClass="GameThirdPersonCamera"
    FixedCameraClass="GameFixedCamera"
    FreeCameraClass="GameFreeCamera"
    CameraStyle="Default"
    DefaultFOV=70.0
}
