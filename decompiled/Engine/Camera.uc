class Camera extends Actor
    native
    notplaceable
    transient
    hidecategories(Navigation);

const MAX_ACTIVE_CAMERA_ANIMS = 8;

enum ECameraAnimPlaySpace
{
    CAPS_CameraLocal,
    CAPS_World,
    CAPS_UserDefined,
};

enum EViewTargetBlendFunction
{
    VTBlend_Linear,
    VTBlend_Cubic,
    VTBlend_EaseIn,
    VTBlend_EaseOut,
    VTBlend_EaseInOut,
};

struct native ViewTargetTransitionParams
{
    var() float BlendTime;
    var() EViewTargetBlendFunction BlendFunction;
    var() float BlendExp;
    var() bool bLockOutgoing;
    var() float MaxAngle;
};

struct native TViewTarget
{
    var() Actor Target;
    var() Controller Controller;
    var() TPOV POV;
    var() float AspectRatio;
    var() PlayerReplicationInfo PRI;
};

struct native TCameraCache
{
    var float TimeStamp;
    var TPOV POV;
};

var PlayerController PCOwner;
var name CameraStyle;
var float DefaultFOV;
var bool bLockedFOV;
var bool bConstrainAspectRatio;
var bool bEnableFading;
var bool bEnableColorScaling;
var bool bEnableColorScaleInterp;
var bool bNonGamePlayCamera;
var float LockedFOV;
var float ConstrainedAspectRatio;
var float DefaultAspectRatio;
var Color FadeColor;
var float FadeAmount;
var float CamOverridePostProcessAlpha;
var PostProcessSettings CamPostProcessSettings;
var Vector ColorScale;
var Vector DesiredColorScale;
var Vector OriginalColorScale;
var float ColorScaleInterpDuration;
var float ColorScaleInterpStartTime;
var TCameraCache CameraCache;
var TCameraCache LastFrameCameraCache;
var float CurViewAspectRatio;
var TViewTarget ViewTarget;
var TViewTarget PendingViewTarget;
var float BlendTimeToGo;
var ViewTargetTransitionParams BlendParams;
var array<CameraModifier> ModifierList;
var float FreeCamDistance;
var Vector FreeCamOffset;
var Vector2D FadeAlpha;
var float FadeTime;
var float FadeTimeRemaining;
var Rotator DeltaRotFromInput;
var Rotator AccumulatedRotFromInput;
var transient array<EmitterCameraLensEffectBase> CameraLensEffects;
var() transient editinline CameraModifier_CameraShake CameraShakeCamMod;
var() class<CameraModifier_CameraShake> CameraShakeCamModClass;
var CameraAnimInst AnimInstPool[8];
var array<CameraAnimInst> ActiveAnims;
var array<CameraAnimInst> FreeAnims;
var transient DynamicCameraActor AnimCameraActor;

native simulated function StopCameraAnim(CameraAnimInst AnimInst, optional bool bImmediate)
{
    AnimInst;
    bImmediate;
}

native simulated function StopAllCameraAnimsByType(CameraAnim Anim, optional bool bImmediate)
{
    Anim;
    bImmediate;
}

native simulated function StopAllCameraAnims(optional bool bImmediate)
{
    bImmediate;
}

native simulated function CameraAnimInst PlayCameraAnim(CameraAnim Anim, optional bool bGamePlayCamera = false, optional float Rate = 1.0, optional float Scale = 1.0, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional float Duration, optional bool bSingleInstance)
{
    Anim;
    bGamePlayCamera;
    Rate;
    Scale;
    BlendInTime;
    BlendOutTime;
    bLoop;
    bRandomStartTime;
    Duration;
    bSingleInstance;
}

function ClearCameraShakesWithOuter(name Outermost)
{
    CameraShakeCamMod.RemoveCameraShakesWithOuter(Outermost);
}

function ClearAllCameraShakes()
{
    CameraShakeCamMod.RemoveAllCameraShakes();
}

