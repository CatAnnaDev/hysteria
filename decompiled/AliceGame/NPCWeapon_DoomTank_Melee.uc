class NPCWeapon_DoomTank_Melee extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__NPCWeapon_DoomTank_Melee.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_DoomTank_Melee.ForceFeedbackWaveformShooting2"
    bUseBodyCheck=True
    MeleeAttackActorList="Default__NPCWeapon_DoomTank_Melee.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_DoomTank_Melee.RadiusAttackActorinfo"
    InstantHitDamageTypes(0)="Engine.DamageType"
    InstantHitDamageTypes(1)="DmgType_DoomTank"
    bMeleeWeaponAbility=True
    Physics="PHYS_Custom"
}
