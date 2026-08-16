class PepperGrinderPrimaryProjectile extends AliceProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_Enable())
    {
        return 1;
    }
    return 0;
}

defaultproperties
{
    AliceProjectileWeaponType=4
    bCheckProjectileLight=True
    bWaitForEffects=True
    bNoRadiusDamageWhenHitPawn=True
    ProjFlightEffectTemplate="GFX_Weapons.hatterstaff.HF_R_Bullet_L4"
    ProjFlightEffects="Default__PepperGrinderPrimaryProjectile.Particle"
    RadiusDamageTime=0.0
    ImpactEffectRandomRadius=60.0
    ProjTrace="Default__PepperGrinderPrimaryProjectile.ProjectileTrace"
    RangeAttackActorList="Default__PepperGrinderPrimaryProjectile.RangeAttackActorinfo"
    MomentumTransfer=1.0
    MyDamageType="DmgType_EyeStaff_RangeProjectile"
    CylinderComponent="Default__PepperGrinderPrimaryProjectile.CollisionCylinder"
    Components(0)="Default__PepperGrinderPrimaryProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__PepperGrinderPrimaryProjectile.CollisionCylinder"
}