static function PlayWorldCameraShake(CameraShake Shake, Actor ShakeInstigator, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff, bool bTryForceFeedback, optional bool bOrientShakeTowardsEpicenter)
{
    local PlayerController PC;
    local float ShakeScale;
    local Rotator CamRot;
    local Vector CamLoc;
    local Vector2D ShakeScaleRange;
    
    if (ShakeInstigator != none)
    {
        foreach ShakeInstigator.LocalPlayerControllers(class'PlayerController', PC)
        {
            if (PC.PlayerCamera != none)
            {
                ShakeScale = CalcRadialShakeScale(PC.PlayerCamera, Epicenter, InnerRadius, OuterRadius, Falloff);
                if (Shake.AnimScaleRange == 0.0)
                {
                    ShakeScale *= Shake.AnimScale;
                }
                else
                {
                    ShakeScaleRange.X = Shake.AnimScale - Shake.AnimScaleRange;
                    ShakeScaleRange.Y = Shake.AnimScale + Shake.AnimScaleRange;
                    ShakeScale *= FMax(0.0, GetRangeValueByPct(ShakeScaleRange, FRand()));
                }
                if (bOrientShakeTowardsEpicenter && PC.Pawn != none)
                {
                    PC.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
                    PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback, 2, rotator(Epicenter - CamLoc));
                    continue;
                }
                PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback);
            }
        }
    }
}

static function float CalcRadialShakeScale(Camera Cam, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff)
{
    local Vector POVLoc;
    local float DistPct;
    
    POVLoc = Cam.Location;
    if (InnerRadius < OuterRadius)
    {
        DistPct = (VSize(Epicenter - POVLoc) - InnerRadius) / (OuterRadius - InnerRadius);
        DistPct = 1.0 - FClamp(DistPct, 0.0, 1.0);
        return DistPct ** Falloff;
    }
    else
    {
        return VSize(Epicenter - POVLoc) < InnerRadius ? 1.0 : 0.0;
    }
}

function StopCameraShake(CameraShake Shake)
{
    if (Shake != none)
    {
        CameraShakeCamMod.RemoveCameraShake(Shake);
    }
}

function PlayCameraShake(CameraShake Shake, float Scale, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    if (Shake != none)
    {
        CameraShakeCamMod.AddCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
    }
}

function ClearCameraLensEffects()
{
    local EmitterCameraLensEffectBase LensEffect;
    
    foreach CameraLensEffects(LensEffect)
    {
        LensEffect.Destroy();
    }
    CameraLensEffects.Length = 0;
}

function RemoveCameraLensEffect(EmitterCameraLensEffectBase Emitter)
{
    CameraLensEffects.RemoveItem(Emitter);
}

function AddCameraLensEffect(class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local EmitterCameraLensEffectBase LensEffect;
    
    if (LensEffectEmitterClass != none)
    {
        if (!LensEffectEmitterClass.default.default.bAllowMultipleInstances)
        {
            LensEffect = FindCameraLensEffect(LensEffectEmitterClass);
            if (LensEffect != none)
            {
                LensEffect.NotifyRetriggered();
            }
        }
        if (LensEffect == none)
        {
            LensEffect = Spawn(LensEffectEmitterClass, PCOwner.GetViewTarget());
            if (LensEffect != none)
            {
                GetCameraViewPoint(CamLoc, CamRot);
                LensEffect.UpdateLocation(CamLoc, CamRot, GetFOVAngle());
                LensEffect.RegisterCamera(self);
                CameraLensEffects.AddItem(LensEffect);
            }
        }
    }
}

