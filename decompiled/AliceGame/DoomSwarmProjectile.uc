class DoomSwarmProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__DoomSwarmProjectile.Particle"
    ProjTrace="Default__DoomSwarmProjectile.ProjectileTrace"
    RangeAttackActorList="Default__DoomSwarmProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_DoomSwarm"
    CylinderComponent="Default__DoomSwarmProjectile.CollisionCylinder"
    Components(0)="Default__DoomSwarmProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__DoomSwarmProjectile.CollisionCylinder"
}
