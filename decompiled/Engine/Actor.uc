class Actor extends Object
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

const RB_Sleeping = 0x02;
const RB_NeedsUpdate = 0x01;
const RB_None = 0x00;
const RBSTATE_ANGVELSCALE = 1000.0;
const RBSTATE_LINVELSCALE = 10.0;
const ACTORMAXSTEPHEIGHT = 35.0;
const MINFLOORZ = 0.7;
const REP_RBLOCATION_ERROR_TOLERANCE_SQ = 16.0f;
const TRACEFLAG_Blocking = 8;
const TRACEFLAG_SkipMovers = 4;
const TRACEFLAG_PhysicsVolumes = 2;
const TRACEFLAG_Bullet = 1;

enum EInterruptByAIType
{
    e_IBAI_SeeEnemy,
    e_IBAI_HearNoise,
    e_IBAI_CollisionPlayer,
    e_IBAI_TakeDamage,
};

enum EDoubleClickDir
{
    DCLICK_None,
    DCLICK_Left,
    DCLICK_Right,
    DCLICK_Forward,
    DCLICK_Back,
    DCLICK_Active,
    DCLICK_Done,
};

enum ETravelType
{
    TRAVEL_Absolute,
    TRAVEL_Partial,
    TRAVEL_Relative,
};

enum ECollisionType
{
    COLLIDE_CustomDefault,
    COLLIDE_NoCollision,
    COLLIDE_BlockAll,
    COLLIDE_BlockWeapons,
    COLLIDE_TouchAll,
    COLLIDE_TouchWeapons,
    COLLIDE_BlockAllButWeapons,
    COLLIDE_TouchAllButWeapons,
    COLLIDE_BlockWeaponsKickable,
};

enum ENetRole
{
    ROLE_None,
    ROLE_SimulatedProxy,
    ROLE_AutonomousProxy,
    ROLE_Authority,
};

enum EMoveDir
{
    MD_Stationary,
    MD_Forward,
    MD_Backward,
    MD_Left,
    MD_Right,
    MD_Up,
    MD_Down,
};

enum EPhysics
{
    PHYS_None,
    PHYS_Walking,
    PHYS_Falling,
    PHYS_Swimming,
    PHYS_Flying,
    PHYS_Rotating,
    PHYS_Projectile,
    PHYS_Interpolating,
    PHYS_Spider,
    PHYS_Ladder,
    PHYS_RigidBody,
    PHYS_SoftBody,
    PHYS_NavMeshWalking,
    PHYS_Unused,
    PHYS_Custom,
    PHYS_Slide,
    PHYS_TrackSlide,
    PHYS_Float,
    PHYS_JumpPad,
    PHYS_Death,
    PHYS_SteamVent,
};

struct native BasedPosition
{
    var() Actor Base;
    var() Vector Position;
    var Vector CachedBaseLocation;
    var Rotator CachedBaseRotation;
    var Vector CachedTransPosition;
};

struct native immutable NavReference
{
    var() NavigationPoint Nav;
    var() const editconst Guid Guid;
};

struct native immutable ActorReference
{
    var() Actor Actor;
    var() const editconst Guid Guid;
};

struct native PhysEffectInfo
{
    var() float Threshold;
    var() float ReFireDelay;
    var() ParticleSystem Effect;
    var() SoundCue Sound;
};

struct native ReplicatedHitImpulse
{
    var Vector AppliedImpulse;
    var Vector HitLocation;
    var name BoneName;
    var byte ImpulseCount;
    var bool bRadialImpulse;
};

struct CollisionImpactData
{
    var array<RigidBodyContactInfo> ContactInfos;
    var Vector TotalNormalForceVector;
    var Vector TotalFrictionForceVector;
};

struct RigidBodyContactInfo
{
    var Vector ContactPosition;
    var Vector ContactNormal;
    var float ContactPenetration;
    var Vector ContactVelocity[2];
    var PhysicalMaterial PhysMaterial[2];
};

struct RigidBodyState
{
    var Vector Position;
    var Quat Quaternion;
    var Vector LinVel;
    var Vector AngVel;
    var byte bNewData;
};

struct native transient AnimSlotDesc
{
    var name SlotName;
    var int NumChannels;
};

struct native transient AnimSlotInfo
{
    var name SlotName;
    var array<float> ChannelWeights;
};

struct native transient ImpactInfo
{
    var Actor HitActor;
    var Vector HitLocation;
    var Vector HitNormal;
    var Vector RayDir;
    var Vector StartTrace;
    var TraceHitInfo HitInfo;
};

struct native transient TraceHitInfo
{
    var Material Material;
    var PhysicalMaterial PhysMaterial;
    var int Item;
    var int LevelIndex;
    var name BoneName;
    var export editinline PrimitiveComponent HitComponent;
};

struct native TimerData
{
    var bool bLoop;
    var bool bPaused;
    var name FuncName;
    var float Rate;
    var float Count;
    var float TimerTimeDilation;
    var Object TimerObj;
};