function EmitterCameraLensEffectBase FindCameraLensEffect(class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    local EmitterCameraLensEffectBase LensEffect;
    
    foreach CameraLensEffects(LensEffect)
    {
        if (LensEffect.Class == LensEffectEmitterClass && !LensEffect.bDeleteMe)
        {
            return LensEffect;
        }
    }
    return none;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector EyesLoc;
    local Rotator EyesRot;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("\tCamera Style:" $ string(CameraStyle) @ "main ViewTarget:" $ string(ViewTarget.Target));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("   CamLoc:" $ string(CameraCache.POV.Location) @ "CamRot:" $ string(CameraCache.POV.Rotation) @ "FOV:" $ string(CameraCache.POV.FOV));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("   AspectRatio:" $ string(ConstrainedAspectRatio));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (ViewTarget.Target != none)
    {
        ViewTarget.Target.GetActorEyesViewPoint(EyesLoc, EyesRot);
        Canvas.DrawText("   EyesLoc:" $ string(EyesLoc) @ "EyesRot:" $ string(EyesRot));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}

function bool AllowPawnRotation()
{
    return true;
}

function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot)
{
    local int ModifierIdx;
    
    DeltaRotFromInput = OutDeltaRot;
    for (ModifierIdx = 0; ModifierIdx < ModifierList.Length; ModifierIdx++)
    {
        if (ModifierList[ModifierIdx] != none)
        {
            if (ModifierList[ModifierIdx].ProcessViewRotation(ViewTarget.Target, DeltaTime, OutViewRotation, OutDeltaRot))
            {
                break;
            }
        }
    }
}

native final function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams)
{
    NewViewTarget;
    TransitionParams;
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Vector Loc, pos, HitLocation, HitNormal;
    local Rotator Rot;
    local Actor HitActor;
    local CameraActor CamActor;
    local bool bDoNotApplyModifiers;
    local TPOV OrigPOV;
    
    if (PendingViewTarget.Target != none && OutVT == ViewTarget && BlendParams.bLockOutgoing)
    {
        return;
    }
    OrigPOV = OutVT.POV;
    OutVT.POV.FOV = DefaultFOV;
    CamActor = CameraActor(OutVT.Target);
    if (CamActor != none)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;
        CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
        CamPostProcessSettings = CamActor.CamOverridePostProcess;
        UpdateCameraControl(CamActor, OutVT);
    }
    else
    {
        AccumulatedRotFromInput = rotator(vect(0.0, 0.0, 0.0));
        if (Pawn(OutVT.Target) == none || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
        {
            bDoNotApplyModifiers = true;
            switch (CameraStyle)
            {
                case 'Fixed':
                    OutVT.POV = OrigPOV;
                    break;
                case 'ThirdPerson':
                case 'FreeCam':
                case 'FreeCam_Default':
                    Loc = OutVT.Target.Location;
                    Rot = OutVT.Target.Rotation;
                    if (CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default')
                    {
                        Rot = PCOwner.Rotation;
                    }
                    Loc += FreeCamOffset >> Rot;
                    pos = Loc - vector(Rot) * FreeCamDistance;
                    HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(12.0, 12.0, 12.0));
                    OutVT.POV.Location = (HitActor == none ? pos : HitLocation);
                    OutVT.POV.Rotation = Rot;
                    break;
                case 'FirstPerson':
                default:
                    OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
                    break;
            }
        }
    }
    if (!bDoNotApplyModifiers)
    {
        ApplyCameraModifiers(DeltaTime, OutVT.POV);
    }
}

function UpdateCameraControl(CameraActor CamActor, out TViewTarget OutVT)
{
    local int PitchLimit, YawLimit;
    
    AccumulatedRotFromInput += DeltaRotFromInput;
    if (CamActor.CtrlParam.bCanBeRotated)
    {
        PitchLimit = int(Abs(CamActor.CtrlParam.PitchLimit * 10430.378 * 0.017453292));
        if (AccumulatedRotFromInput.Pitch > PitchLimit || AccumulatedRotFromInput.Pitch < -PitchLimit)
        {
            AccumulatedRotFromInput.Pitch = int(float(AccumulatedRotFromInput.Pitch) / Abs(float(AccumulatedRotFromInput.Pitch)) * float(PitchLimit));
        }
        YawLimit = int(Abs(CamActor.CtrlParam.YawLimit * 10430.378 * 0.017453292));
        if (AccumulatedRotFromInput.Yaw > YawLimit || AccumulatedRotFromInput.Yaw < -YawLimit)
        {
            AccumulatedRotFromInput.Yaw = int(float(AccumulatedRotFromInput.Yaw) / Abs(float(AccumulatedRotFromInput.Yaw)) * float(YawLimit));
        }
        OutVT.POV.Rotation += AccumulatedRotFromInput;
    }
    if (CamActor.CtrlParam.bHideAlice)
    {
        if (PCOwner != none && PCOwner.Pawn != none)
        {
            OutVT.POV.Location = PCOwner.Pawn.Location;
            OutVT.POV.Location.Z += PCOwner.Pawn.EyeHeight;
            OutVT.POV.Location += vector(PCOwner.Pawn.Rotation) * 25.0;
            OutVT.POV.Rotation = PCOwner.Pawn.GetViewRotation();
        }
    }
}

