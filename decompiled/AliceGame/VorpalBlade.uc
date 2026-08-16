class VorpalBlade extends WeaponForAliceMelee
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug);

var const ESpecialMove WeaponMeleeAnimation_Dash;
var(DLC) float MODDLCAliceDefenceAdd_Percent;

function UpdateAchievement29()
{
    if (AliceGameInfo(WorldInfo.Game).Achievement29 == 0)
    {
        AliceGameInfo(WorldInfo.Game).Achievement29 = 1;
    }
}

simulated function SkeletalMeshComponent GetMuzzleSocketMesh()
{
    if (Instigator != none)
    {
        return Instigator.Mesh;
    }
    return none;
}

simulated function AttachOwnerData()
{
    Mesh.AttachComponentToSocket(FlushParticleComponent, TraceSocket);
    Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeSocket);
}

simulated function ChangeDLCData()
{
    local AlicePawn pAlice;
    
    pAlice = AlicePawn(Instigator);
    ChangeDLCData();
    if (pAlice != none && GetDLCWeaponFlag() == 1)
    {
        pAlice.WeaponDefence_Percent = MODDLCAliceDefenceAdd_Percent;
    }
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_VB_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_VB_Enable())
    {
        return 1;
    }
    return 0;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
}

state AliceWeaponMeleeFire
{
    simulated function PostSlideToTarget()
    {
    }
    
    simulated function bool ShouldSlideToTargetWhenFire(out Vector DeltaPos, out ESpecialMove SM_Slide)
    {
        local AlicePawn AlicePawn;
        local AlicePlayerController APC;
        local Vector vOffset, VDir;
        local float fCollisionRadius;
        
        if (CurrentComboState != 0)
        {
            return false;
        }
        if (!EnableSlideOnMelee)
        {
            return false;
        }
        DeltaPos = vect(0.0, 0.0, 0.0);
        if (PawnSlideToTargetDuration < float(0))
        {
            return false;
        }
        AlicePawn = AlicePawn(Instigator);
        if (AlicePawn == none)
        {
            return false;
        }
        APC = AlicePlayerController(AlicePawn.Controller);
        if (APC == none || APC.TargetingActor == none)
        {
            return false;
        }
        if (Pawn(APC.TargetingActor) != none)
        {
            vOffset = APC.TargetingActor.Location - AlicePawn.Location;
            fCollisionRadius = Pawn(APC.TargetingActor).CylinderComponent.CollisionRadius;
        }
        else if (GameBreakableActor(APC.TargetingActor) != none)
        {
            vOffset = APC.TargetBActorInfo.vLocation - AlicePawn.Location;
            fCollisionRadius = GameBreakableActor(APC.TargetingActor).StaticMeshComponent.Bounds.SphereRadius;
        }
        else
        {
            return false;
        }
        vOffset.Z = 0.0;
        VDir = Normal(vOffset);
        if (VSize(vOffset) > EnableSlideDistance)
        {
            return false;
        }
        if (EnableSlideBackOnMelee && APC.IsLeftStickDownPressed())
        {
            SM_Slide = 54;
            DeltaPos = -VDir * SlideBackwardDistance;
            AlicePawn.SetRotation(rotator(VDir));
            return true;
        }
        else
        {
            SM_Slide = 53;
            vOffset -= VDir * (AlicePawn.CylinderComponent.CollisionRadius + fCollisionRadius);
            if (VSize(vOffset) < SlideMinDistance)
            {
                return false;
            }
            else if (VSize(vOffset) > SlideMaxDistance)
            {
                AlicePawn.SetRotation(rotator(VDir));
                DeltaPos = VDir * SlideMaxDistance;
                return true;
            }
            else
            {
                AlicePawn.SetRotation(rotator(VDir));
                DeltaPos = vOffset;
                return true;
            }
        }
    }
    
    Stop;
}

defaultproperties
{
    WeaponMeleeAnimation_Dash="SM_Combat_ShieldBreakingDash"
    MODDLCAliceDefenceAdd_Percent=0.25
    WeaponMeleeAnimation_NoLock="SM_VorpalBladeNLMeleeAttack"
    AliceMorphName="None"
    AliceMorphParticle="GFX_Alice.Transform.AliceTransform_Blue"
    ChargeCompleteSocket="PSocket"
    ChargeSocket="PSocket"
    TraceSocket="PSocket"
    CanHitClockBomb=True
    MinSwitchJudgeDist=100.0
    MaxSwitchJudgeDist=300.0
    RushBeforeSwitchComboAnimationName="AliceW_WP1_Mele_Attack_Rush_Switch"
    SwitchWeaponAnimationName="AliceW_WP1_Mele_SwitchAttack_1"
    WeaponTypeEnum="EAWT_VorpalBlade"
    FlushParticleComponent="Default__VorpalBlade.ParticleSystemComponent0"
    ChargeParticleComponent="Default__VorpalBlade.ParticleSystemComponent1"
    TracePSCTemplate="GFX_Weapons.VorpalBlade.VB_M_Trail_L4"
    ChargePSCTemplate="GFX_Weapons.VorpalBlade.VB_R_Charge"
    ChargeFinishPSCTemplate="GFX_Weapons.VorpalBlade.VB_R_ChargeComplete"
    AppearPSCTemplate="GFX_Weapons.VorpalBlade.VB_Appear"
    DisAppearPSCTemplate="GFX_Weapons.VorpalBlade.VB_Disappear"
    AudioChargeComp="Default__VorpalBlade.ChargeSound"
    AudioChargeCompleteSound="Default__VorpalBlade.CCS"
    PawnSlideToTargetDuration=0.3
    SlideMaxDistance=300.0
    WeaponFireWaveForm="Default__VorpalBlade.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__VorpalBlade.ForceFeedbackWaveformShooting2"
    ManuallyCurveType="EProjManualCurve_Type1"
    MuzzleFlashPSCTemplate="GFX_Weapons.VorpalBlade.VB_R_Muzzle_L4"
    MuzzleFlashLightClass="AliceBoomshotLight"
    SelfCollisionPhysicsAsset(0)="ANI_Alice.Alice_Knife_Physics"
    MeleeAttackActorList="Default__VorpalBlade.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__VorpalBlade.RadiusAttackActorinfo"
    FiringStatesArray(0)="None"
    FiringStatesArray(1)="AliceWeaponMeleeFire"
    WeaponFireTypes(0)=249
    WeaponFireTypes(1)=30
    FireInterval(0)=0.0
    FireInterval(1)=1.0
    Spread(0)=0.0
    Spread(1)=0.0
    InstantHitDamage(0)=0.0
    InstantHitDamage(1)=7.0
    InstantHitMomentum(0)=0.0
    InstantHitMomentum(1)=0.0
    InstantHitDamageTypes(0)="None"
    InstantHitDamageTypes(1)="DmgType_VorpalBlade_Melee"
    bMeleeWeaponAbility=True
    WeaponMeleeRange=300.0
    Mesh="Default__VorpalBlade.WeaponMesh"
    DroppedPickupMesh="Default__VorpalBlade.WeaponMesh"
    PickupFactoryMesh="Default__VorpalBlade.WeaponMesh"
    Components(0)="Default__VorpalBlade.ChargeSound"
    Components(1)="Default__VorpalBlade.CCS"
    Components(2)="Default__VorpalBlade.WeaponMesh"
}
