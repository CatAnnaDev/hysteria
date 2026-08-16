class GameThirdPersonCameraMode extends Object
    native
    notplaceable
    config(Camera);

enum ECameraViewportTypes
{
    CVT_16to9_Full,
    CVT_16to9_VertSplit,
    CVT_16to9_HorizSplit,
    CVT_4to3_Full,
    CVT_4to3_HorizSplit,
    CVT_4to3_VertSplit,
};

struct native ViewOffsetData
{
    var() Vector OffsetHigh;
    var() Vector OffsetMid;
    var() Vector OffsetLow;
};

var transient GameThirdPersonCamera ThirdPersonCam;
var() const config float FOVAngle;
var() const float BlendTime;
var() const bool bLockedToViewTarget;
var() const bool bDirectLook;
var() const bool bFollowTarget;
var() bool bInterpLocation;
var() bool bUsePerAxisOriginLocInterp;
var() bool bInterpRotation;
var() bool bRotInterpSpeedConstant;
var() const bool bDoPredictiveAvoidance;
var() const bool bValidateWorstLoc;
var() bool bSkipCameraCollision;
var() bool bApplyDeltaViewOffset;
var(DepthOfField) const bool bAdjustDOF;
var transient bool bDOFUpdated;
var() bool bInterpViewOffsetOnlyForCamTransition;
var() const float FollowingInterpSpeed_Pitch;
var() const float FollowingInterpSpeed_Yaw;
var() const float FollowingInterpSpeed_Roll;
var() const float FollowingCameraVelThreshold;
var() float OriginLocInterpSpeed;
var() Vector PerAxisOriginLocInterpSpeed;
var() float OriginRotInterpSpeed;
var() const Vector StrafeLeftAdjustment;
var() const Vector StrafeRightAdjustment;
var() const float StrafeOffsetScalingThreshold;
var() const float StrafeOffsetInterpSpeedIn;
var() const float StrafeOffsetInterpSpeedOut;
var transient Vector LastStrafeOffset;
var() const Vector RunFwdAdjustment;
var() const Vector RunBackAdjustment;
var() const float RunOffsetScalingThreshold;
var() const float RunOffsetInterpSpeedIn;
var() const float RunOffsetInterpSpeedOut;
var transient Vector LastRunOffset;
var() Vector WorstLocOffset;
var() const Vector TargetRelativeCameraOriginOffset;
var() const ViewOffsetData ViewOffset;
var() const ViewOffsetData ViewOffset_ViewportAdjustments[6];
var(DepthOfField) const float DOF_FalloffExponent;
var(DepthOfField) const float DOF_BlurKernelSize;
var(DepthOfField) const float DOF_FocusNearInnerRadius;
var(DepthOfField) const float DOF_FocusFarInnerRadius;
var(DepthOfField) const float DOF_MaxNearBlurAmount;
var(DepthOfField) const float DOF_MaxFarBlurAmount;
var transient float LastDOFRadius;
var transient float LastDOFDistance;
var(DepthOfField) const float DOFDistanceInterpSpeed;
var(DepthOfField) const Vector DOFTraceExtent;
var(DepthOfField) const float DOF_NearFocusDistance;
var(DepthOfField) const float DOF_FarFocusDistance;
var(DepthOfField) const float DOF_ResetAdaptationRate;
var(DepthOfField) const float DOF_RadiusFalloff;
var(DepthOfField) const Vector2D DOF_RadiusRange;
var(DepthOfField) const Vector2D DOF_RadiusDistRange;
var float ViewOffsetInterp;

native final function SetViewOffset(out const ViewOffsetData NewViewOffset)
{
    NewViewOffset;
}

simulated function ModifyPostProcessSettings(out PostProcessSettings PP)
{
    if (bDOFUpdated)
    {
        PP.bEnableDOF = true;
        PP.DOF_FalloffExponent = DOF_FalloffExponent;
        PP.DOF_BlurKernelSize = DOF_BlurKernelSize;
        PP.DOF_MaxNearBlurAmount = DOF_MaxNearBlurAmount;
        PP.DOF_FocusType = 0;
        PP.DOF_FocusNearInnerRadius = DOF_FocusNearInnerRadius;
        PP.DOF_FocusFarInnerRadius = DOF_FocusFarInnerRadius;
        PP.DOF_FocusDistance = DOF_NearFocusDistance;
        PP.DOF_FarFocusDistance = DOF_FarFocusDistance;
        PP.DOF_ResetAdaptationRate = DOF_ResetAdaptationRate;
        bDOFUpdated = false;
    }
}

