class PBRuleNodeRandom extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() int NumOutputs;
var() int MinNumExecuted;
var() int MaxNumExecuted;

defaultproperties
{
    NumOutputs=2
    MinNumExecuted=1
    MaxNumExecuted=1
    NextRules(0)=(NextRule="None",LinkName="0",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="1",DrawY=0)
}
