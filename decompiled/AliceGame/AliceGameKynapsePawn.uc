class AliceGameKynapsePawn extends AliceGamePawn
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EXPType
{
    UseManualXPAmount,
    ET2SmlXPAmount,
    ET2MedXPAmount,
    ET2LgeXPAmount,
    ET1MedXPAmount,
    ET1LgeXPAmount,
    ET1BossXPAmount,
};

enum EShieldOrientType
{
    EShieldOrientType_Front,
    EShieldOrientType_Top,
};

enum ECollisionMode
{
    ECollisionMode_BodyCylinderComponent,
    ECollisionMode_BonesAABB,
    ECollisionMode_BonesShapes,
};

enum ENPCAttachmentComponentAttachType
{
    ENPCAttachmentComponentAttachType_ParentAttach,
    ENPCAttachmentComponentAttachType_SocketAttach,
};

enum ENPCAttachmentComponentType
{
    ENPCAttachmentComponentType_Decoration,
    ENPCAttachmentComponentType_Body,
    ENPCAttachmentComponentType_Head,
};

enum EHealthState
{
    EHealthState_Normal,
    EHealthState_Injured,
    EHealthState_Dead,
};

enum ENPCState
{
    ENPC_Normal,
    ENPC_Injured,
    ENPC_Dead,
};

struct native SmartHP
{
    var() int HPPercentage;
    var() array<DropHPProbability> DropProbability;
};

struct native DropHPProbability
{
    var() int HP;
    var() float Probability;
    var float BeginNumber;
    var float EndNumber;
};

struct native LoopParticleInfo
{
    var() ParticleSystem LoopPS;
    var() name SocketName;
    var() int AttachComponentIndex;
    var() float DrawScale;
    var export editinline ParticleSystemComponent LoopPSComponent;
    var bool bEnable;
};

struct native LoopSoundInfo
{
    var() SoundCue LoopSound;
    var() name SocketName;
    var() int AttachComponentIndex;
    var export editinline AudioComponent LoopSoundComponent;
    var bool bEnable;
};

struct native NPCAttachedActor
{
    var() AliceGameNPCAttachedActor AttachedActorArcheType;
    var AliceGameNPCAttachedActor AttachedActor;
    var() name AttachSocketName;
    var() int LockOnSocketIndex;
    var bool bSonarActive;
};

struct native ShieldPara
{
    var() bool bAvaliable;
    var transient bool bInShield;
    var() ShieldComponentInfo ShieldInfo;
    var() int ComponentIndex;
};

struct native ShieldComponentInfo
{
    var() PhysicsAsset ShieldPhysicsAsset;
    var() ECollisionMode CollisionMode;
    var() EShieldOrientType ShieldOrient;
    var() name ShieldOrientSocket;
    var() Rotator ShieldOrientRefAngle;
    var() float ShieldAreaAngle0;
    var() float ShieldAreaAngle1;
    var() bool PlayAliceReactAnimVorpalBlade;
    var() bool PlayAliceReactAnimHobbyHorse;
    var name ReactByDashPackage;
    var transient int ReactByDashPackageIndex;
    var() name ReactByVorpalBladePackage;
    var int ReactByVorpalBladePackageIndex;
    var() bool ReactByVorpalBladeSkipPlayPhysMaterialEffect;
    var() name ReactByHobbyHorsePackage;
    var int ReactByHobbyHorsePackageIndex;
    var() bool ReactByHobbyHorseSkipPlayPhysMaterialEffect;
    var() name ReactByPepperGrinderPackage;
    var int ReactByPepperGrinderPackageIndex;
    var() bool ReactByPepperGrinderSkipPlayPhysMaterialEffect;
    var() name ReactByPepperGrinderChargedPackage;
    var int ReactByPepperGrinderChargedPackageIndex;
    var() bool ReactByPepperGrinderChargedSkipPlayPhysMaterialEffect;
    var() name ReactByTeaCannonPackage;
    var int ReactByTeaCannonPackageIndex;
    var() bool ReactByTeaCannonSkipPlayPhysMaterialEffect;
    var() name ReactByDeflectProjectilePackage;
    var int ReactByDeflectProjectilePackageIndex;
    var() bool ReactByDeflectProjectileSkipPlayPhysMaterialEffect;
    var() bool CanBreakStrikBack;
    var() float KnockBackDistScale;
    var() float KnockBackTimeScale;
    var() bool bPenetrableToProjectile;
    var() bool bNoBlockVorpalBlade;
    var() bool bNoBlockHobbyHorse;
    var() bool bNoBlockPepperGrinder;
    var() bool bNoBlockTeapotCannon;
};

struct native NPCAttachmentComponent
{
    var() ENPCAttachmentComponentType NPCAttachmentComponentType;
    var() ENPCAttachmentComponentAttachType NPCAttachmentComponentAttachType;
    var() name AttachSocketName;
    var() int AttachSocketComponentIndex;
    var() int ExclusiveArrayIndex;
    var() int ComponentChance;
    var() array<ComponentSkeletalMeshOption> ComponentSkeletalMeshArray;
    var() float ScaleValue;
    var() float RagdollTime;
    var() float FadeOutTime;
    var transient float LeftRagdollTime;
    var transient float LeftFadeOutTime;
    var() name FadeOutTimeVaryParamName;
    var() bool FadeOutMaterialUseDuplicate;
    var() bool FadeOutAlpha;
    var export editinline SkeletalMeshComponent CurrentAttachmentMeshComponent;
    var AliceGameDropActor CurrentDropActor;
    var int CurrentAttachmentMeshComponentIndex;
    var int CurrentAttachmentMeshMaterialIndex;
    var() bool bHiddenComponent;
    var bool bHited;
    var bool bSonarActive;
};

struct native ComponentSkeletalMeshOption
{
    var() SkeletalMesh ComponentSkeletalMesh;
    var() PhysicsAsset RagdollPhysicsAsset;
    var() int ExclusiveSubArrayIndex;
    var() array<MaterialSet> MaterialArray;
    var() array<MaterialSet> LockOnHighlightMaterialArray;
    var() array<MaterialSet> DeathMaterialArray;
};

struct native MaterialSet
{
    var() const array<MaterialInterface> Materails;
};

struct native TagetInfo
{
    var Pawn Pawn;
    var int currentIndexOfTargetingSocket;
    var() array<TargetableSocketInfo> TargetSockets;
};

struct native TargetableSocketInfo
{
    var() name SocketName;
    var() name CollisionSocketName;
    var() name CameraTargetSocket;
    var() bool bEnable;
    var() bool bHideUI;
    var() bool bCriticalUI;
    var Vector LockOnLocation;
    var Rotator LockOnRotation;
    var Vector CollisionLocation;
    var Rotator CollisionRotation;
};

struct native NPCTakeDamageAnimInfo
{
    var() EDamageStrengthType DmgStrength;
    var() int AnimIndex;
    var() Rotator DamageRotationRate;
    var() bool bKnockBack;
    var() bool bPhysicalAnim;
};

struct native NPCBackUpHeadSkeletalControllerInfo
{
    var name ControlName;
    var bool Actived;
};

