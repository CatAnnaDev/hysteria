class ArrowComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color ArrowColor;
var() float ArrowSize;
var() bool bTreatAsASprite;

defaultproperties
{
    ArrowColor=(B=0,G=0,R=255,A=255)
    ArrowSize=1.0
    ReplacementPrimitive="None"
    HiddenGame=True
    AlwaysLoadOnClient=False
    AlwaysLoadOnServer=False
}
