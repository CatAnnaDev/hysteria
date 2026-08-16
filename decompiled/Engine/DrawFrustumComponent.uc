class DrawFrustumComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color FrustumColor;
var() float FrustumAngle;
var() float FrustumAspectRatio;
var() float FrustumStartDist;
var() float FrustumEndDist;
var() Texture Texture;

defaultproperties
{
    FrustumColor=(B=255,G=0,R=255,A=255)
    FrustumAngle=90.0
    FrustumAspectRatio=1.33333
    FrustumStartDist=100.0
    FrustumEndDist=1000.0
    ReplacementPrimitive="None"
    HiddenGame=True
}
