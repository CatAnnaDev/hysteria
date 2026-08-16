class SkelCtrl_AliceHand_Placement extends SkelControlLimb
    native
    notplaceable
    hidecategories(Object,Object);

var(TwistJoint) int UpperArmTwistJointIndex;
var(TwistJoint) int ForeArmTwistJointIndex;
var(TwistJoint) name LeftHandBoneName;
var(TwistJoint) name RightHandBoneName;

defaultproperties
{
    LeftHandBoneName="Bip01-L-Hand"
    RightHandBoneName="Bip01-R-Hand"
    EffectorLocationSpace="BCS_ActorSpace"
}
