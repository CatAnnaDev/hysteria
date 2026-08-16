class AliceAnimNotify_TriggerRadiusDamage extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() class<Object> WeaponClass;
var() name SocketName;
var() float RadiusDamageLength;
var() float RadiusDamageTime;
var() float RadiusDamageValue;
var() int KnockBackParamConfigID;
var() EDamageStrengthType DmgStrength;
var() ForceFeedbackWaveform FFWaveform;
var() bool ActivateOnWeaponHit;
var() bool bNPCWeaponCanAttackOtherNPC;
var() bool bTraceShieldAngleCheckFromSocket;
var() bool bUseRadiusZDiffCheck;
var() bool bTraceAttackLocationOnGround;
var() int RadiusDamageForNPCs;
var() float RetriggerTime;
var() int MaxTriggerCount;
var() float RadiusZDiffCheckHeight;
var() float TraceGroundZDiff;

defaultproperties
{
    KnockBackParamConfigID=-1
    RadiusDamageForNPCs=-1
    RetriggerTime=0.1
    MaxTriggerCount=1
    RadiusZDiffCheckHeight=30.0
    TraceGroundZDiff=30.0
}
