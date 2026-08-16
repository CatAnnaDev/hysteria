class GameBreakableActor extends KActor
    native
    placeable
    config(Game);

struct native BreakablePiece
{
    var() BreakableParticleSystem ParticleEmitter;
    var() StaticMesh BreakMesh;
    var() EPhysics Physics;
    var() SoundCue BreakSound;
    var() float Lifetime;
    var KActorSpawnable subKActor;
    var EmitterSpawnable Emit;
    struct native BreakableParticleSystem
    {
        var() ParticleSystem Emitter;
        var() Vector Offset;
    };
};

struct native BreakableStep
{
    var() float DamageThreshold;
    var() array<BreakableParticleSystem> ParticleEmitters;
    var() StaticMesh BreakMesh;
    var() EPhysics Physics;
    var() SoundCue BreakSound;
    var() bool bIsLockable;
    var() Vector LockOffsetCamera;
    var() Vector LockOffsetUI;
    var() int iPriority;
    var() bool bHideUI;
    var transient float OriginalDamageThreshold;
    struct native BreakableParticleSystem
    {
        var() ParticleSystem Emitter;
        var() Vector Offset;
    };
};

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bDestoryed;
    var bool bSaveDestroyed;
    var bool bInitHideSet;
    var Vector Location;
    var Rotator Rotation;
    var EPhysics InitialPhysics;
    var bool CanSpawnHealth;
    var bool CanSpawnXP;
    var bool Breakable;
};

var array<SmartHP> SmartDropHealth;
var(HP) HealthPickup LargeHealthPickupArchetype;
var(HP) HealthPickup SmallHealthPickupArchetype;
var(HP) bool CanSpawnHealth;
var(HP) bool UseSmartHealthSpawn;
var(XP) bool CanSpawnXP;
var() bool bCanBreakByAlice;
var() bool bCanBreakByNPC;
var() bool bCanLockOnAfterDestroy;
var bool bDestoryed;
var() bool bSaveDestroyed;
var bool bInitHideSet;
var transient bool bSkipPlaySoundAfterCheckPoint;
var bool bParticlesAcceptLights;
var bool bParticlesAcceptDynamicLights;
var() bool bDontWakeByOtherBreakables;
var transient bool bLockedOn;
var transient bool bPendingDestroySelf;
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
var(XP) EBreakableXPType FixedXPEnum;
var transient EPhysics InitialPhysics;
var DropItemsFactory DropFactory;
var() array<class<DamageType>> DamageTypes;
var AlicePlayerController APC;
var transient string initMostOutName;
var transient string initActorFName;
var() array<BreakableStep> BreakableSteps;
var() array<BreakablePiece> FinalPieces;
var int CurrentBreakableStep;
var LightingChannelContainer ParticleLightingChannels;
var() float BreakApartOnImpactSpeed;
var() float BreakApartOnImpactDamage;
var() float BreakApartOnImpactTimeBetweenDamage;
var() float BreakApartOnImpactMaxMomentum;
var transient float LastImpactDamageTime;
var() const export editconst editinline RB_RadialImpulseComponent ImpulseComponent;
var export editinline DrawSphereComponent RenderComponent;
var(LockOnMode) float MinCamDistance;
var(LockOnMode) float MaxCamDistance;
var(LockOnMode) float MinToMaxCamDistanceFactor;
var(LockOnMode) float MinAliceToNPCDistance;
var(LockOnMode) float MaxAliceToNPCDistance;
var transient StaticMesh InitialStaticMesh;

function bool ShouldHideLockOnUI()
{
    return BreakableSteps[CurrentBreakableStep].bHideUI;
}

