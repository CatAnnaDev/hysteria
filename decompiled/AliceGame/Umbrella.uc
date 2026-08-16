class Umbrella extends AliceGameWeapon
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__Umbrella.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__Umbrella.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__Umbrella.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__Umbrella.RadiusAttackActorinfo"
}
