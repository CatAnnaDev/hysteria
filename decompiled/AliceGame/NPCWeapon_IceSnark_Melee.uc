class NPCWeapon_IceSnark_Melee extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__NPCWeapon_IceSnark_Melee.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_IceSnark_Melee.ForceFeedbackWaveformShooting2"
    bUseBodyCheck=True
    WeaponPositionType="EWPT_PartOfPawnMesh"
    MeleeAttackActorList="Default__NPCWeapon_IceSnark_Melee.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_IceSnark_Melee.RadiusAttackActorinfo"
    InstantHitDamage(0)=10.0
    InstantHitDamage(1)=0.0
    InstantHitDamageTypes(0)="Engine.DamageType"
    InstantHitDamageTypes(1)="DmgType_IceSnark"
    bMeleeWeaponAbility=True
    Physics="PHYS_Custom"
}