var(Advanced) bool bLoadIfPhysXLevel0;
var(Advanced) bool bLoadIfPhysXLevel1;
var(Advanced) bool bLoadIfPhysXLevel2;
var const bool bStatic;
var(Display) const repretry bool bHidden;
var bool bForceTranslucency;
var const bool bNoDelete;
var const bool bDeleteMe;
var const transient bool bTicked;
var const bool bOnlyOwnerSee;
var const bool bTickIsDisabled;
var bool bWorldGeometry;
var bool bIgnoreRigidBodyPawns;
var bool bOrientOnSlope;
var const bool bIgnoreEncroachers;
var bool bPushedByEncroachers;
var bool bDestroyedByInterpActor;
var const bool bRouteBeginPlayEvenIfStatic;
var const bool bIsMoving;
var bool bAlwaysEncroachCheck;
var bool bHasAlternateTargetLocation;
var(Collision) bool bCanStepUpOn;
var const bool bNetTemporary;
var const bool bOnlyRelevantToOwner;
var transient bool bNetDirty;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var repretry bool bTearOff;
var bool bOnlyDirtyReplication;
var(Physics) bool bAllowFluidSurfaceInteraction;
var transient bool bDemoRecording;
var bool bDemoOwner;
var bool bForceDemoRelevant;
var const bool bNetInitialRotation;
var bool bReplicateRigidBodyLocation;
var bool bKillDuringLevelTransition;
var const bool bExchangedRoles;
var(Advanced) bool bConsiderAllStaticMeshComponentsForStreaming;
var(Debug) bool bDebug;
var bool bPostRenderIfNotVisible;
var(StopMotion) bool bEnableStopMotion;
var(StopMotion) bool bOnlyLocalStopMotion;
var bool bMorphing;
var transient bool bForceNetUpdate;
var const transient bool bPendingNetUpdate;
var transient bool bInMatineeFaceFxTrack;
var(Attachment) const repretry bool bHardAttach;
var(Attachment) bool bIgnoreBaseRotation;
var(Attachment) bool bShadowParented;
var(Attachment) bool bUseRelativeLocation;
var(Attachment) bool bUseRelativeRotation;
var bool bCanBeAdheredTo;
var bool bCanBeFrictionedTo;
var bool bHurtEntry;
var bool bGameRelevant;
var const bool bMovable;
var bool bDestroyInPainVolume;
var bool bCanBeDamaged;
var bool bShouldBaseAtStartup;
var bool bPendingDelete;
var bool bCanTeleport;
var const bool bAlwaysTick;
var(Navigation) bool bBlocksNavigation;
var(Collision) const transient bool BlockRigidBody;
var bool bCollideWhenPlacing;
var const repretry bool bCollideActors;
var repretry bool bCollideWorld;
var(Collision) bool bCollideComplex;
var repretry bool bBlockActors;
var repretry bool bProjTarget;
var bool bBlocksTeleport;
var bool bMoveIgnoresDestruction;
var(Collision) bool bNoEncroachCheck;
var bool bCollideAsEncroacher;
var(Collision) bool bPhysRigidBodyOutOfWorldCheck;
var const transient bool bComponentOutsideWorld;
var bool bForceOctreeSNFilter;
var const transient bool bRigidBodyWasAwake;
var bool bCallRigidBodyWakeEvents;
var bool bBounce;
var const bool bJustTeleported;
var const bool bNetInitial;
var const repretry bool bNetOwner;
var(Advanced) const bool bHiddenEd;
var(Advanced) const bool bHiddenEdGroup;
var(Advanced) const bool bCanBeAutoClimbedUp;
var const bool bHiddenEdCustom;
var transient editoronly bool bHiddenEdTemporary;
var transient editoronly bool bHiddenEdLevel;
var(Advanced) bool bEdShouldSnap;
var const transient bool bTempEditor;
var(Collision) bool bPathColliding;
var transient bool bPathTemp;
var bool bScriptInitialized;
var(Advanced) bool bLockLocation;
var const bool bForceAllowKismetModification;
var const export editinline array<ActorComponent> Components;
var const transient export editinline array<ActorComponent> AllComponents;
var(Movement) const repretry Vector Location;
var(Movement) const repretry Rotator Rotation;
var(Display) const repretry interp float DrawScale;
var(Display) const interp Vector DrawScale3D;
var(Display) const Vector PrePivot;
var const native RenderCommandFence DetachFence;
var float CustomTimeDilation;
var(Movement) const repretry EPhysics Physics;
var repretry ENetRole RemoteRole;
var repretry ENetRole Role;
var(Collision) const transient ECollisionType CollisionType;
var transient repretry ECollisionType ReplicatedCollisionType;
var const ETickingGroup TickGroup;
var const repretry Actor Owner;
var(Attachment) const repretry Actor Base;
var const array<TimerData> Timers;
var float ForceTranslucencyAlpha;
var(StopMotion) float StopMotionTranslationNoiseLevel;
var(StopMotion) float StopMotionRotationNoiseLevel;
var(StopMotion) float StopMotionFPS;
var Double LastTickTime;
var transient Vector PreviousStopMotionLocation;
var transient Rotator PreviousStopMotionRotation;
var float ElapsedMorphTime;
var float TotalMorphTime;
var float StartMorphWeight;
var float EndMorphWeight;
var name SetMorphNodeName;
var const transient int NetTag;
var const float NetUpdateTime;
var float NetUpdateFrequency;
var float NetPriority;
var const transient float LastNetUpdateTime;
var float TimeSinceLastTick;
var float TickFrequency;
var(Advanced) float TickFrequencyAtEndDistance;
var float TickFrequencyDecreaseDistanceStart;
var float TickFrequencyDecreaseDistanceEnd;
var float TickFrequencyLastSeenTimeBeforeForcingMaxTickFrequency;
var repretry Pawn Instigator;
var const transient WorldInfo WorldInfo;
var float LifeSpan;
var const float CreationTime;
var transient float LastRenderTime;
var(Object) name Tag;
var name InitialState;
var(Object) name Group;
var transient QWord HiddenEditorViews;
var const transient array<Actor> Touching;
var const transient array<Actor> Children;
var const float LatentFloat;
var const AnimNodeSequence LatentSeqNode;
var const transient PhysicsVolume PhysicsVolume;
var repretry Vector Velocity;
var Vector Acceleration;
var const transient Vector AngularVelocity;
var(Attachment) export editinline SkeletalMeshComponent BaseSkelComponent;
var(Attachment) name BaseBoneName;
var const array<Actor> Attached;
var Actor FakeAttached;
var const repretry Vector RelativeLocation;
var const repretry Rotator RelativeRotation;
var(Collision) export editconst editinline PrimitiveComponent CollisionComponent;
var native int OverlapTag;
var(Movement) Rotator RotationRate;
var Actor PendingTouch;
var class<LocalMessage> MessageClass;
var const array<class<SequenceEvent>> SupportedEvents;
var const array<SequenceEvent> GeneratedEvents;
var array<SeqAct_Latent> LatentActions;
var transient float LeftMatineeBlendTime;
var transient float DesiredMatineeBlendTime;

replication
{
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3 && bNetDirty)
        bHidden;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3)
        bTearOff, bNetOwner, RemoteRole, Role;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3)
        bHardAttach;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3 && bNetDirty)
        bCollideActors, bCollideWorld, DrawScale, ReplicatedCollisionType;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3 && bNetDirty && bCollideActors || bCollideWorld)
        bBlockActors, bProjTarget;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && RemoteRole == 2 && bNetInitial || RemoteRole == 1 && bNetInitial || bUpdateSimulatedPosition && Base == none || Base.bWorldGeometry)
        Location, Rotation;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && RemoteRole == 1 && bNetInitial || bUpdateSimulatedPosition)
        Physics, Velocity;
    if (bNetOwner && !bSkipActorPropertyReplication || bNetInitial && Role == 3 && bNetDirty)
        Owner;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && RemoteRole == 1)
        Base;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3 && bNetDirty && bReplicateInstigator)
        Instigator;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && bNetInitial || bUpdateSimulatedPosition && RemoteRole == 1 && Base != none && !Base.bWorldGeometry)
        RelativeLocation, RelativeRotation;
}

native function string GetLanguage()
{
}

native function StartMorphing(name NodeName, float StartWeight, float EndWeight, float MorphTime)
{
    NodeName;
    StartWeight;
    EndWeight;
    MorphTime;
}

native function UpdateMorphing(float DeltaTime)
{
    DeltaTime;
}

native final function bool WillOverlap(Vector PosA, Vector VelA, Vector PosB, Vector VelB, float StepSize, float Radius, out float Time)
{
    PosA;
    VelA;
    PosB;
    VelB;
    StepSize;
    Radius;
    Time;
}

native final function Vector GetAvoidanceVector(out const array<Actor> Obstacles, Vector GoalLocation, float CollisionRadius, float MaxSpeed, optional int NumSamples = 8, optional float VelocityStepRate = 0.1, optional float MaxTimeTilOverlap = 1.0)
{
    Obstacles;
    GoalLocation;
    CollisionRadius;
    MaxSpeed;
    NumSamples;
    VelocityStepRate;
    MaxTimeTilOverlap;
}

final simulated function bool IsClient()
{
    return WorldInfo.NetMode != 1;
}

final simulated function bool IsServer()
{
    return WorldInfo.NetMode != 3;
}

simulated function bool IsOwningClient()
{
    return WorldInfo.NetMode == 0 || Instigator != none && Instigator.IsLocallyControlled();
}

simulated event ReplicationEnded()
{
}

simulated event PostDemoRewind()
{
}

simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
}

native final function bool SupportsKismetModification(SequenceOp AskingOp, out string Reason)
{
    AskingOp;
    Reason;
}

event TrailsNotifyEnd(const AnimNotify_Trails AnimNotifyData)
{
}

