class NPCWeapon_DollBoy_Scissor_B extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponFireWaveForm="Default__NPCWeapon_DollBoy_Scissor_B.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_DollBoy_Scissor_B.ForceFeedbackWaveformShooting2"
    bUseBodyCheck=True
    SelfCollisionPhysicsAsset(0)="CH_MadCap.SK_MadCap_Fork_Physics"
    MeleeAttackActorList="Default__NPCWeapon_DollBoy_Scissor_B.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_DollBoy_Scissor_B.RadiusAttackActorinfo"
    InstantHitDamage(0)=10.0
    InstantHitDamage(1)=0.0
    InstantHitDamageTypes(0)="Engine.DamageType"
    InstantHitDamageTypes(1)="DmgType_Madcap_Melee"
    bMeleeWeaponAbility=True
    Physics="PHYS_Custom"
}
