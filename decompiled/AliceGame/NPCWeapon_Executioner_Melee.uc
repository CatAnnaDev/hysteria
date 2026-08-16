class NPCWeapon_Executioner_Melee extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__NPCWeapon_Executioner_Melee.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_Executioner_Melee.ForceFeedbackWaveformShooting2"
    bUseBodyCheck=True
    SelfCollisionPhysicsAsset(0)="CH_Executioner.SK_Executioner_Weapon_Physics"
    MeleeAttackActorList="Default__NPCWeapon_Executioner_Melee.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_Executioner_Melee.RadiusAttackActorinfo"
    InstantHitDamage(0)=10.0
    InstantHitDamage(1)=0.0
    InstantHitDamageTypes(0)="Engine.DamageType"
    InstantHitDamageTypes(1)="DmgType_Executioner_Melee"
    bMeleeWeaponAbility=True
    Physics="PHYS_Custom"
}
