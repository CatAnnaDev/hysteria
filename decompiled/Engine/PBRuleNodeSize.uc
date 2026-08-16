class PBRuleNodeSize extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() EProcBuildingAxis SizeAxis;
var() float DecisionSize;
var() bool bUseTopLevelScopeSize;

defaultproperties
{
    DecisionSize=512.0
    NextRules(0)=(NextRule="None",LinkName="Less",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="Greater/Equal",DrawY=0)
}
