class GameThirdPersonCamera extends GameCameraBase
    native
    notplaceable
    config(Camera);

struct native PenetrationAvoidanceFeeler
{
    var() Rotator AdjustmentRot;
    var() float WorldWeight;
    var() float PawnWeight;
    var() Vector Extent;
};

struct native CamFocusPointParams
{
    var() Actor FocusActor;
    var() name FocusBoneName;
    var() Vector FocusWorldLoc;
    var() float CameraFOV;
    var() Vector2D InterpSpeedRange;
    var() Vector2D InFocusFOV;
    var() bool bAlwaysFocus;
    var() bool bAdjustCamera;
    var() bool bIgnoreTrace;
    var() float FocusPitchOffsetDeg;
};

var transient Vector LastActualCameraOrigin;
var float WorstLocBlockedPct;
var() float WorstLocPenetrationExtentScale;
var() float PenetrationBlendOutTime;
var() float PenetrationBlendInTime;
var float PenetrationBlockedPct;
var() float PenetrationExtentScale;
var transient Vector LastActualOriginOffset;
var transient Rotator LastActualCameraOriginRot;
var() float OriginOffsetInterpSpeed;
var transient Vector LastViewOffset;
var transient float LastCamFOV;
var() editinline GameThirdPersonCameraMode ThirdPersonCamDefault;
var() class<GameThirdPersonCameraMode> ThirdPersonCamDefaultClass;
var() transient editinline GameThirdPersonCameraMode CurrentCamMode;
var transient float LastHeightAdjustment;
var transient float LastPitchAdjustment;
var transient float LastYawAdjustment;
var transient float LeftoverPitchAdjustment;
var(Focus) float Focus_BackOffStrength;
var(Focus) float Focus_StepHeightAdjustment;
var(Focus) int Focus_MaxTries;
var(Focus) float Focus_FastAdjustKickInTime;
var transient float LastFocusChangeTime;
var transient Vector ActualFocusPointWorldLoc;
var transient Vector LastFocusPointLoc;
var(Focus) CamFocusPointParams FocusPoint;
var bool bFocusPointSet;
var transient bool bFocusPointSuccessful;
var bool bDoingACameraTurn;
var bool bTurnAlignTargetWhenFinished;
var() bool bDrawDebug;
var transient bool bDoingDirectLook;
var(Debug) bool bDebugChangedCameraMode;
var float TurnCurTime;
var int TurnStartAngle;
var int TurnEndAngle;
var float TurnTotalTime;
var float TurnDelay;
var transient int LastPostCamTurnYaw;
var transient int DirectLookYaw;
var() float DirectLookInterpSpeed;
var() float WorstLocInterpSpeed;
var transient Vector LastWorstLocationLocal;
var transient Vector LastPreModifierCameraLoc;
var transient Rotator LastPreModifierCameraRot;
var() array<PenetrationAvoidanceFeeler> PenetrationAvoidanceFeelers;
var() const float OffsetAdjustmentInterpSpeed;
var protectedwrite transient Vector LastOffsetAdjustment;

function ResetInterpolation()
{
    ResetInterpolation();
    LastHeightAdjustment = 0.0;
    LastYawAdjustment = 0.0;
    LastPitchAdjustment = 0.0;
    LeftoverPitchAdjustment = 0.0;
}

event ModifyPostProcessSettings(out PostProcessSettings PP)
{
    if (CurrentCamMode != none)
    {
        CurrentCamMode.ModifyPostProcessSettings(PP);
    }
}

function OnBecomeActive(GameCameraBase OldCamera)
{
    if (!PlayerCamera.bInterpolateCamChanges)
    {
        Reset();
    }
    OnBecomeActive(OldCamera);
}

function ProcessViewRotation(float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    if (CurrentCamMode != none)
    {
        CurrentCamMode.ProcessViewRotation(DeltaTime, ViewTarget, out_ViewRotation, out_DeltaRot);
    }
}

protected final function UpdateCameraMode(Pawn P)
{
    local GameThirdPersonCameraMode NewCamMode;
    
    NewCamMode = FindBestCameraMode(P);
    if (NewCamMode != CurrentCamMode)
    {
        if (CurrentCamMode != none)
        {
            CurrentCamMode.OnBecomeInActive(P, NewCamMode);
        }
        if (NewCamMode != none)
        {
            NewCamMode.OnBecomeActive(P, CurrentCamMode);
        }
        bDebugChangedCameraMode = true;
        CurrentCamMode = NewCamMode;
    }
}

function GameThirdPersonCameraMode FindBestCameraMode(Pawn P)
{
    if (P != none)
    {
        return ThirdPersonCamDefault;
    }
    return none;
}

