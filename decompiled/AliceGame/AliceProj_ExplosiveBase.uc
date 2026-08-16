class AliceProj_ExplosiveBase extends AliceProjectile
    abstract
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    ProjFlightEffects="Default__AliceProj_ExplosiveBase.Particle"
    RangeAttackActorList="Default__AliceProj_ExplosiveBase.RangeAttackActorinfo"
    CylinderComponent="Default__AliceProj_ExplosiveBase.CollisionCylinder"
    Components(0)="Default__AliceProj_ExplosiveBase.CollisionCylinder"
    CollisionComponent="Default__AliceProj_ExplosiveBase.CollisionCylinder"
}
