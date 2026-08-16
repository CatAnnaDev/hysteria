class SpotLightComponent extends PointLightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var() float InnerConeAngle;
var() float OuterConeAngle;
var const export editinline DrawLightConeComponent PreviewInnerCone;
var const export editinline DrawLightConeComponent PreviewOuterCone;
var() const Rotator Rotation;

native final function SetRotation(Rotator NewRotation)
{
    NewRotation;
}

defaultproperties
{
    OuterConeAngle=44.0
}