event TrailsNotifyTick(const AnimNotify_Trails AnimNotifyData)
{
}

event TrailsNotify(const AnimNotify_Trails AnimNotifyData)
{
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
}

event PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData, SkeletalMeshComponent SrcSkelComp)
{
}

simulated function GetAimAdhesionExtent(out float Width, out float Height, out Vector Center)
{
    if (bCanBeAdheredTo)
    {
        GetBoundingCylinder(Width, Height);
    }
    else
    {
        Width = 0.0;
        Height = 0.0;
    }
    Center = Location;
}

simulated function GetAimFrictionExtent(out float Width, out float Height, out Vector Center)
{
    if (bCanBeFrictionedTo)
    {
        GetBoundingCylinder(Width, Height);
    }
    else
    {
        Width = 0.0;
        Height = 0.0;
    }
    Center = Location;
}

native final function bool IsInPersistentLevel(optional bool bIncludeLevelStreamingPersistent)
{
    bIncludeLevelStreamingPersistent;
}

simulated event OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
}

native static final function Guid GetPackageGuid(name PackageName)
{
    PackageName;
}

event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
}

simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
}

simulated event RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
}

native simulated function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    PC;
    Canvas;
    CameraPosition;
    CameraDir;
}

native simulated function SetHUDLocation(Vector NewHUDLocation)
{
    NewHUDLocation;
}

event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
}

function PickedUpBy(Pawn P)
{
}

event SpawnedByKismet()
{
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

simulated function FindGoodEndView(PlayerController PC, out Rotator GoodRotation)
{
    GoodRotation = PC.Rotation;
}

simulated function NotifyLocalPlayerTeamReceived()
{
}

simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return "";
}

simulated event byte ScriptGetTeamNum()
{
    return 255;
}

native simulated function byte GetTeamNum()
{
}

function PawnBaseDied()
{
}

native simulated function bool IsPlayerOwned()
{
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = Location;
    out_Rotation = Rotation;
}

function bool IsStationary()
{
    return true;
}

event FaceFXAsset GetActorFaceFXAsset()
{
}

simulated function bool CanActorPlayFaceFXAnim()
{
    return true;
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return false;
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
}

event StopActorFaceFXAnim()
{
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
}

event FinishAnimControl(InterpGroup InInterpGroup)
{
}

event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
}

event BeginAnimControl(InterpGroup InInterpGroup)
{
}

event OnAnimPlay(AnimNodeSequence SeqNode)
{
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors, bOldBlockActors;
    local Vector X, Y, Z;
    
    Attachment.SetBase(none);
    Attachment.SetHardAttach(Action.bHardAttach);
    if (Action.bUseRelativeOffset || Action.bUseRelativeRotation)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(false, false);
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRotation(Rotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            GetAxes(Rotation, X, Y, Z);
            Attachment.SetLocation(Location + Action.RelativeOffset.X * X + Action.RelativeOffset.Y * Y + Action.RelativeOffset.Z * Z);
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors);
    }
    Attachment.SetBase(self);
    Attachment.ForceNetRelevant();
    Attachment.bNetDirty = true;
    if (Attachment.RemoteRole != 0 && Attachment.bStatic || Attachment.bNoDelete)
    {
        Attachment.SetForcedInitialReplicatedProperty(StructProperty'Actor.RelativeLocation', Attachment.RelativeLocation == Attachment.default.RelativeLocation);
        Attachment.SetForcedInitialReplicatedProperty(StructProperty'Actor.RelativeRotation', Attachment.RelativeRotation == Attachment.default.RelativeRotation);
    }
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
    local int Idx;
    local Actor Attachment;
    local Controller C;
    local array<Object> objVars;
    
    Action.GetObjectVars(objVars, "Attachment");
    for (Idx = 0; Idx < objVars.Length && Attachment == none; Idx++)
    {
        Attachment = Actor(objVars[Idx]);
        C = Controller(Attachment);
        if (C != none && C.Pawn != none)
        {
            Attachment = C.Pawn;
        }
        if (Attachment != none)
        {
            if (Action.bDetach)
            {
                Attachment.SetBase(none);
                Attachment.SetHardAttach(false);
                continue;
            }
            C = Controller(self);
            if (C != none && C.Pawn != none)
            {
                C.Pawn.DoKismetAttachment(Attachment, Action);
                continue;
            }
            DoKismetAttachment(Attachment, Action);
        }
    }
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    local int AttachIdx, IgnoreIdx;
    local Actor A;
    
    if (Action.bToggleBasedActors)
    {
        for (AttachIdx = 0; AttachIdx < Attached.Length; AttachIdx++)
        {
            A = Attached[AttachIdx];
            for (IgnoreIdx = 0; IgnoreIdx < Action.IgnoreBasedClasses.Length; IgnoreIdx++)
            {
                if (ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
                {
                    A = none;
                    break;
                }
            }
            if (A == none)
            {
                continue;
            }
            A.OnToggleHidden(Action);
        }
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        SetHidden(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        SetHidden(false);
    }
    else
    {
        SetHidden(!bHidden);
    }
    ForceNetRelevant();
    if (RemoteRole != 0)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
    }
}

function OnChangeCollision(SeqAct_ChangeCollision Action)
{
    if (Action.ObjInstanceVersion < Action.GetObjClassVersion())
    {
        SetCollision(Action.bCollideActors, Action.bBlockActors, Action.bIgnoreEncroachers);
    }
    else
    {
        SetCollisionType(Action.CollisionType);
    }
    ForceNetRelevant();
    if (RemoteRole != 0)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bCollideActors', bCollideActors == default.bCollideActors);
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bBlockActors', bBlockActors == default.bBlockActors);
    }
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    ForceNetRelevant();
    SetPhysics(Action.newPhysics);
    if (RemoteRole != 0)
    {
        if (Physics != 0)
        {
            bUpdateSimulatedPosition = true;
            if (bOnlyDirtyReplication)
            {
                bNetDirty = true;
            }
        }
        SetForcedInitialReplicatedProperty(ByteProperty'Actor.Physics', Physics == default.Physics);
    }
}

simulated function OnSetBlockRigidBody(SeqAct_SetBlockRigidBody Action)
{
    if (CollisionComponent != none)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            CollisionComponent.SetBlockRigidBody(true);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            CollisionComponent.SetBlockRigidBody(false);
        }
    }
}

simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
    local Vector V;
    local float Mag;
    
    Mag = Action.VelocityMag;
    if (Mag <= 0.0)
    {
        Mag = VSize(Action.VelocityDir);
    }
    V = Normal(Action.VelocityDir) * Mag;
    if (Action.bVelocityRelativeToActorRotation)
    {
        V = V >> Rotation;
    }
    Velocity = V;
    if (Physics == 10 && CollisionComponent != none)
    {
        CollisionComponent.SetRBLinearVelocity(Velocity);
    }
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;
    local Controller C;
    
    Action.GetObjectVars(objVars, "Destination");
    for (Idx = 0; Idx < objVars.Length && destActor == none; Idx++)
    {
        destActor = Actor(objVars[Idx]);
        C = Controller(destActor);
        if (C != none && C.Pawn != none)
        {
            destActor = C.Pawn;
        }
    }
    if (destActor != none && SetLocation(destActor.Location))
    {
        PlayTeleportEffect(false, true);
        if (Action.bUpdateRotation)
        {
            SetRotation(destActor.Rotation);
        }
        ForceNetRelevant();
        bUpdateSimulatedPosition = true;
        bNetDirty = true;
    }
    else
    {
        WarnInternal("Unable to teleport to" @ string(destActor));
    }
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
    local Controller InstigatorController;
    local Pawn InstigatorPawn;
    
    InstigatorController = Controller(Action.Instigator);
    if (InstigatorController == none)
    {
        InstigatorPawn = Pawn(Action.Instigator);
        if (InstigatorPawn != none)
        {
            InstigatorController = InstigatorPawn.Controller;
        }
    }
    if (Action.bHeal)
    {
        HealDamage(int(Action.Amount), InstigatorController, Action.DamageType);
    }
    else
    {
        TakeDamage(int(Action.Amount), InstigatorController, Location, vector(Rotation) * -Action.Momentum, Action.DamageType);
    }
}

