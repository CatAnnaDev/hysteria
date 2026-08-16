class DrawCylinderComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color CylinderColor;
var() Material CylinderMaterial;
var() float CylinderRadius;
var() float CylinderTopRadius;
var() float CylinderHeight;
var() float CylinderHeightOffset;
var() int CylinderSides;
var() bool bDrawWireCylinder;
var() bool bDrawLitCylinder;

defaultproperties
{
    CylinderColor=(B=0,G=0,R=255,A=255)
    CylinderRadius=100.0
    CylinderTopRadius=100.0
    CylinderHeight=100.0
    CylinderSides=16
    bDrawWireCylinder=True
    ReplacementPrimitive="None"
    HiddenGame=True
}
