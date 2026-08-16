class WeaponForAlice extends AliceGameWeapon
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

struct native WeaponLevelDataPackage
{
    var() SkeletalMesh WLDP_SkeletalMesh;
    var() ParticleSystem WLDP_Particle_Trail;
    var() array<ParticleSystem> WLDP_WeaponEffect;
    var() ParticleSystem WLDP_Particle_Muzzle;
    var() array<AttachedLoopingParticleEffect> AttachedLoopingParticleArray;
    var() array<SoundCue> WLDP_RangeFireSoundCue;
    var() array<SoundCue> WLDP_ChargedRangeFireSoundCue;
    var() class<Projectile> WLDP_Project1;
    var() int WLDP_RunningNoLockMeleeDamage;
    var() int WLDP_SwitchMeleeDamage;
    var() ProjectileLevelDataPackage ProjectilePackage[3];
    var() array<MeleeComboInfo> ComboArray;
};

struct native AttachedLoopingParticleEffect
{
    var() ParticleSystem WLDP_AttachedLoopingParticle;
    var() name AttachedLoopingParticleSocket;
    var export editinline ParticleSystemComponent AttachedLoopingParticleComponent;
};

struct native MeleeComboInfo
{
    var() name AnimationName;
    var() name AnimationTransientName;
    var() bool CanBreakTransient;
    var() float PlayRate;
    var() float TransientPlayRate;
    var() float BlendInTime;
    var() float BlendOutTime;
    var() name WeaponAnimationName;
    var() name WeaponAnimationNameHysteria;
    var() name WeaponAnimationNameDLC;
    var() int Damage;
    var() int RadiusDamage;
};

var name AliceMorphName;
var ParticleSystem AliceMorphParticle;
var(Weapon) float TapTime;
var(Weapon) float ChargeTime;
var(Weapon) name ChargeCompleteSocket;
var(Weapon) name ChargeSocket;
var(Weapon) name TraceSocket;
var int WeaponLevel;
var int SaveWeaponLevel;
var bool FlagComboFromOtherWeapon;
var bool bSuperDamage;
var transient bool bInUse;
var(SlideToTargetOnDodge) bool EnableSlideOnDodge;
var(SlideToTargetOnDodge) bool EnableSlideOnDodgeBack;
var bool bIsSlideToTarget;
var bool FlagHasComboInputBeforeBlendingStart;
var bool FlagComboBlendingStart;
var bool FlagComboInputAcceptStart;
var bool FlagComboInputAcceptFinish;
var bool CanHitClockBomb;
var transient bool bFadeToHide;
var(Weapon) float MinSwitchJudgeDist;
var(Weapon) float MaxSwitchJudgeDist;
var name RushBeforeSwitchComboAnimationName;
var name SwitchWeaponAnimationName;
var EAliceWeaponType WeaponTypeEnum;
var(Weapon) array<WeaponLevelDataPackage> WeaponLevelData;
var export editinline ParticleSystemComponent FlushParticleComponent;
var export editinline ParticleSystemComponent ChargeParticleComponent;
var ParticleSystem TracePSCTemplate;
var array<ParticleSystem> WeaponEffectPSCTemplate;
var(Weapon) ParticleSystem ChargePSCTemplate;
var(Weapon) ParticleSystem ChargeFinishPSCTemplate;
var(Weapon) ParticleSystem AppearPSCTemplate;
var(Weapon) ParticleSystem DisAppearPSCTemplate;
var(Weapon) SoundCue NoAmmoSound;
var export editinline AudioComponent AudioChargeComp;
var export editinline AudioComponent AudioChargeCompleteSound;
var ProjectileLevelDataPackage CurrentProjectilePackage;
var(Weapon) float NoLockHideWeaponTime;
var(DLC) WeaponLevelDataPackage DLCPackage;
var(SlideToTarget) float PawnSlideToTargetDuration;
var(SlideToTarget) float EnableSlideDistance;
var(SlideToTarget) float SlideBackwardDistance;
var(SlideToTarget) float SlideMaxDistance;
var(SlideToTarget) float SlideMinDistance;
var transient export editinline SkeletalMeshComponent CurMeshComponent;

function ClearPressFireButtonTimer()
{
    ClearTimer('PressFireButton');
}