simulated function UpdatePostProcess(out const TViewTarget VT, float DeltaTime)
{
    local Vector FocusLoc, StartTrace, EndTrace, CamDir;
    local float FocusDist, SubjectDist, Pct;
    
    bDOFUpdated = false;
    if (bAdjustDOF)
    {
        CamDir = vector(VT.POV.Rotation);
        StartTrace = VT.POV.Location + CamDir * float(10);
        EndTrace = StartTrace + CamDir * float(50000);
        FocusLoc = GetDOFFocusLoc(VT.Target, StartTrace, EndTrace);
        SubjectDist = VSize(FocusLoc - StartTrace);
        if (!ThirdPersonCam.bResetCameraInterpolation)
        {
            FocusDist = FInterpTo(LastDOFDistance, SubjectDist, DeltaTime, DOFDistanceInterpSpeed);
        }
        else
        {
            FocusDist = SubjectDist;
        }
        LastDOFDistance = FocusDist;
        Pct = GetRangePctByValue(DOF_RadiusDistRange, FocusDist);
        LastDOFRadius = GetRangeValueByPct(DOF_RadiusRange, FClamp(Pct, 0.0, 1.0) ** DOF_RadiusFalloff);
        bDOFUpdated = true;
    }
}

protected simulated function Vector DOFTrace(Actor TraceOwner, Vector StartTrace, Vector EndTrace)
{
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    
    HitActor = TraceOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, DOFTraceExtent, , TraceOwner.1);
    if (HitActor == none)
    {
        HitLocation = EndTrace;
    }
    if (HitActor != none)
    {
        if (!HitActor.bBlockActors && HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume'))
        {
            HitActor.bProjTarget = false;
            HitLocation = DOFTrace(TraceOwner, HitLocation, EndTrace);
            HitActor.bProjTarget = true;
        }
    }
    return HitLocation;
}

protected simulated function Vector GetDOFFocusLoc(Actor TraceOwner, Vector StartTrace, Vector EndTrace)
{
    return DOFTrace(TraceOwner, StartTrace, EndTrace);
}

simulated function ProcessViewRotation(float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
}

simulated function bool SetFocusPoint(Pawn ViewedPawn)
{
    return false;
}

simulated event Vector GetCameraWorstCaseLoc(Pawn TargetPawn)
{
    return TargetPawn.Location + (WorstLocOffset >> TargetPawn.Rotation);
}

function float GetDesiredFOV(Pawn ViewedPawn)
{
    return FOVAngle;
}

event Vector AdjustViewOffset(Pawn P, Vector Offset)
{
    return Offset;
}

function OnBecomeInActive(Pawn TargetPawn, GameThirdPersonCameraMode NewMode)
{
}

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
    if (BlendTime > 0.0)
    {
        ViewOffsetInterp = 1.0 / BlendTime;
    }
    else
    {
        ViewOffsetInterp = 0.0;
    }
}

function Init()
{
}

defaultproperties
{
    BlendTime=0.67
    bLockedToViewTarget=True
    bInterpLocation=True
    bDoPredictiveAvoidance=True
    bValidateWorstLoc=True
    bInterpViewOffsetOnlyForCamTransition=True
    OriginLocInterpSpeed=8.0
    StrafeOffsetInterpSpeedIn=12.0
    StrafeOffsetInterpSpeedOut=20.0
    RunOffsetInterpSpeedIn=6.0
    RunOffsetInterpSpeedOut=12.0
    WorstLocOffset=(X=-8.0,Y=1.0,Z=90.0)
    DOF_FalloffExponent=1.0
    DOF_BlurKernelSize=3.0
    DOF_MaxNearBlurAmount=0.6
    DOF_MaxFarBlurAmount=1.0
    DOFDistanceInterpSpeed=10.0
    DOF_RadiusFalloff=1.0
    DOF_RadiusRange=(X=2500.0,Y=60000.0)
    DOF_RadiusDistRange=(X=1000.0,Y=50000.0)
}
