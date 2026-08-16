class NPCWeapon_General_Melee_Blunt3 extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__NPCWeapon_General_Melee_Blunt3.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_General_Melee_Blunt3.ForceFeedbackWaveformShooting2"
    bUseBodyCheck=True
    MeleeAttackActorList="Default__NPCWeapon_General_Melee_Blunt3.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_General_Melee_Blunt3.RadiusAttackActorinfo"
    InstantHitDamageTypes(0)="Engine.DamageType"
    InstantHitDamageTypes(1)="DmgType_General_Melee_Blunt3"
    bMeleeWeaponAbility=True
    Physics="PHYS_Custom"
}
