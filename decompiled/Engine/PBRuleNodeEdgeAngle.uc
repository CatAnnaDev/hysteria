class PBRuleNodeEdgeAngle extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

enum EProcBuildingEdge
{
    EPBE_Top,
    EPBE_Bottom,
    EPBE_Left,
    EPBE_Right,
};

struct native RBEdgeAngleInfo
{
    var() float Angle;
};

var() EProcBuildingEdge Edge;
var() array<RBEdgeAngleInfo> Angles;

defaultproperties
{
    Edge="EPBE_Left"
}