var transient float fAngleToAlice;
var transient int AngleIndex;
var int MagicAcheivmentIdentify;
var int MagicValueForAcheivment;
var array<NPCBackUpHeadSkeletalControllerInfo> BackupHealControllerInfo;
var ENPCState NPCState;
var EHealthState HealthState;
var EAIState AIState;
var DT_WeaponIndentify DiedByWeaponIndectify;
var(XP) EXPType FixedXPEnum;
var transient EPhysics OldPhysicsBeforeAttach;
var WeaponForNPC MyWeapon;
var() array<AnimationParaConfig> NPCAnimationParaConfigs;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var() float EnemyLevel;
var int EnemyClassRank;
var() float InjuredStateHPPercent;
var() bool EnableInjuredState;
var bool bSkipEffectWhenVBDamaged;
var bool bSkipEffectWhenHHDamaged;
var bool bSkipEffectWhenESDamaged;
var bool bSkipEffectWhenTCDamaged;
var bool bSkipEffectWhenNPCProjectDamaged;
var bool bDamageAllowPlayInNotify;
var() bool bIsUsingSphinxConfigInit;
var() bool bIsSleeping;
var() bool bIsIdle;
var() bool bIsWandering;
var() bool bIsFollowingPath;
var() bool bIsFighting;
var() bool bNotifyTeammateToFight;
var(AISphinxIndex) bool CanUseJumpPad;
var() bool bSkipCheckVorpalBlade;
var() bool bSkipCheckEyeStaff;
var() bool bSkipCheckHobbyHorse;
var() bool bSkipCheckTeapotCannon;
var() bool bAttractedByBomb;
var() bool bCanFrozenByBomb;
var bool bPauseTick;
var(Collision) bool IsTakeFallingDamaged;
var(Collision) bool bUsePhysicalAssetCollision;
var() bool bLineCheckPhysMatResult;
var(HP) bool CanSpawnHealth;
var(HP) bool UseSmartHealthSpawn;
var(XP) bool CanSpawnXP;
var bool bForceUseManualHP;
var bool bForceUseManualXP;
var() bool bIPAlertIsOn;
var() bool bAlwaysLookatAlice;
var() bool bLookatActive;
var transient bool bInterpolatingAttchedPosition;
var transient bool bBeingAttachedToAlice;
var bool bFirstTickDetectRagdoll;
var bool bRagDollStarted;
var transient bool bSkipBlockingCheckWithDesiredBlockingVolumn;
var transient bool bSkipBlockingCheckWithAlice;
var transient bool bSkipBlockingCheckWithOtherNPC;
var transient bool bSkipCheckWithJumpingNPC;
var() bool bDamageRotEnable;
var bool bSonarActive;
var bool bSonarActor;
var() const export editinline KynapseHandle KynapseHandle;
var() export editinline array<SphinxScriptSequenceEventPackage> EventPackages;
var() export editinline array<SphinxScriptSequenceHealthEventPackage> HealthEventPackages;
var() SphinxWanderVolume WanderVolume;
var() Route FollowRoute;
var() SphinxTeamContainer MyTeam;
var Vector NpcSpawnOriginalLocation;
var(AISphinxIndex) array<NPCTakeDamageAnimInfo> TakeDamageAnimArray;
var(AISphinxIndex) int PathEndIndex;
var(AISphinxIndex) int InterstingPointIndex;
var(AISphinxIndex) int DeathIndex;
var(AISphinxIndex) name WarningPackagePrimary;
var name WarningPackageAlternate;
var int ConfigWarningAlternateIndex;
var(AISphinxIndex) array<name> WarningPackageAlternateArray;
var(AISphinxIndex) name TeammateNotifyPackage;
var(AISphinxIndex) int SleepIndex;
var(AISphinxIndex) int WakeIndex;
var(AISphinxIndex) int TauntIndex;
var(AISphinxIndex) name DeathByLightMeleePackage;
var(AISphinxIndex) name DeathByHeavyMeleePackage;
var(AISphinxIndex) name DeathByLightRangePackage;
var(AISphinxIndex) name DeathByHeavyRangePackage;
var(AISphinxIndex) name HitByDashPackage;
var() array<NPCAttachmentComponent> NPCAttachmentComponentsArray;
var transient export editinline SkeletalMeshComponent HeadComponent;
var() array<ShieldPara> ShieldComponentsArray;
var() array<NPCAttachedActor> NPCAttachedActors;
var() array<LoopSoundInfo> LoopSounds;
var() array<LoopParticleInfo> LoopParticles;
var(LockOnMode) TagetInfo LockOnInfo;
var(LockOnMode) float HightlightMaterials_Head;
var(LockOnMode) float HightlightMaterials_Body;
var(LockOnMode) float MinCamDistance;
var(LockOnMode) float MaxCamDistance;
var(LockOnMode) float MinToMaxCamDistanceFactor;
var(LockOnMode) float MinAliceToNPCDistance;
var(LockOnMode) float MaxAliceToNPCDistance;
var SeqAct_Interp ControlledInterp;
var int IndexInLatentActors;
var(Collision) PhysicalMaterial PhysMaterial;
var(Collision) name PhysicalMaterialSocket;
var Pawn killerPawn;
var(HP) HealthPickup LargeHealthPickupArchetype;
var(HP) HealthPickup SmallHealthPickupArchetype;
var(HP) int ManualHPAmountEasy;
var(HP) int ManualHPAmountNormal;
var(HP) int ManualHPAmountHard;
var(HP) int ManualHPAmountVeryHard;
var(XP) XPPickup LargeXPPickupArchetype;
var(XP) XPPickup SmallXPPickupArchetype;
var(XP) int ManualXPAmountEasy;
var(XP) int ManualXPAmountNormal;
var(XP) int ManualXPAmountHard;
var(XP) int ManualXPAmountVeryHard;
var DropItemsFactory DropFactory;
var(KnockBack) float KnockBackDistScale;
var(KnockBack) float KnockBackTimeScale;
var int SphinxEventAnimTreeBranchIndex;
var(NPCAttachment) float DamagePerTimeUnitWhenAttached;
var(NPCAttachment) float InterpolationTimeWhenStartAttaching;
var(NPCAttachment) const ParticleSystem DamageParticleWhenAttached;
var export editinline AudioComponent AttachLeechAC;
var(NPCAttachment) SoundCue AttachLeechLoopingCue;
var(NPCAttachment) float AttachLeechSndCueFadeTime;
var(NPCAttachment) SoundCue AttachedNPCBiteAliceSoundCue;
var(NPCAttachment) SoundCue AttachedNPCAliceDamagedSoundCue;
var transient float fTimeInterpolatingAttachedPosition;
var transient Vector StartLocationInterpolatingAttachToAlice;
var transient Rotator StartRotationInterpolatingAttachToAlice;
var() SoundCue AmbientSound;
var() export editinline AudioComponent AmbientSoundComponent;
var() float AmbientSoundFadeInTime;
var() float AmbientSoundFadeOutTime;

event PostSetSonarActive()
{
    if (bSonarActor && bSonarActive)
    {
        Controller.AddSonarDetectedActor(self);
    }
    else
    {
        Controller.RemoveSonarDetectedActor(self);
    }
}

event FaceFXAsset GetActorFaceFXAsset()
{
    if (HeadComponent != none)
    {
        return HeadComponent.SkeletalMesh.FaceFXAsset;
    }
    else if (Mesh != none)
    {
        return Mesh.SkeletalMesh.FaceFXAsset;
    }
    return none;
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    if (HeadComponent != none)
    {
        HeadComponent.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
    }
    else if (Mesh != none)
    {
        Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
    }
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    if (HeadComponent != none)
    {
        return HeadComponent.IsPlayingFaceFXAnim();
    }
    else
    {
        return Mesh != none && Mesh.IsPlayingFaceFXAnim();
    }
}

