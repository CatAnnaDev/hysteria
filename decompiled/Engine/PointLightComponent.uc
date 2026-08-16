class PointLightComponent extends LightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() interp float ShadowRadiusMultiplier;
var() interp float Radius;
var() interp float FalloffExponent;
var() float ShadowFalloffExponent;
var() float MinShadowFalloffRadius;
var const Matrix CachedParentToWorld;
var() const Vector Translation;
var const export editinline DrawLightRadiusComponent PreviewLightRadius;
var(Lightmass) LightmassPointLightSettings LightmassSettings;
var const export editinline DrawLightRadiusComponent PreviewLightSourceRadius;

function OnUpdatePropertyBrightness()
{
    UpdateColorAndBrightness();
}

function OnUpdatePropertyLightColor()
{
    UpdateColorAndBrightness();
}

native final function SetTranslation(Vector NewTranslation)
{
    NewTranslation;
}

defaultproperties
{
    ShadowRadiusMultiplier=1.1
    Radius=1024.0
    FalloffExponent=2.0
    ShadowFalloffExponent=2.0
    LightmassSettings=(LightSourceRadius=100.0,IndirectLightingScale=1.0,IndirectLightingSaturation=1.0,ShadowExponent=2.0)
}
