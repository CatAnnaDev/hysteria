class AliceDummyWeapon extends WeaponForAliceMelee
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug);

defaultproperties
{
    WeaponTypeEnum="EAWT_DummyWeapon"
    FlushParticleComponent="Default__AliceDummyWeapon.ParticleSystemComponent0"
    ChargeParticleComponent="Default__AliceDummyWeapon.ParticleSystemComponent1"
    AudioChargeComp="Default__AliceDummyWeapon.ChargeSound"
    AudioChargeCompleteSound="Default__AliceDummyWeapon.CCS"
    WeaponFireWaveForm="Default__AliceDummyWeapon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__AliceDummyWeapon.ForceFeedbackWaveformShooting2"
    WeaponPositionType="EWPT_PartOfPawnMesh"
    MeleeAttackActorList="Default__AliceDummyWeapon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__AliceDummyWeapon.RadiusAttackActorinfo"
    Mesh="None"
    Components(0)="Default__AliceDummyWeapon.ChargeSound"
    Components(1)="Default__AliceDummyWeapon.CCS"
    CollisionType="COLLIDE_CustomDefault"
}
