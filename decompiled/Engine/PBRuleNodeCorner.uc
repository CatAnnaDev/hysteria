class PBRuleNodeCorner extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

struct native RBCornerAngleInfo
{
    var() float Angle;
    var() float CornerSize;
};

var() float CornerSize;
var() array<RBCornerAngleInfo> Angles;
var() float FlatThreshold;
var() bool bNoMeshForConcaveCorners;
var() bool bUseAdjacentRulesetForRightGap;
var() EPBCornerType CornerType;
var() float CornerShapeOffset;
var() int RoundTesselation;
var() float RoundCurvature;

defaultproperties
{
    CornerSize=256.0
    Angles(0)=(Angle=90.0,CornerSize=0.0)
    Angles(1)=(Angle=-90.0,CornerSize=0.0)
    FlatThreshold=5.0
    RoundTesselation=4
    RoundCurvature=1.0
}
