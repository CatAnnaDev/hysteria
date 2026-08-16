class LightEnvironmentComponent extends ActorComponent
    native
    notplaceable;

var() const bool bEnabled;
var() bool bForceNonCompositeDynamicLights;
var() bool bAllowDynamicShadowsOnTranslucency;
var const transient bool bTranslucencyShadowed;
var const transient export editinline LightComponent AffectingDominantLight;
var const transient export editinline array<PrimitiveComponent> AffectedComponents;

native final function bool IsEnabled()
{
}

native final function SetEnabled(bool bNewEnabled)
{
    bNewEnabled;
}

defaultproperties
{
    bEnabled=True
}
