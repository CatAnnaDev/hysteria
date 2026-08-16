class SkyLightComponent extends LightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() const float LowerBrightness;
var() const Color LowerColor;

defaultproperties
{
    LowerColor=(B=255,G=255,R=255,A=0)
    CastShadows=False
}
