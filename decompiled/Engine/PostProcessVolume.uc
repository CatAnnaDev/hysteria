class PostProcessVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Collision,Volume);

struct native PPV_MaterialEffect
{
    var() name EffectName;
    var() bool bShowInEditor;
    var() bool bShowInGame;
    var() bool bSetNewMaterial;
    var() bool bUseScreenAsTexture;
    var() MaterialInterface NewMaterial;
    var() array<PPV_MatParameter> MatParameters;
};

struct native PPV_MatParameter
{
    var() name ParamName;
    var() float ScalarValue;
    var() bool bActiveVaryingTime;
};

struct native PostProcessSettings
{
    var bool bOverride_EnableBloom;
    var bool bOverride_EnableDOF;
    var bool bOverride_EnableMotionBlur;
    var bool bOverride_EnableDynamicTonemapping;
    var bool bOverride_EnableSceneEffect;
    var bool bOverride_AllowAmbientOcclusion;
    var bool bOverride_OverrideRimShaderColor;
    var bool bOverride_Bloom_Scale;
    var bool bOverride_Bloom_InterpolationDuration;
    var bool bOverride_DOF_FalloffExponent;
    var bool bOverride_DOF_BlurKernelSize;
    var bool bOverride_DOF_BlurBloomKernelSize;
    var bool bOverride_DOF_MaxNearBlurAmount;
    var bool bOverride_DOF_MaxFarBlurAmount;
    var bool bOverride_DOF_ModulateBlurColor;
    var bool bOverride_DOF_FocusType;
    var bool bOverride_DOF_FocusNearInnerRadius;
    var bool bOverride_DOF_FocusFarInnerRadius;
    var bool bOverride_DOF_FocusDistance;
    var bool bOverride_DOF_FarFocusDistance;
    var bool bOverride_DOF_FocusPosition;
    var bool bOverride_DOF_InterpolationDuration;
    var bool bOverride_DOF_EnableDynamicDoF;
    var bool bOverride_DOF_AdaptationRate;
    var bool bOverride_DOF_WaitingTime;
    var bool bOverride_DOF_AimingPoint;
    var bool bOverride_DOF_MinFarInnerRadius;
    var bool bOverride_DOF_DDofRange;
    var bool bOverride_DOF_ResetAdaptationRate;
    var bool bOverride_DOF_ResetDistDifference;
    var bool bOverride_MotionBlur_MaxVelocity;
    var bool bOverride_MotionBlur_Amount;
    var bool bOverride_MotionBlur_FullMotionBlur;
    var bool bOverride_MotionBlur_CameraRotationThreshold;
    var bool bOverride_MotionBlur_CameraTranslationThreshold;
    var bool bOverride_MotionBlur_InterpolationDuration;
    var bool bOverride_DynamicTonemapping_MiddleGray;
    var bool bOverride_DynamicTonemapping_AdaptationRate;
    var bool bOverride_DynamicTonemapping_LuminanceScale;
    var bool bOverride_DynamicTonemapping_MinGray;
    var bool bOverride_DynamicTonemapping_MinColorScale;
    var bool bOverride_DynamicTonemapping_MaxColorScale;
    var bool bOverride_Scene_Desaturation;
    var bool bOverride_Scene_HighLights;
    var bool bOverride_Scene_MidTones;
    var bool bOverride_Scene_Shadows;
    var bool bOverride_Scene_InterpolationDuration;
    var bool bOverride_RimShader_Color;
    var bool bOverride_RimShader_InterpolationDuration;
    var() bool bEnableBloom;
    var() bool bEnableDOF;
    var() bool bEnableMotionBlur;
    var() bool bEnableSceneEffect;
    var() bool bAllowAmbientOcclusion;
    var() bool bOverrideRimShaderColor;
    var() bool bEnableDynamicTonemapping;
    var() interp float Bloom_Scale;
    var() float Bloom_InterpolationDuration;
    var() interp float DOF_FalloffExponent;
    var() interp float DOF_BlurKernelSize;
    var() interp float DOF_BlurBloomKernelSize;
    var() interp float DOF_MaxNearBlurAmount;
    var() interp float DOF_MaxFarBlurAmount;
    var() Color DOF_ModulateBlurColor;
    var() EFocusType DOF_FocusType;
    var() interp float DOF_FocusNearInnerRadius;
    var() interp float DOF_FocusFarInnerRadius;
    var() interp float DOF_FocusDistance;
    var() interp float DOF_FarFocusDistance;
    var() Vector DOF_FocusPosition;
    var() float DOF_InterpolationDuration;
    var() bool DOF_EnableDynamicDoF;
    var() interp float DOF_AdaptationRate;
    var() interp float DOF_WaitingTime;
    var() interp Vector DOF_AimingPoint;
    var() interp float DOF_MinFarInnerRadius;
    var() interp float DOF_DDofRange;
    var() interp float DOF_ResetAdaptationRate;
    var() interp float DOF_ResetDistDifference;
    var() interp float MotionBlur_MaxVelocity;
    var() interp float MotionBlur_Amount;
    var() bool MotionBlur_FullMotionBlur;
    var() interp float MotionBlur_CameraRotationThreshold;
    var() interp float MotionBlur_CameraTranslationThreshold;
    var() float MotionBlur_InterpolationDuration;
    var() interp float DynamicTonemapping_MiddleGray;
    var() interp float DynamicTonemapping_AdaptationRate;
    var() interp float DynamicTonemapping_LuminanceScale;
    var() interp float DynamicTonemapping_MinGray;
    var() interp float DynamicTonemapping_MinColorScale;
    var() interp float DynamicTonemapping_MaxColorScale;
    var() interp float Scene_Desaturation;
    var() interp Vector Scene_HighLights;
    var() interp Vector Scene_MidTones;
    var() interp Vector Scene_Shadows;
    var() float Scene_InterpolationDuration;
    var() LinearColor RimShader_Color;
    var() float RimShader_InterpolationDuration;
    var() Texture ColorGrading_LookupTable;
};

var() float Priority;
var() PostProcessSettings Settings;
var const transient PostProcessVolume NextLowerPriorityVolume;
var() repretry bool bEnabled;
var(MaterialEffects) array<PPV_MaterialEffect> MaterialEffects;

replication
{
    if (bNetDirty)
        bEnabled;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'PostProcessVolume.bEnabled', bEnabled == default.bEnabled);
}

defaultproperties
{
    Settings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    bEnabled=True
    BrushComponent="Default__PostProcessVolume.BrushComponent0"
    bStatic=False
    bTickIsDisabled=True
    bCollideActors=False
    Components(0)="Default__PostProcessVolume.BrushComponent0"
    CollisionComponent="Default__PostProcessVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
}
