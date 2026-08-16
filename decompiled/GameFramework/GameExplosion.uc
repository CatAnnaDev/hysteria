class GameExplosion extends Object
    native
    notplaceable
    editinlinenew;

var() bool bDirectionalExplosion;
var() bool bAllowTeammateCringes;
var transient bool bFullDamageToAttachee;
var() bool bAttachExplosionEmitterToAttachee;
var() bool bCausesFracture;
var() bool bAllowPerMaterialFX;
var() bool bParticleSystemIsBeingOverriddenDontUsePhysMatVersion;
var() bool bUseMapSpecificValues;
var() bool bUseOverlapCheck;
var() bool bOrientCameraShakeTowardsEpicenter;
var() bool bAutoControllerVibration;
var() float DirectionalExplosionAngleDeg;
var() float DamageDelay;
var() float Damage;
var() float DamageRadius;
var() float DamageFalloffExponent;
var transient Actor ActorToIgnoreForDamage;
var() class<Actor> ActorClassToIgnoreForDamage;
var() class<Actor> ActorClassToIgnoreForKnockdownsAndCringes;
var() class<DamageType> MyDamageType;
var() float KnockDownRadius;
var() float KnockDownStrength;
var() float CringeRadius;
var() Vector2D CringeDuration;
var() float MomentumTransferScale;
var() ParticleSystem ParticleEmitterTemplate;
var() float ExplosionEmitterScale;
var Actor HitActor;
var Vector HitLocation;
var Vector HitNormal;
var() SoundCue ExplosionSound;
var() export editinline PointLightComponent ExploLight;
var() float ExploLightFadeOutTime;
var() export editinline RadialBlurComponent ExploRadialBlur;
var() float ExploRadialBlurFadeOutTime;
var() float ExploRadialBlurMaxBlur;
var() float FractureMeshRadius;
var() float FracturePartVel;
var() Actor Attachee;
var() Controller AttacheeController;
var() editinline CameraShake CamShake;
var() editinline CameraShake CamShake_Left;
var() editinline CameraShake CamShake_Right;
var() editinline CameraShake CamShake_Rear;
var() float CamShakeInnerRadius;
var() float CamShakeOuterRadius;
var() float CamShakeFalloff;
var() class<EmitterCameraLensEffectBase> CameraLensEffect;
var() float CameraLensEffectRadius;

defaultproperties
{
    bCausesFracture=True
    bAutoControllerVibration=True
    CringeDuration=(X=-1.0,Y=-1.0)
    MomentumTransferScale=1.0
    ExplosionEmitterScale=1.0
    ExploRadialBlurMaxBlur=2.0
    CamShakeFalloff=2.0
}