function FadeOutWeapon()
{
    local int I;
    
    bFadeToHide = true;
    for (I = 0; I < WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray.Length; I++)
    {
        if (WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
        {
            WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.DeactivateSystem();
        }
    }
    if (!IsInState('Inactive'))
    {
        GotoState('Inactive');
    }
}

function FadeInWeapon()
{
    local int I;
    
    bFadeToHide = false;
    for (I = 0; I < WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray.Length; I++)
    {
        if (WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
        {
            WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.ActivateSystem();
        }
    }
    if (!IsInState('Active') && !IsInState('NormalFireState') && !IsInState('AliceWeaponMeleeFire') && !IsInState('WeaponPuttingDown'))
    {
        GotoState('Active');
    }
}

function ResetAliceWeapon()
{
}

function SetPawnSlideToTargetParameters(Vector DeltaPos, float DeltaTime)
{
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(Instigator);
    if (AlicePawn == none)
    {
        return;
    }
    if (DeltaTime > float(0) && !IsZero(DeltaPos))
    {
        AlicePawn.SlideToTargetDuration = DeltaTime;
        AlicePawn.SlideToTargetTimeAccumulated = 0.0;
        AlicePawn.SlideToTargetDeltaPos = DeltaPos;
        AlicePawn.SlideToTargetDeltaVel = AlicePawn.SlideToTargetDeltaPos / DeltaTime;
    }
}

simulated function PostSlideToTarget()
{
}

simulated function PreSlideToTarget(Vector DeltaPos, ESpecialMove SM_Slide)
{
    local AlicePawn pPawn;
    
    pPawn = AlicePawn(Instigator);
    if (pPawn != none)
    {
        bIsSlideToTarget = true;
        pPawn.bSlidingToTarget = true;
        pPawn.DoSpecialMove(SM_Slide, true);
        SetPawnSlideToTargetParameters(DeltaPos, PawnSlideToTargetDuration);
        SetTimer(PawnSlideToTargetDuration, false, 'PostSlideToTarget');
    }
}

simulated function ClearAllFireTimers()
{
}

function AnnouncePickup(Pawn Other)
{
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    return false;
}

function OnPauseGame()
{
    PlayerController(Instigator.Controller).SetPause(true);
}

function AnnounceWeaponUpgrade(int oldLevel, int newLevel)
{
    AliceGameInfo(WorldInfo.Game).ShowWeaponUpgradeTip(oldLevel, newLevel, Class);
}

simulated event ParticleSystem GetWeaponLeveDateEffect(int WeaponEffectIndex)
{
    if (WeaponEffectIndex < WeaponEffectPSCTemplate.Length)
    {
        return WeaponEffectPSCTemplate[WeaponEffectIndex];
    }
    else
    {
        return WeaponEffectPSCTemplate[0];
    }
}

simulated event ParticleSystem GetWeaponLeveDateTrails()
{
    return TracePSCTemplate;
}

event PlayMeleeAttackEffectOnAttachedActor(AliceGameNPCAttachedActor AttachedActor, ShapeCollisionResult CollisionResult)
{
    local Vector ImpactLoc;
    local Rotator ImpactRot;
    local PhysicalMaterial PM;
    local ParticleSystem ImpactPS, PSFromProjectile;
    local Emitter ImpactEmitter;
    local SoundCue ImpactCue, CueFromWeapon;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (AttachedActor == none || AttachedActor.SkeletalMeshComponent == none)
    {
        return;
    }
    if (CollisionResult.HitBodySetUp.BoneName != 'None' && CollisionResult.HitBodySetUp.PhysMaterial != none)
    {
        PM = CollisionResult.HitBodySetUp.PhysMaterial;
        if (PM == none)
        {
            return;
        }
        if (CollisionResult.EffectSocketIndex == -1 || !AttachedActor.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex], ImpactLoc, ImpactRot))
        {
            ImpactLoc = AttachedActor.SkeletalMeshComponent.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            ImpactRot = rot(0, 0, 1);
        }
        WorldInfo.LogPhysMatInfo("FXInfoWeapon", string(Name), string(PM.Name));
        ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        if (ImpactPS != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(ImpactPS, true);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(ImpactCue);
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
    }
}

event PlayShieldPhysicsMaterialEffect(Pawn TargetPawn, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult)
{
    local Vector ImpactLoc;
    local PhysicalMaterial PM;
    local ParticleSystem ImpactPS, PSFromProjectile;
    local Emitter ImpactEmitter;
    local SoundCue ImpactCue, CueFromWeapon;
    local AliceGameKynapsePawn TargetNPC;
    local SkeletalMeshComponent ShieldMeshComponent;
    local Rotator ImpactRot;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (TargetPawn == none)
    {
        return;
    }
    TargetNPC = AliceGameKynapsePawn(TargetPawn);
    ShieldMeshComponent = TargetNPC.NPCAttachmentComponentsArray[TargetNPC.ShieldComponentsArray[ShieldResult.ShieldIndex].ComponentIndex].CurrentAttachmentMeshComponent;
    if (TargetNPC != none && ShieldResult.ShieldIndex >= 0 && ShieldResult.ShieldIndex < TargetNPC.ShieldComponentsArray.Length)
    {
        if (CollisionResult.HitBodySetUp != none)
        {
            PM = CollisionResult.HitBodySetUp.PhysMaterial;
        }
        if (PM == none)
        {
            return;
        }
        if (CollisionResult.EffectSocketIndex == -1 || !ShieldMeshComponent.GetSocketWorldLocationAndRotation(CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex], ImpactLoc, ImpactRot))
        {
            ImpactLoc = ShieldMeshComponent.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            ImpactRot = rot(0, 0, 1);
        }
        ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        if (ImpactPS != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(ImpactPS, true);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(ImpactCue);
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
        return;
    }
}

function int GetWeaponLevel()
{
    return WeaponLevel;
}

simulated function ChangeDLCData()
{
    if (WeaponLevel <= 4)
    {
        FlashWeaponDLCMesh();
    }
}

simulated function ChangeLevelData(int Level)
{
    ChangeWeaponLevelData(Level);
    WeaponLevel = Level;
    if (WeaponLevel <= 4)
    {
        SaveWeaponLevel = WeaponLevel;
    }
}

function ResetWeaponAfterChangeLevel()
{
}

simulated event ChangeLevel(int Level)
{
    ChangeLevelData(Level);
    if (Level != 5)
    {
        ChangeDLCData();
    }
    ResetWeaponAfterChangeLevel();
}

function SetLoopingParticle(int Level)
{
    local int I, J;
    local ParticleSystem LoopingParticle;
    local name LoopingParticleSocket;
    
    for (I = 0; I < 5; I++)
    {
        for (J = 0; J < WeaponLevelData[I].AttachedLoopingParticleArray.Length; J++)
        {
            if (WeaponLevelData[I].AttachedLoopingParticleArray[J].AttachedLoopingParticleComponent != none)
            {
                Mesh.DetachComponent(WeaponLevelData[I].AttachedLoopingParticleArray[J].AttachedLoopingParticleComponent);
            }
        }
    }
    for (I = 0; I < WeaponLevelData[Level - 1].AttachedLoopingParticleArray.Length; I++)
    {
        LoopingParticle = WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].WLDP_AttachedLoopingParticle;
        LoopingParticleSocket = WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleSocket;
        if (LoopingParticle != none && LoopingParticleSocket != 'None')
        {
            if (WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent == none)
            {
                WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent = new(self) class'Engine.ParticleSystemComponent';
            }
            if (WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
            {
                WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.SetTemplate(LoopingParticle);
                Mesh.AttachComponentToSocket(WeaponLevelData[Level - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent, LoopingParticleSocket);
            }
        }
    }
}

function FlashWeaponDLCMesh()
{
    if (GetDLCWeaponFlag() == 1)
    {
        SetDLCLevelData();
    }
}

function SetDLCLevelData()
{
    Mesh.SetSkeletalMesh(DLCPackage.WLDP_SkeletalMesh);
    TracePSCTemplate = DLCPackage.WLDP_Particle_Trail;
    WeaponEffectPSCTemplate = DLCPackage.WLDP_WeaponEffect;
    MuzzleFlashPSCTemplate = DLCPackage.WLDP_Particle_Muzzle;
    WeaponProjectiles[0] = DLCPackage.WLDP_Project1;
    CurrentProjectilePackage = DLCPackage.ProjectilePackage[0];
}

function ChangeWeaponLevelData(int Level)
{
    local float OldLevelProjectileDamage, OldLevelProjectileDamageRadius;
    
    if (Level - 1 >= WeaponLevelData.Length)
    {
    }
    else
    {
        Mesh.SetSkeletalMesh(WeaponLevelData[Level - 1].WLDP_SkeletalMesh);
        TracePSCTemplate = WeaponLevelData[Level - 1].WLDP_Particle_Trail;
        WeaponEffectPSCTemplate = WeaponLevelData[Level - 1].WLDP_WeaponEffect;
        MuzzleFlashPSCTemplate = WeaponLevelData[Level - 1].WLDP_Particle_Muzzle;
        WeaponProjectiles[0] = WeaponLevelData[Level - 1].WLDP_Project1;
        if (Level == 5)
        {
            OldLevelProjectileDamage = CurrentProjectilePackage.Damage;
            OldLevelProjectileDamageRadius = CurrentProjectilePackage.DamageRadius;
        }
        CurrentProjectilePackage = WeaponLevelData[Level - 1].ProjectilePackage[0];
        if (Level == 5)
        {
            CurrentProjectilePackage.Damage = OldLevelProjectileDamage;
            CurrentProjectilePackage.DamageRadius = OldLevelProjectileDamageRadius;
        }
        CurMeshComponent = Mesh;
    }
}

simulated function NotifyLockTargetAttackHappen(EAliceWeaponType Type)
{
    local AlicePawn pPawn;
    local AliceGameKynapsePawn PKynapsePawn;
    
    pPawn = AlicePawn(Instigator);
    PKynapsePawn = AliceGameKynapsePawn(pPawn.GetCurrentAttackTargetActor());
    if (AlicePlayerController(pPawn.Controller).bFirstPersonViewActive && AlicePlayerController(pPawn.Controller).AimingReticuleTarget != none)
    {
        PKynapsePawn = AliceGameKynapsePawn(AlicePlayerController(pPawn.Controller).AimingReticuleTarget);
    }
    if (PKynapsePawn != none)
    {
        switch (Type)
        {
            case 1:
                AliceGameKynapseAIController(PKynapsePawn.Controller).RegisterSphinxEvent(5);
                break;
            case 4:
                AliceGameKynapseAIController(PKynapsePawn.Controller).RegisterSphinxEvent(4);
                break;
            case 2:
                AliceGameKynapseAIController(PKynapsePawn.Controller).RegisterSphinxEvent(6);
                break;
            case 3:
                AliceGameKynapseAIController(PKynapsePawn.Controller).RegisterSphinxEvent(3);
                break;
            default:
        }
    }
}

simulated function PressFireButton()
{
}

simulated function ReleaseFireButton()
{
}

simulated function HandleFinishedFiring()
{
    FlushParticleComponent.DeactivateSystem();
    FlushParticleComponent.SetActive(false);
    ChargeParticleComponent.DeactivateSystem();
    ChargeParticleComponent.SetActive(false);
    HandleFinishedFiring();
}

function bool AllowSwitchOtherWeapon()
{
    return true;
}

function ReSetAllFlag()
{
}

simulated function ForceEndFire()
{
    ReSetAllFlag();
    FlushParticleComponent.KillParticlesForced();
    ChargeParticleComponent.KillParticlesForced();
    ForceEndFire();
}

simulated function CleanInfoWhenBreak()
{
}

simulated function StopParticleTrail()
{
    FlushParticleComponent.SetActive(false);
    ChargeParticleComponent.SetActive(false);
}

simulated function bool IsWeaponFadeToHide()
{
    return bFadeToHide;
}

simulated function bool IsWeaponHidden()
{
    return Mesh.HiddenGame;
}

simulated function ForceWeaponSetHidden(bool Set)
{
    WeaponSetHidden(Set, true);
}

simulated function WeaponSetHidden(bool Set, optional bool bForce = false)
{
    if (IsFiring() == false || bForce == true)
    {
        if (Set == true)
        {
            FlushParticleComponent.SetTemplate(DisAppearPSCTemplate);
            FlushParticleComponent.SetActive(true);
        }
        else
        {
            FlushParticleComponent.SetTemplate(AppearPSCTemplate);
            FlushParticleComponent.SetActive(true);
        }
        Mesh.SetHidden(Set);
    }
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local AliceGameKynapsePawn ap;
    local Vector FakeRootMotionDirection;
    local Rotator FakeRootMotionRot, DiffRot;
    
    if (Impact.HitActor != none)
    {
        if (AlicePawn(Impact.HitActor) != none)
        {
            return;
        }
        ap = AliceGameKynapsePawn(Impact.HitActor);
        if (ap != none)
        {
            ap.CurrentDmgStrength = InstantHitDamageStrength;
        }
        if (ap != none && ap.Mesh != none && ap.ShouldDoKnockBack(ap.CurrentDmgStrength) && DefaultCombatGlobalConfig.KnockBackParas.Length != 0 && InstantRangeAttackKnockBackParamID >= 0)
        {
            FakeRootMotionDirection = Instigator.Location - ap.Location;
            FakeRootMotionDirection.Z = 0.0;
            FakeRootMotionRot = rotator(FakeRootMotionDirection);
            if (Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw)) > float(0))
            {
                DiffRot = Normalize(FakeRootMotionRot - Instigator.Rotation);
                if (DiffRot.Yaw > 0)
                {
                    FakeRootMotionRot = Normalize(FakeRootMotionRot + MakeRotator(0, int(Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw))), 0));
                }
                else
                {
                    FakeRootMotionRot = Normalize(FakeRootMotionRot + MakeRotator(0, int(-Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw))), 0));
                }
            }
            if (ap.AbsKnockBackTotalTime >= 0.0 && ap.AbsKnockBackScale >= 0.0)
            {
                ap.Mesh.SetFakeRootMotionPara(ap.AbsKnockBackScale, ap.AbsKnockBackTotalTime, 10, FakeRootMotionRot);
                ap.Mesh.ActiveFakeRootMotion();
                ap.Mesh.FakeRootMotionMode = 3;
            }
            else
            {
                ap.Mesh.SetFakeRootMotionPara(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackScale, DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackTotalTime, 10, FakeRootMotionRot);
                ap.Mesh.ActiveFakeRootMotion();
                ap.Mesh.FakeRootMotionMode = 3;
            }
        }
        ProcessInstantHit(FiringMode, Impact, NumHits);
    }
}