function AdjustFocusPointInterpolation(Rotator Delta)
{
    if (bFocusPointSet && FocusPoint.bAdjustCamera)
    {
        Delta = Normalize(Delta);
        LastYawAdjustment -= float(Delta.Yaw);
        LastPitchAdjustment -= float(Delta.Pitch);
    }
}

function Vector GetActualFocusLocation()
{
    local Vector FocusLoc;
    local SkeletalMeshComponent ComponentIt;
    
    if (FocusPoint.FocusActor != none)
    {
        if (!PlayerCamera.GetActualLookatLocation(FocusLoc, FocusPoint.FocusActor))
        {
            FocusLoc = FocusPoint.FocusActor.Location;
            if (FocusPoint.FocusBoneName != 'None')
            {
                foreach FocusPoint.FocusActor.ComponentList(class'Engine.SkeletalMeshComponent', ComponentIt)
                {
                    if (ComponentIt.MatchRefBone(FocusPoint.FocusBoneName) != -1)
                    {
                        FocusLoc = ComponentIt.GetBoneLocation(FocusPoint.FocusBoneName);
                        break;
                    }
                }
            }
        }
    }
    else
    {
        FocusLoc = FocusPoint.FocusWorldLoc;
    }
    return FocusLoc;
}

protected event UpdateFocusPoint(Pawn P)
{
    if (bFocusPointSet)
    {
        LastFocusPointLoc = ActualFocusPointWorldLoc;
        ActualFocusPointWorldLoc = GetActualFocusLocation();
    }
}

function ClearFocusPoint(optional bool bLeaveCameraRotation)
{
    bFocusPointSet = false;
    if (bLeaveCameraRotation && FocusPoint.bAdjustCamera)
    {
        LastPitchAdjustment = 0.0;
        LastYawAdjustment = 0.0;
        if (PlayerCamera.PCOwner != none)
        {
            PlayerCamera.PCOwner.SetRotation(LastPreModifierCameraRot);
        }
    }
    PlayerCamera.ClearFocusActor();
}

function Actor GetFocusActor()
{
    return bFocusPointSet ? FocusPoint.FocusActor : none;
}

function SetFocusOnActor(Actor FocusActor, name FocusBoneName, Vector2D InterpSpeedRange, Vector2D InFocusFOV, optional float CameraFOV, optional bool bAlwaysFocus, optional bool bAdjustCamera, optional bool bIgnoreTrace, optional float FocusPitchOffsetDeg)
{
    if ((LastPitchAdjustment != float(0) || LastYawAdjustment != float(0)) && !bAdjustCamera && FocusPoint.bAdjustCamera)
    {
        ClearFocusPoint(true);
    }
    FocusPoint.FocusActor = FocusActor;
    FocusPoint.FocusBoneName = FocusBoneName;
    FocusPoint.InterpSpeedRange = InterpSpeedRange;
    FocusPoint.InFocusFOV = InFocusFOV;
    FocusPoint.CameraFOV = CameraFOV;
    FocusPoint.bAlwaysFocus = bAlwaysFocus;
    FocusPoint.bAdjustCamera = bAdjustCamera;
    FocusPoint.bIgnoreTrace = bIgnoreTrace;
    FocusPoint.FocusPitchOffsetDeg = FocusPitchOffsetDeg;
    bFocusPointSet = true;
    LastFocusChangeTime = PlayerCamera.WorldInfo.TimeSeconds;
    LastFocusPointLoc = GetActualFocusLocation();
    bFocusPointSuccessful = false;
}

function SetFocusOnLoc(Vector FocusWorldLoc, Vector2D InterpSpeedRange, Vector2D InFocusFOV, optional float CameraFOV, optional bool bAlwaysFocus, optional bool bAdjustCamera, optional bool bIgnoreTrace, optional float FocusPitchOffsetDeg)
{
    if ((LastPitchAdjustment != float(0) || LastYawAdjustment != float(0)) && !bAdjustCamera && FocusPoint.bAdjustCamera)
    {
        ClearFocusPoint(true);
    }
    FocusPoint.FocusWorldLoc = FocusWorldLoc;
    FocusPoint.FocusActor = none;
    FocusPoint.FocusBoneName = 'None';
    FocusPoint.InterpSpeedRange = InterpSpeedRange;
    FocusPoint.InFocusFOV = InFocusFOV;
    FocusPoint.CameraFOV = CameraFOV;
    FocusPoint.bAlwaysFocus = bAlwaysFocus;
    FocusPoint.bAdjustCamera = bAdjustCamera;
    FocusPoint.bIgnoreTrace = bIgnoreTrace;
    FocusPoint.FocusPitchOffsetDeg = FocusPitchOffsetDeg;
    bFocusPointSet = true;
    LastFocusChangeTime = PlayerCamera.WorldInfo.TimeSeconds;
    LastFocusPointLoc = GetActualFocusLocation();
    bFocusPointSuccessful = false;
}

