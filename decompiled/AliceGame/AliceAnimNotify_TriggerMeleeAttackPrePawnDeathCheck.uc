class AliceAnimNotify_TriggerMeleeAttackPrePawnDeathCheck extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() class<AliceGameWeapon> WeaponClass;
var() float AttackRangeDist;
var() Rotator AttackRangeAngle;
var() float AttackDamage;
var() int KnockBackParamConfigID;
var() EDamageStrengthType DmgStrength;
var() ForceFeedbackWaveform FFWaveform;
var() bool ActivateOnWeaponHit;

defaultproperties
{
    AttackRangeDist=200.0
    AttackRangeAngle=(Pitch=8192,Yaw=8192,Roll=0)
    KnockBackParamConfigID=-1
}
