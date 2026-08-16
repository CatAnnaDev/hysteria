class DrawCapsuleComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color CapsuleColor;
var() Material CapsuleMaterial;
var() float CapsuleHeight;
var() float CapsuleRadius;
var() bool bDrawWireCapsule;
var() bool bDrawLitCapsule;

defaultproperties
{
    CapsuleColor=(B=0,G=0,R=255,A=255)
    CapsuleHeight=200.0
    CapsuleRadius=200.0
    bDrawWireCapsule=True
    ReplacementPrimitive="None"
    HiddenGame=True
}
