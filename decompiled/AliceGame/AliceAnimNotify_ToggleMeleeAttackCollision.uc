class AliceAnimNotify_ToggleMeleeAttackCollision extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EAnimWeaponAttackCollisionMode
{
    EAnimWeaponAttackCollisionMode_BodyCylinderComponent,
    EAnimWeaponAttackCollisionMode_BonesAABB,
    EAnimWEaponAttackCollisionMode_BonesShapes,
};

var() class<AliceGameWeapon> WeaponClass;
var() bool Active;
var() bool bNPCWeaponCanAttackOtherNPC;
var() bool ActivateOnWeaponHit;
var() float AttackDamage;
var() EAnimWeaponAttackCollisionMode WeaponAttackCollisionMode;
var() EAnimWeaponAttackCollisionMode PawnAttackCollisionMode;
var() EDamageStrengthType DmgStrength;
var() int AttackPhysicsAssetConfigID;
var() int KnockBackParamConfigID;
var() float RetriggerTime;
var() int MaxTriggerCount;
var() ForceFeedbackWaveform FFWaveform;
var() int DamageForNPCs;

defaultproperties
{
    WeaponAttackCollisionMode="EAnimWeaponAttackCollisionMode_BonesAABB"
    PawnAttackCollisionMode="EAnimWeaponAttackCollisionMode_BonesAABB"
    KnockBackParamConfigID=-1
    RetriggerTime=0.1
    MaxTriggerCount=1
    DamageForNPCs=-1
}
