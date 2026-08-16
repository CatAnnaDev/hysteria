class SkelControlHandlebars extends SkelControlSingleBone
    native
    notplaceable
    hidecategories(Object,Object,Translation,Rotation);

var(Handlebars) EAxis WheelRollAxis;
var(Handlebars) EAxis HandlebarRotateAxis;
var(Handlebars) name WheelBoneName;
var(Handlebars) bool bInvertRotation;
var int SteerWheelBoneIndex;

defaultproperties
{
    WheelRollAxis="AXIS_Y"
    HandlebarRotateAxis="AXIS_Z"
    SteerWheelBoneIndex=-1
    bApplyRotation=True
    BoneTranslationSpace="BCS_BoneSpace"
    BoneRotationSpace="BCS_BoneSpace"
    bIgnoreWhenNotRendered=True
}
