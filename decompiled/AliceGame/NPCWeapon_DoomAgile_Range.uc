class NPCWeapon_DoomAgile_Range extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    AmmoCount=100000
    WeaponFireWaveForm="Default__NPCWeapon_DoomAgile_Range.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_DoomAgile_Range.ForceFeedbackWaveformShooting2"
    WeaponFireSnd(0)="None"
    bUseBodyCheck=True
    WeaponPositionType="EWPT_PartOfPawnMesh"
    MeleeAttackActorList="Default__NPCWeapon_DoomAgile_Range.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_DoomAgile_Range.RadiusAttackActorinfo"
    WeaponFireTypes(0)=250
    WeaponProjectiles(0)="DoomAgileProjectile"
    FireInterval(0)=1.5
    Spread(0)=0.0
    InstantHitDamage(0)=5.0
    InstantHitDamage(1)=0.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_Tea"
    WeaponRange=22000.0
    Physics="PHYS_Projectile"
}