event StopActorFaceFXAnim()
{
    if (HeadComponent != none)
    {
        HeadComponent.StopFaceFXAnim();
    }
    else if (Mesh != none)
    {
        Mesh.StopFaceFXAnim();
    }
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    if (HeadComponent != none)
    {
        return HeadComponent.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
    }
    else
    {
        return Mesh != none && Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
    }
}

function PlayPhysMatEffectInDamageZone(int iWeaponLevel)
{
    local PhysicsAsset SimplePhysAsset;
    local PhysicalMaterial PM, outPM;
    local RB_BodySetup BodySetup;
    local int bProjectOnSurface, FXIndex, I;
    local float ProjectionDistance;
    local array<int> DecalBuffer;
    local name SocketName;
    local Vector ImpactLoc;
    local Rotator ImpactRot;
    local DecalData DecalData;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = 0;
    InDLCWeaponFlag = (AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_Enable() ? 1 : 0);
    OutDLCMatFlag = 0;
    if (CurrentCollisionPhysicsAssetID >= 0 && CurrentCollisionPhysicsAssetID < CollisionPhysicsAssets.Length)
    {
        SimplePhysAsset = CollisionPhysicsAssets[CurrentCollisionPhysicsAssetID];
    }
    if (SimplePhysAsset == none)
    {
        return;
    }
    BodySetup = SimplePhysAsset.BodySetup[0];
    if (BodySetup == none || BodySetup.PhysMaterial == none)
    {
        return;
    }
    PM = BodySetup.PhysMaterial;
    WorldInfo.LogPhysMatInfo("ProjectileDamageZone", string(Name), string(PM.Name));
    SocketName = PhysicalMaterialSocket;
    class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(PM, class'PepperGrinderAlternateProjectile', InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, iWeaponLevel, DecalBuffer);
    foreach DecalBuffer(I)
    {
        DecalData = class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
        if (DecalData.bIsValid)
        {
            Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
            if (DecalData.DecalMaterial != none)
            {
                LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, 'None', DecalData);
                if (bool(bProjectOnSurface))
                {
                    LeaveADecal(DecalTrace_360AroundPawn_Down, DecalData, ProjectionDistance, true);
                }
            }
        }
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    if (bInJumpPad)
    {
        bInJumpPad = false;
        JumpPadNPC(JumpPad).NotifyLanded();
        JumpPad = none;
        AliceGameKynapseAIController(Controller).GotoState('NPCNormal');
        SetPhysics(1);
    }
    if (Physics == 2)
    {
        AliceGameKynapseAIController(Controller).NotifyNPCLandedFromFalling();
    }
}

simulated function OnAttachedActorDie(AliceGameNPCAttachedActor AttachedActor, int ActorID)
{
    if (NPCAttachedActors[ActorID].AttachedActor == AttachedActor)
    {
        WakeUpNPCAttachedActor(false, ActorID, -1);
    }
}

function bool GetGroundLoc(out Vector GroundLoc)
{
    local Vector PawnLoc, TraceStart, TraceDest, out_HitLocation, out_HitNormal, TraceExtent;
    local float CurrHeight;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    
    PawnLoc = Location;
    CurrHeight = GetCollisionHeight();
    TraceStart = PawnLoc;
    TraceDest = PawnLoc - vect(0.0, 0.0, 1.0) * CurrHeight - vect(0.0, 0.0, 50.0);
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo, 8411);
    if (TraceActor != none)
    {
        GroundLoc = out_HitLocation;
        return true;
    }
    return false;
}

function PlayRagDollPMEffect(PhysicalMaterial PhysMat, Vector HitLocation)
{
    local Emitter ImpactEmitter;
    
    if (PhysMat == none || !PhysMat.EnableRagdollEffect)
    {
        return;
    }
    if (PhysMat.RagdollImpactParticle != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(HitLocation);
            ImpactEmitter.SetTemplate(PhysMat.RagdollImpactParticle, true);
        }
    }
    if (PhysMat.RagdollImpactSound != none)
    {
        PlaySound(PhysMat.RagdollImpactSound);
    }
}

function DetectRagDollHitGround()
{
    local int I;
    local Vector vGroundLoc, vExtent, vHitLocation;
    local NPCAttachmentComponent pNPCComponent;
    local ComponentSkeletalMeshOption pSkeletalMesh;
    local PhysicalMaterial PhysMat;
    
    vExtent = vect(500.0, 500.0, 5.0);
    if (!GetGroundLoc(vGroundLoc))
    {
        return;
    }
    for (I = 0; I < NPCAttachmentComponentsArray.Length; I++)
    {
        pNPCComponent = NPCAttachmentComponentsArray[I];
        pSkeletalMesh = pNPCComponent.ComponentSkeletalMeshArray[pNPCComponent.CurrentAttachmentMeshComponentIndex];
        if (pSkeletalMesh.ComponentSkeletalMesh != none && pSkeletalMesh.RagdollPhysicsAsset != none && pNPCComponent.CurrentAttachmentMeshComponent != none)
        {
            if (pSkeletalMesh.RagdollPhysicsAsset.DetectAABBHitGround(PhysMat, vHitLocation, pNPCComponent.CurrentAttachmentMeshComponent, vGroundLoc, vExtent, false))
            {
                if (!NPCAttachmentComponentsArray[I].bHited && !bFirstTickDetectRagdoll)
                {
                    PlayRagDollPMEffect(PhysMat, vHitLocation);
                }
                else if (bFirstTickDetectRagdoll)
                {
                }
                NPCAttachmentComponentsArray[I].bHited = true;
            }
            continue;
        }
        if (NPCAttachmentComponentsArray[I].CurrentDropActor != none && pSkeletalMesh.RagdollPhysicsAsset != none && NPCAttachmentComponentsArray[I].CurrentDropActor.SkelComp != none)
        {
            if (pSkeletalMesh.RagdollPhysicsAsset.DetectAABBHitGround(PhysMat, vHitLocation, NPCAttachmentComponentsArray[I].CurrentDropActor.SkelComp, vGroundLoc, vExtent, false))
            {
                if (!NPCAttachmentComponentsArray[I].bHited && !bFirstTickDetectRagdoll)
                {
                    PlayRagDollPMEffect(PhysMat, vHitLocation);
                }
                NPCAttachmentComponentsArray[I].bHited = true;
            }
            continue;
        }
    }
    bFirstTickDetectRagdoll = false;
    return;
}

function string GetStringInfo(NPCAttachmentComponent Info)
{
    local string sResult;
    
    if (Info.NPCAttachmentComponentType == 0)
    {
        sResult = " Attach ";
        if (Info.NPCAttachmentComponentAttachType == 1)
        {
            if (Info.AttachSocketName == 'None')
            {
                sResult $= "Unknown";
            }
            else
            {
                sResult $= string(Info.AttachSocketName);
            }
        }
    }
    else if (Info.NPCAttachmentComponentType == 1)
    {
        sResult = " Body ";
    }
    else if (Info.NPCAttachmentComponentType == 2)
    {
        sResult = " Head ";
    }
    return sResult;
}

function bool IsRagDollOnGround()
{
    return false;
}

function bool IsRagDollStart()
{
    return bRagDollStarted;
}

event Tick(float DeltaTime)
{
    if (IsRagDollStart() && !IsRagDollOnGround())
    {
        DetectRagDollHitGround();
    }
}