native function PrestreamTextures(float Seconds, bool bEnableStreaming, optional int CinematicTextureGroups = 0)
{
    Seconds;
    bEnableStreaming;
    CinematicTextureGroups;
}

simulated event ShutDown()
{
    SetPhysics(0);
    SetCollision(false, false);
    if (CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(false);
    }
    SetHidden(true);
    SetTickIsDisabled(true);
    ForceNetRelevant();
    if (RemoteRole != 0)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bCollideActors', bCollideActors == default.bCollideActors);
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bBlockActors', bBlockActors == default.bBlockActors);
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
        SetForcedInitialReplicatedProperty(ByteProperty'Actor.Physics', Physics == default.Physics);
    }
    NetUpdateFrequency = 0.1;
    bForceNetUpdate = true;
}

native final function SetNetUpdateTime(float NewUpdateTime)
{
    NewUpdateTime;
}

event ForceNetRelevant()
{
    if (RemoteRole == 0 && bNoDelete && !bStatic)
    {
        RemoteRole = 1;
        bAlwaysRelevant = true;
        NetUpdateFrequency = 0.1;
    }
    bForceNetUpdate = true;
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
    local int AttachIdx, IgnoreIdx;
    local Actor A;
    
    if (Action.bDestroyBasedActors)
    {
        for (AttachIdx = 0; AttachIdx < Attached.Length; AttachIdx++)
        {
            A = Attached[AttachIdx];
            for (IgnoreIdx = 0; IgnoreIdx < Action.IgnoreBasedClasses.Length; IgnoreIdx++)
            {
                if (ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
                {
                    A = none;
                    break;
                }
            }
            if (A == none)
            {
                continue;
            }
            A.OnDestroy(Action);
        }
    }
    if (bNoDelete || Role < 3)
    {
        ShutDown();
    }
    else if (!bDeleteMe)
    {
        Destroy();
    }
}

final simulated function ClearLatentAction(class<SeqAct_Latent> actionClass, optional bool bAborted, optional SeqAct_Latent exceptionAction)
{
    local int Idx;
    
    for (Idx = 0; Idx < LatentActions.Length; Idx++)
    {
        if (LatentActions[Idx] == none)
        {
            LatentActions.Remove(Idx--, 1);
            continue;
        }
        if (ClassIsChildOf(LatentActions[Idx].Class, actionClass) && LatentActions[Idx] != exceptionAction)
        {
            if (bAborted)
            {
                LatentActions[Idx].AbortFor(self);
            }
            LatentActions.Remove(Idx--, 1);
        }
    }
}

final simulated function bool FindEventsOfClass(class<SequenceEvent> EventClass, optional out array<SequenceEvent> out_EventList, optional bool bIncludeDisabled)
{
    local SequenceEvent Evt;
    local bool bFoundEvent;
    
    foreach GeneratedEvents(Evt)
    {
        if (Evt != none && Evt.bEnabled || bIncludeDisabled && ClassIsChildOf(Evt.Class, EventClass) && Evt.MaxTriggerCount == 0 || Evt.MaxTriggerCount > Evt.TriggerCount)
        {
            out_EventList.AddItem(Evt);
            bFoundEvent = true;
        }
    }
    return bFoundEvent;
}

final simulated function bool ActivateEventClass(class<SequenceEvent> InClass, Actor InInstigator, out const array<SequenceEvent> EventList, optional out const array<int> ActivateIndices, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local SequenceEvent Evt;
    
    ActivatedEvents.Length = 0;
    foreach EventList(Evt)
    {
        if (ClassIsChildOf(Evt.Class, InClass) && Evt.CheckActivate(self, InInstigator, bTest, ActivateIndices))
        {
            ActivatedEvents.AddItem(Evt);
        }
    }
    return ActivatedEvents.Length > 0;
}

simulated function bool TriggerGlobalEventClass(class<SequenceEvent> InEventClass, Actor InInstigator, optional int ActivateIndex = -1)
{
    local array<SequenceObject> EventsToActivate;
    local array<int> ActivateIndices;
    local Sequence GameSeq;
    local bool bResult;
    local int I;
    
    if (ActivateIndex >= 0)
    {
        ActivateIndices[0] = ActivateIndex;
    }
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(InEventClass, true, EventsToActivate);
        for (I = 0; I < EventsToActivate.Length; I++)
        {
            if (SequenceEvent(EventsToActivate[I]).CheckActivate(self, InInstigator, , ActivateIndices))
            {
                bResult = true;
            }
        }
    }
    return bResult;
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
}

simulated function bool TriggerEventClass(class<SequenceEvent> InEventClass, Actor InInstigator, optional int ActivateIndex = -1, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local array<int> ActivateIndices;
    
    if (ActivateIndex >= 0)
    {
        ActivateIndices[0] = ActivateIndex;
    }
    return ActivateEventClass(InEventClass, InInstigator, GeneratedEvents, ActivateIndices, bTest, ActivatedEvents);
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController P;
    local bool bResult;
    
    if (WorldInfo.NetMode == 1)
    {
        return bForceDedicated;
    }
    if (WorldInfo.NetMode == 2 && WorldInfo.Game.NumPlayers > 1)
    {
        if (bForceDedicated)
        {
            return true;
        }
        if (Instigator != none && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
        {
            return true;
        }
    }
    else if (Instigator != none && Instigator.IsHumanControlled())
    {
        return true;
    }
    if (SpawnLocation == Location)
    {
        bResult = WorldInfo.TimeSeconds - LastRenderTime < 0.5;
    }
    else if (Instigator != none && WorldInfo.TimeSeconds - Instigator.LastRenderTime < 1.0)
    {
        bResult = true;
    }
    if (bResult)
    {
        bResult = false;
        foreach LocalPlayerControllers(class'PlayerController', P)
        {
            if (P.ViewTarget != none)
            {
                if (P.Pawn == Instigator && Instigator != none)
                {
                    return true;
                    continue;
                }
                bResult = CheckMaxEffectDistance(P, SpawnLocation, CullDistance);
                break;
            }
        }
    }
    return bResult;
}

simulated function bool CheckMaxEffectDistance(PlayerController P, Vector SpawnLocation, optional float CullDistance)
{
    local float Dist;
    
    if (P.ViewTarget == none)
    {
        return true;
    }
    if (vector(P.Rotation) Dot (SpawnLocation - P.ViewTarget.Location) < 0.0)
    {
        return VSize(P.ViewTarget.Location - SpawnLocation) < float(1600);
    }
    Dist = VSize(SpawnLocation - P.ViewTarget.Location);
    if (CullDistance > 0.0 && CullDistance < Dist * P.LODDistanceFactor)
    {
        return false;
    }
    return !P.BeyondFogDistance(P.ViewTarget.Location, SpawnLocation);
}

simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
    local float Radius, Height, AdjustedVelocity;
    
    if (bAllowFluidSurfaceInteraction)
    {
        AdjustedVelocity = 0.01 * Abs(Velocity.Z);
        GetBoundingCylinder(Radius, Height);
        Fluid.FluidComponent.ApplyForce(HitLocation, AdjustedVelocity * Fluid.FluidComponent.ForceImpact, Radius * 0.3, true);
    }
}

