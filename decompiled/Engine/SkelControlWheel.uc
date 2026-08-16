class SkelControlWheel extends SkelControlSingleBone
    native
    notplaceable
    hidecategories(Object,Object,Translation,Rotation);

var(Wheel) transient float WheelDisplacement;
var(Wheel) float WheelMaxRenderDisplacement;
var(Wheel) transient float WheelRoll;
var(Wheel) EAxis WheelRollAxis;
var(Wheel) EAxis WheelSteeringAxis;
var(Wheel) transient float WheelSteering;
var(Wheel) bool bInvertWheelRoll;
var(Wheel) bool bInvertWheelSteering;

defaultproperties
{
    WheelMaxRenderDisplacement=50.0
    WheelRollAxis="AXIS_X"
    WheelSteeringAxis="AXIS_Z"
    bApplyTranslation=True
    bApplyRotation=True
    bAddTranslation=True
    bAddRotation=True
    BoneTranslationSpace="BCS_BoneSpace"
    BoneRotationSpace="BCS_BoneSpace"
    bIgnoreWhenNotRendered=True
}