function EndLeechLoopingEffect()
{
    if (AttachLeechAC != none)
    {
        AttachLeechAC.FadeOut(AttachLeechSndCueFadeTime, 0.0);
    }
}

function StartLeechLoopingEffect()
{
    if (AttachLeechAC == none)
    {
        AttachLeechAC = CreateAudioComponent(AttachLeechLoopingCue);
    }
    if (AttachLeechAC != none)
    {
        AttachLeechAC.Play();
    }
}

simulated function DetachFromAlice(AlicePawn Alice)
{
    SetHardAttach(false);
    SetBase(none);
    SetPhysics(OldPhysicsBeforeAttach);
    Mesh.SetLightEnvironment(Mesh.LightEnvironment);
    Mesh.SetShadowParent(Mesh);
    EndLeechLoopingEffect();
    bBeingAttachedToAlice = false;
}

simulated function AttachToAlice(AlicePawn Alice, name SocketName)
{
    OldPhysicsBeforeAttach = Physics;
    SetHardAttach(true);
    SetPhysics(0);
    bInterpolatingAttchedPosition = true;
    fTimeInterpolatingAttachedPosition = 0.0;
    StartLocationInterpolatingAttachToAlice = Location;
    StartRotationInterpolatingAttachToAlice = Rotation;
    SetBase(Alice);
    Mesh.SetLightEnvironment(Alice.Mesh.LightEnvironment);
    Mesh.SetShadowParent(Alice.Mesh);
    SetPhysics(0);
    StartLeechLoopingEffect();
    bBeingAttachedToAlice = true;
}

native function HideNPCAttachedActor(bool bSetHidden, int ActorIndex)
{
    bSetHidden;
    ActorIndex;
}

native function WakeUpNPCAttachedActor(bool bActive, int ActorIndex, int HP)
{
    bActive;
    ActorIndex;
    HP;
}

native function KillNPCAttachedActor(int ActorIndex)
{
    ActorIndex;
}

native function float GetShieldKnockBackTimeScale(int ShieldIndex)
{
    ShieldIndex;
}

native function float GetShieldKnockBackDistScale(int ShieldIndex)
{
    ShieldIndex;
}

native simulated function Vector GetReboundTargetLocation(optional Actor RequestedBy)
{
    RequestedBy;
}

native simulated function Rotator GetTargetRotation(optional Actor RequestedBy, optional bool bRequestAlternateLoc)
{
    RequestedBy;
    bRequestAlternateLoc;
}

native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc)
{
    RequestedBy;
    bRequestAlternateLoc;
}

native function Actor GetCurrentAttackTargetActor()
{
}

simulated function bool ShouldHideLockOnUI(int SocketIndex)
{
    if (Mesh != none && SocketIndex >= 0 && SocketIndex < LockOnInfo.TargetSockets.Length)
    {
        return LockOnInfo.TargetSockets[SocketIndex].bHideUI;
    }
    return false;
}

simulated function Vector GetCameraTargetSocketLoc(int SocketIndex)
{
    local Vector Loc;
    local Rotator Rot;
    
    if (Mesh != none && SocketIndex >= 0 && SocketIndex < LockOnInfo.TargetSockets.Length)
    {
        if (LockOnInfo.TargetSockets[SocketIndex].CameraTargetSocket != 'None')
        {
            Mesh.GetSocketWorldLocationAndRotation(LockOnInfo.TargetSockets[SocketIndex].CameraTargetSocket, Loc, Rot);
        }
        else
        {
            Loc = LockOnInfo.TargetSockets[SocketIndex].CollisionLocation;
        }
    }
    return Loc;
}

simulated event OnToggleSpawnXPAndHP(SeqAct_ToggleSpawnXPAndHP Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        CanSpawnHealth = Action.CanSpawnHealth;
        CanSpawnXP = Action.CanSpawnXP;
        bForceUseManualHP = Action.ForceUseManualHP;
        bForceUseManualXP = Action.ForceUseManualXP;
    }
}

function int GetManualXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return ManualXPAmountEasy;
            break;
        case 1:
            return ManualXPAmountNormal;
            break;
        case 2:
            return ManualXPAmountHard;
            break;
        case 3:
            return ManualXPAmountVeryHard;
            break;
        default:
    }
}

function int GetManualHPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return ManualHPAmountEasy;
            break;
        case 1:
            return ManualHPAmountNormal;
            break;
        case 2:
            return ManualHPAmountHard;
            break;
        case 3:
            return ManualHPAmountVeryHard;
            break;
        default:
    }
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    NotifyDied(Killer, DamageType, HitLocation);
    if (DropFactory == none)
    {
        DropFactory = Spawn(class'DropItemsFactory');
    }
    if (DropFactory != none)
    {
        DropFactory.SetHealthArchetype(LargeHealthPickupArchetype, SmallHealthPickupArchetype);
        DropFactory.SetXPArchetype(LargeXPPickupArchetype, SmallXPPickupArchetype);
        DropFactory.DropPickupsForNPC(CanSpawnHealth, CanSpawnXP, UseSmartHealthSpawn, GetManualHPAmount(), GetManualXPAmount(), FixedXPEnum, int(CylinderComponent.CollisionRadius * float(2)), bForceUseManualHP, bForceUseManualXP);
    }
    return Died(Killer, DamageType, HitLocation);
}

function NotifyDied(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local AlicePlayerController APC;
    
    if (DamageType != none)
    {
        DiedByWeaponIndectify = DamageType.default.default.WeaponTypeIndentify;
        ModifyDiedByWeapon();
    }
    APC = AlicePlayerController(Killer);
    if (APC != none)
    {
        APC.OnNPCDied(self, DamageType, HitLocation);
    }
    bRagDollStarted = true;
}

function HackPawnMarkDeathType(class<DamageType> DamageType, Actor Causer)
{
}

function ModifyDiedByWeapon()
{
}

simulated event Destroyed()
{
    local int Index;
    
    for (Index = 0; Index < NPCAttachmentComponentsArray.Length; Index++)
    {
        if (NPCAttachmentComponentsArray[Index].CurrentDropActor != none)
        {
            NPCAttachmentComponentsArray[Index].CurrentDropActor.LifeSpan = 1.0;
            NPCAttachmentComponentsArray[Index].CurrentDropActor.Destroy();
        }
    }
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
        AmbientSoundComponent = none;
    }
    for (Index = 0; Index < LoopSounds.Length; Index++)
    {
        if (LoopSounds[Index].LoopSoundComponent != none)
        {
            LoopSounds[Index].LoopSoundComponent.Stop();
            DetachComponent(LoopSounds[Index].LoopSoundComponent);
            LoopSounds[Index].LoopSoundComponent = none;
        }
    }
    for (Index = 0; Index < LoopParticles.Length; Index++)
    {
        if (LoopParticles[Index].LoopPSComponent != none)
        {
            LoopParticles[Index].LoopPSComponent.DeactivateSystem();
            DetachComponent(LoopParticles[Index].LoopPSComponent);
            LoopParticles[Index].LoopPSComponent = none;
        }
    }
    for (Index = 0; Index < NPCAttachedActors.Length; Index++)
    {
        if (NPCAttachedActors[Index].AttachedActor != none)
        {
            NPCAttachedActors[Index].AttachedActor.LifeSpan = 1.0;
            NPCAttachedActors[Index].AttachedActor.Destroy();
        }
    }
    if (bSonarActor && bSonarActive)
    {
        Controller.RemoveSonarDetectedActor(self);
        bSonarActive = false;
        bSonarActor = false;
    }
}

