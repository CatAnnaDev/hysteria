class DirectionalLightComponent extends LightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var(AdvancedLighting) float TraceDistance;
var(CascadedShadowMaps) const float WholeSceneDynamicShadowRadius;
var(CascadedShadowMaps) const int NumWholeSceneDynamicShadowCascades;
var(CascadedShadowMaps) const float CascadeDistributionExponent;
var(Lightmass) LightmassDirectionalLightSettings LightmassSettings;

function OnUpdatePropertyBrightness()
{
    UpdateColorAndBrightness();
}

function OnUpdatePropertyLightColor()
{
    UpdateColorAndBrightness();
}

defaultproperties
{
    TraceDistance=100000.0
    NumWholeSceneDynamicShadowCascades=1
    CascadeDistributionExponent=4.0
    LightmassSettings=(LightSourceAngle=3.0,IndirectLightingScale=1.0,IndirectLightingSaturation=1.0,ShadowExponent=2.0)
}
