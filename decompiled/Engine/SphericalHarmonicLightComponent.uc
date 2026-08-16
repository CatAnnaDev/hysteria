class SphericalHarmonicLightComponent extends LightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() SHVectorRGB WorldSpaceIncidentLighting;
var bool bRenderBeforeModShadows;

defaultproperties
{
    CastShadows=False
}
