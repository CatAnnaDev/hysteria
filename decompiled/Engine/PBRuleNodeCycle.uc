class PBRuleNodeCycle extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() EProcBuildingAxis RepeatAxis;
var() float RepeatSize;
var() int CycleSize;
var() bool bFixRepeatSize;

defaultproperties
{
    RepeatAxis="EPBAxis_Z"
    RepeatSize=512.0
    CycleSize=2
    NextRules(0)=(NextRule="None",LinkName="Remainder",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="Step 0",DrawY=0)
    NextRules(2)=(NextRule="None",LinkName="Step 1",DrawY=0)
}