function UpdateCriticalControl(bool bActive, int SocketIndex)
{
    local AlicePlayerController APC;
    local bool bPrevCritical;
    
    APC = AlicePlayerController(AlicePawn(WorldInfo.GetLocalPlayerPawn()).Controller);
    if (APC != none)
    {
        if (APC.IsLockOnNPC() && APC.TargetNPCSocket.Pawn != none && APC.TargetNPCSocket.Pawn == self && APC.TargetNPCSocket.SocketIndex == SocketIndex)
        {
            bPrevCritical = APC.bTargetUIPrevCritical;
            if (bPrevCritical != bActive)
            {
                AliceGameInfo(WorldInfo.Game).ToggleCritical(bActive);
                APC.bTargetUIPrevCritical = bActive;
            }
        }
    }
}

function bool IsTargetSocketCritical(int SocketIndex)
{
    if (SocketIndex >= 0 && SocketIndex < LockOnInfo.TargetSockets.Length)
    {
        return LockOnInfo.TargetSockets[SocketIndex].bCriticalUI;
    }
    return false;
}

event ToggleTargetSocketCritical(bool bActive, int SocketIndex)
{
    if (SocketIndex >= 0 && SocketIndex < LockOnInfo.TargetSockets.Length)
    {
        if (LockOnInfo.TargetSockets[SocketIndex].bCriticalUI != bActive)
        {
            LockOnInfo.TargetSockets[SocketIndex].bCriticalUI = bActive;
            UpdateCriticalControl(bActive, SocketIndex);
        }
    }
}

function OnEventBeLockOn()
{
    AliceGameKynapseAIController(Controller).NotifyEventBeLockOn();
}

event SphinxNotifyDestory()
{
}

event ToggleLoopSound(bool bEnable, int SoundID, float FadeTime)
{
    local SkeletalMeshComponent SkelComp;
    local int ComponentID;
    
    if (SoundID >= 0 && SoundID < LoopSounds.Length)
    {
        if (bEnable)
        {
            ComponentID = LoopSounds[SoundID].AttachComponentIndex;
            if (ComponentID >= 0 && ComponentID < NPCAttachmentComponentsArray.Length)
            {
                if (NPCAttachmentComponentsArray[ComponentID].CurrentAttachmentMeshComponent != none)
                {
                    SkelComp = NPCAttachmentComponentsArray[ComponentID].CurrentAttachmentMeshComponent;
                }
                else if (NPCAttachmentComponentsArray[ComponentID].CurrentDropActor != none && NPCAttachmentComponentsArray[ComponentID].CurrentDropActor.SkelComp != none)
                {
                    SkelComp = NPCAttachmentComponentsArray[ComponentID].CurrentDropActor.SkelComp;
                }
            }
            if (SkelComp != none)
            {
                if (LoopSounds[SoundID].LoopSound != none)
                {
                    if (LoopSounds[SoundID].LoopSoundComponent == none)
                    {
                        LoopSounds[SoundID].LoopSoundComponent = new(self) class'Engine.AudioComponent';
                        if (LoopSounds[SoundID].SocketName != 'None')
                        {
                            SkelComp.AttachComponentToSocket(LoopSounds[SoundID].LoopSoundComponent, LoopSounds[SoundID].SocketName);
                        }
                        else
                        {
                            AttachComponent(LoopSounds[SoundID].LoopSoundComponent);
                        }
                        LoopSounds[SoundID].LoopSoundComponent.Stop();
                        LoopSounds[SoundID].LoopSoundComponent.SoundCue = LoopSounds[SoundID].LoopSound;
                    }
                    LoopSounds[SoundID].LoopSoundComponent.FadeIn(FadeTime, 1.0);
                }
            }
        }
        else if (LoopSounds[SoundID].LoopSoundComponent != none)
        {
            LoopSounds[SoundID].LoopSoundComponent.FadeOut(FadeTime, 0.0);
        }
    }
}

event ToggleLoopParticle(bool bEnable, int ParticleID)
{
    local SkeletalMeshComponent SkelComp;
    local int ComponentID;
    local float ParticleScale;
    
    if (ParticleID >= 0 && ParticleID < LoopParticles.Length)
    {
        if (bEnable)
        {
            ComponentID = LoopParticles[ParticleID].AttachComponentIndex;
            if (ComponentID >= 0 && ComponentID < NPCAttachmentComponentsArray.Length)
            {
                if (NPCAttachmentComponentsArray[ComponentID].CurrentAttachmentMeshComponent != none)
                {
                    SkelComp = NPCAttachmentComponentsArray[ComponentID].CurrentAttachmentMeshComponent;
                }
                else if (NPCAttachmentComponentsArray[ComponentID].CurrentDropActor != none && NPCAttachmentComponentsArray[ComponentID].CurrentDropActor.SkelComp != none)
                {
                    SkelComp = NPCAttachmentComponentsArray[ComponentID].CurrentDropActor.SkelComp;
                }
            }
            if (SkelComp != none)
            {
                if (LoopParticles[ParticleID].LoopPS != none)
                {
                    if (LoopParticles[ParticleID].LoopPSComponent == none)
                    {
                        LoopParticles[ParticleID].LoopPSComponent = new(self) class'Engine.ParticleSystemComponent';
                        LoopParticles[ParticleID].LoopPSComponent.SetTemplate(LoopParticles[ParticleID].LoopPS);
                        if (LoopParticles[ParticleID].SocketName != 'None')
                        {
                            SkelComp.AttachComponentToSocket(LoopParticles[ParticleID].LoopPSComponent, LoopParticles[ParticleID].SocketName);
                        }
                    }
                    ParticleScale = LoopParticles[ParticleID].DrawScale;
                    if (ParticleScale <= 0.0)
                    {
                        ParticleScale = 1.0;
                    }
                    LoopParticles[ParticleID].LoopPSComponent.SetScale(ParticleScale);
                    LoopParticles[ParticleID].LoopPSComponent.ActivateSystem(true);
                }
            }
        }
        else if (LoopParticles[ParticleID].LoopPSComponent != none)
        {
            LoopParticles[ParticleID].LoopPSComponent.DeactivateSystem();
        }
    }
}

simulated function NPCOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    local int Idx;
    
    for (Idx = 0; Idx < NPCAttachmentComponentsArray.Length; Idx++)
    {
        if (NPCAttachmentComponentsArray[Idx].CurrentAttachmentMeshComponent != none)
        {
            NPCAttachmentComponentsArray[Idx].CurrentAttachmentMeshComponent.DetachComponent(PSC);
            continue;
        }
        if (NPCAttachmentComponentsArray[Idx].CurrentDropActor != none && NPCAttachmentComponentsArray[Idx].CurrentDropActor.SkelComp != none)
        {
            NPCAttachmentComponentsArray[Idx].CurrentDropActor.SkelComp.DetachComponent(PSC);
        }
    }
    WorldInfo.MyEmitterPool.OnParticleSystemFinished(PSC);
}

