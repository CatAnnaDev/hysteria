class PBRuleNodeExtractTopBottom extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() float ExtractTopZ;
var() float ExtractNotTopZ;
var() float ExtractBottomZ;
var() float ExtractNotBottomZ;

defaultproperties
{
    ExtractTopZ=512.0
    ExtractBottomZ=512.0
    NextRules(0)=(NextRule="None",LinkName="Top",DrawY=0)
    NextRules(1)=(NextRule="None",LinkName="Not Top",DrawY=0)
    NextRules(2)=(NextRule="None",LinkName="Mid",DrawY=0)
    NextRules(3)=(NextRule="None",LinkName="Bottom",DrawY=0)
    NextRules(4)=(NextRule="None",LinkName="Not Bottom",DrawY=0)
}
