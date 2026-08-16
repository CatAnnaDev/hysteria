class DynamicLightEnvironmentComponent extends LightEnvironmentComponent
    native
    notplaceable;

enum EDynamicLightEnvironmentBoundsMethod
{
    DLEB_OwnerComponents,
    DLEB_ManualOverride,
    DLEB_ActiveComponents,
};

var const native transient Pointer State;
var() float InvisibleUpdateTime;
var() float MinTimeBetweenFullUpdates;
var float ShadowInterpolationSpeed;
var() int NumVolumeVisibilitySamples;
var() LinearColor AmbientShadowColor;
var() Vector AmbientShadowSourceDirection;
var() LinearColor AmbientGlow;
var() float LightDesaturation;
var() float LightDistance;
var() float ShadowDistance;
var() bool bCastShadows;
var() bool bCompositeShadowsFromDynamicLights;
var const bool bForceCompositeAllLights;
var() bool bDynamic;
var() bool bSynthesizeDirectionalLight;
var() bool bSynthesizeSHLight;
var() bool bForceAllowLightEnvSphericalHarmonicLights;
var() bool bRequiresNonLatentUpdates;
var() bool bTraceFromClosestBoundsPoint;
var bool bIsCharacterLightEnvironment;
var bool bOverrideOwnerLightingChannels;
var() float ModShadowFadeoutTime;
var() float ModShadowFadeoutExponent;
var() LinearColor MaxModulatedShadowColor;
var float DominantShadowTransitionStartDistance;
var float DominantShadowTransitionEndDistance;
var() int MinShadowResolution;
var() int MaxShadowResolution;
var() int ShadowFadeResolution;
var() EShadowFilterQuality ShadowFilterQuality;
var() ELightShadowMode LightShadowMode;
var EDynamicLightEnvironmentBoundsMethod BoundsMethod;
var() float BouncedLightingFactor;
var() float MinShadowAngle;
var BoxSphereBounds OverriddenBounds;
var LightingChannelContainer OverriddenLightingChannels;
var const export editinline array<LightComponent> OverriddenLightComponents;

defaultproperties
{
    InvisibleUpdateTime=5.0
    MinTimeBetweenFullUpdates=1.0
    ShadowInterpolationSpeed=0.004
    NumVolumeVisibilitySamples=1
    AmbientShadowColor=(R=0.001,G=0.001,B=0.001,A=1.0)
    AmbientShadowSourceDirection=(X=0.01,Y=0.0,Z=0.99)
    AmbientGlow=(R=0.0,G=0.0,B=0.0,A=1.0)
    LightDistance=10.0
    ShadowDistance=5.0
    bCastShadows=True
    bCompositeShadowsFromDynamicLights=True
    bDynamic=True
    bSynthesizeDirectionalLight=True
    ModShadowFadeoutExponent=3.0
    MaxModulatedShadowColor=(R=0.5,G=0.5,B=0.5,A=1.0)
    DominantShadowTransitionStartDistance=100.0
    DominantShadowTransitionEndDistance=10.0
    LightShadowMode="LightShadow_Modulate"
    BouncedLightingFactor=1.0
    MinShadowAngle=25.0
}
