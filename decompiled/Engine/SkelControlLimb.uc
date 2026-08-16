class SkelControlLimb extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

var(Effector) Vector EffectorLocation;
var(Effector) EBoneControlSpace EffectorLocationSpace;
var(Joint) EBoneControlSpace JointTargetLocationSpace;
var(Limb) EAxis BoneAxis;
var(Limb) EAxis JointAxis;
var(Effector) name EffectorSpaceBoneName;
var(Joint) Vector JointTargetLocation;
var(Joint) name JointTargetSpaceBoneName;
var(Limb) bool bInvertBoneAxis;
var(Limb) bool bInvertJointAxis;
var(Limb) bool bMaintainEffectorRelRot;
var(Limb) bool bTakeRotationFromEffectorSpace;
var() bool bAllowStretching;
var() Vector2D StretchLimits;
var() name StretchRollBoneName;

defaultproperties
{
    BoneAxis="AXIS_X"
    JointAxis="AXIS_Y"
    StretchLimits=(X=0.71,Y=1.2)
    CategoryDesc="Limb"
}
