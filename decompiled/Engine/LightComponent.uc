class LightComponent extends ActorComponent
    abstract
    native
    noexport
    notplaceable;

enum EShadowFilterQuality
{
    SFQ_Low,
    SFQ_Medium,
    SFQ_High,
};

enum EShadowProjectionTechnique
{
    ShadowProjTech_Default,
    ShadowProjTech_PCF,
    ShadowProjTech_VSM,
    ShadowProjTech_BPCF_Low,
    ShadowProjTech_BPCF_Medium,
    ShadowProjTech_BPCF_High,
};

enum ELightShadowMode
{
    LightShadow_Normal,
    LightShadow_Modulate,
    LightShadow_ModulateBetter,
};

enum ELightAffectsClassification
{
    LAC_USER_SELECTED,
    LAC_DYNAMIC_AFFECTING,
    LAC_STATIC_AFFECTING,
    LAC_DYNAMIC_AND_STATIC_AFFECTING,
};

struct LightingChannelContainer
{
    var bool bInitialized;
    var() bool BSP;
    var() bool Static;
    var() bool Dynamic;
    var() bool CompositeDynamic;
    var() bool Skybox;
    var() bool Unnamed_1;
    var() bool Unnamed_2;
    var() bool Unnamed_3;
    var() bool PhysXLighting_1;
    var() bool PhysXLighting_2;
    var() bool PhysXLighting_3;
    var() bool Cinematic_1;
    var() bool Cinematic_2;
    var() bool Cinematic_3;
    var() bool Cinematic_4;
    var() bool Cinematic_5;
    var() bool Cinematic_6;
    var() bool Cinematic_7;
    var() bool Cinematic_8;
    var() bool Cinematic_9;
    var() bool Cinematic_10;
    var() bool Gameplay_1;
    var() bool Gameplay_2;
    var() bool Gameplay_3;
    var() bool Gameplay_4;
    var() bool Crowd;
};

var const native transient Pointer SceneInfo;
var const native transient Matrix WorldToLight;
var const native transient Matrix LightToWorld;
var const duplicatetransient Guid LightGuid;
var const duplicatetransient Guid LightmapGuid;
var() const interp float Brightness;
var() const interp Color LightColor;
var() const export editinline LightFunction Function;
var() const interp float LightEnv_BouncedLightBrightness;
var() const interp Color LightEnv_BouncedModulationColor;
var() const bool bEnabled;
var() const bool CastShadows;
var() const bool CastStaticShadows;
var() bool CastDynamicShadows;
var() bool bCastCompositeShadow;
var() bool bAffectCompositeShadowDirection;
var() bool bNonModulatedSelfShadowing;
var() interp bool bSelfShadowOnly;
var bool bAllowPreShadow;
var() const bool bForceDynamicLight;
var() const bool UseDirectLightMap;
var const bool bHasLightEverBeenBuiltIntoLightMap;
var() const bool bOnlyAffectSameAndSpecifiedLevels;
var() const bool bCanAffectDynamicPrimitivesOutsideDynamicChannel;
var() bool bUseVolumes;
var const bool bPrecomputedLightingIsValid;
var const export editinline LightEnvironmentComponent LightEnvironment;
var() const array<name> OtherLevelsToAffect;
var() const LightingChannelContainer LightingChannels;
var() const editoronly array<Brush> InclusionVolumes;
var() const editoronly array<Brush> ExclusionVolumes;
var const native array<Pointer> InclusionConvexVolumes;
var const native array<Pointer> ExclusionConvexVolumes;
var() const editconst ELightAffectsClassification LightAffectsClassification;
var() ELightShadowMode LightShadowMode;
var() LinearColor ModShadowColor;
var() float ModShadowFadeoutTime;
var() float ModShadowFadeoutExponent;
var const native duplicatetransient int LightListIndex;
var() EShadowProjectionTechnique ShadowProjectionTechnique;
var() EShadowFilterQuality ShadowFilterQuality;
var() int MinShadowResolution;
var() int MaxShadowResolution;
var() int ShadowFadeResolution;

native final function UpdateColorAndBrightness()
{
}

native final function Vector GetDirection()
{
}

native final function Vector GetOrigin()
{
}

native final function SetLightProperties(optional float NewBrightness = Brightness, optional Color NewLightColor = LightColor, optional LightFunction NewLightFunction = Function)
{
    NewBrightness;
    NewLightColor;
    NewLightFunction;
}

native final function SetEnabled(bool bSetEnabled)
{
    bSetEnabled;
}

defaultproperties
{
    Brightness=1.0
    LightColor=(B=255,G=255,R=255,A=0)
    LightEnv_BouncedModulationColor=(B=255,G=255,R=255,A=0)
    bEnabled=True
    CastShadows=True
    CastStaticShadows=True
    CastDynamicShadows=True
    bCastCompositeShadow=True
    bAffectCompositeShadowDirection=True
    bPrecomputedLightingIsValid=True
    LightingChannels=(bInitialized=True,BSP=True,Static=True,Dynamic=True,CompositeDynamic=True,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,PhysXLighting_1=False,PhysXLighting_2=False,PhysXLighting_3=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=False)
    LightShadowMode="LightShadow_Modulate"
    ModShadowColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    ModShadowFadeoutExponent=3.0
}
