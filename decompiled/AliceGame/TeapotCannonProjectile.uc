class TeapotCannonProjectile extends AliceProjectile
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var float DamageCoreValue;
var float DamageSplashValue;
var float DamageCoreRadius;
var float DamageSplashRadius;
var EDamageStrengthType DamageCoreStrength;
var EDamageStrengthType DamageSplashStrength;
var export AliceExplosionLightTemplate RadiusAttackLightTemplate;
var ParticleSystem ChargedImpactParticle;
var() CameraAnim NormalProjImpactCameraAnim;
var() CameraAnim ChargedProjImpactCameraAnim;
var config float CamShakeDistanceNormal;
var config float CamShakeDistanceCharged;
var transient bool bChargedProjectile;
var PhysicalMaterial ExplodePhysMaterial;

function PhysicalMaterial GetExplodePhysMaterial()
{
    return ExplodePhysMaterial;
}

function ParticleSystem AltinatePSFromProjectile()
{
    return ChargedImpactParticle;
}

simulated event TriggerRadiusDamageCameraShake()
{
    local Vector RadiusLoc;
    local float CameraAnimDist;
    local CameraAnim DesiredCameraAnim;
    local AlicePawn pAlice;
    local AlicePlayerController pAliceController;
    
    RadiusLoc = Location;
    if (bChargedProjectile)
    {
        DesiredCameraAnim = ChargedProjImpactCameraAnim;
        CameraAnimDist = CamShakeDistanceCharged;
    }
    else
    {
        DesiredCameraAnim = NormalProjImpactCameraAnim;
        CameraAnimDist = CamShakeDistanceNormal;
    }
    pAlice = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    pAliceController = AlicePlayerController(pAlice.Controller);
    if (pAliceController != none && pAlice != none && DesiredCameraAnim != none && VSize(RadiusLoc - pAlice.Location) <= CameraAnimDist)
    {
        pAliceController.PlayCameraAnim(DesiredCameraAnim, true, 1.0);
    }
}

simulated event TriggerRadiusDamageLight()
{
    local Vector RadiusLoc;
    local AliceExplosionLight Light;
    
    RadiusLoc = Location;
    Light = AliceGameEmitterPool(WorldInfo.MyEmitterPool).SpawnTemplateExplosionLight(RadiusAttackLightTemplate, RadiusLoc);
    Light.ResetLight();
}

function InitConfigData(float BlastDelay, float DmgValueCore, float DmgValueSplash, EDamageStrengthType StrengthCore, EDamageStrengthType StrengthSplash, float CoreRadius, float SplashRadius)
{
    DamageCoreValue = DmgValueCore;
    DamageSplashValue = DmgValueSplash;
    DamageCoreStrength = StrengthCore;
    DamageSplashStrength = StrengthSplash;
    DamageCoreRadius = CoreRadius;
    DamageSplashRadius = SplashRadius;
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_TC_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_TC_Enable())
    {
        return 1;
    }
    return 0;
}

defaultproperties
{
    RadiusAttackLightTemplate=(TimeShift=(),HighDetailFrameTime=0.15,bCheckFrameRate=False,CastShadows=False)
    CamShakeDistanceNormal=1000.0
    CamShakeDistanceCharged=2000.0
    AliceProjectileWeaponType=3
    bCheckProjectileLight=True
    bWaitForEffects=True
    bForceTraceGround=True
    ExplosionSound="SFX_TC.sfx_teacannon_explode01_Cue"
    ProjFlightEffectTemplate="GFX_Weapons.hatterstaff.HF_R_Bullet_L4"
    ProjFlightEffects="Default__TeapotCannonProjectile.Particle"
    AccelRate=2500.0
    CheckRadius=20.0
    CameraEffectRadius=10000.0
    DamageStrength="EDSTR_HeaveyWithoutKnockback"
    MinShotDist=350.0
    MaxShotDist=10000.0
    RadiusDamageTime=0.1
    KnockBackID=6
    ProjTrace="Default__TeapotCannonProjectile.ProjectileTrace"
    RangeAttackActorList="Default__TeapotCannonProjectile.RangeAttackActorinfo"
    AngleToleranceXY=20.0
    GroundTraceGapForWalkingPawn=100.0
    GroundTraceGapForFlyingPawn=20.0
    Speed=1000.0
    MaxSpeed=5000.0
    bRotationFollowsVelocity=True
    Damage=20.0
    DamageRadius=200.0
    MyDamageType="DmgType_TeapotCannon_RangeProjectile"
    CylinderComponent="Default__TeapotCannonProjectile.CollisionCylinder"
    bBlockActors=True
    Components(0)="Default__TeapotCannonProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__TeapotCannonProjectile.CollisionCylinder"
}
