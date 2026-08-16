class DoomGeneralProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__DoomGeneralProjectile.Particle"
    ProjTrace="Default__DoomGeneralProjectile.ProjectileTrace"
    RangeAttackActorList="Default__DoomGeneralProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_DoomGeneral"
    CylinderComponent="Default__DoomGeneralProjectile.CollisionCylinder"
    Components(0)="Default__DoomGeneralProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__DoomGeneralProjectile.CollisionCylinder"
}