simulated function bool CanSplash()
{
    return false;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
}

function bool IsInPain()
{
    local PhysicsVolume V;
    
    foreach TouchingActors(class'PhysicsVolume', V)
    {
        if (V.bPainCausing && V.DamagePerSec > float(0))
        {
            return true;
        }
    }
    return false;
}

function bool IsInVolume(Volume aVolume)
{
    local Volume V;
    
    foreach TouchingActors(class'Volume', V)
    {
        if (V == aVolume)
        {
            return true;
        }
    }
    return false;
}

event Reset()
{
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return none;
}

simulated event ModifyHearSoundComponent(AudioComponent AC)
{
}

simulated function string GetPhysicsName()
{
    switch (Physics)
    {
        case 0:
            return "None";
            break;
        case 1:
            return "Walking";
            break;
        case 2:
            return "Falling";
            break;
        case 17:
            return "Floating";
            break;
        case 3:
            return "Swimming";
            break;
        case 4:
            return "Flying";
            break;
        case 5:
            return "Rotating";
            break;
        case 6:
            return "Projectile";
            break;
        case 7:
            return "Interpolating";
            break;
        case 8:
            return "Spider";
            break;
        case 9:
            return "Ladder";
            break;
        case 10:
            return "RigidBody";
            break;
        case 13:
            return "Unused";
            break;
        case 14:
            return "Custom";
            break;
        default:
    }
    return "Unknown";
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Actor A;
    local float MyRadius, MyHeight;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.SetDrawColor(255, 0, 0);
    T = GetDebugName();
    if (bDeleteMe)
    {
        T = T $ " DELETED (bDeleteMe == true)";
    }
    if (T != "")
    {
        Canvas.DrawText(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    Canvas.SetDrawColor(255, 255, 255);
    if (HUD.ShouldDisplayDebug('net'))
    {
        if (WorldInfo.NetMode != 0)
        {
            T = "ROLE:" @ string(Role) @ "RemoteRole:" @ string(RemoteRole) @ "NetMode:" @ string(WorldInfo.NetMode);
            if (bTearOff)
            {
                T = T @ "Tear Off";
            }
            Canvas.DrawText(T, false);
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
    }
    Canvas.DrawText("Location:" @ string(Location) @ "Rotation:" @ string(Rotation), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('Physics'))
    {
        T = "Physics" @ GetPhysicsName() @ "in physicsvolume" @ GetItemName(string(PhysicsVolume)) @ "on base" @ GetItemName(string(Base)) @ "gravity" @ string(GetGravityZ());
        if (bBounce)
        {
            T = T $ " - will bounce";
        }
        Canvas.DrawText(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("bHardAttach:" @ string(bHardAttach) @ "RelativeLoc:" @ string(RelativeLocation) @ "RelativeRot:" @ string(RelativeRotation) @ "SkelComp:" @ string(BaseSkelComponent) @ "Bone:" @ string(BaseBoneName), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Velocity:" @ string(Velocity) @ "Speed:" @ string(VSize(Velocity)) @ "Speed2D:" @ string(VSize2D(Velocity)), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Acceleration:" @ string(Acceleration), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Collision'))
    {
        Canvas.DrawColor.B = 0;
        GetBoundingCylinder(MyRadius, MyHeight);
        Canvas.DrawText("Collision Radius:" @ string(MyRadius) @ "Height:" @ string(MyHeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Collides with Actors:" @ string(bCollideActors) @ " world:" @ string(bCollideWorld) @ "proj. target:" @ string(bProjTarget));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Blocks Actors:" @ string(bBlockActors));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "Touching ";
        foreach TouchingActors(class'Actor', A)
        {
            T = T $ GetItemName(string(A)) $ " ";
        }
        if (T == "Touching ")
        {
            T = "Touching nothing";
        }
        Canvas.DrawText(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    Canvas.DrawColor.B = 255;
    Canvas.DrawText(" STATE:" @ string(GetStateName()), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText(" Instigator:" @ GetItemName(string(Instigator)) @ "Owner:" @ GetItemName(string(Owner)));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
}

function string GetDebugName()
{
    return GetItemName(string(self));
}

function MatchStarting()
{
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return "";
}

static function ReplaceText(out string Text, string Replace, string With)
{
    local int I;
    local string Input;
    
    Input = Text;
    Text = "";
    I = InStr(Input, Replace);
    while (I != -1)
    {
        Text = Text $ Left(Input, I) $ With;
        Input = Mid(Input, I + Len(Replace));
        I = InStr(Input, Replace);
    }
    Text = Text $ Input;
}

simulated function string GetHumanReadableName()
{
    return GetItemName(string(Class));
}

simulated function string GetItemName(string FullName)
{
    local int pos;
    
    pos = InStr(FullName, ".");
    while (pos != -1)
    {
        FullName = Right(FullName, Len(FullName) - pos - 1);
        pos = InStr(FullName, ".");
    }
    return FullName;
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitNormal;
    local float Radius, Height;
    
    GetBoundingCylinder(Radius, Height);
    if (Trace(out_CamLoc, HitNormal, Location - vector(out_CamRot) * Radius * float(20), Location, false) == none)
    {
        out_CamLoc = Location - vector(out_CamRot) * Radius * float(20);
    }
    else
    {
        out_CamLoc = Location + Height * vector(Rotation);
    }
    return false;
}

event EndViewTarget(PlayerController PC)
{
}

event BecomeViewTarget(PlayerController PC)
{
}

function bool CheckForErrors()
{
}

event DebugFreezeGame(optional Actor ActorToLookAt)
{
    local PlayerController PC;
    
    ScriptTrace();
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        PC.ConsoleCommand("PlayersOnly");
        if (ActorToLookAt != none)
        {
            PC.SetViewTarget(ActorToLookAt);
        }
        return;
    }
}

native function float GetGravityZ()
{
}

final simulated function CheckHitInfo(out TraceHitInfo HitInfo, PrimitiveComponent FallBackComponent, Vector Dir, out Vector out_HitLocation)
{
    local Vector out_NewHitLocation, out_HitNormal, TraceEnd, TraceStart;
    local TraceHitInfo newHitInfo;
    
    if (SkeletalMeshComponent(HitInfo.HitComponent) != none && HitInfo.BoneName != 'None')
    {
        return;
    }
    if (HitInfo.HitComponent == none || SkeletalMeshComponent(HitInfo.HitComponent) == none && SkeletalMeshComponent(FallBackComponent) != none)
    {
        HitInfo.HitComponent = FallBackComponent;
    }
    if (SkeletalMeshComponent(HitInfo.HitComponent) != none && HitInfo.BoneName == 'None')
    {
        if (IsZero(Dir))
        {
            Dir = vector(Rotation);
        }
        if (IsZero(out_HitLocation))
        {
            out_HitLocation = Location;
        }
        TraceStart = out_HitLocation - float(128) * Normal(Dir);
        TraceEnd = out_HitLocation + float(128) * Normal(Dir);
        if (TraceComponent(out_NewHitLocation, out_HitNormal, HitInfo.HitComponent, TraceEnd, TraceStart, vect(0.0, 0.0, 0.0), newHitInfo))
        {
            HitInfo.BoneName = newHitInfo.BoneName;
            HitInfo.PhysMaterial = newHitInfo.PhysMaterial;
            out_HitLocation = out_NewHitLocation;
        }
    }
}

native final function EnableForceTranslucency(bool bEnable, float fAlpha, float BlendTime, optional int SortPriority = 0, optional bool bCameraForceTranslucency = true)
{
    bEnable;
    fAlpha;
    BlendTime;
    SortPriority;
    bCameraForceTranslucency;
}

simulated function SetDamageEffect(Actor DamageCauser)
{
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    local float ColRadius, ColHeight, DamageScale, Dist, ScaledDamage;
    local Vector Dir;
    
    GetBoundingCylinder(ColRadius, ColHeight);
    Dir = Location - HurtOrigin;
    Dist = VSize(Dir);
    Dir = Normal(Dir);
    if (bFullDamage)
    {
        DamageScale = 1.0;
    }
    else
    {
        Dist = FMax(Dist - ColRadius, 0.0);
        DamageScale = FClamp(1.0 - Dist / DamageRadius, 0.0, 1.0);
        DamageScale = DamageScale ** DamageFalloffExponent;
    }
    if (DamageScale > 0.0)
    {
        ScaledDamage = DamageScale * BaseDamage;
        TakeDamage(int(ScaledDamage), InstigatedBy, Location - 0.5 * (ColHeight + ColRadius) * Dir, DamageScale * Momentum * Dir, DamageType, , DamageCauser);
    }
}

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int Idx;
    local SeqEvent_TakeDamage dmgEvent;
    
    for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
    {
        dmgEvent = SeqEvent_TakeDamage(GeneratedEvents[Idx]);
        if (dmgEvent != none)
        {
            dmgEvent.HandleDamage(self, EventInstigator, DamageType, DamageAmount);
        }
    }
}

function KilledBy(Pawn EventInstigator)
{
}

simulated function bool HurtRadius(float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = Instigator != none ? Instigator.Controller : none, optional bool bDoFullDamage)
{
    local Actor Victim;
    local bool bCausedDamage;
    local TraceHitInfo HitInfo;
    local StaticMeshComponent HitComponent;
    local KActorFromStatic NewKActor;
    
    if (bHurtEntry)
    {
        return false;
    }
    bHurtEntry = true;
    bCausedDamage = false;
    foreach VisibleCollidingActors(class'Actor', Victim, DamageRadius, HurtOrigin, , , , , HitInfo)
    {
        if (Victim.bWorldGeometry)
        {
            HitComponent = StaticMeshComponent(HitInfo.HitComponent);
            if (HitComponent != none && HitComponent.CanBecomeDynamic())
            {
                NewKActor = class'KActorFromStatic'.static.MakeDynamic(HitComponent);
                if (NewKActor != none)
                {
                    Victim = NewKActor;
                }
            }
        }
        if (!Victim.bWorldGeometry && Victim != self && Victim != IgnoredActor && Victim.bProjTarget || NavigationPoint(Victim) == none)
        {
            Victim.TakeRadiusDamage(InstigatedByController, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
        }
    }
    bHurtEntry = false;
    return bCausedDamage;
}

simulated function bool StopsProjectile(Projectile P)
{
    return bProjTarget || bBlockActors;
}

simulated event NotifySkelControlBeyondLimit(SkelControlLookAt LookAt)
{
}

simulated event ConstraintBrokenNotify(Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance)
{
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    if (InitialState != 'None')
    {
        GotoState(InitialState);
    }
    else
    {
        GotoState('Auto');
    }
}

event PostBeginPlay()
{
}

event BroadcastLocalizedTeamMessage(int TeamIndex, class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    WorldInfo.Game.BroadcastLocalizedTeam(TeamIndex, self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

event BroadcastLocalizedMessage(class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    WorldInfo.Game.BroadcastLocalized(self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

event PreBeginPlay()
{
    if (bStatic && !(bLoadIfPhysXLevel0 && bLoadIfPhysXLevel1 && bLoadIfPhysXLevel2))
    {
        if (!WorldInfo.Game.CheckRelevance(self))
        {
            SetHidden(true);
            SetCollisionType(1);
        }
    }
    else if ((!(bLoadIfPhysXLevel0 && bLoadIfPhysXLevel1 && bLoadIfPhysXLevel2) || !bGameRelevant && !bStatic && WorldInfo.NetMode != 3) && !WorldInfo.Game.CheckRelevance(self))
    {
        if (bNoDelete)
        {
            ShutDown();
        }
        else
        {
            Destroy();
        }
    }
}

final function bool FindActorsOfClass(class<Actor> ActorClass, out array<Actor> out_Actors)
{
    local Actor TestActor;
    
    out_Actors.Length = 0;
    foreach AllActors(ActorClass, TestActor)
    {
        out_Actors[out_Actors.Length] = TestActor;
    }
    return out_Actors.Length > 0;
}

native final function PlayerController GetALocalPlayerController()
{
}

native final iterator function LocalPlayerControllers(class<PlayerController> BaseClass, out PlayerController PC)
{
    BaseClass;
    PC;
}

native final iterator function AllOwnedComponents(class<Component> BaseClass, out ActorComponent OutComponent)
{
    BaseClass;
    OutComponent;
}

native final iterator function ComponentList(class<ActorComponent> BaseClass, out ActorComponent out_Component)
{
    BaseClass;
    out_Component;
}

native final iterator function OverlappingActors(class<Actor> BaseClass, out Actor out_Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden)
{
    BaseClass;
    out_Actor;
    Radius;
    Loc;
    bIgnoreHidden;
}

native(321) final iterator function CollidingActors(class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bUseOverlapCheck, optional class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo)
{
    BaseClass;
    Actor;
    Radius;
    Loc;
    bUseOverlapCheck;
    InterfaceClass;
    HitInfo;
}

native(312) final iterator function VisibleCollidingActors(class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden, optional Vector Extent, optional bool bTraceActors, optional class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo)
{
    BaseClass;
    Actor;
    Radius;
    Loc;
    bIgnoreHidden;
    Extent;
    bTraceActors;
    InterfaceClass;
    HitInfo;
}

native(311) final iterator function VisibleActors(class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc)
{
    BaseClass;
    Actor;
    Radius;
    Loc;
}

native(309) final iterator function TraceActors(class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags)
{
    BaseClass;
    Actor;
    HitLoc;
    HitNorm;
    End;
    Start;
    Extent;
    HitInfo;
    ExtraTraceFlags;
}

native(307) final iterator function TouchingActors(class<Actor> BaseClass, out Actor Actor)
{
    BaseClass;
    Actor;
}

native(306) final iterator function BasedActors(class<Actor> BaseClass, out Actor Actor)
{
    BaseClass;
    Actor;
}

native(305) final iterator function ChildActors(class<Actor> BaseClass, out Actor Actor)
{
    BaseClass;
    Actor;
}

native(313) final iterator function DynamicActors(class<Actor> BaseClass, out Actor Actor, optional class<Interface> InterfaceClass)
{
    BaseClass;
    Actor;
    InterfaceClass;
}

native(304) final iterator function AllActors(class<Actor> BaseClass, out Actor Actor, optional class<Interface> InterfaceClass)
{
    BaseClass;
    Actor;
    InterfaceClass;
}

native(547) final function string GetURLMap()
{
}

function PostTeleport(Teleporter OutTeleporter)
{
}

function bool PreTeleport(Teleporter InTeleporter)
{
}

native final function Vector GetDestination(Controller C)
{
    C;
}

native final function bool SuggestTossVelocity(out Vector TossVelocity, Vector Destination, Vector Start, float TossSpeed, optional float BaseTossZ, optional float DesiredZPct, optional Vector CollisionSize, optional float TerminalVelocity, optional float OverrideGravityZ, optional bool bOnlyTraceUp)
{
    TossVelocity;
    Destination;
    Start;
    TossSpeed;
    BaseTossZ;
    DesiredZPct;
    CollisionSize;
    TerminalVelocity;
    OverrideGravityZ;
    bOnlyTraceUp;
}

native(532) final function bool PlayerCanSeeMe()
{
}

native(512) final function MakeNoise(float Loudness, optional name NoiseType)
{
    Loudness;
    NoiseType;
}

native final function PlaySound(SoundCue InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation, optional bool bNoRepToRelevant)
{
    InSoundCue;
    bNotReplicated;
    bNoRepToOwner;
    bStopWhenOwnerDestroyed;
    SoundLocation;
    bNoRepToRelevant;
}

native final function AudioComponent CreateAudioComponent(SoundCue InSoundCue, optional bool bPlay, optional bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation, optional bool bAttachToSelf = true)
{
    InSoundCue;
    bPlay;
    bStopWhenOwnerDestroyed;
    bUseLocation;
    SourceLocation;
    bAttachToSelf;
}

native final function ResetTimerTimeDilation(const name TimerName, optional Object inObj)
{
    TimerName;
    inObj;
}

native final function ModifyTimerTimeDilation(const name TimerName, const float InTimerTimeDilation, optional Object inObj)
{
    TimerName;
    InTimerTimeDilation;
    inObj;
}

final simulated function float GetRemainingTimeForTimer(optional name TimerFuncName = 'Timer', optional Object inObj)
{
    local float Count, Rate;
    
    Rate = GetTimerRate(TimerFuncName, inObj);
    if (Rate != -1.0)
    {
        Count = GetTimerCount(TimerFuncName, inObj);
        return Rate - Count;
    }
    return -1.0;
}

native final function float GetTimerRate(optional name TimerFuncName = 'Timer', optional Object inObj)
{
    TimerFuncName;
    inObj;
}

native final function float GetTimerCount(optional name inTimerFunc = 'Timer', optional Object inObj)
{
    inTimerFunc;
    inObj;
}

native final function bool IsTimerActive(optional name inTimerFunc = 'Timer', optional Object inObj)
{
    inTimerFunc;
    inObj;
}

native final function PauseTimer(bool bPause, optional name inTimerFunc = 'Timer', optional Object inObj)
{
    bPause;
    inTimerFunc;
    inObj;
}

native final function ClearAllTimers(optional Object inObj)
{
    inObj;
}

native final function ClearTimer(optional name inTimerFunc = 'Timer', optional Object inObj)
{
    inTimerFunc;
    inObj;
}

native(280) final function SetTimer(float InRate, optional bool inbLoop, optional name inTimerFunc = 'Timer', optional Object inObj)
{
    InRate;
    inbLoop;
    inTimerFunc;
    inObj;
}

event TornOff()
{
}

native(279) final function bool Destroy()
{
}

native final function Actor Spawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail)
{
    SpawnClass;
    SpawnOwner;
    SpawnTag;
    SpawnLocation;
    SpawnRotation;
    ActorTemplate;
    bNoCollisionFail;
}

native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight)
{
    CollisionRadius;
    CollisionHeight;
}

native final function GetComponentsBoundingBox(out Box ActorBox)
{
    ActorBox;
}

native final function bool IsOverlapping(Actor A)
{
    A;
}

native final function bool ContainsPoint(Vector Spot)
{
    Spot;
}

native final function bool FindSpot(Vector BoxExtent, out Vector SpotLocation)
{
    BoxExtent;
    SpotLocation;
}

native final function bool TraceAllPhysicsAssetInteractions(SkeletalMeshComponent SkelMeshComp, Vector EndTrace, Vector StartTrace, out array<ImpactInfo> out_Hits, optional Vector Extent)
{
    SkelMeshComp;
    EndTrace;
    StartTrace;
    out_Hits;
    Extent;
}

native(548) final function bool FastTrace(Vector TraceEnd, optional Vector TraceStart, optional Vector BoxExtent, optional bool bTraceBullet)
{
    TraceEnd;
    TraceStart;
    BoxExtent;
    bTraceBullet;
}

native final function bool PointCheckComponent(PrimitiveComponent InComponent, Vector PointLocation, Vector PointExtent)
{
    InComponent;
    PointLocation;
    PointExtent;
}

native final function bool TraceComponent(out Vector HitLocation, out Vector HitNormal, PrimitiveComponent InComponent, Vector TraceEnd, optional Vector TraceStart, optional Vector Extent, optional out TraceHitInfo HitInfo, optional bool bComplexCollision)
{
    HitLocation;
    HitNormal;
    InComponent;
    TraceEnd;
    TraceStart;
    Extent;
    HitInfo;
    bComplexCollision;
}

native(277) final function Actor Trace(out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags)
{
    HitLocation;
    HitNormal;
    TraceEnd;
    TraceStart;
    bTraceActors;
    Extent;
    HitInfo;
    ExtraTraceFlags;
}

simulated function VolumeBasedDestroy(PhysicsVolume PV)
{
    Destroy();
}

simulated event OutsideWorldBounds()
{
    Destroy();
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    SetPhysics(0);
    SetHidden(true);
    SetCollision(false, false);
    Destroy();
}

function bool UsedBy(Pawn User)
{
    return TriggerEventClass(class'SeqEvent_Used', User, -1);
}

simulated event bool OverRotated(out Rotator out_Desired, out Rotator out_Actual)
{
}

native final simulated function bool ClampRotation(out Rotator out_Rot, Rotator rBase, Rotator rUpperLimits, Rotator rLowerLimits)
{
    out_Rot;
    rBase;
    rUpperLimits;
    rLowerLimits;
}

event OnSleepRBPhysics()
{
}

event OnWakeRBPhysics()
{
}

event RanInto(Actor Other)
{
}

event EncroachedBy(Actor Other)
{
}

event bool EncroachingOn(Actor Other)
{
}

event CollisionChanged()
{
}

event Actor SpecialHandling(Pawn Other)
{
}

event Detach(Actor Other)
{
}

event Attach(Actor Other)
{
}

event BaseChange()
{
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
}

event UnTouch(Actor Other)
{
}

event PostTouch(Actor Other)
{
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
}

event Landed(Vector HitNormal, Actor FloorActor)
{
}

event Falling()
{
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    TriggerEventClass(class'SeqEvent_HitWall', Wall);
}

event Timer()
{
}

event Tick(float DeltaTime)
{
}

event LostChild(Actor Other)
{
}

event GainedChild(Actor Other)
{
}

event Destroyed()
{
}

native function bool CanTakeDamage()
{
}

native final function SetTickIsDisabled(bool bInDisabled)
{
    bInDisabled;
}

native final function SetTickGroup(ETickingGroup NewTickGroup)
{
    NewTickGroup;
}

native final function ReattachComponent(ActorComponent ComponentToReattach)
{
    ComponentToReattach;
}

native final function DetachComponent(ActorComponent ExComponent)
{
    ExComponent;
}

native final function AttachComponent(ActorComponent NewComponent)
{
    NewComponent;
}

native final function UnClock(out float Time)
{
    Time;
}

native final function Clock(out float Time)
{
    Time;
}

native(3970) final function SetPhysics(EPhysics newPhysics)
{
    newPhysics;
}

native final function SetOnlyOwnerSee(bool bNewOnlyOwnerSee)
{
    bNewOnlyOwnerSee;
}

native final function SetHidden(bool bNewHidden)
{
    bNewHidden;
}

native final function ChartData(string DataName, float DataValue)
{
    DataName;
    DataValue;
}

native static final function FlushDebugStrings()
{
}

native static final function DrawDebugFrustrum(out const Matrix FrustumToWorld, byte R, byte G, byte B, optional bool bPersistentLines)
{
    FrustumToWorld;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function DrawDebugString(Vector TextLocation, coerce string Text, optional Actor TestBaseActor, optional Color TextColor, optional float Duration = -1.0)
{
    TextLocation;
    Text;
    TestBaseActor;
    TextColor;
    Duration;
}

native static final function DrawDebugCone(Vector Origin, Vector Direction, float Length, float AngleWidth, float AngleHeight, int NumSides, Color DrawColor, optional bool bPersistentLines)
{
    Origin;
    Direction;
    Length;
    AngleWidth;
    AngleHeight;
    NumSides;
    DrawColor;
    bPersistentLines;
}

native static final function DrawDebugCylinder(Vector Start, Vector End, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines)
{
    Start;
    End;
    Radius;
    Segments;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function DrawDebugSphere(Vector Center, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines)
{
    Center;
    Radius;
    Segments;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function DrawDebugCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines)
{
    AxisLoc;
    AxisRot;
    Scale;
    bPersistentLines;
}

native static final function DrawDebugStar(Vector Position, float Size, byte R, byte G, byte B, optional bool bPersistentLines)
{
    Position;
    Size;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function DrawDebugBox(Vector Center, Vector Extent, byte R, byte G, byte B, optional bool bPersistentLines)
{
    Center;
    Extent;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function DrawDebugPoint(Vector Position, float Size, LinearColor PointColor, optional bool bPersistentLines)
{
    Position;
    Size;
    PointColor;
    bPersistentLines;
}

native static final function DrawDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B, optional bool bPersistentLines)
{
    LineStart;
    LineEnd;
    R;
    G;
    B;
    bPersistentLines;
}

native static final function FlushPersistentDebugLines()
{
}

native static final function Vector GetBasedPosition(BasedPosition BP)
{
    BP;
}

native static final function SetBasedPosition(out BasedPosition BP, Vector pos, optional Actor ForcedBase)
{
    BP;
    pos;
    ForcedBase;
}

native static final function Vector BP2Vect(BasedPosition BP)
{
    BP;
}

native static final function Vect2BP(out BasedPosition BP, Vector pos, optional Actor ForcedBase)
{
    BP;
    pos;
    ForcedBase;
}

native final function SetForcedInitialReplicatedProperty(Property PropToReplicate, bool bAdd)
{
    PropToReplicate;
    bAdd;
}

simulated event ReplicatedDataBinding(name VarName)
{
}

simulated event ReplicatedEvent(name VarName)
{
}

native final function bool IsOwnedBy(Actor TestActor)
{
    TestActor;
}

native function Actor GetBaseMost()
{
}

native final function bool IsBasedOn(Actor TestActor)
{
    TestActor;
}

native function FindBase()
{
}

native(272) final function SetOwner(Actor NewOwner)
{
    NewOwner;
}

native(298) final function SetBase(Actor NewBase, optional Vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name AttachName)
{
    NewBase;
    NewFloor;
    SkelComp;
    AttachName;
}

native function float GetTerminalVelocity()
{
}

native(3971) final function AutonomousPhysics(float DeltaSeconds)
{
    DeltaSeconds;
}

native(3969) final function bool MoveSmooth(Vector Delta)
{
    Delta;
}

native final function int fixedTurn(int Current, int Desired, int DeltaRate)
{
    Current;
    Desired;
    DeltaRate;
}

native final function SetHardAttach(optional bool bNewHardAttach)
{
    bNewHardAttach;
}

native final function bool SetRelativeLocation(Vector NewLocation)
{
    NewLocation;
}

native final function bool SetRelativeRotation(Rotator NewRotation)
{
    NewRotation;
}

native final function SetZone(bool bForceRefresh)
{
    bForceRefresh;
}

native function EMoveDir MovingWhichWay(out float Amount)
{
    Amount;
}

native(299) final function bool SetRotation(Rotator NewRotation)
{
    NewRotation;
}

native final function bool SetLocationNoCheck(Vector NewLocation)
{
    NewLocation;
}

native(267) final function bool SetLocation(Vector NewLocation)
{
    NewLocation;
}

native(266) final function bool Move(Vector Delta)
{
    Delta;
}

native final function SetDrawScale3D(Vector NewScale3D)
{
    NewScale3D;
}

native final function SetDrawScale(float NewScale)
{
    NewScale;
}

native final function SetCollisionType(ECollisionType NewCollisionType)
{
    NewCollisionType;
}

native(283) final function SetCollisionSize(float NewRadius, float NewHeight)
{
    NewRadius;
    NewHeight;
}

native(262) final function SetCollision(optional bool bNewColActors, optional bool bNewBlockActors, optional bool bNewIgnoreEncroachers)
{
    bNewColActors;
    bNewBlockActors;
    bNewIgnoreEncroachers;
}

native(261) final latent function FinishAnim(AnimNodeSequence SeqNode)
{
    SeqNode;
}

native(256) final latent function Sleep(float Seconds)
{
    Seconds;
}

native function string ConsoleCommand(string Command, optional bool bWriteToLog = true)
{
    Command;
    bWriteToLog;
}

native function ForceUpdateComponents(optional bool bCollisionUpdate = false, optional bool bTransformOnly = true)
{
    bCollisionUpdate;
    bTransformOnly;
}

native exec function PureVisualStopMotion()
{
}

native exec function StopMotion()
{
}

defaultproperties
{
    bLoadIfPhysXLevel0=True
    bLoadIfPhysXLevel1=True
    bLoadIfPhysXLevel2=True
    bPushedByEncroachers=True
    bRouteBeginPlayEvenIfStatic=True
    bCanStepUpOn=True
    bReplicateMovement=True
    bAllowFluidSurfaceInteraction=True
    bMovable=True
    bJustTeleported=True
    DrawScale=1.0
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    CustomTimeDilation=1.0
    Role="ROLE_Authority"
    CollisionType="COLLIDE_NoCollision"
    ReplicatedCollisionType="None"
    ForceTranslucencyAlpha=1.0
    StopMotionTranslationNoiseLevel=0.02
    StopMotionRotationNoiseLevel=0.02
    StopMotionFPS=16.0
    NetUpdateFrequency=100.0
    NetPriority=1.0
    TickFrequencyLastSeenTimeBeforeForcingMaxTickFrequency=2.0
    MessageClass="LocalMessage"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
}