event PlayParticleEffectFromSphinxSequence(const SphinxSequenceEventPlayParticle SequenceData)
{
    local Vector Loc;
    local Rotator Rot;
    local ParticleSystemComponent PSC;
    local SkeletalMeshComponent SkelComp;
    local int ComponentIndex;
    
    if (class'Engine.Engine'.static.GetPhysXLevel() == 0 && !SequenceData.bLoadIfPhysXLevel0)
    {
        return;
    }
    if (class'Engine.Engine'.static.GetPhysXLevel() == 1 && !SequenceData.bLoadIfPhysXLevel1)
    {
        return;
    }
    if (class'Engine.Engine'.static.GetPhysXLevel() == 2 && !SequenceData.bLoadIfPhysXLevel2)
    {
        return;
    }
    SkelComp = none;
    ComponentIndex = SequenceData.ComponentIndex;
    if (ComponentIndex >= 0 && ComponentIndex < NPCAttachmentComponentsArray.Length)
    {
        if (NPCAttachmentComponentsArray[ComponentIndex].CurrentAttachmentMeshComponent != none)
        {
            SkelComp = NPCAttachmentComponentsArray[ComponentIndex].CurrentAttachmentMeshComponent;
        }
        else if (NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor != none && NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor.SkelComp != none)
        {
            SkelComp = NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor.SkelComp;
        }
    }
    if (SkelComp != none)
    {
        if (SequenceData.bAttach == true)
        {
            if (SequenceData.Bone != 'None')
            {
                PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(SequenceData.Particle, SkelComp, SequenceData.Bone, false);
            }
            else if (SequenceData.Socket != 'None')
            {
                PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(SequenceData.Particle, SkelComp, SequenceData.Socket, true);
            }
            PSC.SetAbsolute(false, false, false);
            PSC.SetScale(SequenceData.DrawScale);
            PSC.SetIgnoreOwnerHidden(SequenceData.bIgnoreOwnerHiddenIfAttached);
            PSC.ActivateSystem();
            PSC.__OnSystemFinished__Delegate = NPCOnParticleSystemFinished;
        }
        else
        {
            if (SequenceData.Bone != 'None')
            {
                Loc = SkelComp.GetBoneLocation(SequenceData.Bone);
                Rot = rot(0, 0, 1);
            }
            else if (SequenceData.Socket != 'None')
            {
                SkelComp.GetSocketWorldLocationAndRotation(SequenceData.Socket, Loc, Rot);
            }
            else
            {
                Loc = Location;
                Rot = rot(0, 0, 1);
            }
            PSC = WorldInfo.MyEmitterPool.SpawnEmitter(SequenceData.Particle, Loc, Rot);
            PSC.SetAbsolute(false, false, false);
            PSC.SetScale(SequenceData.DrawScale);
            PSC.ActivateSystem();
        }
    }
}

event PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData, SkeletalMeshComponent SrcSkelComp)
{
    local SkeletalMeshComponent SkelComp;
    local int ComponentIndex;
    
    SkelComp = none;
    ComponentIndex = AnimNotifyData.ComponentIndex;
    if (ComponentIndex >= 0 && ComponentIndex < NPCAttachmentComponentsArray.Length)
    {
        if (NPCAttachmentComponentsArray[ComponentIndex].CurrentAttachmentMeshComponent != none)
        {
            SkelComp = NPCAttachmentComponentsArray[ComponentIndex].CurrentAttachmentMeshComponent;
        }
        else if (NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor != none && NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor.SkelComp != none)
        {
            SkelComp = NPCAttachmentComponentsArray[ComponentIndex].CurrentDropActor.SkelComp;
        }
    }
    if (SkelComp != SrcSkelComp)
    {
        SkelComp.PlayParticleEffect(AnimNotifyData);
    }
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBase Node;
    local int I;
    
    AnimTreeRootNode = AnimTree(Mesh.Animations);
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        AnimBlendNodes[I] = none;
    }
    foreach Mesh.AllAnimNodes(class'AliceGameAnimNode_BlendBase', Node)
    {
        switch (Node.NodeName)
        {
            case 'Slot_FullBody_Main':
                AnimBlendNodes[0] = Node;
                continue;
            case 'Slot_HalfBody_Upper_Main':
                AnimBlendNodes[1] = Node;
                continue;
            case 'PerBone_BlendUpperLower_Main':
                AnimBlendNodes[2] = Node;
                continue;
            default:
                continue;
        }
    }
    CacheAnimNodes();
}

simulated event SetNewWeapon(Weapon NewWeapon)
{
    SetActiveWeapon(NewWeapon);
}

simulated event KismetFinished()
{
    AliceGameKynapseAIController(Controller).NotifyKismetControll(false);
}

simulated event KismetStarted()
{
    AliceGameKynapseAIController(Controller).NotifyKismetControll(true);
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    ControlledInterp = none;
    IndexInLatentActors = -1;
    Controller.SetGodMode(false);
    AliceGameKynapseAIController(Controller).NotifyKismetControll(false);
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    local int I;
    
    ControlledInterp = InterpAction;
    for (I = 0; I < ControlledInterp.LatentActors.Length; I++)
    {
        if (ControlledInterp.LatentActors[I] == self)
        {
            IndexInLatentActors = I;
            break;
        }
    }
    AliceGameKynapseAIController(Controller).NotifyKismetControll(true);
    Controller.SetGodMode(true);
    InterpolationStarted(InterpAction, GroupInst);
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float IncreasedDamagePercent, TotalHysterisDamage;
    local AlicePawn ap;
    
    if (KynapseAIController(Controller).GetBrainState() == -1)
    {
        return;
    }
    ap = AlicePawn(EventInstigator.Pawn);
    if (ap != none && ap.bInHysteriaMode)
    {
        TotalHysterisDamage = float(DamageAmount);
        IncreasedDamagePercent = FClamp(ap.IncraseDamagePercent, 0.0, ap.IncraseDamagePercent);
        TotalHysterisDamage = TotalHysterisDamage + TotalHysterisDamage * IncreasedDamagePercent / 100.0;
        DamageAmount = int(TotalHysterisDamage);
    }
    TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    HackPawnMarkDeathType(DamageType, DamageCauser);
    if (EnableInjuredState)
    {
        if (Health <= 0)
        {
            HealthState = 2;
        }
        else if (float(Health) < float(HealthMax) * InjuredStateHPPercent)
        {
            HealthState = 1;
        }
        else
        {
            HealthState = 0;
        }
    }
    DoDamageEffects(float(DamageAmount), EventInstigator.Pawn, HitLocation, DamageType, Momentum, HitInfo);
}

simulated function bool ShouldDoKnockBack(EDamageStrengthType DmgStrength)
{
    return TakeDamageAnimArray[int(DmgStrength)].bKnockBack;
}

function DoDamageEffects(float Damage, Pawn InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    if (Damage > float(0))
    {
        if (TakeDamageAnimArray[int(CurrentDmgStrength)].bPhysicalAnim == true)
        {
            PlayPhysicsBodyImpact(HitLocation, Momentum, DamageType, HitInfo);
        }
    }
}

function StartLookatAlice(name ControllerName)
{
    SetHeadTrackActor(AliceGameKynapseAIController(Controller).GetLookatPawn(), ControllerName);
}

event ToggleSkeletalControl(name ControlName, bool bSetActived)
{
    if (bSetActived)
    {
        StartLookatAlice(ControlName);
        bLookatActive = true;
    }
    else
    {
        DisableHeadTrack(ControlName);
        bLookatActive = false;
    }
}

