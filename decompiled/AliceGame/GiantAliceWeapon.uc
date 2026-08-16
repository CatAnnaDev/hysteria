class GiantAliceWeapon extends WeaponForAliceMelee
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var() array<name> GiantAliceAttackAnims;

function FadeOutWeapon()
{
}

function SetSpecialMoveParam(AlicePawn aPawn, WeaponComboAttackState TheCurrentState)
{
    local ASM_MeleeComboCommon SpecialMoveInstance;
    
    aPawn.VerifySMHasBeenInstanced(MeleeAttackCommonSpecialMove);
    SpecialMoveInstance = ASM_MeleeComboCommon(aPawn.SpecialMoves[int(MeleeAttackCommonSpecialMove)]);
    SpecialMoveInstance.bCanRepeat = true;
    if (SpecialMoveInstance != none)
    {
        SpecialMoveInstance.AnimCfg_Animation.AnimationNames[0] = GiantAliceAttackAnims[int(TheCurrentState)];
        SpecialMoveInstance.PlayRate = 1.0;
        SpecialMoveInstance.AnimCfg_Animation.BlendInTime = 0.1;
        SpecialMoveInstance.AnimCfg_Animation.BlendOutTime = 0.1;
    }
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    Mesh.SkeletalMesh = Instigator.Mesh.SkeletalMesh;
}

state Inactive
{
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal("######################");
    }
    
    Stop;
}

defaultproperties
{
    GiantAliceAttackAnims(0)="AliceGiant_Attack01"
    GiantAliceAttackAnims(1)="AliceGiant_Attack02"
    GiantAliceAttackAnims(2)="AliceGiant_Attack03"
    ComboMaxIndex=3
    WeaponTypeEnum="EAWT_GiantCombat"
    FlushParticleComponent="Default__GiantAliceWeapon.ParticleSystemComponent0"
    ChargeParticleComponent="Default__GiantAliceWeapon.ParticleSystemComponent1"
    AudioChargeComp="Default__GiantAliceWeapon.ChargeSound"
    AudioChargeCompleteSound="Default__GiantAliceWeapon.CCS"
    WeaponFireWaveForm="Default__GiantAliceWeapon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__GiantAliceWeapon.ForceFeedbackWaveformShooting2"
    SelfCollisionPhysicsAsset(0)="ANI_Alice.Alice_Knife_Physics"
    MeleeAttackActorList="Default__GiantAliceWeapon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__GiantAliceWeapon.RadiusAttackActorinfo"
    FiringStatesArray(0)="None"
    FiringStatesArray(1)="AliceWeaponMeleeFire"
    WeaponFireTypes(0)=249
    FireInterval(0)=1.0
    Spread(0)=0.0
    InstantHitDamage(0)=7.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_VorpalBlade_Melee"
    bMeleeWeaponAbility=True
    WeaponMeleeRange=600.0
    Mesh="Default__GiantAliceWeapon.WeaponMesh"
    Components(0)="Default__GiantAliceWeapon.ChargeSound"
    Components(1)="Default__GiantAliceWeapon.CCS"
}
