class SphereComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories;

var() const export float CollisionRadius;
var() const Color SphereColor;
var const bool bDrawBoundingBox;
var const bool bDrawNonColliding;

native final function SetSphereSize(float NewRadius)
{
    NewRadius;
}

defaultproperties
{
    CollisionRadius=22.0
    SphereColor=(B=223,G=149,R=157,A=255)
    bDrawBoundingBox=True
    ReplacementPrimitive="None"
    HiddenGame=True
    bCastDynamicShadow=False
    BlockZeroExtent=True
    BlockNonZeroExtent=True
}
