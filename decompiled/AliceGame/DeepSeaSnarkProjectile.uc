class DeepSeaSnarkProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__DeepSeaSnarkProjectile.Particle"
    ProjTrace="Default__DeepSeaSnarkProjectile.ProjectileTrace"
    RangeAttackActorList="Default__DeepSeaSnarkProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_DeepSeaSnark"
    CylinderComponent="Default__DeepSeaSnarkProjectile.CollisionCylinder"
    Components(0)="Default__DeepSeaSnarkProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__DeepSeaSnarkProjectile.CollisionCylinder"
}
