class PBRuleNodeSplit extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

struct native RBSplitInfo
{
    var() bool bFixSize;
    var() float FixedSize;
    var() float ExpandRatio;
    var() name SplitName;
};

var() EProcBuildingAxis SplitAxis;
var() array<RBSplitInfo> SplitSetup;

defaultproperties
{
    SplitAxis="EPBAxis_Z"
    NextRules(0)=(NextRule="None",LinkName="Next",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="0",DrawY=0)
}
