class DrawBoxComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color BoxColor;
var() Material BoxMaterial;
var() Vector BoxExtent;
var() bool bDrawWireBox;
var() bool bDrawLitBox;

defaultproperties
{
    BoxColor=(B=0,G=0,R=255,A=255)
    BoxExtent=(X=200.0,Y=200.0,Z=200.0)
    bDrawWireBox=True
    ReplacementPrimitive="None"
    HiddenGame=True
}