simulated function SetWeaponParaInfo(AliceGameWeaponBase DesiredWeapon, WeaponPara DesiredWeaponPara)
{
    if (DesiredWeaponPara.ComponentIndex > 0 && DesiredWeaponPara.ComponentIndex < NPCAttachmentComponentsArray.Length)
    {
        DesiredWeapon.Mesh = NPCAttachmentComponentsArray[DesiredWeaponPara.ComponentIndex].CurrentAttachmentMeshComponent;
    }
    else
    {
        DesiredWeapon.Mesh = none;
    }
    SetWeaponParaInfo(DesiredWeapon, DesiredWeaponPara);
}

event PostBeginPlay()
{
    local WeaponPara tempweaponpara;
    local int I;
    local SkeletalMeshComponent FacialSkelComp;
    
    NpcSpawnOriginalLocation = Location;
    CustomNPC();
    for (I = 1; I < NPCAttachmentComponentsArray.Length; I++)
    {
        NPCAttachmentComponentsArray[I].CurrentAttachmentMeshComponent.SetLightEnvironment(NPCAttachmentComponentsArray[0].CurrentAttachmentMeshComponent.LightEnvironment);
        NPCAttachmentComponentsArray[I].CurrentAttachmentMeshComponent.SetShadowParent(NPCAttachmentComponentsArray[0].CurrentAttachmentMeshComponent);
    }
    PostBeginPlay();
    if (bAlwaysLookatAlice)
    {
        SetTimer(1.0, false, 'StartLookatAlice');
    }
    AutoSetMaterialsForAllSkelComponents();
    MyWeapon = WeaponForNPC(FindInventoryType(class'WeaponForNPC', true));
    if (Role == 3 && InvManager != none)
    {
        foreach WeaponParas(tempweaponpara)
        {
            if (tempweaponpara.WeaponClass != none && ClassIsChildOf(tempweaponpara.WeaponClass, class'WeaponForNPC'))
            {
                MyWeapon = WeaponForNPC(FindInventoryType(tempweaponpara.WeaponClass, true));
                MyWeapon.RangeAttackSocket = tempweaponpara.RangeAttackSocket;
                MyWeapon.RangeAttackSocketArray = tempweaponpara.RangeAttackSocketArray;
                if (tempweaponpara.bAvailable && MyWeapon.Mesh == none && tempweaponpara.ComponentIndex == 0)
                {
                    MyWeapon.WeaponPositionType = 2;
                }
                if (tempweaponpara.bAvailable && MyWeapon.WeaponPositionType == 0 && MyWeapon.Mesh != none && tempweaponpara.DefaultAttachedSocketName != 'None')
                {
                    MyWeapon.Mesh.SetLightEnvironment(Mesh.LightEnvironment);
                    MyWeapon.Mesh.SetShadowParent(Mesh);
                    if (MyWeapon.bMeleeWeaponAbility)
                    {
                        MyWeapon.Mesh.InitRBPhys();
                    }
                }
            }
        }
    }
    if (MyWeapon != none)
    {
        InvManager.SetCurrentWeapon(MyWeapon);
    }
    VerifyLockOnInfo();
    Mesh.FakeRootMotionInvMassScale = KnockBackDistScale;
    Mesh.FakeRootMotionTimeScale = KnockBackTimeScale;
    if (bUsePhysicalAssetCollision)
    {
        EnableKynapsePawnPhysicalAssetCollision();
    }
    if (AmbientSound != none)
    {
        AmbientSoundComponent = new(self) class'Engine.AudioComponent';
        if (AmbientSoundComponent != none)
        {
            AttachComponent(AmbientSoundComponent);
            AmbientSoundComponent.Stop();
            AmbientSoundComponent.SoundCue = AmbientSound;
            AmbientSoundComponent.FadeIn(AmbientSoundFadeInTime, 1.0);
        }
    }
    if (HeadComponent != none)
    {
        FacialSkelComp = HeadComponent;
    }
    else
    {
        FacialSkelComp = Mesh;
    }
    if (FacialSkelComp != none && FacialSkelComp.SkeletalMesh != none && FacialSkelComp.SkeletalMesh.FaceFXAsset != none)
    {
        for (I = 0; I < FacialAnimSets.Length; ++I)
        {
            FacialSkelComp.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(FacialAnimSets[I]);
        }
    }
    bSkipBlockingCheckWithDesiredBlockingVolumn = false;
    bSkipBlockingCheckWithAlice = false;
    bSkipBlockingCheckWithOtherNPC = false;
}

function OnNotLockedOn()
{
    if (bLockedOn)
    {
        bLockedOn = false;
        LogInternal("***" @ string(self) @ "'s NOT locked on!");
    }
    else
    {
        return;
    }
    if (IsInState('Dying'))
    {
        LifeSpan = 25.0;
    }
}

function OnLockedOn()
{
    if (!bLockedOn)
    {
        LogInternal("***" @ string(self) @ "'s locked on!");
        bLockedOn = true;
    }
    else
    {
        return;
    }
}

native function ChangeDeathMaterial(int ComponentID, int MatID, MaterialInterface NewMaterial)
{
    ComponentID;
    MatID;
    NewMaterial;
}

native function ChangeLockOnHighlightMaterial(int ComponentID, int MatID, MaterialInterface NewMaterial)
{
    ComponentID;
    MatID;
    NewMaterial;
}

function bool AnyLockableSocketaEnable()
{
    local int Idx;
    local bool bRet;
    
    for (Idx = 0; Idx < LockOnInfo.TargetSockets.Length; Idx++)
    {
        if (LockOnInfo.TargetSockets[Idx].bEnable)
        {
            bRet = true;
            break;
        }
    }
    return bRet;
}

function bool LockableSocketEnable(int Idx)
{
    if (Idx < 0 || Idx > LockOnInfo.TargetSockets.Length)
    {
        return false;
    }
    return LockOnInfo.TargetSockets[Idx].bEnable;
}

function int GetSocketNumber()
{
    return LockOnInfo.TargetSockets.Length;
}

function VerifyLockOnInfo()
{
    local int Idx;
    local Vector Loc;
    local Rotator Rot;
    
    LockOnInfo.Pawn = self;
    LockOnInfo.currentIndexOfTargetingSocket = -1;
    for (Idx = 0; Idx < LockOnInfo.TargetSockets.Length; Idx++)
    {
        if (Mesh != none && LockOnInfo.TargetSockets[Idx].SocketName != 'None')
        {
            Mesh.GetSocketWorldLocationAndRotation(LockOnInfo.TargetSockets[Idx].SocketName, Loc, Rot);
            LockOnInfo.TargetSockets[Idx].LockOnLocation = Loc;
            LockOnInfo.TargetSockets[Idx].LockOnRotation = Rot;
            if (LockOnInfo.currentIndexOfTargetingSocket < 0)
            {
                LockOnInfo.currentIndexOfTargetingSocket = Idx;
            }
            if (LockOnInfo.TargetSockets[Idx].CollisionSocketName != 'None' && Mesh.GetSocketWorldLocationAndRotation(LockOnInfo.TargetSockets[Idx].CollisionSocketName, Loc, Rot))
            {
                LockOnInfo.TargetSockets[Idx].CollisionLocation = Loc;
                LockOnInfo.TargetSockets[Idx].CollisionRotation = Rot;
            }
            else
            {
                LockOnInfo.TargetSockets[Idx].CollisionLocation = LockOnInfo.TargetSockets[Idx].LockOnLocation;
                LockOnInfo.TargetSockets[Idx].CollisionRotation = LockOnInfo.TargetSockets[Idx].LockOnRotation;
            }
            continue;
        }
        LockOnInfo.TargetSockets[Idx].bEnable = false;
    }
}