native function CheckViewTarget(out TViewTarget VT)
{
    VT;
}

final function FillCameraCache(out const TPOV NewPOV)
{
    if (CameraCache.TimeStamp != WorldInfo.TimeSeconds)
    {
        LastFrameCameraCache = CameraCache;
    }
    CameraCache.TimeStamp = WorldInfo.TimeSeconds;
    CameraCache.POV = NewPOV;
}

final function TPOV BlendViewTargets(out const TViewTarget A, out const TViewTarget B, float Alpha)
{
    local TPOV POV;
    
    POV.Location = VLerp(A.POV.Location, B.POV.Location, Alpha);
    POV.FOV = Lerp(A.POV.FOV, B.POV.FOV, Alpha);
    POV.Rotation = RLerp(A.POV.Rotation, B.POV.Rotation, Alpha, true);
    return POV;
}

simulated event UpdateCamera(float DeltaTime)
{
    local TPOV NewPOV;
    local float DurationPct, BlendPct;
    
    if (bEnableColorScaleInterp)
    {
        BlendPct = FClamp((WorldInfo.TimeSeconds - ColorScaleInterpStartTime) / ColorScaleInterpDuration, 0.0, 1.0);
        ColorScale = VLerp(OriginalColorScale, DesiredColorScale, BlendPct);
        if (BlendPct == 1.0)
        {
            bEnableColorScaleInterp = false;
        }
    }
    bConstrainAspectRatio = false;
    CamOverridePostProcessAlpha = 0.0;
    if (PendingViewTarget.Target == none || !BlendParams.bLockOutgoing)
    {
        if (ViewTarget.Target != PendingViewTarget.Target)
        {
            CheckViewTarget(ViewTarget);
            UpdateViewTarget(ViewTarget, DeltaTime);
        }
    }
    NewPOV = ViewTarget.POV;
    ConstrainedAspectRatio = ViewTarget.AspectRatio;
    if (PendingViewTarget.Target != none)
    {
        BlendTimeToGo -= DeltaTime;
        bConstrainAspectRatio = false;
        CheckViewTarget(PendingViewTarget);
        UpdateViewTarget(PendingViewTarget, DeltaTime);
        if (BlendTimeToGo > float(0))
        {
            DurationPct = (BlendParams.BlendTime - BlendTimeToGo) / BlendParams.BlendTime;
            switch (BlendParams.BlendFunction)
            {
                case 0:
                    BlendPct = Lerp(0.0, 1.0, DurationPct);
                    break;
                case 1:
                    BlendPct = FCubicInterp(0.0, 0.0, 1.0, 0.0, DurationPct);
                    break;
                case 2:
                    BlendPct = FInterpEaseIn(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                case 3:
                    BlendPct = FInterpEaseOut(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                case 4:
                    BlendPct = FInterpEaseInOut(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                default:
            }
            NewPOV = BlendViewTargets(ViewTarget, PendingViewTarget, BlendPct);
        }
        else
        {
            ViewTarget = PendingViewTarget;
            PendingViewTarget.Target = none;
            PendingViewTarget.Controller = none;
            BlendTimeToGo = 0.0;
            NewPOV = PendingViewTarget.POV;
        }
        if (bConstrainAspectRatio)
        {
            ConstrainedAspectRatio = PendingViewTarget.AspectRatio;
        }
    }
    FillCameraCache(NewPOV);
    if (bEnableFading && FadeTimeRemaining > 0.0)
    {
        FadeTimeRemaining = FMax(FadeTimeRemaining - DeltaTime, 0.0);
        if (FadeTime > 0.0)
        {
            FadeAmount = FadeAlpha.X + (1.0 - FadeTimeRemaining / FadeTime) * (FadeAlpha.Y - FadeAlpha.X);
        }
    }
}

simulated function SetDesiredColorScale(Vector NewColorScale, float InterpTime)
{
    if (!bEnableColorScaling)
    {
        bEnableColorScaling = true;
        ColorScale.X = 1.0;
        ColorScale.Y = 1.0;
        ColorScale.Z = 1.0;
    }
    if (NewColorScale != ColorScale)
    {
        OriginalColorScale = ColorScale;
        DesiredColorScale = NewColorScale;
        ColorScaleInterpStartTime = WorldInfo.TimeSeconds;
        ColorScaleInterpDuration = InterpTime;
        bEnableColorScaleInterp = true;
    }
}

final function GetCameraViewPoint(out Vector OutCamLoc, out Rotator OutCamRot)
{
    OutCamLoc = CameraCache.POV.Location;
    OutCamRot = CameraCache.POV.Rotation;
}

function SetFOV(float NewFOV)
{
    if (NewFOV < float(1) || NewFOV > float(170))
    {
        bLockedFOV = false;
        return;
    }
    bLockedFOV = true;
    LockedFOV = NewFOV;
}

function float GetFOVAngle()
{
    if (bLockedFOV)
    {
        return LockedFOV;
    }
    return CameraCache.POV.FOV;
}

function InitializeFor(PlayerController PC)
{
    CameraCache.POV.FOV = DefaultFOV;
    PCOwner = PC;
    SetViewTarget(PC.ViewTarget);
    SetDesiredColorScale(WorldInfo.DefaultColorScale, 5.0);
    UpdateCamera(0.0);
}

native function ApplyCameraModifiers(float DeltaTime, out TPOV OutPOV)
{
    DeltaTime;
    OutPOV;
}

event Destroyed()
{
    AnimCameraActor.Destroy();
    Destroyed();
}

function PostBeginPlay()
{
    local int Idx;
    
    PostBeginPlay();
    if (CameraShakeCamMod == none && CameraShakeCamModClass != none)
    {
        CameraShakeCamMod = CameraModifier_CameraShake(CreateCameraModifier(CameraShakeCamModClass));
    }
    for (Idx = 0; Idx < 8; ++Idx)
    {
        AnimInstPool[Idx] = new(self) class'CameraAnimInst';
        FreeAnims[Idx] = AnimInstPool[Idx];
    }
    AnimCameraActor = Spawn(class'DynamicCameraActor', self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0), , true);
}

event bool InSightCheck(Vector vLocation)
{
}

event float GetCurViewAspectRatio()
{
    return bConstrainAspectRatio ? ConstrainedAspectRatio : CurViewAspectRatio;
}

protected function CameraModifier CreateCameraModifier(class<CameraModifier> ModifierClass)
{
    local CameraModifier NewMod;
    
    NewMod = new(Outer) ModifierClass;
    NewMod.Init();
    NewMod.AddCameraModifier(self);
    return NewMod;
}

defaultproperties
{
    DefaultFOV=90.0
    DefaultAspectRatio=1.33333
    CamPostProcessSettings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    CameraCache=(TimeStamp=0.0,POV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0))
    LastFrameCameraCache=(TimeStamp=0.0,POV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0))
    ViewTarget=(Target="None",Controller="None",POV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0),AspectRatio=0.0,PRI="None")
    PendingViewTarget=(Target="None",Controller="None",POV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0),AspectRatio=0.0,PRI="None")
    BlendParams=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    FreeCamDistance=256.0
    CameraShakeCamModClass="CameraModifier_CameraShake"
    bHidden=True
    CollisionType="COLLIDE_CustomDefault"
}
