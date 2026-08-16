class CylinderComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories;

var() const export float CollisionHeight;
var() const export float CollisionRadius;
var() const Color CylinderColor;
var const bool bDrawBoundingBox;
var const bool bDrawNonColliding;
var const bool bAlwaysRenderIfSelected;

native final function SetCylinderSize(float NewRadius, float NewHeight)
{
    NewRadius;
    NewHeight;
}

defaultproperties
{
    CollisionHeight=22.0
    CollisionRadius=22.0
    CylinderColor=(B=157,G=149,R=223,A=255)
    bDrawBoundingBox=True
    ReplacementPrimitive="None"
    HiddenGame=True
    bCastDynamicShadow=False
    BlockZeroExtent=True
    BlockNonZeroExtent=True
}
