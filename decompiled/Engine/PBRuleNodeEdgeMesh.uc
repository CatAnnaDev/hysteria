class PBRuleNodeEdgeMesh extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() float FlatThreshold;
var() float MainXPullIn;

defaultproperties
{
    FlatThreshold=5.0
    NextRules(0)=(NextRule="None",LinkName="Main",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="Edge",DrawY=0)
}
