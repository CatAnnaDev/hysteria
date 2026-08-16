class DrawSphereComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color SphereColor;
var() Material SphereMaterial;
var() float SphereRadius;
var() int SphereSides;
var() bool bDrawWireSphere;
var() bool bDrawLitSphere;
var bool bRenderIfSelected;

defaultproperties
{
    SphereColor=(B=0,G=0,R=255,A=255)
    SphereRadius=100.0
    SphereSides=16
    bDrawWireSphere=True
    ReplacementPrimitive="None"
    HiddenGame=True
}