function AdjustTurn(int AngleOffset)
{
    TurnStartAngle += AngleOffset;
    TurnEndAngle += AngleOffset;
}

native function EndTurn()
{
}

function BeginTurn(int StartAngle, int EndAngle, float TimeSec, optional float DelaySec, optional bool bAlignTargetWhenFinished)
{
    bDoingACameraTurn = true;
    TurnTotalTime = TimeSec;
    TurnDelay = DelaySec;
    TurnCurTime = 0.0;
    TurnStartAngle = StartAngle;
    TurnEndAngle = EndAngle;
    bTurnAlignTargetWhenFinished = bAlignTargetWhenFinished;
}

native protected function PlayerUpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
    P;
    CameraActor;
    DeltaTime;
    OutVT;
}

function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
    if (P == none && OutVT.Target != none)
    {
        OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
    }
    else if (P != none && P.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
    {
        PlayerCamera.ApplyCameraModifiers(DeltaTime, OutVT.POV);
        PlayerUpdateCamera(P, CameraActor, DeltaTime, OutVT);
        return;
    }
    bResetCameraInterpolation = false;
}

event float GetDesiredFOV(Pawn ViewedPawn)
{
    if (bFocusPointSet && FocusPoint.CameraFOV > 0.0 && bFocusPointSuccessful)
    {
        return FocusPoint.CameraFOV;
    }
    return CurrentCamMode.GetDesiredFOV(ViewedPawn);
}

function Init()
{
    if (ThirdPersonCamDefault == none)
    {
        ThirdPersonCamDefault = CreateCameraMode(ThirdPersonCamDefaultClass);
    }
}

function Reset()
{
    bResetCameraInterpolation = true;
}

protected function GameThirdPersonCameraMode CreateCameraMode(class<GameThirdPersonCameraMode> ModeClass)
{
    local GameThirdPersonCameraMode NewMode;
    
    NewMode = new(self) ModeClass;
    NewMode.ThirdPersonCam = self;
    NewMode.Init();
    return NewMode;
}

defaultproperties
{
    WorstLocPenetrationExtentScale=1.0
    PenetrationBlendOutTime=0.15
    PenetrationBlendInTime=0.1
    PenetrationBlockedPct=1.0
    PenetrationExtentScale=1.0
    OriginOffsetInterpSpeed=8.0
    ThirdPersonCamDefaultClass="GameThirdPersonCameraMode_Default"
    Focus_BackOffStrength=0.33
    Focus_StepHeightAdjustment=64.0
    Focus_MaxTries=4
    Focus_FastAdjustKickInTime=0.5
    DirectLookInterpSpeed=6.0
    WorstLocInterpSpeed=8.0
    PenetrationAvoidanceFeelers(0)=(AdjustmentRot=(Pitch=0,Yaw=0,Roll=0),WorldWeight=1.0,PawnWeight=1.0,Extent=(X=14.0,Y=14.0,Z=14.0))
    PenetrationAvoidanceFeelers(1)=(AdjustmentRot=(Pitch=0,Yaw=3072,Roll=0),WorldWeight=0.75,PawnWeight=0.75,Extent=(X=0.0,Y=0.0,Z=0.0))
    PenetrationAvoidanceFeelers(2)=(AdjustmentRot=(Pitch=0,Yaw=-3072,Roll=0),WorldWeight=0.75,PawnWeight=0.75,Extent=(X=0.0,Y=0.0,Z=0.0))
    PenetrationAvoidanceFeelers(3)=(AdjustmentRot=(Pitch=0,Yaw=6144,Roll=0),WorldWeight=0.5,PawnWeight=0.5,Extent=(X=0.0,Y=0.0,Z=0.0))
    PenetrationAvoidanceFeelers(4)=(AdjustmentRot=(Pitch=0,Yaw=-6144,Roll=0),WorldWeight=0.5,PawnWeight=0.5,Extent=(X=0.0,Y=0.0,Z=0.0))
    PenetrationAvoidanceFeelers(5)=(AdjustmentRot=(Pitch=3640,Yaw=0,Roll=0),WorldWeight=1.0,PawnWeight=1.0,Extent=(X=0.0,Y=0.0,Z=0.0))
    PenetrationAvoidanceFeelers(6)=(AdjustmentRot=(Pitch=-3640,Yaw=0,Roll=0),WorldWeight=0.5,PawnWeight=0.5,Extent=(X=0.0,Y=0.0,Z=0.0))
    OffsetAdjustmentInterpSpeed=12.0
    bResetCameraInterpolation=True
}