simulated function BeginFire(byte FireModeNum)
{
    BeginFire(FireModeNum);
}

simulated function StartFire(byte FireModeNum)
{
    StartFire(FireModeNum);
    bInUse = true;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    ChangeLevel(WeaponLevel);
}

simulated function bool CanPerformNextAction()
{
}

simulated state Active
{
    simulated event EndState(name NextStateName)
    {
        local int I;
        
        EndState(NextStateName);
        for (I = 0; I < WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray.Length; I++)
        {
            if (WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
            {
                WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.DeactivateSystem();
            }
        }
    }
    
    event Tick(float DeltaTime)
    {
        local int I;
        
        Global.Tick(DeltaTime);
        if (Mesh.HiddenGame)
        {
            for (I = 0; I < WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray.Length; I++)
            {
                if (WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
                {
                    WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.DeactivateSystem();
                }
            }
        }
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        local int I;
        
        BeginState(PreviousStateName);
        SetLoopingParticle(WeaponLevel);
        for (I = 0; I < WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray.Length; I++)
        {
            if (WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent != none)
            {
                WeaponLevelData[WeaponLevel - 1].AttachedLoopingParticleArray[I].AttachedLoopingParticleComponent.ActivateSystem();
            }
        }
    }
    
    Stop;
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        if (InvManager.CancelWeaponChange())
        {
            return;
        }
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        AlicePawn(Instigator).FadeOutWeapon();
        DetachWeapon();
        GotoState('Inactive');
        InvManager.ChangedWeapon();
    }
    
    Stop;
}

defaultproperties
{
    AliceMorphName="WeaponForAlice"
    WeaponLevel=1
    MinSwitchJudgeDist=-1.0
    MaxSwitchJudgeDist=-1.0
    FlushParticleComponent="Default__WeaponForAlice.ParticleSystemComponent0"
    ChargeParticleComponent="Default__WeaponForAlice.ParticleSystemComponent1"
    AudioChargeComp="Default__WeaponForAlice.ChargeSound"
    AudioChargeCompleteSound="Default__WeaponForAlice.CCS"
    NoLockHideWeaponTime=5.0
    PawnSlideToTargetDuration=0.3
    EnableSlideDistance=1000.0
    SlideBackwardDistance=300.0
    SlideMaxDistance=500.0
    SlideMinDistance=100.0
    WeaponFireWaveForm="Default__WeaponForAlice.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__WeaponForAlice.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__WeaponForAlice.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__WeaponForAlice.RadiusAttackActorinfo"
    EquipTime=0.01
    PutDownTime=0.01
    Mesh="Default__WeaponForAlice.WeaponMesh"
    Components(0)="Default__WeaponForAlice.ChargeSound"
    Components(1)="Default__WeaponForAlice.CCS"
}
