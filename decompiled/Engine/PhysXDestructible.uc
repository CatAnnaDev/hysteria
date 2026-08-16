class PhysXDestructible extends Object
    native
    notplaceable
    hidecategories(Object);

struct native PhysXDestructibleParameters
{
    var() float DamageThreshold;
    var() float DamageToRadius;
    var() float DamageCap;
    var() float ForceToDamage;
    var() SoundCue FractureSound;
    var() ParticleSystem CrumbleParticleSystem;
    var() float CrumbleParticleSize;
    var() bool bAccumulateDamage;
    var float ScaledDamageToRadius;
    var() editfixedsize array<PhysXDestructibleDepthParameters> DepthParameters;
};

struct native PhysXDestructibleDepthParameters
{
    var() bool bTakeImpactDamage;
    var() bool bPlaySoundEffect;
    var() bool bPlayParticleEffect;
    var() bool bDoNotTimeOut;
    var bool bNoKillDummy;
};

var FracturedStaticMesh FracturedStaticMesh;
var array<PhysXDestructibleAsset> DestructibleAssets;
var() editinline PhysXDestructibleParameters DestructibleParameters;
var() array<Vector> CookingScales;

defaultproperties
{
    DestructibleParameters=(DamageThreshold=5.0,DamageToRadius=0.1,DamageCap=0.0,ForceToDamage=0.0,FractureSound="None",CrumbleParticleSystem="None",CrumbleParticleSize=10.0,bAccumulateDamage=True,ScaledDamageToRadius=0.0,DepthParameters=())
    CookingScales(0)=(X=1.0,Y=1.0,Z=1.0)
}
