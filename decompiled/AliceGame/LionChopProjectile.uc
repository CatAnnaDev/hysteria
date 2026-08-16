class LionChopProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__LionChopProjectile.Particle"
    ProjTrace="Default__LionChopProjectile.ProjectileTrace"
    RangeAttackActorList="Default__LionChopProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_LionChop"
    CylinderComponent="Default__LionChopProjectile.CollisionCylinder"
    Components(0)="Default__LionChopProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__LionChopProjectile.CollisionCylinder"
}
