class CameraAnimInst extends Object
    native
    notplaceable;

var CameraAnim CamAnim;
var export editinline InterpGroupInst InterpGroupInst;
var transient float CurTime;
var transient bool bLooping;
var transient bool bFinished;
var transient bool bAutoReleaseWhenFinished;
var transient bool bBlendingIn;
var transient bool bBlendingOut;
var bool bGamePlayCamera;
var float BlendInTime;
var float BlendOutTime;
var transient float CurBlendInTime;
var transient float CurBlendOutTime;
var float PlayRate;
var float BasePlayScale;
var float TransientScaleModifier;
var float CurrentBlendWeight;
var transient float RemainingTime;
var transient InterpTrackMove MoveTrack;
var transient InterpTrackInstMove MoveInst;
var transient AnimNodeSequence SourceAnimNode;
var protectedwrite ECameraAnimPlaySpace PlaySpace;
var transient Matrix UserPlaySpaceMatrix;
var transient PostProcessSettings LastPPSettings;
var transient float LastPPSettingsAlpha;

native final function SetPlaySpace(ECameraAnimPlaySpace NewSpace, optional Rotator UserPlaySpace)
{
    NewSpace;
    UserPlaySpace;
}

native final function ApplyTransientScaling(float Scalar)
{
    Scalar;
}

native final function Stop(optional bool bImmediate)
{
    bImmediate;
}

native final function AdvanceAnim(float DeltaTime, bool bJump)
{
    DeltaTime;
    bJump;
}

native final function Update(float NewRate, float NewScale, float NewBlendInTime, float NewBlendOutTime, optional float NewDuration)
{
    NewRate;
    NewScale;
    NewBlendInTime;
    NewBlendOutTime;
    NewDuration;
}

native final function Play(CameraAnim Anim, Actor CamActor, float InRate, float InScale, float InBlendInTime, float InBlendOutTime, bool bInLoop, bool bRandomStartTime, optional float Duration)
{
    Anim;
    CamActor;
    InRate;
    InScale;
    InBlendInTime;
    InBlendOutTime;
    bInLoop;
    bRandomStartTime;
    Duration;
}

defaultproperties
{
    InterpGroupInst="Default__CameraAnimInst.InterpGroupInst0"
    bFinished=True
    bAutoReleaseWhenFinished=True
    PlayRate=1.0
    TransientScaleModifier=1.0
    LastPPSettings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
}
