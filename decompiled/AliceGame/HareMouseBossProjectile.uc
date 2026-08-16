class HareMouseBossProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__HareMouseBossProjectile.Particle"
    ProjTrace="Default__HareMouseBossProjectile.ProjectileTrace"
    RangeAttackActorList="Default__HareMouseBossProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_HareMouseBoss"
    CylinderComponent="Default__HareMouseBossProjectile.CollisionCylinder"
    Components(0)="Default__HareMouseBossProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__HareMouseBossProjectile.CollisionCylinder"
}