function DisableAllLockTargets()
{
    local int I;
    
    for (I = 0; I < LockOnInfo.TargetSockets.Length; I++)
    {
        LockOnInfo.TargetSockets[I].bEnable = false;
    }
}

event LockTargetsSet(int Index, bool Set)
{
    if (Index >= 0 && Index < LockOnInfo.TargetSockets.Length)
    {
        LockOnInfo.TargetSockets[Index].bEnable = Set;
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    SphinxAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    if (Other.IsA('KynapseObstacleSmall'))
    {
        if (OtherComp != none)
        {
            OtherComp.AddImpulse(-200.0 * HitNormal, 0.5 * (Other.Location + Location));
        }
    }
}

function TakeFallingDamage()
{
    if (IsTakeFallingDamaged)
    {
        TakeFallingDamage();
    }
}

native function bool IsLineCheckPhysMatResult()
{
}

native function PlayDeathRagdoll()
{
}

native function bool ForceDetechFromAlice()
{
}

native function EnableKynapsePawnPhysicalAssetCollision()
{
}

native function float GetFarGroupDistance()
{
}

native final function UnattachCustomComponent(int ComponentArrayIndex)
{
    ComponentArrayIndex;
}

native final function RepairNPCComponentAttachment()
{
}

native final function CustomNPC()
{
}

native final function SphinxAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    SeqNode;
    PlayedTime;
    ExcessTime;
}

state Dying
{
    event BeginState(name PreviousStateName)
    {
        local Actor A;
        local array<SequenceEvent> TouchEvents;
        local int I;
        
        if (bTearOff && WorldInfo.NetMode == 1)
        {
            LifeSpan = 2.0;
        }
        else
        {
            Controller.NotifyBeginDying(self);
            SetTimer(5.0, false);
            LifeSpan = 25.0;
        }
        SetDyingPhysics();
        SetCollision(true, false);
        if (Controller != none)
        {
            if (Controller.bIsPlayer)
            {
                DetachFromController();
            }
        }
        foreach TouchingActors(class'Engine.Actor', A)
        {
            if (A.FindEventsOfClass(class'Engine.SeqEvent_Touch', TouchEvents))
            {
                for (I = 0; I < TouchEvents.Length; I++)
                {
                    SeqEvent_Touch(TouchEvents[I]).NotifyTouchingPawnDied(self);
                }
                TouchEvents.Length = 0;
            }
        }
        foreach BasedActors(class'Engine.Actor', A)
        {
            A.PawnBaseDied();
        }
    }
    
    event SphinxNotifyDestory()
    {
        Controller.Destroy();
        Destroy();
    }
    
    event Timer()
    {
    }
    
    function FellOutOfWorld(class<DamageType> dmgType)
    {
    }
    
    function BreathTimer()
    {
    }
    
    function Falling()
    {
    }
    
    function PhysicsVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function HeadVolumeChange(PhysicsVolume newHeadVolume)
    {
    }
    
    function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
    {
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    Stop;
}

defaultproperties
{
    MagicAcheivmentIdentify=-1
    MagicValueForAcheivment=-1
    LightEnvironment="Default__AliceGameKynapsePawn.MyLightEnvironment"
    EnemyLevel=1.0
    EnemyClassRank=1
    InjuredStateHPPercent=0.5
    bDamageAllowPlayInNotify=True
    bIsWandering=True
    bNotifyTeammateToFight=True
    bAttractedByBomb=True
    bCanFrozenByBomb=True
    CanSpawnHealth=True
    UseSmartHealthSpawn=True
    CanSpawnXP=True
    bIPAlertIsOn=True
    bFirstTickDetectRagdoll=True
    bDamageRotEnable=True
    KynapseHandle="Default__AliceGameKynapsePawn.PawnKynapseHandle"
    TakeDamageAnimArray(0)=(DmgStrength="EDSTR_Weak",AnimIndex=-1,DamageRotationRate=(Pitch=0,Yaw=32767,Roll=0),bKnockBack=False,bPhysicalAnim=False)
    TakeDamageAnimArray(1)=(DmgStrength="EDSTR_Light",AnimIndex=-1,DamageRotationRate=(Pitch=0,Yaw=32767,Roll=0),bKnockBack=False,bPhysicalAnim=True)
    TakeDamageAnimArray(2)=(DmgStrength="EDSTR_Medium",AnimIndex=-1,DamageRotationRate=(Pitch=0,Yaw=32767,Roll=0),bKnockBack=False,bPhysicalAnim=True)
    TakeDamageAnimArray(3)=(DmgStrength="EDSTR_Heavy",AnimIndex=-1,DamageRotationRate=(Pitch=0,Yaw=32767,Roll=0),bKnockBack=True,bPhysicalAnim=True)
    TakeDamageAnimArray(4)=(DmgStrength="EDSTR_HeaveyWithoutKnockback",AnimIndex=-1,DamageRotationRate=(Pitch=0,Yaw=32767,Roll=0),bKnockBack=False,bPhysicalAnim=False)
    PathEndIndex=-1
    InterstingPointIndex=-1
    DeathIndex=-1
    WarningPackagePrimary="NAME_None"
    WarningPackageAlternate="NAME_None"
    ConfigWarningAlternateIndex=-1
    SleepIndex=-1
    WakeIndex=-1
    TauntIndex=-1
    DeathByLightMeleePackage="NAME_None"
    DeathByHeavyMeleePackage="NAME_None"
    DeathByLightRangePackage="NAME_None"
    DeathByHeavyRangePackage="NAME_None"
    MinCamDistance=525.0
    MaxCamDistance=525.0
    MinToMaxCamDistanceFactor=1.0
    LargeHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Large_Archetype"
    SmallHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Small_Archetype"
    ManualHPAmountEasy=5
    ManualHPAmountNormal=5
    ManualHPAmountHard=5
    ManualHPAmountVeryHard=5
    LargeXPPickupArchetype="Pickup_ArcheType.XPPickup_Large_NPC"
    SmallXPPickupArchetype="Pickup_ArcheType.XPPickup_Small_NPC"
    ManualXPAmountEasy=10
    ManualXPAmountNormal=10
    ManualXPAmountHard=10
    ManualXPAmountVeryHard=10
    KnockBackDistScale=1.0
    KnockBackTimeScale=1.0
    DamagePerTimeUnitWhenAttached=5.0
    InterpolationTimeWhenStartAttaching=0.3
    AmbientSoundFadeInTime=0.2
    AmbientSoundFadeOutTime=0.2
    AnimBlendNodes(0)="None"
    AnimBlendNodeNum=1
    bCanClimbLadders=True
    bCanBeLockedOn=True
    ControllerClass="AliceGameKynapseAIController"
    Mesh="Default__AliceGameKynapsePawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameKynapsePawn.CollisionCylinder"
    InventoryManagerClass="NPCInventoryManager"
    FacialAudioComp="Default__AliceGameKynapsePawn.FaceAudioComponent"
    bCanStepUpOn=False
    Components(0)="Default__AliceGameKynapsePawn.CollisionCylinder"
    Components(1)="Default__AliceGameKynapsePawn.Arrow"
    Components(2)="Default__AliceGameKynapsePawn.FaceAudioComponent"
    Components(3)="Default__AliceGameKynapsePawn.MyLightEnvironment"
    Components(4)="Default__AliceGameKynapsePawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameKynapsePawn.PawnKynapseHandle"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__AliceGameKynapsePawn.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_LockedOn"
}
