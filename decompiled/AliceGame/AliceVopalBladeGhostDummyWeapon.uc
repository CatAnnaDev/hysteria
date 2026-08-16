class AliceVopalBladeGhostDummyWeapon extends WeaponForAlice
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    FlushParticleComponent="Default__AliceVopalBladeGhostDummyWeapon.ParticleSystemComponent0"
    ChargeParticleComponent="Default__AliceVopalBladeGhostDummyWeapon.ParticleSystemComponent1"
    AudioChargeComp="Default__AliceVopalBladeGhostDummyWeapon.ChargeSound"
    AudioChargeCompleteSound="Default__AliceVopalBladeGhostDummyWeapon.CCS"
    WeaponFireWaveForm="Default__AliceVopalBladeGhostDummyWeapon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__AliceVopalBladeGhostDummyWeapon.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__AliceVopalBladeGhostDummyWeapon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__AliceVopalBladeGhostDummyWeapon.RadiusAttackActorinfo"
    Mesh="Default__AliceVopalBladeGhostDummyWeapon.WeaponMesh"
    Components(0)="Default__AliceVopalBladeGhostDummyWeapon.ChargeSound"
    Components(1)="Default__AliceVopalBladeGhostDummyWeapon.CCS"
    CollisionType="COLLIDE_CustomDefault"
}
