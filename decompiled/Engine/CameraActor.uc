class CameraActor extends Actor
    native
    placeable
    hidecategories(Navigation);

struct native ControllableParams
{
    var() bool bCanBeRotated;
    var() float PitchLimit;
    var() float YawLimit;
    var() bool bCanBeMovedAlongX;
    var() float XLimit;
    var() bool bCanBeMovedAlongY;
    var() float YLimit;
    var() bool bCanBeMovedAlongZ;
    var() float ZLimit;
    var() bool bHideAlice;
};

var() bool bConstrainAspectRatio;
var deprecated bool bCamOverridePostProcess;
var() bool bGamePlayCamera;
var() repretry interp float AspectRatio;
var() repretry interp float FOVAngle;
var() interp float CamOverridePostProcessAlpha;
var() interp PostProcessSettings CamOverridePostProcess;
var export editinline DrawFrustumComponent DrawFrustum;
var export editinline StaticMeshComponent MeshComp;
var() ControllableParams CtrlParam;

replication
{
    if (Role == 3)
        AspectRatio, FOVAngle;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local float XL;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.StrLen("TEST", XL, out_YL);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("FOV:" $ string(FOVAngle), false);
}

simulated function GetCameraView(float DeltaTime, out TPOV OutPOV)
{
    GetActorEyesViewPoint(OutPOV.Location, OutPOV.Rotation);
    OutPOV.FOV = FOVAngle;
}

defaultproperties
{
    bConstrainAspectRatio=True
    AspectRatio=1.77778
    FOVAngle=90.0
    CamOverridePostProcess=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    DrawFrustum="Default__CameraActor.DrawFrust0"
    MeshComp="Default__CameraActor.CamMesh0"
    CtrlParam=(bCanBeRotated=False,PitchLimit=15.0,YawLimit=15.0,bCanBeMovedAlongX=False,XLimit=0.0,bCanBeMovedAlongY=False,YLimit=0.0,bCanBeMovedAlongZ=False,ZLimit=0.0,bHideAlice=False)
    bNoDelete=True
    bEdShouldSnap=True
    Components(0)="Default__CameraActor.CamMesh0"
    Components(1)="Default__CameraActor.DrawFrust0"
    Physics="PHYS_Interpolating"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=1.0
}
