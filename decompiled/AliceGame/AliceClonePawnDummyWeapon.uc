class AliceClonePawnDummyWeapon extends WeaponForAlice
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var() float FreezePawnTime;
var() int Achievement36CheckCount;
var() bool bDecreaseHPWhenHitAlice;

native simulated function TriggerRadiusDamage()
{
}

simulated event bool IsClockStyle()
{
    return InstantHitDamageTypes[1] == class'DmgType_ClockBombWeapon';
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (AliceClonePawn(Instigator) != none)
    {
        Mesh = Instigator.Mesh;
    }
}

defaultproperties
{
    FreezePawnTime=5.0
    Achievement36CheckCount=3
    bDecreaseHPWhenHitAlice=True
    WeaponTypeEnum="EAWT_ClonePawnWeapon"
    FlushParticleComponent="Default__AliceClonePawnDummyWeapon.ParticleSystemComponent0"
    ChargeParticleComponent="Default__AliceClonePawnDummyWeapon.ParticleSystemComponent1"
    AudioChargeComp="Default__AliceClonePawnDummyWeapon.ChargeSound"
    AudioChargeCompleteSound="Default__AliceClonePawnDummyWeapon.CCS"
    WeaponFireWaveForm="Default__AliceClonePawnDummyWeapon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__AliceClonePawnDummyWeapon.ForceFeedbackWaveformShooting2"
    WeaponPositionType="EWPT_PartOfPawnMesh"
    SelfCollisionPhysicsAsset(0)="CH_ClockworkBomb.SK_ClockworkBomb_Physics"
    MeleeAttackActorList="Default__AliceClonePawnDummyWeapon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__AliceClonePawnDummyWeapon.RadiusAttackActorinfo"
    InstantHitDamageTypes(0)="DmgType_ClonePawnWeapon"
    InstantHitDamageTypes(1)="DmgType_ClonePawnWeapon"
    Mesh="Default__AliceClonePawnDummyWeapon.WeaponMesh"
    Components(0)="Default__AliceClonePawnDummyWeapon.ChargeSound"
    Components(1)="Default__AliceClonePawnDummyWeapon.CCS"
    CollisionType="COLLIDE_CustomDefault"
}