simulated function float GetAutoTargetPriority(Pawn AimingPawn, Weapon W, Weapon AltW)
{
    return 0.0;
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

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bInitHideSet = false;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    }
    OnToggleHidden(Action);
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local float Momentum;
    
    if (WorldInfo.TimeSeconds - LastImpactDamageTime > BreakApartOnImpactTimeBetweenDamage)
    {
        Momentum = FMin(VSize(RigidCollisionData.TotalNormalForceVector), BreakApartOnImpactMaxMomentum);
        if (AlicePawn(OtherComponent.Owner) != none && AlicePawn(OtherComponent.Owner).Controller.IsInState('PlayerRoll'))
        {
            OtherComponent.Owner.Bump(self, HitComponent, RigidCollisionData.ContactInfos[0].ContactNormal);
        }
        else
        {
            TakeRadiusDamage(none, BreakApartOnImpactDamage, StaticMeshComponent.Bounds.SphereRadius, class'Engine.DmgType_Crushed', Momentum, RigidCollisionData.ContactInfos[0].ContactPosition, false, OtherComponent.Owner);
        }
        LogInternal("RBC:" @ string(self) @ string(OtherComponent.Owner) @ "Damage=" $ string(BreakApartOnImpactDamage) @ "Momentum=" $ string(Momentum) @ "(" $ string(VSize(RigidCollisionData.TotalNormalForceVector)) $ ")");
        LastImpactDamageTime = WorldInfo.TimeSeconds;
    }
}

simulated function Reset()
{
    local int I;
    
    if (!bNoDelete)
    {
        HideBActor();
        return;
    }
    for (I = 0; I < BreakableSteps.Length; I++)
    {
        BreakableSteps[I].DamageThreshold = BreakableSteps[I].OriginalDamageThreshold;
    }
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    StaticMeshComponent.PutRigidBodyToSleep();
    StaticMeshComponent.SetHidden(true);
    SetPhysics(0);
    SetCollision(false, false);
    SetLocation(InitialLocation);
    SetRotation(InitialRotation);
    SetCollision(true, true);
    SetHidden(false);
    StaticMeshComponent.SetStaticMesh(InitialStaticMesh);
    StaticMeshComponent.SetHidden(false);
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    if (!bWakeOnLevelStart)
    {
        StaticMeshComponent.PutRigidBodyToSleep();
    }
    else
    {
        StaticMeshComponent.WakeRigidBody();
    }
    SetPhysics(InitialPhysics);
    ResolveRBState();
    if (CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(true);
    }
    LastImpactDamageTime = 0.0;
    CurrentBreakableStep = 0;
    GotoState('None');
}

