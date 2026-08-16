class SkelControl_TwistBone extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

var() name SourceBoneName;
var() float TwistAngleScale;

defaultproperties
{
    TwistAngleScale=-0.5
    bIgnoreWhenNotRendered=True
    CategoryDesc="Single Bone"
}
