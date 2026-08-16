class NPCWeapon_DoomGrunt_Range_2 extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    AmmoCount=100000
    WeaponFireWaveForm="Default__NPCWeapon_DoomGrunt_Range_2.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_DoomGrunt_Range_2.ForceFeedbackWaveformShooting2"
    WeaponFireSnd(0)="None"
    bUseReferenceFireSocket=True
    bAlignMuzzleLocDir=True
    ReferenceFireSocketRotationSpace=1
    bUseBodyCheck=True
    MeleeAttackActorList="Default__NPCWeapon_DoomGrunt_Range_2.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_DoomGrunt_Range_2.RadiusAttackActorinfo"
    WeaponFireTypes(0)=250
    WeaponProjectiles(0)="DoomGruntProjectile2"
    FireInterval(0)=0.01
    Spread(0)=0.0
    InstantHitDamage(0)=5.0
    InstantHitDamage(1)=0.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_DoomGrunt2"
    Physics="PHYS_Projectile"
}
