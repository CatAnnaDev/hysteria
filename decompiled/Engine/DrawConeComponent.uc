class DrawConeComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color ConeColor;
var() float ConeRadius;
var() float ConeAngle;
var() int ConeSides;

defaultproperties
{
    ConeColor=(B=255,G=200,R=150,A=255)
    ConeRadius=100.0
    ConeAngle=44.0
    ConeSides=16
    ReplacementPrimitive="None"
    HiddenGame=True
}
