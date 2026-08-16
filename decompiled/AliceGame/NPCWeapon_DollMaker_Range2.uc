class NPCWeapon_DollMaker_Range2 extends WeaponForNPC
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    AmmoCount=100000
    WeaponFireWaveForm="Default__NPCWeapon_DollMaker_Range2.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__NPCWeapon_DollMaker_Range2.ForceFeedbackWaveformShooting2"
    WeaponFireSnd(0)="None"
    bAlignMuzzleLocDir=True
    bUseBodyCheck=True
    MeleeAttackActorList="Default__NPCWeapon_DollMaker_Range2.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__NPCWeapon_DollMaker_Range2.RadiusAttackActorinfo"
    WeaponFireTypes(0)=250
    WeaponProjectiles(0)="DollMakerProjectile2"
    FireInterval(0)=1.5
    Spread(0)=0.0
    InstantHitDamage(0)=5.0
    InstantHitDamage(1)=0.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_DollMaker"
    Physics="PHYS_Projectile"
}