function DropPickups()
{
    if (DropFactory == none)
    {
        DropFactory = Spawn(class'DropItemsFactory');
    }
    if (DropFactory != none)
    {
        DropFactory.SetHealthArchetype(LargeHealthPickupArchetype, SmallHealthPickupArchetype);
        DropFactory.SetXPArchetype(LargeXPPickupArchetype, SmallXPPickupArchetype);
        DropFactory.DropPickupsForGBA(CanSpawnHealth, CanSpawnXP, UseSmartHealthSpawn, GetManualHPAmount(), GetManualXPAmount(), FixedXPEnum, 100);
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

function HideAndDestroy()
{
    if (!APC.MyAlicePawn.bEnableTargetOnDestroyedActor || !bCanLockOnAfterDestroy)
    {
        HideBActor();
        if (APC.TargetingActor == self)
        {
            APC.TargetingActor = none;
        }
    }
}

function HideBActor()
{
    SetHidden(true);
    StaticMeshComponent.SetHidden(true);
    StaticMeshComponent.PutRigidBodyToSleep();
    RemoveDecals();
    DropPickups();
    bDestoryed = true;
    CanSpawnHealth = false;
    CanSpawnXP = false;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
}

function OnNotLockedOn()
{
    if (bLockedOn)
    {
        bLockedOn = false;
        if (APC.MyAlicePawn.bEnableTargetOnDestroyedActor && bPendingDestroySelf)
        {
        }
    }
}

function OnLockedOn()
{
    if (!bLockedOn)
    {
        bLockedOn = true;
    }
}

function WakeFromOtherBreakable(GameBreakableActor Waker)
{
    SetPhysics(10);
    StaticMeshComponent.WakeRigidBody();
    CheckWakeStackedObjects(Waker);
}

function CheckWakeStackedObjects(optional GameBreakableActor Other)
{
    local GameBreakableActor GB;
    local Vector vloc;
    local float frad;
    
    vloc = StaticMeshComponent.Bounds.Origin;
    frad = StaticMeshComponent.Bounds.SphereRadius;
    vloc.Z += StaticMeshComponent.Bounds.BoxExtent.Z * 0.75;
    foreach VisibleCollidingActors(class'GameBreakableActor', GB, frad, vloc, true)
    {
        if (GB != self && GB != Other && GB.Physics != 10 && !GB.bDontWakeByOtherBreakables)
        {
            GB.WakeFromOtherBreakable(self);
        }
    }
}

function BreakLastApart(Controller EventInstigator)
{
    local int I;
    local EmitterSpawnable Emit;
    local Vector SpawnLocation;
    
    if (WorldInfo.NetMode != 1 && BreakableSteps[CurrentBreakableStep].ParticleEmitters.Length > 0)
    {
        for (I = 0; I < BreakableSteps[CurrentBreakableStep].ParticleEmitters.Length; I++)
        {
            SpawnLocation = Location + BreakableSteps[CurrentBreakableStep].ParticleEmitters[I].Offset;
            Emit = Spawn(class'Engine.EmitterSpawnable', , , SpawnLocation, Rotation);
            if (Emit != none)
            {
                SetParticlesLighting(Emit);
                Emit.SetTemplate(BreakableSteps[CurrentBreakableStep].ParticleEmitters[I].Emitter);
                Emit.SetBase(self);
            }
        }
    }
    SetPhysics(0);
    SetCollision(false, false);
    if (CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(false);
    }
    if (APC.MyAlicePawn.bEnableTargetOnDestroyedActor)
    {
        bPendingDestroySelf = true;
        HideBActor();
        APC.OnBreakableActorDestroyed(self);
    }
    else
    {
        SetTimer(0.1, false, 'HideAndDestroy');
    }
    TriggerEventClass(class'Engine.SeqEvent_Destroyed', EventInstigator);
    if (BreakableSteps[CurrentBreakableStep].BreakSound != none)
    {
        if (!bSkipPlaySoundAfterCheckPoint)
        {
            PlaySound(BreakableSteps[CurrentBreakableStep].BreakSound, true, , , CollisionComponent.Bounds.Origin);
        }
    }
    for (I = 0; I < Attached.Length; ++I)
    {
        if (Pawn(Attached[I]) != none)
        {
            Pawn(Attached[I]).DoFall();
        }
    }
    PawnSubObjects();
    ImpulseComponent.FireImpulse(Location);
}

function BreakStepApart(int BrokenStep, Controller EventInstigator)
{
    local EmitterSpawnable Emit;
    local int I;
    local Vector SpawnLocation;
    
    if (WorldInfo.NetMode != 1 && BreakableSteps[BrokenStep].ParticleEmitters.Length > 0)
    {
        for (I = 0; I < BreakableSteps[BrokenStep].ParticleEmitters.Length; I++)
        {
            SpawnLocation = Location + BreakableSteps[BrokenStep].ParticleEmitters[I].Offset;
            Emit = Spawn(class'Engine.EmitterSpawnable', , , SpawnLocation, Rotation);
            if (Emit != none)
            {
                SetParticlesLighting(Emit);
                Emit.SetTemplate(BreakableSteps[BrokenStep].ParticleEmitters[I].Emitter);
                Emit.SetBase(self);
                Emit.bIgnoreBaseRotation = true;
            }
        }
    }
    if (BreakableSteps[BrokenStep].BreakSound != none)
    {
        if (!bSkipPlaySoundAfterCheckPoint)
        {
            PlaySound(BreakableSteps[BrokenStep].BreakSound, true, , , CollisionComponent.Bounds.Origin);
        }
    }
    SetPhysics(BreakableSteps[BrokenStep].Physics);
    if (BreakableSteps[BrokenStep].Physics == 10)
    {
        StaticMeshComponent.bDisableAllRigidBody = false;
        StaticMeshComponent.WakeRigidBody();
        CheckWakeStackedObjects();
    }
    else if (BreakableSteps[BrokenStep].Physics == 0)
    {
        StaticMeshComponent.bDisableAllRigidBody = true;
    }
    if (BreakableSteps[BrokenStep].BreakMesh != none)
    {
        StaticMeshComponent.SetStaticMesh(BreakableSteps[BrokenStep].BreakMesh);
    }
    TriggerStepDestroyedEvent(EventInstigator, BrokenStep);
}

function TakeStepDamage(int Damage, Controller EventInstigator, bool bIsBroken, int BrokenStep)
{
    BreakableSteps[CurrentBreakableStep].DamageThreshold -= float(Damage);
    if (BreakableSteps[CurrentBreakableStep].DamageThreshold < float(0))
    {
        CurrentBreakableStep++;
        if (CurrentBreakableStep < BreakableSteps.Length - 1)
        {
            TakeStepDamage(int(-BreakableSteps[CurrentBreakableStep - 1].DamageThreshold), EventInstigator, true, CurrentBreakableStep - 1);
        }
        else
        {
            TakeLastDamage(int(-BreakableSteps[CurrentBreakableStep - 1].DamageThreshold), EventInstigator, true, CurrentBreakableStep - 1);
        }
    }
    else if (bIsBroken)
    {
        BreakStepApart(BrokenStep, EventInstigator);
    }
}

function TakeLastDamage(int Damage, Controller EventInstigator, bool bIsBroken, int BrokenStep)
{
    BreakableSteps[CurrentBreakableStep].DamageThreshold -= float(Damage);
    if (BreakableSteps[CurrentBreakableStep].DamageThreshold < float(0))
    {
        BreakLastApart(EventInstigator);
    }
    else if (bIsBroken)
    {
        BreakStepApart(BrokenStep, EventInstigator);
    }
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    local Vector vExplosionDir, vImpactPoint;
    local float fDistanceToExplosion, fDamagePercentage, fActualDamage, fActualMomentum;
    
    if (!bHidden && IsValidDamageType(DamageType))
    {
        vExplosionDir = HurtOrigin - StaticMeshComponent.Bounds.Origin;
        fDistanceToExplosion = VSize(vExplosionDir) - StaticMeshComponent.Bounds.SphereRadius;
        vExplosionDir = Normal(vExplosionDir);
        if (fDistanceToExplosion < 0.0)
        {
            vImpactPoint = HurtOrigin;
            fDamagePercentage = 1.0;
        }
        else
        {
            vImpactPoint = Location + vExplosionDir * StaticMeshComponent.Bounds.SphereRadius;
            fDamagePercentage = 1.0 - fDistanceToExplosion / DamageRadius;
        }
        fActualDamage = BaseDamage * fDamagePercentage;
        fActualMomentum = Momentum * fDamagePercentage;
        TakeDamage(int(fActualDamage), InstigatedBy, vImpactPoint, vExplosionDir * -fActualMomentum, DamageType);
    }
    TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (!bHidden && IsValidDamageType(DamageType))
    {
        if (CurrentBreakableStep == BreakableSteps.Length - 1)
        {
            TakeLastDamage(Damage, EventInstigator, false, CurrentBreakableStep);
        }
        else
        {
            TakeStepDamage(Damage, EventInstigator, false, CurrentBreakableStep);
        }
    }
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function PawnSubObjects()
{
    local int I;
    local Vector SpawnLocation;
    
    for (I = 0; I < FinalPieces.Length; I++)
    {
        if (FinalPieces[I].BreakSound != none)
        {
            if (!bSkipPlaySoundAfterCheckPoint)
            {
                PlaySound(FinalPieces[I].BreakSound, true, , , CollisionComponent.Bounds.Origin);
            }
        }
        FinalPieces[I].subKActor = Spawn(class'Engine.KActorSpawnable', self, , Location, Rotation);
        FinalPieces[I].subKActor.bCanStepUpOn = false;
        FinalPieces[I].subKActor.bPawnCanBaseOn = false;
        FinalPieces[I].subKActor.LifeSpan = FinalPieces[I].Lifetime;
        if (FinalPieces[I].subKActor != none && FinalPieces[I].ParticleEmitter.Emitter != none)
        {
            SpawnLocation = FinalPieces[I].subKActor.Location + FinalPieces[I].ParticleEmitter.Offset;
            FinalPieces[I].Emit = Spawn(class'Engine.EmitterSpawnable', FinalPieces[I].subKActor, , SpawnLocation, Rotation);
            FinalPieces[I].Emit.SetDrawScale(DrawScale);
            FinalPieces[I].Emit.SetDrawScale3D(DrawScale3D);
            FinalPieces[I].Emit.LifeSpan = FinalPieces[I].Lifetime;
            if (FinalPieces[I].Emit != none)
            {
                SetParticlesLighting(FinalPieces[I].Emit);
                FinalPieces[I].Emit.SetTemplate(FinalPieces[I].ParticleEmitter.Emitter);
                FinalPieces[I].Emit.SetBase(FinalPieces[I].subKActor);
            }
        }
        FinalPieces[I].subKActor.SetPhysics(FinalPieces[I].Physics);
        if (FinalPieces[I].Physics == 10)
        {
            FinalPieces[I].subKActor.SetCollisionType(4);
            FinalPieces[I].subKActor.StaticMeshComponent.SetBlockRigidBody(true);
            FinalPieces[I].subKActor.StaticMeshComponent.SetRBChannel(14);
            FinalPieces[I].subKActor.StaticMeshComponent.SetRBCollidesWithChannel(2, true);
            FinalPieces[I].subKActor.StaticMeshComponent.WakeRigidBody();
            CheckWakeStackedObjects();
        }
        else if (FinalPieces[I].Physics == 0)
        {
            FinalPieces[I].subKActor.StaticMeshComponent.bDisableAllRigidBody = true;
        }
        if (FinalPieces[I].subKActor != none && FinalPieces[I].BreakMesh != none)
        {
            FinalPieces[I].subKActor.SetDrawScale(DrawScale);
            FinalPieces[I].subKActor.SetDrawScale3D(DrawScale3D);
            FinalPieces[I].subKActor.StaticMeshComponent.SetStaticMesh(FinalPieces[I].BreakMesh);
        }
    }
}

simulated event OnToggleSpawnXPAndHP(SeqAct_ToggleSpawnXPAndHP Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        CanSpawnHealth = Action.CanSpawnHealth;
        CanSpawnXP = Action.CanSpawnXP;
    }
}

protected simulated event TriggerStepDestroyedEvent(Controller EventInstigator, int iBrokenStep)
{
}

event UpdateAfterAcceptPersistentDate()
{
    if (bDestoryed)
    {
        CanSpawnHealth = false;
        CanSpawnXP = false;
    }
    if (!bInitHideSet)
    {
        SetCollision(true, true);
        SetHidden(false);
        StaticMeshComponent.SetHidden(false);
        SetCollisionType(2);
    }
    if (bSaveDestroyed && bDestoryed)
    {
        bSkipPlaySoundAfterCheckPoint = true;
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_HobbyHorse_Melee');
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_GiantStompAttack');
        bSkipPlaySoundAfterCheckPoint = false;
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bDestoryed = Record.bDestoryed;
    bSaveDestroyed = Record.bSaveDestroyed;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    bInitHideSet = Record.bInitHideSet;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    InitialLocation = Record.Location;
    InitialRotation = Record.Rotation;
    InitialPhysics = Record.InitialPhysics;
    CanSpawnHealth = Record.CanSpawnHealth;
    CanSpawnXP = Record.CanSpawnXP;
    StaticMeshComponent.WakeRigidBody();
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    StaticMeshComponent.PutRigidBodyToSleep();
    StaticMeshComponent.SetStaticMesh(InitialStaticMesh);
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    SetPhysics(InitialPhysics);
    ResolveRBState();
    if (CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(true);
    }
    LastImpactDamageTime = 0.0;
    CurrentBreakableStep = 0;
    if (!bInitHideSet)
    {
        SetCollision(true, true);
        SetHidden(false);
        StaticMeshComponent.SetHidden(false);
        SetCollisionType(2);
    }
    GotoState('None');
    if (bSaveDestroyed && bDestoryed)
    {
        bSkipPlaySoundAfterCheckPoint = true;
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_HobbyHorse_Melee');
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_GiantStompAttack');
        bSkipPlaySoundAfterCheckPoint = false;
    }
}

function bool GetIsBreakAble()
{
    return false;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bDestoryed = bDestoryed;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
    Record.Rotation = Rotation;
    Record.Location = Location;
    Record.InitialPhysics = InitialPhysics;
    Record.CanSpawnHealth = CanSpawnHealth;
    Record.CanSpawnXP = CanSpawnXP;
    Record.bSaveDestroyed = bSaveDestroyed;
    Record.bInitHideSet = bInitHideSet;
    Record.Breakable = GetIsBreakAble();
}

simulated event PostBeginPlay()
{
    local int I;
    
    InitialLocation = Location;
    InitialRotation = Rotation;
    InitialPhysics = Physics;
    InitialStaticMesh = StaticMeshComponent.StaticMesh;
    if (BreakApartOnImpactSpeed > 0.0)
    {
        StaticMeshComponent.ScriptRigidBodyCollisionThreshold = BreakApartOnImpactSpeed;
        StaticMeshComponent.SetNotifyRigidBodyCollision(true);
    }
    for (I = 0; I < BreakableSteps.Length; I++)
    {
        BreakableSteps[I].OriginalDamageThreshold = BreakableSteps[I].DamageThreshold;
    }
    if (Physics == 0)
    {
        StaticMeshComponent.bDisableAllRigidBody = true;
        StaticMeshComponent.SetStaticMesh(StaticMeshComponent.StaticMesh, true);
    }
    bInitHideSet = bHidden;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
    PostBeginPlay();
}

native function bool IsValidDamageType(class<DamageType> inDamageType)
{
    inDamageType;
}

native function RemoveDecals()
{
}

native function SetParticlesLighting(Emitter Emit)
{
    Emit;
}

native function Vector GetOffsetToWorld(Vector Offset)
{
    Offset;
}

defaultproperties
{
    LargeHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Large_Archetype"
    SmallHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Small_Archetype"
    CanSpawnHealth=True
    UseSmartHealthSpawn=True
    CanSpawnXP=True
    bCanBreakByAlice=True
    bCanBreakByNPC=True
    LargeXPPickupArchetype="Pickup_ArcheType.XPPickup_Large_Breakable"
    SmallXPPickupArchetype="Pickup_ArcheType.XPPickup_Small_Breakable"
    ManualXPAmountEasy=10
    ManualXPAmountNormal=10
    ManualXPAmountHard=10
    ManualXPAmountVeryHard=10
    BreakApartOnImpactSpeed=200.0
    BreakApartOnImpactTimeBetweenDamage=0.25
    ImpulseComponent="Default__GameBreakableActor.ImpulseComponent0"
    RenderComponent="Default__GameBreakableActor.DrawSphere0"
    MinCamDistance=525.0
    MaxCamDistance=525.0
    MinToMaxCamDistanceFactor=1.0
    StaticMeshComponent="Default__GameBreakableActor.StaticMeshComponent0"
    LightEnvironment="Default__GameBreakableActor.MyLightEnvironment"
    bPawnCanBaseOn=True
    bNoDelete=False
    bCanStepUpOn=False
    bCollideWorld=True
    Components(0)="Default__GameBreakableActor.MyLightEnvironment"
    Components(1)="Default__GameBreakableActor.StaticMeshComponent0"
    Components(2)="Default__GameBreakableActor.Sprite"
    Components(3)="Default__GameBreakableActor.DrawSphere0"
    Components(4)="Default__GameBreakableActor.ImpulseComponent0"
    CollisionType="COLLIDE_BlockAllButWeapons"
    CollisionComponent="Default__GameBreakableActor.StaticMeshComponent0"
}
