class PBRuleNodeAlternate extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() EProcBuildingAxis RepeatAxis;
var() float ASize;
var() float BMaxSize;
var() bool bInvertPatternOrder;
var() bool bEqualSizeAB;

defaultproperties
{
    ASize=512.0
    NextRules(0)=(NextRule="None",LinkName="A",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="B",DrawY=0)
}
