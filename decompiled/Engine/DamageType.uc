class DamageType extends Object
    abstract
    native
    notplaceable;

enum DT_WeaponIndentify
{
    DTWI_NPCWeaponMelee,
    DTWI_NPCWeaponProject,
    DTWI_AliceWeaponVB,
    DTWI_AliceWeaponTC,
    DTWI_AliceWeaponHH,
    DTWI_AliceWeaponES,
    DTWI_AliceClonePawnWeapon,
    DTWI_NPCWeaponProjectReflect,
};

var DT_WeaponIndentify WeaponTypeIndentify;
var() bool bMeleeDamage;
var() bool bArmorStops;
var() bool bAlwaysGibs;
var() bool bNeverGibs;
var() bool bLocationalHit;
var() bool bCausesBlood;
var bool bCausedByWorld;
var bool bExtraMomentumZ;
var() bool bCausesFracture;
var bool bIgnoreDriverDamageMult;
var(RigidBody) bool bRadialDamageVelChange;
var(RigidBody) float KStartingWeight;
var(RigidBody) float KDamageImpulse;
var(RigidBody) float KDeathVel;
var(RigidBody) float KDeathUpKick;
var(RigidBody) float RadialDamageImpulse;
var float VehicleDamageScaling;
var float VehicleMomentumScaling;
var ForceFeedbackWaveform DamagedFFWaveform;
var ForceFeedbackWaveform KilledFFWaveform;
var float FracturedMeshDamage;

static function float VehicleDamageScalingFor(Vehicle V)
{
    return default.VehicleDamageScaling;
}

defaultproperties
{
    bArmorStops=True
    bLocationalHit=True
    bCausesBlood=True
    bExtraMomentumZ=True
    KStartingWeight=1.0
    KDamageImpulse=100.0
    VehicleDamageScaling=1.0
    VehicleMomentumScaling=1.0
    FracturedMeshDamage=1.0
}
