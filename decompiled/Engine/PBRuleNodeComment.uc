class PBRuleNodeComment extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() int SizeX;
var() int SizeY;
var() int BorderWidth;
var() Color BorderColor;
var() bool bFilled;
var() Color FillColor;

defaultproperties
{
    SizeX=128
    SizeY=64
    BorderWidth=1
    BorderColor=(B=0,G=0,R=0,A=255)
    bFilled=True
    FillColor=(B=255,G=255,R=255,A=16)
}
