class HobbyHorse extends WeaponForAliceMelee
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug);

struct native HobbyHorseLevelDataPackage
{
    var() export AliceExplosionLightTemplate RadiusAttackLightTemplate;
};

var export AliceExplosionLightTemplate RadiusAttackLightTemplate;
var() array<HobbyHorseLevelDataPackage> HobbyHorseLevelData;
var() int Achievement31CheckCount;
var bool bPendingTriggerGhost;
var bool bVampireModeActivated;
var int MaxTriggerGhostCount;
var int GhostCheckRadius;
var int DamageValue;
var EDamageStrengthType GhostDmgStrength;
var float GhostSpeed;
var transient ParticleSystem GhostTemplate;
var transient float HeightGap;
var transient int GhostLeftCount;
var transient float HalfAngleGap;
var transient Vector BackUpAliceLoc;
var transient Rotator BackUpAliceRot;
var(DLC) int VampireWeaponPerHit_AbsValue;

function UpdateAchievement29()
{
    if (AliceGameInfo(WorldInfo.Game).Achievement29 == 1)
    {
        ConsoleCommand("trophy unlock=31");
    }
}

simulated event TriggerRadiusDamageLight()
{
    local Vector RadiusLoc;
    local Rotator RadiusRot;
    local AliceExplosionLight Light;
    
    if (!GetWeaponMesh().GetSocketWorldLocationAndRotation(RadiusAttackSocket, RadiusLoc, RadiusRot))
    {
        RadiusLoc = Instigator.Location;
    }
    Light = AliceGameEmitterPool(WorldInfo.MyEmitterPool).SpawnTemplateExplosionLight(RadiusAttackLightTemplate, RadiusLoc);
    Light.ResetLight();
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
    Mesh.AttachComponentToSocket(FlushParticleComponent, ChargeSocket);
    Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeCompleteSocket);
}

function DataSwitchForHysteria()
{
    local int Index;
    
    for (Index = 0; Index < WeaponMeleeComboInfo.Length; Index++)
    {
        WeaponMeleeComboInfo[Index].WeaponAnimationName = WeaponMeleeComboInfo[Index].WeaponAnimationNameHysteria;
    }
}

simulated function ChangeDLCData()
{
    local int Index;
    
    ChangeDLCData();
    if (GetDLCWeaponFlag() == 1)
    {
        for (Index = 0; Index < WeaponMeleeComboInfo.Length; Index++)
        {
            WeaponMeleeComboInfo[Index].WeaponAnimationName = WeaponMeleeComboInfo[Index].WeaponAnimationNameDLC;
        }
        bVampireModeActivated = true;
    }
}

simulated function ChangeLevelData(int Level)
{
    ChangeLevelData(Level);
    if (Level <= HobbyHorseLevelData.Length)
    {
        RadiusAttackLightTemplate = HobbyHorseLevelData[Level - 1].RadiusAttackLightTemplate;
    }
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_HH_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_HH_Enable())
    {
        return 1;
    }
    return 0;
}

simulated function PostBeginPlay()
{
    bVampireModeActivated = false;
    PostBeginPlay();
}

native final function RegistGhostDestroy()
{
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
    RadiusAttackLightTemplate=(TimeShift=(),HighDetailFrameTime=0.15,bCheckFrameRate=False,CastShadows=False)
    Achievement31CheckCount=3
    VampireWeaponPerHit_AbsValue=5
    WeaponMeleeAnimation_NoLock="SM_HobbyHorseNLMeleeAttack"
    AliceMorphName="Alice_MorphOrange"
    AliceMorphParticle="GFX_Alice.Transform.AliceTransform_Orange"
    ChargeCompleteSocket="PSocket"
    ChargeSocket="PSocket"
    CanHitClockBomb=True
    SwitchWeaponAnimationName="AliceW_WP2_Mele_SwitchAttack_1"
    WeaponTypeEnum="EAWT_HobbyHorse"
    FlushParticleComponent="Default__HobbyHorse.ParticleSystemComponent0"
    ChargeParticleComponent="Default__HobbyHorse.ParticleSystemComponent1"
    TracePSCTemplate="GFX_Weapons.hatterstaff.HF_M_Trail_L4"
    ChargePSCTemplate="GFX_Weapons.hatterstaff.HF_R_Charge"
    ChargeFinishPSCTemplate="GFX_Weapons.hatterstaff.HF_R_ChargeComplete"
    AppearPSCTemplate="GFX_Weapons.VorpalBlade.VB_Appear"
    DisAppearPSCTemplate="GFX_Weapons.VorpalBlade.VB_Disappear"
    NoAmmoSound="SFX_Combat.Flail_No_Ammo_Cue"
    AudioChargeComp="Default__HobbyHorse.ChargeSound"
    AudioChargeCompleteSound="Default__HobbyHorse.CCS"
    WeaponFireWaveForm="Default__HobbyHorse.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__HobbyHorse.ForceFeedbackWaveformShooting2"
    ManuallyCurveType="EProjManualCurve_Type1"
    MuzzleFlashPSCTemplate="GFX_Weapons.VorpalBlade.VB_R_Muzzle_L4"
    MuzzleFlashLightClass="AliceBoomshotLight"
    SelfCollisionPhysicsAsset(0)="CH_Alice_Graphic.PhysicsAsset.SK_Wp2_Physics"
    MeleeAttackActorList="Default__HobbyHorse.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__HobbyHorse.RadiusAttackActorinfo"
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
    InstantHitDamageTypes(1)="DmgType_HobbyHorse_Melee"
    bMeleeWeaponAbility=True
    WeaponMeleeRange=300.0
    Mesh="Default__HobbyHorse.WeaponMesh"
    Components(0)="Default__HobbyHorse.ChargeSound"
    Components(1)="Default__HobbyHorse.CCS"
    Components(2)="Default__HobbyHorse.WeaponMesh"
}
