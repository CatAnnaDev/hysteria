class Pawn extends Actor
    abstract
    native
    nativereplication
    placeable
    config(Game)
    hidecategories(Navigation);

enum ECmnLedgeType
{
    ECLT_None,
    ECLT_Step,
    ECLT_Abyss,
    ECLT_Wall,
};

enum EPathSearchType
{
    PST_Default,
    PST_Breadth,
    PST_NewBestPathTo,
    PST_Constraint,
};

enum EAIState
{
    EAIState_Idle,
    EAIState_Fighting,
    EAIState_Fleeing,
};

struct native FacialFaceFXAnimInfo
{
    var() int FacialAnimSetIndex;
    var() string FacialAnimName;
    var() string FacialAnimGroupName;
    var() SoundCue FacialSoundCue;
};

struct native ScalarParameterInterpStruct
{
    var() name ParameterName;
    var() float ParameterValue;
    var() float InterpTime;
    var() float WarmupTime;
};

var() const float MaxStepHeight;
var() const float MaxJumpHeight;
var const float WalkableFloorZ;
var const float LedgeCheckThreshold;
var repnotify editinline Controller Controller;
var const Pawn NextPawn;
var float NetRelevancyTime;
var PlayerController LastRealViewer;
var Actor LastViewer;
var bool bUpAndOut;
var repretry bool bIsWalking;
var bool bWantsToCrouch;
var const repretry bool bIsCrouched;
var const bool bTryToUncrouch;
var() bool bCanCrouch;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bJumpCapable;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanClimbLadders;
var bool bCanStrafe;
var bool bAvoidLedges;
var bool bAllowLedgeOverhang;
var const repretry bool bSimulateGravity;
var bool bIgnoreForces;
var bool bCanWalkOffLedges;
var bool bCanBeBaseForPawns;
var const bool bSimGravityDisabled;
var bool bDirectHitWall;
var const bool bPushesRigidBodies;
var bool bForceFloorCheck;
var bool bForceKeepAnchor;
var config bool bCanMantle;
var config bool bCanClimbUp;
var bool bCanClimbCeilings;
var config repretry bool bCanSwatTurn;
var config bool bCanLeap;
var config bool bCanCoverSlip;
var globalconfig bool bDisplayPathErrors;
var bool bIsFemale;
var bool bCanPickupInventory;
var bool bAmbientCreature;
var(AI) bool bLOSHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bDontPossess;
var bool bAutoFire;
var bool bRollToDesired;
var bool bStationary;
var bool bCachedRelevant;
var bool bNoWeaponFiring;
var bool bModifyReachSpecCost;
var bool bModifyNavPointDest;
var bool bPathfindsAsVehicle;
var bool bRunPhysicsWithNoController;
var bool bForceMaxAccel;
var bool bLimitFallAccel;
var bool bReplicateHealthToAll;
var bool bForceRMVelocity;
var bool bForceRegularVelocity;
var bool bPlayedDeath;
var const bool bDesiredRotationSet;
var const bool bLockDesiredRotation;
var const bool bUnlockWhenReached;
var bool bNeedsBaseTickedFirst;
var repretry bool bRootMotionFromInterpCurve;
var transient bool bBlendingRefBoxZPosition;
var transient bool CheckLedgeWhileZAxisMovement;
var transient bool IgnoreXYMovementWhileZAxisMovement;
var transient bool bSlidingToTarget;
var(Debug) bool bDebugShowCameraLocation;
var bool bInDeathRagdoll;
var(LockOnMode) bool bCanBeLockedOn;
var transient bool bLockedOn;
var(Foot) bool bUseTranslateIK;
var transient bool bJustPushDownByIK;
var const float UncrouchTime;
var float CrouchHeight;
var float CrouchRadius;
var const int FullHeight;
var int bStopAtLedges;
var float NonPreferredVehiclePathMultiplier;
var() float BasicFlyHeight;
var() float FlyAttackHeight;
var() float FlyOffsetRange;
var native transient Pointer SteamingLevel;
var() int XPValue;
var() int XPMaxValue;
var EPathSearchType PathSearchType;
var const repretry byte RemoteViewPitch;
var repnotify byte FlashCount;
var repnotify byte FiringMode;
var transient ECmnLedgeType LedgeTypeWhileZAxisMovement;
var PathConstraint PathConstraintList;
var PathGoalEvaluator PathGoalList;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var(AI) float HearingThreshold;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var const float AvgPhysicsTime;
var float Mass;
var float Buoyancy;
var float MeleeRange;
var const NavigationPoint Anchor;
var const int AnchorItem;
var const NavigationPoint LastAnchor;
var float FindAnchorFailedTime;
var float LastValidAnchorTime;
var float DestinationOffset;
var float NextPathRadius;
var Vector SerpentineDir;
var float SerpentineDist;
var float SerpentineTime;
var float SpawnTime;
var int MaxPitchLimit;
var() repretry float GroundSpeed;
var() repretry float WaterSpeed;
var() repretry float AirSpeed;
var() float LadderSpeed;
var() repretry float AccelRate;
var() repretry float JumpZ;
var float OutofWaterZ;
var float MaxOutOfWaterStepHeight;
var() repretry float AirControl;
var float WalkingPct;
var float CrouchedPct;
var float MaxFallSpeed;
var float AIMaxFallSpeedFactor;
var(Camera) float BaseEyeHeight;
var(Camera) float EyeHeight;
var(Collision) float AdditionCollisionHeight;
var Vector Floor;
var float SplashTime;
var float OldZ;
var transient PhysicsVolume HeadVolume;
var() repretry int Health;
var() int HealthMax;
var float BreathTime;
var float UnderWaterTime;
var float LastPainTime;
var Vector RMVelocity;
var const Vector noise1spot;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const Vector noise2spot;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var float SoundDampening;
var float DamageScaling;
var const localized string MenuName;
var class<AIController> ControllerClass;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var LadderVolume OnLadder;
var name LandMovementState;
var name WaterMovementState;
var PlayerStart LastStartSpot;
var float LastStartTime;
var repretry Vector TakeHitLocation;
var repretry class<DamageType> HitDamageType;
var repretry Vector TearOffMomentum;
var() export editinline SkeletalMeshComponent Mesh;
var export editinline CylinderComponent CylinderComponent;
var() float RBPushRadius;
var() float RBPushStrength;
var repnotify Vehicle DrivenVehicle;
var float AlwaysRelevantDistanceSquared;
var() float VehicleCheckRadius;
var Controller LastHitBy;
var() float ViewPitchMin;
var() float ViewPitchMax;
var int AllowedYawError;
var(Movement) const Rotator DesiredRotation;
var Rotator LastFrameRotatorInBlendingByNpcRotor;
var class<InventoryManager> InventoryManagerClass;
var repnotify InventoryManager InvManager;
var() Weapon Weapon;
var transient Weapon PrevWeapon;
var repnotify Vector FlashLocation;
var Vector LastFiringFlashLocation;
var int ShotCount;
var export editinline PrimitiveComponent PreRagdollCollisionComponent;
var RB_BodyInstance PhysicsPushBody;
var int FailedLandingCount;
var transient array<AnimNodeSlot> SlotNodes;
var transient array<InterpGroup> InterpGroupList;
var transient export editinline AudioComponent FacialAudioComp;
var transient MaterialInstanceConstant MIC_PawnMat;
var transient MaterialInstanceConstant MIC_PawnHair;
var() array<ScalarParameterInterpStruct> ScalarParameterInterpArray;
var RootMotionCurve RootMotionInterpCurve;
var repretry float RootMotionInterpRate;
var repretry float RootMotionInterpCurrentTime;
var repretry Vector RootMotionInterpCurveLastValue;
var() float RefBoxBlendingMaxLineCheckDist;
var transient float RefBoxDeltaZ;
var transient float BlendingRefBoxDuration;
var transient float BlendingRefBoxDeltaZVelocity;
var transient float BlendingRefBoxTimeAcculumated;
var transient float RootRotationFactor;
var() float LedgeHeightToAvoidFallingWhenCombat;
var() float ZAxisMovementMaxLineCheckDist;
var() float ZAxisMovementAdditionalRadius;
var transient float ZAxisMovementFloorHeight;
var transient float ZAxisMovementDuration;
var transient float ZAxisMovementTimeAcculumated;
var transient float SlideToTargetDuration;
var transient float SlideToTargetTimeAccumulated;
var transient Vector SlideToTargetDeltaPos;
var transient Vector SlideToTargetDeltaVel;
var(FaceFX) array<FaceFXAnimSet> FacialAnimSets;
var(FaceFX) array<FacialFaceFXAnimInfo> FacialAnimInfo;
var float AbsKnockBackScale;
var float AbsKnockBackTotalTime;
var transient float ClockWeaponFreezeLeftTime;
var const transient Vector MeshTranslationOffset;
var(Foot) float FootOffsetBlendingSpeed;
var transient float MeshHeightOffset;
var transient float bJustPushDownSpeed;
var(Foot) float ThresholdHeightToCancelPushDownByIK;
var native transient map<int, int> FeetPositions;
var native transient map<int, int> FeetLanded;

replication
{
    if (bNetDirty && bNetOwner && Role == 3)
        Controller, GroundSpeed, WaterSpeed, AirSpeed, AccelRate, JumpZ, AirControl, InvManager;
    if (bNetDirty && Role == 3)
        bIsWalking, bSimulateGravity, PlayerReplicationInfo, TakeHitLocation, HitDamageType, DrivenVehicle, FlashLocation;
    if (bNetDirty && !bNetOwner || bDemoRecording && Role == 3)
        bIsCrouched, FlashCount, FiringMode;
    if (bNetDirty && bNetOwner && bNetInitial)
        bCanSwatTurn;
    if (bNetInitial && !bNetOwner && Role == 3)
        bRootMotionFromInterpCurve;
    if ((!bNetOwner || bDemoRecording) && Role == 3)
        RemoteViewPitch;
    if (bNetDirty && bNetOwner || bReplicateHealthToAll)
        Health;
    if (bTearOff && bNetDirty && Role == 3)
        TearOffMomentum;
    if (bNetInitial && !bNetOwner && Role == 3 && bRootMotionFromInterpCurve)
        RootMotionInterpRate, RootMotionInterpCurrentTime, RootMotionInterpCurveLastValue;
}

event PostSetPhysFalling()
{
}

function StartSlideToTarget()
{
    bSlidingToTarget = true;
}

event DelaySlideToTarget(float DelayTime)
{
    SetTimer(DelayTime, false, 'StartSlideToTarget');
}

function bool AnyLockableSocketaEnable()
{
    return false;
}

simulated function Vector GetCameraTargetSocketLoc(int SocketIndex)
{
    return Location;
}

function OnNotLockedOn()
{
    if (bLockedOn)
    {
        bLockedOn = false;
    }
    else
    {
        return;
    }
}

function OnLockedOn()
{
    if (!bLockedOn)
    {
        bLockedOn = true;
    }
    else
    {
        return;
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    CheckLedgeWhileZAxisMovement = false;
    bBlendingRefBoxZPosition = false;
    RootRotationFactor = 1.0;
}

event NotifyDetachNPC(Pawn DetachPawn)
{
}

event NotifyAttachNPC(Pawn AttachPawn)
{
}

event RegisterFightingNPC(Pawn FightingNPC)
{
}

event UnRegisterFightingNPC(Pawn FightingNPC)
{
}

native simulated function Vector VerifyTranslatedRootMotion(Vector DeltaMove, float DeltaTime)
{
    DeltaMove;
    DeltaTime;
}

native final simulated function SetScalarParameterInterp(out const ScalarParameterInterpStruct ScalarParameterInterp)
{
    ScalarParameterInterp;
}

native function SetRootMotionInterpCurrentTime(float inTime, optional float DeltaTime, optional bool bUpdateSkelPose)
{
    inTime;
    DeltaTime;
    bUpdateSkelPose;
}

simulated function SetCinematicMode(bool bInCinematicMode)
{
}

simulated function ZeroMovementVariables()
{
    Velocity = vect(0.0, 0.0, 0.0);
    Acceleration = vect(0.0, 0.0, 0.0);
}

native function ClearPathStep()
{
}

native function DrawPathStep(Canvas C)
{
    C;
}

native function IncrementPathChild(int Cnt, Canvas C)
{
    Cnt;
    C;
}

native function IncrementPathStep(int Cnt, Canvas C)
{
    Cnt;
    C;
}

function PathGoalEvaluator CreatePathGoalEvaluator(class<PathGoalEvaluator> GoalEvalClass)
{
    return new(self) GoalEvalClass;
}

function PathConstraint CreatePathConstraint(class<PathConstraint> ConstraintClass)
{
    return new(self) ConstraintClass;
}

native function AddGoalEvaluator(PathGoalEvaluator Evaluator)
{
    Evaluator;
}

native function AddPathConstraint(PathConstraint Constraint)
{
    Constraint;
}

native function ClearConstraints()
{
}

event SoakPause()
{
    local PlayerController PC;
    
    foreach WorldInfo.LocalPlayerControllers(class'PlayerController', PC)
    {
        PC.SoakPause(self);
        break;
    }
}

simulated event BecomeViewTarget(PlayerController PC)
{
    if (PhysicsVolume != none)
    {
        PhysicsVolume.NotifyPawnBecameViewTarget(self, PC);
    }
    if (!bReplicateHealthToAll && WorldInfo.NetMode != 3)
    {
        PC.ForceSingleNetUpdateFor(self);
    }
}

simulated function AdjustCameraScale(bool bMoveCameraIn)
{
}

final event MessagePlayer(coerce string msg)
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        PC.ClientMessage(msg);
    }
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController P;
    
    if (WorldInfo.NetMode == 1)
    {
        return bForceDedicated;
    }
    if (WorldInfo.NetMode == 2 && WorldInfo.Game.NumPlayers + WorldInfo.Game.NumSpectators > 1)
    {
        if (bForceDedicated)
        {
            return true;
        }
        if (IsHumanControlled() && IsLocallyControlled())
        {
            return true;
        }
    }
    else if (IsHumanControlled())
    {
        return true;
    }
    if (SpawnLocation != Location || WorldInfo.TimeSeconds - LastRenderTime < 1.0)
    {
        foreach LocalPlayerControllers(class'PlayerController', P)
        {
            if (P.ViewTarget != none && P.Pawn == self || CheckMaxEffectDistance(P, SpawnLocation, CullDistance))
            {
                return true;
            }
        }
    }
    return false;
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;
    local Controller C;
    local Vector desteLocation;
    
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
    desteLocation = destActor.Location;
    if (destActor != none && SetLocation(desteLocation))
    {
        PlayTeleportEffect(false, true);
        if (Action.bUpdateRotation)
        {
            SetRotation(destActor.Rotation);
            if (Controller != none)
            {
                Controller.SetRotation(destActor.Rotation);
                Controller.ClientSetRotation(destActor.Rotation);
            }
        }
    }
    else
    {
        WarnInternal("Unable to teleport to" @ string(destActor));
    }
    if (Controller != none)
    {
        Controller.OnTeleport(none);
    }
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
    if (Mesh != none)
    {
        Mesh.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    }
}

function float GetDamageScaling()
{
    return DamageScaling;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors, bOldBlockActors, bValidBone, bValidSocket;
    
    if (Mesh != none && Action.BoneName != 'None')
    {
        bValidSocket = Mesh.GetSocketByName(Action.BoneName) != none;
        bValidBone = Mesh.MatchRefBone(Action.BoneName) != -1;
        if (!bValidBone && !bValidSocket)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ string(Class) @ string(GetFuncName()) @ "bone or socket" @ string(Action.BoneName) @ "not found on actor" @ string(self) @ "with mesh" @ string(Mesh));
        }
    }
    if (bValidBone || bValidSocket)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(false, false);
        Attachment.SetHardAttach(Action.bHardAttach);
        if (bValidBone && !bValidSocket)
        {
            if (Action.bUseRelativeOffset)
            {
                Attachment.SetLocation(Mesh.GetBoneLocation(Action.BoneName));
            }
            if (Action.bUseRelativeRotation)
            {
                Attachment.SetRotation(QuatToRotator(Mesh.GetBoneQuaternion(Action.BoneName)));
            }
        }
        Attachment.SetBase(self, , Mesh, Action.BoneName);
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors);
    }
    else
    {
        DoKismetAttachment(Attachment, Action);
    }
}

event SpawnedByKismet()
{
    if (Controller != none)
    {
        Controller.SpawnedByKismet();
    }
}

function bool IsStationary()
{
    return false;
}

final simulated function Vector GetCollisionExtent()
{
    local Vector Extent;
    
    Extent = GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Extent.Z = GetCollisionHeight();
    return Extent;
}

simulated function float GetCollisionHeight()
{
    return CylinderComponent != none ? CylinderComponent.CollisionHeight : 0.0;
}

simulated function float GetCollisionRadius()
{
    return CylinderComponent != none ? CylinderComponent.CollisionRadius : 0.0;
}

function bool CheatFly()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(true, true);
    bCollideWorld = true;
    return true;
}

function bool CheatGhost()
{
    UnderWaterTime = -1.0;
    SetCollision(false, false);
    bCollideWorld = false;
    SetPushesRigidBodies(false);
    return true;
}

function bool CheatWalk()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(true, true);
    SetPhysics(2);
    bCollideWorld = true;
    SetPushesRigidBodies(default.bPushesRigidBodies);
    return true;
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
}

simulated function SetActiveWeapon(Weapon NewWeapon)
{
    if (InvManager != none)
    {
        InvManager.SetCurrentWeapon(NewWeapon);
    }
}

function TossInventory(Inventory Inv, optional Vector ForceVelocity)
{
    local Vector POVLoc, TossVel;
    local Rotator POVRot;
    local Vector X, Y, Z;
    
    if (ForceVelocity != vect(0.0, 0.0, 0.0))
    {
        TossVel = ForceVelocity;
    }
    else
    {
        GetActorEyesViewPoint(POVLoc, POVRot);
        TossVel = vector(POVRot);
        TossVel = TossVel * (Velocity Dot TossVel + float(500)) + vect(0.0, 0.0, 200.0);
    }
    GetAxes(Rotation, X, Y, Z);
    Inv.DropFrom(Location + 0.8 * CylinderComponent.CollisionRadius * X - 0.5 * CylinderComponent.CollisionRadius * Y, TossVel);
}

function ThrowActiveWeapon()
{
    if (Weapon != none)
    {
        TossInventory(Weapon);
    }
}

simulated function DrawHUD(HUD H)
{
    if (InvManager != none)
    {
        InvManager.DrawHUD(H);
    }
}

final simulated function Inventory FindInventoryType(class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    return InvManager != none ? InvManager.FindInventoryType(DesiredClass, bAllowSubclass) : none;
}

final event Inventory CreateInventory(class<Inventory> NewInvClass, optional bool bDoNotActivate)
{
    if (InvManager != none)
    {
        return InvManager.CreateInventory(NewInvClass, bDoNotActivate);
    }
    return none;
}

function AddDefaultInventory()
{
}

simulated event StopDriving(Vehicle V)
{
    if (Mesh != none)
    {
        Mesh.SetCullDistance(default.Mesh.CachedMaxDrawDistance);
        Mesh.SetShadowParent(none);
    }
    bForceNetUpdate = true;
    if (V != none)
    {
        V.StopFiring();
    }
    if (Physics == 10)
    {
        return;
    }
    DrivenVehicle = none;
    bIgnoreForces = false;
    SetHardAttach(false);
    bCanTeleport = true;
    bCollideWorld = true;
    if (V != none)
    {
        V.DetachDriver(self);
    }
    SetCollision(true, true);
    if (Role == 3)
    {
        if (PhysicsVolume.bWaterVolume && Health > 0)
        {
            SetPhysics(3);
        }
        else
        {
            SetPhysics(2);
        }
        SetBase(none);
        SetHidden(false);
    }
}

simulated event StartDriving(Vehicle V)
{
    StopFiring();
    if (Health <= 0)
    {
        return;
    }
    DrivenVehicle = V;
    bForceNetUpdate = true;
    ShouldCrouch(false);
    bIgnoreForces = true;
    bCanTeleport = false;
    BreathTime = 0.0;
    V.AttachDriver(self);
}

simulated function bool CanThrowWeapon()
{
    return Weapon != none && Weapon.CanThrow();
}

function Suicide()
{
    KilledBy(self);
}

native function Vehicle GetVehicleBase()
{
}

function PlayLanded(float ImpactVel)
{
}

function bool CannotJumpNow()
{
    return false;
}

event PlayFootStepWaterEffect(const AnimNotify_WaterEffect AnimNotifyData, const AnimNodeSequence NodeSeq)
{
}

event PlayFootStepSound(int FootDown)
{
}

simulated event TornOff()
{
    if (!bPlayedDeath)
    {
        PlayDying(HitDamageType, TakeHitLocation);
    }
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    GotoState('Dying');
    bReplicateMovement = false;
    bTearOff = true;
    Velocity += TearOffMomentum;
    SetDyingPhysics();
    bPlayedDeath = true;
}

function SetDyingPhysics()
{
    if (Physics != 10)
    {
        SetPhysics(2);
    }
}

simulated function TurnOff()
{
    if (Role == 3)
    {
        RemoteRole = 1;
    }
    if (WorldInfo.NetMode != 1 && Mesh != none)
    {
        Mesh.bPauseAnims = true;
        if (Physics == 10)
        {
            Mesh.PhysicsWeight = 1.0;
            Mesh.bUpdateKinematicBonesFromAnimation = false;
        }
    }
    SetCollision(true, false);
    bNoWeaponFiring = true;
    Velocity = vect(0.0, 0.0, 0.0);
    SetPhysics(0);
    bIgnoreForces = true;
    if (Weapon != none)
    {
        Weapon.StopFire(Weapon.CurrentFireMode);
    }
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    if (Damage <= float(0) && Controller == none || !Controller.bGodMode)
    {
        return;
    }
    LastPainTime = WorldInfo.TimeSeconds;
}

function PlayDyingSound()
{
}

function DoFall()
{
    if (Physics == 1 || Physics == 9 || Physics == 8)
    {
        SetPhysics(2);
    }
}

function bool DoJump(bool bUpdating)
{
    if (bJumpCapable && !bIsCrouched && !bWantsToCrouch && Physics == 1 || Physics == 9 || Physics == 8)
    {
        if (Physics == 8)
        {
            Velocity = JumpZ * Floor;
        }
        else if (Physics == 9)
        {
            Velocity.Z = 0.0;
        }
        else if (bIsWalking)
        {
            Velocity.Z = default.JumpZ;
        }
        else
        {
            Velocity.Z = JumpZ;
        }
        if (Base != none && !Base.bWorldGeometry && Base.Velocity.Z > 0.0)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        return true;
    }
    return false;
}

function bool CheckWaterJump(out Vector WallNormal)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal, Checkpoint, Start, checkNorm, Extent;
    
    if (AIController(Controller) != none)
    {
        if (Controller.InLatentExecution(Controller.503) && Controller.MoveTarget != none && !Controller.MoveTarget.PhysicsVolume.bWaterVolume)
        {
            Checkpoint = Normal(Controller.MoveTarget.Location - Location);
        }
        else
        {
            Checkpoint = Acceleration;
        }
        Checkpoint.Z = 0.0;
    }
    if (Checkpoint == vect(0.0, 0.0, 0.0))
    {
        Checkpoint = vector(Rotation);
    }
    Checkpoint.Z = 0.0;
    checkNorm = Normal(Checkpoint);
    Checkpoint = Location + 1.2 * CylinderComponent.CollisionRadius * checkNorm;
    Extent = CylinderComponent.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = CylinderComponent.CollisionHeight;
    HitActor = Trace(HitLocation, HitNormal, Checkpoint, Location, true, Extent, , 8);
    if (HitActor != none && Pawn(HitActor) == none)
    {
        WallNormal = float(-1) * HitNormal;
        Start = Location;
        Start.Z += MaxOutOfWaterStepHeight;
        Checkpoint = Start + 3.2 * CylinderComponent.CollisionRadius * WallNormal;
        HitActor = Trace(HitLocation, HitNormal, Checkpoint, Start, true, , , 8);
        if (HitActor == none || HitNormal.Z > 0.7)
        {
            return true;
        }
    }
    return false;
}

function TakeDrowningDamage()
{
}

event BreathTimer()
{
    if (HeadVolume.bWaterVolume)
    {
        if (Health < 0 || WorldInfo.NetMode == 3 || DrivenVehicle != none)
        {
            return;
        }
        TakeDrowningDamage();
        if (Health > 0)
        {
            BreathTime = 2.0;
        }
    }
    else
    {
        BreathTime = 0.0;
    }
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

function bool TouchingWaterVolume()
{
    local PhysicsVolume V;
    
    foreach TouchingActors(class'PhysicsVolume', V)
    {
        if (V.bWaterVolume)
        {
            return true;
        }
    }
    return false;
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
    if (WorldInfo.NetMode == 3 || Controller == none)
    {
        return;
    }
    if (HeadVolume != none && HeadVolume.bWaterVolume)
    {
        if (!newHeadVolume.bWaterVolume)
        {
            if (Controller.bIsPlayer && BreathTime > float(0) && BreathTime < float(8))
            {
                Gasp();
            }
            BreathTime = -1.0;
        }
    }
    else if (newHeadVolume.bWaterVolume)
    {
        BreathTime = UnderWaterTime;
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    if (Health > 0)
    {
        PlayLanded(Velocity.Z);
    }
    LastHitBy = none;
}

event Falling()
{
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local SeqAct_Latent Action;
    
    bCanBeDamaged = false;
    if (DamageType == none)
    {
        DamageType = class'DamageType';
    }
    if (bDeleteMe || WorldInfo.Game == none || WorldInfo.Game.bLevelChange)
    {
        return false;
    }
    if (DamageType.default.default.bCausedByWorld && Killer == none || Killer == Controller && LastHitBy != none)
    {
        Killer = LastHitBy;
    }
    if (WorldInfo.Game.PreventDeath(self, Killer, DamageType, HitLocation))
    {
        Health = Max(Health, 1);
        return false;
    }
    Health = Min(0, Health);
    TriggerEventClass(class'SeqEvent_Death', self);
    foreach LatentActions(Action)
    {
        Action.AbortFor(self);
    }
    LatentActions.Length = 0;
    if (DrivenVehicle != none)
    {
        Velocity = DrivenVehicle.Velocity;
        DrivenVehicle.DriverDied(DamageType);
    }
    else if (Weapon != none)
    {
        Weapon.HolderDied();
        ThrowWeaponOnDeath();
    }
    if (Controller != none)
    {
        WorldInfo.Game.Killed(Killer, Controller, self, DamageType);
    }
    else
    {
        WorldInfo.Game.Killed(Killer, Controller(Owner), self, DamageType);
    }
    DrivenVehicle = none;
    if (InvManager != none)
    {
        InvManager.OwnerDied();
    }
    Velocity.Z *= 1.3;
    if (IsHumanControlled())
    {
        PlayerController(Controller).ForceDeathUpdate();
    }
    NetUpdateFrequency = default.NetUpdateFrequency;
    PlayDying(DamageType, HitLocation);
    return true;
}

function ThrowWeaponOnDeath()
{
    ThrowActiveWeapon();
}

simulated event bool IsSameTeam(Pawn Other)
{
    return Other != none && Other.GetTeam() != none && Other.GetTeam() == GetTeam();
}

simulated function TeamInfo GetTeam()
{
    if (Controller != none && Controller.PlayerReplicationInfo != none)
    {
        return Controller.PlayerReplicationInfo.Team;
    }
    else if (PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.Team;
    }
    else if (DrivenVehicle != none && DrivenVehicle.PlayerReplicationInfo != none)
    {
        return DrivenVehicle.PlayerReplicationInfo.Team;
    }
    else
    {
        return none;
    }
}

native simulated function byte GetTeamNum()
{
}

event ShieldDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
}

event bool WillBeKilledByDamage(float DamageValue)
{
    if (float(Health) <= DamageValue)
    {
        return true;
    }
    return false;
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int actualDamage;
    local PlayerController PC;
    local Controller Killer;
    
    if (Role < 3 || Health <= 0)
    {
        return;
    }
    if (DamageType == none)
    {
        if (InstigatedBy == none)
        {
            WarnInternal("No damagetype for damage with no instigator");
        }
        else
        {
            WarnInternal("No damagetype for damage by " $ string(InstigatedBy.Pawn) $ " with weapon " $ string(InstigatedBy.Pawn.Weapon));
        }
        DamageType = class'DamageType';
    }
    Damage = Max(Damage, 0);
    if (Physics == 0 && DrivenVehicle == none)
    {
        SetMovementPhysics();
    }
    if (Physics == 1 && DamageType.default.default.bExtraMomentumZ)
    {
        Momentum.Z = FMax(Momentum.Z, 0.4 * VSize(Momentum));
    }
    Momentum = Momentum / Mass;
    if (DrivenVehicle != none)
    {
        DrivenVehicle.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    actualDamage = Damage;
    WorldInfo.Game.ReduceDamage(actualDamage, self, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    AdjustDamage(actualDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    TakeDamage(actualDamage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    Health -= actualDamage;
    if (WorldInfo.bNPCGodModeOn)
    {
        Health += actualDamage;
    }
    if (HitLocation == vect(0.0, 0.0, 0.0))
    {
        HitLocation = Location;
    }
    if (Health <= 0)
    {
        PC = PlayerController(Controller);
        if (PC != none)
        {
            PC.ClientPlayForceFeedbackWaveform(DamageType.default.default.KilledFFWaveform);
        }
        NotifyTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        Killer = SetKillInstigator(InstigatedBy, DamageType);
        TearOffMomentum = Momentum;
        Died(Killer, DamageType, HitLocation);
    }
    else
    {
        NotifyTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        if (DrivenVehicle != none)
        {
            DrivenVehicle.NotifyDriverTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        }
        if (InstigatedBy != none && InstigatedBy != Controller)
        {
            LastHitBy = InstigatedBy;
        }
    }
    PlayHit(float(actualDamage), InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    MakeNoise(1.0);
}

function Controller SetKillInstigator(Controller InstigatedBy, class<DamageType> DamageType)
{
    if (InstigatedBy != none && InstigatedBy != Controller)
    {
        return InstigatedBy;
    }
    else if (DamageType.default.default.bCausedByWorld && LastHitBy != none)
    {
        return LastHitBy;
    }
    return InstigatedBy;
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    if (Controller != none)
    {
        Controller.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    }
}

event bool TakeRadiusDamageOnBones(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, array<name> Bones)
{
    local int Idx;
    local TraceHitInfo HitInfo;
    local bool bResult;
    local float DamageScale, Dist;
    local Vector Dir, BoneLoc;
    
    PruneDamagedBoneList(Bones);
    for (Idx = 0; Idx < Bones.Length; Idx++)
    {
        HitInfo.BoneName = Bones[Idx];
        HitInfo.HitComponent = Mesh;
        BoneLoc = Mesh.GetBoneLocation(Bones[Idx]);
        Dir = BoneLoc - HurtOrigin;
        Dist = VSize(Dir);
        Dir = Normal(Dir);
        if (bFullDamage)
        {
            DamageScale = 1.0;
        }
        else
        {
            DamageScale = 1.0 - Dist / DamageRadius;
        }
        if (DamageScale > 0.0)
        {
            TakeDamage(int(DamageScale * BaseDamage), InstigatedBy, BoneLoc, DamageScale * Momentum * Dir, DamageType, HitInfo, DamageCauser);
        }
        bResult = true;
    }
    return bResult;
}

function PruneDamagedBoneList(out array<name> Bones)
{
}

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
    if (Health > 0 && Health < HealthMax)
    {
        Health = Min(HealthMax, Health + Amount);
        return true;
    }
    else
    {
        return false;
    }
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
}

function SetMovementPhysics()
{
    if (PhysicsVolume.bWaterVolume)
    {
        SetPhysics(3);
    }
    else if (Physics != 2)
    {
        SetPhysics(2);
    }
}

function Gasp()
{
}

simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
    local int Idx;
    local class<Inventory> InvClass;
    
    if (inAction.bClearExisting)
    {
        InvManager.DiscardInventory();
    }
    if (inAction.InventoryList.Length > 0)
    {
        for (Idx = 0; Idx < inAction.InventoryList.Length; Idx++)
        {
            InvClass = inAction.InventoryList[Idx];
            if (InvClass != none)
            {
                if (FindInventoryType(InvClass, false) == none)
                {
                    CreateInventory(InvClass);
                }
                continue;
            }
            inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
        }
    }
    else
    {
        inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
    }
}

function OnAssignController(SeqAct_AssignController inAction)
{
    if (inAction.ControllerClass != none)
    {
        if (Controller != none)
        {
            DetachFromController(true);
        }
        Controller = Spawn(inAction.ControllerClass);
        Controller.Possess(self, false);
        if (Controller.IsA('AIController'))
        {
            ControllerClass = class<AIController>(Controller.Class);
        }
    }
    else
    {
        WarnInternal("Assign controller w/o a class specified!");
    }
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
    if (Controller != none)
    {
        Controller.ReceivedNewEvent(Evt);
    }
    ReceivedNewEvent(Evt);
}

function SpawnDefaultController()
{
    if (Controller != none)
    {
        LogInternal("SpawnDefaultController" @ string(self) @ ", Controller != None" @ string(Controller));
        return;
    }
    if (ControllerClass != none)
    {
        Controller = Spawn(ControllerClass);
    }
    if (Controller != none)
    {
        Controller.Possess(self, false);
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    SplashTime = 0.0;
    SpawnTime = WorldInfo.TimeSeconds;
    EyeHeight = BaseEyeHeight;
    LogInternal(" Pawn " @ string(self) @ "post begin Play");
    if (WorldInfo.bStartup && Health > 0 && !bDontPossess)
    {
        SpawnDefaultController();
    }
    if (FacialAudioComp != none)
    {
        FacialAudioComp.__OnAudioFinished__Delegate = FaceFXAudioFinished;
    }
    if (Role == 3 && InvManager == none && InventoryManagerClass != none)
    {
        InvManager = Spawn(InventoryManagerClass, self);
        if (InvManager == none)
        {
            LogInternal("Warning! Couldn't spawn InventoryManager" @ string(InventoryManagerClass) @ "for" @ string(self) @ GetHumanReadableName());
        }
        else
        {
            InvManager.SetupFor(self);
        }
    }
    ClockWeaponFreezeLeftTime = -1.0;
    ClearPathStep();
}

simulated event PreBeginPlay()
{
    if (HealthMax == 0)
    {
        HealthMax = default.Health;
    }
    PreBeginPlay();
    Instigator = self;
    SetDesiredRotation(Rotation);
    EyeHeight = BaseEyeHeight;
}

simulated event Destroyed()
{
    DetachFromController();
    if (InvManager != none)
    {
        InvManager.Destroy();
    }
    if (WorldInfo.NetMode == 3)
    {
        return;
    }
    SetAnchor(none);
    Weapon = none;
    ClearPathStep();
    Destroyed();
}

function DetachFromController(optional bool bDestroyController)
{
    local Controller OldController;
    
    if (Controller != none && Controller.Pawn == self)
    {
        OldController = Controller;
        Controller.PawnDied(self);
        if (Controller != none)
        {
            Controller.UnPossess();
        }
        if (bDestroyController && OldController != none && !OldController.bDeleteMe && !OldController.bIsPlayer)
        {
            OldController.Destroy();
        }
        Controller = none;
    }
}

function CrushedBy(Pawn OtherPawn)
{
}

simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
    return bCanBeBaseForPawns;
}

singular event BaseChange()
{
    local DynamicSMActor Dyn;
    
    if (Pawn(Base) != none && DrivenVehicle == none || !DrivenVehicle.IsBasedOn(Base))
    {
        if (!Pawn(Base).CanBeBaseForPawn(self))
        {
            Pawn(Base).CrushedBy(self);
            JumpOffPawn();
        }
    }
    Dyn = DynamicSMActor(Base);
    if (Dyn != none && !Dyn.CanBasePawn(self))
    {
        JumpOffPawn();
    }
}

event StuckOnPawn(Pawn OtherPawn)
{
}

function JumpOffPawn()
{
    Velocity += (float(100) + CylinderComponent.CollisionRadius) * VRand();
    if (VSize2D(Velocity) > FMax(500.0, GroundSpeed))
    {
        Velocity = FMax(500.0, GroundSpeed) * Normal(Velocity);
    }
    Velocity.Z = 200.0 + CylinderComponent.CollisionHeight;
    SetPhysics(2);
}

function tryResolveEncroach()
{
}

function bool isInEncroachState()
{
    return false;
}

function gibbedBy(Actor Other)
{
    if (Role < 3)
    {
        return;
    }
    if (Pawn(Other) != none)
    {
        Died(Pawn(Other).Controller, class'DmgType_Telefragged', Location);
    }
    else
    {
        Died(none, class'DmgType_Telefragged', Location);
    }
}

event EncroachedBy(Actor Other)
{
    if (Pawn(Other) != none && Vehicle(Other) == none)
    {
        gibbedBy(Other);
    }
}

event bool EncroachingOn(Actor Other)
{
    if (Other.bWorldGeometry || Other.bBlocksTeleport)
    {
        return true;
    }
    if ((Controller == none || !Controller.bIsPlayer) && Pawn(Other) != none)
    {
        return true;
    }
    return false;
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    if (!InFreeCam())
    {
        if (Physics == 9)
        {
            NewRotation = OnLadder.WallDir;
        }
        else if (Physics == 1 || Physics == 2)
        {
            NewRotation.Pitch = 0;
        }
        SetRotation(NewRotation);
    }
}

final simulated event UpdatePawnRotation(Rotator NewRotation)
{
    FaceRotation(NewRotation, 0.0);
}

function ClientSetRotation(Rotator NewRotation)
{
    if (Controller != none)
    {
        Controller.ClientSetRotation(NewRotation);
    }
}

function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    if (Controller != none)
    {
        Controller.ClientSetLocation(NewLocation, NewRotation);
    }
}

simulated function ClientRestart()
{
    ZeroMovementVariables();
    SetBaseEyeheight();
}

function Restart()
{
}

function TakeFallingDamage()
{
    local float EffectiveSpeed;
    
    if (Velocity.Z < -0.5 * MaxFallSpeed)
    {
        if (Role == 3)
        {
            MakeNoise(1.0);
            if (Velocity.Z < float(-1) * MaxFallSpeed)
            {
                EffectiveSpeed = Velocity.Z;
                if (TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                if (EffectiveSpeed < float(-1) * MaxFallSpeed)
                {
                    TakeDamage(int(float(-100) * (EffectiveSpeed + MaxFallSpeed) / MaxFallSpeed), none, Location, vect(0.0, 0.0, 0.0), class'DmgType_Fell');
                }
            }
        }
    }
    else if (Velocity.Z < -1.4 * JumpZ)
    {
        MakeNoise(0.5);
    }
    else if (Velocity.Z < -0.8 * JumpZ)
    {
        MakeNoise(0.2);
    }
}

function KilledBy(Pawn EventInstigator)
{
    local Controller Killer;
    
    Health = 0;
    if (EventInstigator != none)
    {
        Killer = EventInstigator.Controller;
        LastHitBy = none;
    }
    Died(Killer, class'DmgType_Suicided', Location);
}

function AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    if (bIgnoreForces || NewVelocity == vect(0.0, 0.0, 0.0))
    {
        return;
    }
    if (Physics == 1 || (Physics == 9 || Physics == 8) && NewVelocity.Z > default.JumpZ)
    {
        SetPhysics(2);
    }
    if (Velocity.Z > default.JumpZ && NewVelocity.Z > float(0))
    {
        NewVelocity.Z *= 0.5;
    }
    Velocity += NewVelocity;
}

function HandleMomentum(Vector Momentum, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
}

function RestartPlayer()
{
}

simulated event StartCrouch(float HeightAdjust)
{
    EyeHeight += HeightAdjust;
    OldZ -= HeightAdjust;
    SetBaseEyeheight();
}

simulated event EndCrouch(float HeightAdjust)
{
    EyeHeight -= HeightAdjust;
    OldZ += HeightAdjust;
    SetBaseEyeheight();
}

function ShouldCrouch(bool bCrouch)
{
    bWantsToCrouch = bCrouch;
}

simulated function UnCrouch()
{
    if (bIsCrouched || bWantsToCrouch)
    {
        ShouldCrouch(false);
    }
}

simulated singular event OutsideWorldBounds()
{
    if (Role == 3 && PlayerController(Controller) == none)
    {
        Destroy();
    }
    else
    {
        if (Role == 3)
        {
            KilledBy(self);
        }
        SetPhysics(0);
        SetHidden(true);
        LifeSpan = FMin(LifeSpan, 1.0);
    }
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    if (Role == 3)
    {
        Health = -1;
        Died(none, dmgType, Location);
        if (dmgType == none)
        {
            SetPhysics(0);
            SetHidden(true);
            LifeSpan = FMin(LifeSpan, 1.0);
        }
    }
}

simulated event ModifyVelocity(float DeltaTime, Vector OldVelocity)
{
}

function JumpOutOfWater(Vector jumpDir)
{
    Falling();
    Velocity = jumpDir * WaterSpeed;
    Acceleration = jumpDir * AccelRate;
    Velocity.Z = OutofWaterZ;
    bUpAndOut = true;
}

function FinishedInterpolation()
{
    DropToGround();
}

event ClientMessage(coerce string S, optional name Type)
{
    if (PlayerController(Controller) != none)
    {
        PlayerController(Controller).ClientMessage(S, Type);
    }
}

function ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (PlayerController(Controller) != none)
    {
        PlayerController(Controller).ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

function HandlePickup(Inventory Inv)
{
    MakeNoise(0.2);
    if (Controller != none)
    {
        Controller.HandlePickup(Inv);
    }
}

function float AdjustedStrength()
{
    return 0.0;
}

function bool LineOfSightTo(Actor Other)
{
    return Controller != none && Controller.LineOfSightTo(Other);
}

function SetMoveTarget(Actor NewTarget)
{
    if (Controller != none)
    {
        Controller.MoveTarget = NewTarget;
    }
}

function Actor GetMoveTarget()
{
    if (Controller == none)
    {
        return none;
    }
    return Controller.MoveTarget;
}

function bool NearMoveTarget()
{
    if (Controller == none || Controller.MoveTarget == none)
    {
        return false;
    }
    return ReachedDestination(Controller.MoveTarget);
}

simulated function bool AffectedByHitEffects()
{
    return Controller == none || Controller.bAffectedByHitEffects;
}

function bool InGodMode()
{
    return Controller != none && Controller.bGodMode;
}

simulated function bool PawnCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    return CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
}

simulated function SetViewRotation(Rotator NewRotation)
{
    if (Controller != none)
    {
        Controller.SetRotation(NewRotation);
    }
    else
    {
        SetRotation(NewRotation);
    }
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    if (Controller == none || Role < 3)
    {
        return GetBaseAimRotation();
    }
    return Controller.GetAdjustedAimFor(W, StartFireLoc);
}

simulated event bool InFreeCam()
{
    local PlayerController PC;
    
    PC = PlayerController(Controller);
    return PC != none && PC.PlayerCamera != none && PC.PlayerCamera.CameraStyle == 'FreeCam' || PC.PlayerCamera.CameraStyle == 'FreeCam_Default';
}

simulated singular event Rotator GetBaseAimRotation()
{
    local Vector POVLoc;
    local Rotator POVRot;
    
    if (Controller != none && !InFreeCam())
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVRot;
    }
    POVRot = Rotation;
    if (POVRot.Pitch == 0)
    {
        POVRot.Pitch = int(RemoteViewPitch) << int(8);
    }
    return POVRot;
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector POVLoc;
    local Rotator POVRot;
    
    if (Controller != none)
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVLoc;
    }
    return GetPawnViewLocation();
}

native simulated event Vector GetPawnViewLocation()
{
}

native simulated event Rotator GetViewRotation()
{
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = GetPawnViewLocation();
    out_Rotation = GetViewRotation();
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    out_ViewRotation += out_DeltaRot;
    out_DeltaRot = rot(0, 0, 0);
    if (PlayerController(Controller) != none)
    {
        out_ViewRotation = PlayerController(Controller).LimitViewRotation(out_ViewRotation, ViewPitchMin, ViewPitchMax);
    }
}

simulated function bool IsFirstPerson()
{
    local PlayerController PC;
    
    PC = PlayerController(Controller);
    return PC != none && PC.UsingFirstPersonCamera();
}

simulated function bool WasPlayerPawn()
{
    return false;
}

native simulated function bool IsPlayerPawn()
{
}

native final simulated function bool IsLocallyControlled(optional Controller PawnController)
{
    PawnController;
}

native final simulated function bool IsHumanControlled(optional Controller PawnController)
{
    PawnController;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Canvas Canvas;
    local AnimTree AnimTreeRootNode;
    local int I;
    
    Canvas = HUD.Canvas;
    if (PlayerReplicationInfo == none)
    {
        Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    else
    {
        PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
    }
    DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Health " $ string(Health));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawText("Anchor " $ string(Anchor) $ " Serpentine Dist " $ string(SerpentineDist) $ " Time " $ string(SerpentineTime));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Physics'))
    {
        T = "Floor " $ string(Floor) $ " DesiredSpeed " $ string(DesiredSpeed) $ " Crouched " $ string(bIsCrouched);
        if (OnLadder != none || Physics == 9)
        {
            T = T $ " on ladder " $ string(OnLadder);
        }
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "Collision Component:" @ string(CollisionComponent);
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "bForceMaxAccel:" @ string(bForceMaxAccel);
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        if (Mesh != none)
        {
            T = "RootMotionMode:" @ string(Mesh.RootMotionMode) @ "RootMotionVelocity:" @ string(Mesh.RootMotionVelocity);
            Canvas.DrawText(T);
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Camera'))
    {
        Canvas.DrawText("EyeHeight " $ string(EyeHeight) $ " BaseEyeHeight " $ string(BaseEyeHeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (Controller == none)
    {
        Canvas.SetDrawColor(255, 0, 0);
        Canvas.DrawText("NO CONTROLLER");
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        HUD.PlayerOwner.DisplayDebug(HUD, out_YL, out_YPos);
    }
    else
    {
        Controller.DisplayDebug(HUD, out_YL, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Weapon'))
    {
        if (Weapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
        else
        {
            Weapon.DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Animation'))
    {
        if (Mesh != none && Mesh.Animations != none)
        {
            AnimTreeRootNode = AnimTree(Mesh.Animations);
            if (AnimTreeRootNode != none)
            {
                Canvas.DrawText("AnimGroups count:" @ string(AnimTreeRootNode.AnimGroups.Length));
                out_YPos += out_YL;
                Canvas.SetPos(4.0, out_YPos);
                for (I = 0; I < AnimTreeRootNode.AnimGroups.Length; I++)
                {
                    Canvas.DrawText(" GroupName:" @ string(AnimTreeRootNode.AnimGroups[I].GroupName) @ "NodeCount:" @ string(AnimTreeRootNode.AnimGroups[I].SeqNodes.Length) @ "RateScale:" @ string(AnimTreeRootNode.AnimGroups[I].RateScale));
                    out_YPos += out_YL;
                    Canvas.SetPos(4.0, out_YPos);
                }
            }
        }
    }
}

function ClimbLadder(LadderVolume L)
{
    OnLadder = L;
    SetRotation(OnLadder.WallDir);
    SetPhysics(9);
    if (IsHumanControlled())
    {
        Controller.GotoState('PlayerClimbing');
    }
}

function EndClimbLadder(LadderVolume OldLadder)
{
    if (Controller != none)
    {
        Controller.EndClimbLadder();
    }
    if (Physics == 9)
    {
        SetPhysics(2);
    }
}

simulated function bool CanSplash()
{
    if (WorldInfo.TimeSeconds - SplashTime > 0.15 && Physics == 2 || Physics == 4 && Abs(Velocity.Z) > float(100))
    {
        SplashTime = WorldInfo.TimeSeconds;
        return true;
    }
    return false;
}

event SetWalking(bool bNewIsWalking)
{
    if (bNewIsWalking != bIsWalking)
    {
        bIsWalking = bNewIsWalking;
    }
}

function float RangedAttackTime()
{
    return 0.0;
}

function bool RecommendLongRangedAttack()
{
    return false;
}

function bool CanGrabLadder()
{
    return bCanClimbLadders && Controller != none && Physics != 9 && Physics != 2 || Abs(Velocity.Z) <= JumpZ;
}

function DropToGround()
{
    bCollideWorld = true;
    if (Health > 0)
    {
        SetCollision(true, true);
        SetPhysics(2);
        if (IsHumanControlled())
        {
            Controller.GotoState(LandMovementState);
        }
    }
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    if (RequestedBy != none && RequestedBy.PlayerCamera != none && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'ThirdPerson';
}

function UnPossessed()
{
    bForceNetUpdate = true;
    if (DrivenVehicle != none)
    {
        NetUpdateFrequency = 5.0;
    }
    PlayerReplicationInfo = none;
    SetOwner(none);
    Controller = none;
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    if (!bVehicleTransition)
    {
        Controller.SetRotation(Rotation);
    }
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    Controller = C;
    NetPriority = 3.0;
    NetUpdateFrequency = 100.0;
    bForceNetUpdate = true;
    if (C.PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo = C.PlayerReplicationInfo;
    }
    UpdateControllerOnPossess(bVehicleTransition);
    SetOwner(Controller);
    EyeHeight = BaseEyeHeight;
    if (C.IsA('PlayerController'))
    {
        if (WorldInfo.NetMode != 0)
        {
            RemoteRole = 2;
        }
        if (Weapon != none)
        {
            Weapon.ClientWeaponSet(false);
        }
    }
    else
    {
        RemoteRole = default.RemoteRole;
    }
    if (Weapon != none)
    {
        Weapon.CacheAIController();
    }
}

simulated function NotifyTeamChanged()
{
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    MakeNoise(1.0);
}

simulated function string GetHumanReadableName()
{
    if (PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    return MenuName;
}

function bool NeedToTurn(Vector targ)
{
    local Vector LookDir, AimDir;
    
    LookDir = vector(Rotation);
    LookDir.Z = 0.0;
    LookDir = Normal(LookDir);
    AimDir = targ - Location;
    AimDir.Z = 0.0;
    AimDir = Normal(AimDir);
    return LookDir Dot AimDir < 0.93;
}

function bool IsFiring()
{
    if (Weapon != none)
    {
        return Weapon.IsFiring();
    }
    return false;
}

function bool HasRangedAttack()
{
    return Weapon != none;
}

function bool FireOnRelease()
{
    if (Weapon != none)
    {
        return Weapon.FireOnRelease();
    }
    return false;
}

function bool TooCloseToAttack(Actor Other)
{
    return false;
}

function bool CanAttack(Actor Other)
{
    if (Weapon == none)
    {
        return false;
    }
    return Weapon.CanAttack(Other);
}

function byte ChooseFireMode()
{
    return 0;
}

function bool BotFire(bool bFinished)
{
    StartFire(ChooseFireMode());
    return true;
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
    ShotCount = 0;
    if (InWeapon != none)
    {
        InWeapon.StopFireEffects(GetWeaponFiringMode(InWeapon));
    }
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
    ShotCount++;
    if (InWeapon != none)
    {
        InWeapon.PlayFireEffects(GetWeaponFiringMode(InWeapon), HitLocation);
    }
}

simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
    if (!IsZero(InFlashLocation))
    {
        WeaponFired(InWeapon, bViaReplication, InFlashLocation);
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
}

final function Internal_ClearFlashLocation(Weapon InWeapon, out Vector out_FlashLocation)
{
    if (!IsZero(out_FlashLocation))
    {
        bForceNetUpdate = true;
        out_FlashLocation = vect(0.0, 0.0, 0.0);
        FlashLocationUpdated(InWeapon, out_FlashLocation, false);
    }
}

function ClearFlashLocation(Weapon InWeapon)
{
    Internal_ClearFlashLocation(InWeapon, FlashLocation);
}

final simulated function Internal_SetFlashLocation(Weapon InWeapon, out Vector out_FlashLocation, byte InFiringMode, Vector NewLoc)
{
    if (NewLoc == LastFiringFlashLocation)
    {
        NewLoc += vect(0.0, 0.0, 1.0);
    }
    if (NewLoc == vect(0.0, 0.0, 0.0))
    {
        NewLoc = vect(0.0, 0.0, 1.0);
    }
    bForceNetUpdate = true;
    out_FlashLocation = NewLoc;
    LastFiringFlashLocation = NewLoc;
    SetFiringMode(InWeapon, InFiringMode);
    FlashLocationUpdated(InWeapon, out_FlashLocation, false);
}

simulated function SetFlashLocation(Weapon InWeapon, byte InFiringMode, Vector NewLoc)
{
    Internal_SetFlashLocation(InWeapon, FlashLocation, InFiringMode, NewLoc);
}

final simulated function Internal_ClearFlashCount(Weapon InWeapon, out byte out_FlashCountVar)
{
    if (out_FlashCountVar != 0)
    {
        bForceNetUpdate = true;
        out_FlashCountVar = 0;
        FlashCountUpdated(InWeapon, out_FlashCountVar, false);
    }
}

simulated function ClearFlashCount(Weapon InWeapon)
{
    Internal_ClearFlashCount(InWeapon, FlashCount);
}

simulated function FlashCountUpdated(Weapon InWeapon, byte InFlashCount, bool bViaReplication)
{
    if (InFlashCount > 0)
    {
        WeaponFired(InWeapon, bViaReplication);
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
}

final simulated function Internal_IncrementFlashCount(Weapon InWeapon, byte InFiringMode, out byte out_FlashCountVar)
{
    bForceNetUpdate = true;
    out_FlashCountVar++;
    if (out_FlashCountVar == 0)
    {
        out_FlashCountVar += 2;
    }
    SetFiringMode(InWeapon, InFiringMode);
    FlashCountUpdated(InWeapon, out_FlashCountVar, false);
}

simulated function IncrementFlashCount(Weapon InWeapon, byte InFiringMode)
{
    Internal_IncrementFlashCount(InWeapon, InFiringMode, FlashCount);
}

simulated function FiringModeUpdated(Weapon InWeapon, byte InFiringMode, bool bViaReplication)
{
    if (InWeapon != none)
    {
        InWeapon.FireModeUpdated(InFiringMode, bViaReplication);
    }
}

final simulated function Internal_SetFiringMode(Weapon InWeapon, byte InFiringMode, out byte out_FiringModeVar)
{
    if (out_FiringModeVar != InFiringMode)
    {
        out_FiringModeVar = InFiringMode;
        bForceNetUpdate = true;
        FiringModeUpdated(InWeapon, out_FiringModeVar, false);
    }
}

simulated function SetFiringMode(Weapon InWeapon, byte InFiringMode)
{
    Internal_SetFiringMode(InWeapon, InFiringMode, FiringMode);
}

simulated function byte GetWeaponFiringMode(Weapon InWeapon)
{
    return FiringMode;
}

simulated function StopFire(byte FireModeNum)
{
    if (InvManager != none)
    {
        InvManager.StopFire(FireModeNum);
    }
}

simulated function StartFire(byte FireModeNum)
{
    if (bNoWeaponFiring)
    {
        return;
    }
    if (InvManager != none)
    {
        InvManager.StartFire(FireModeNum);
    }
}

function bool StopFiring()
{
    if (Weapon != none)
    {
        Weapon.StopFire(Weapon.CurrentFireMode);
    }
    return true;
}

function Reset()
{
    if (Controller == none || Controller.bIsPlayer)
    {
        DetachFromController();
        Destroy();
    }
    else
    {
        Reset();
    }
}

function PlayerChangedTeam()
{
    Died(none, class'DamageType', Location);
}

simulated function SetBaseEyeheight()
{
    if (!bIsCrouched)
    {
        BaseEyeHeight = default.BaseEyeHeight;
    }
    else
    {
        BaseEyeHeight = FMin(0.8 * CrouchHeight, CrouchHeight - float(10));
    }
}

event bool SpecialMoveThruEdge(ENavMeshEdgeType Type, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem)
{
}

function bool SpecialMoveTo(NavigationPoint Start, NavigationPoint End, Actor Next)
{
}

native function PlayDeathRagdoll()
{
}

native function bool TermRagdoll()
{
}

native function bool InitRagdoll()
{
}

simulated function bool IsValidEnemy()
{
    return true;
}

function int SpecialCostForPath(ReachSpec Path)
{
    return NavigationPoint(Path.End.Actor).Cost;
}

native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight)
{
    CollisionRadius;
    CollisionHeight;
}

native final function bool ReachedDesiredRotation()
{
}

native function SetPushesRigidBodies(bool NewPush)
{
    NewPush;
}

native function ForceCrouch()
{
}

native function bool ReachedPoint(Vector Point, Actor NewAnchor)
{
    Point;
    NewAnchor;
}

native function bool ReachedDestination(Actor Goal)
{
    Goal;
}

native function NavigationPoint GetBestAnchor(Actor TestActor, Vector TestLocation, bool bStartPoint, bool bOnlyCheckVisible, out float out_Dist)
{
    TestActor;
    TestLocation;
    bStartPoint;
    bOnlyCheckVisible;
    out_Dist;
}

native function SetAnchor(NavigationPoint NewAnchor)
{
    NewAnchor;
}

native final function SetRemoteViewPitch(int NewRemoteViewPitch)
{
    NewRemoteViewPitch;
}

native function bool IsInvisible()
{
}

native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy)
{
    PRI;
    bNoPRIisEnemy;
}

native function bool IsValidTargetFor(const Controller C)
{
    C;
}

native function float GetFallDuration()
{
}

native function bool SuggestJumpVelocity(out Vector JumpVelocity, Vector Destination, Vector Start)
{
    JumpVelocity;
    Destination;
    Start;
}

native final function bool ValidAnchor()
{
}

native final function Vector AdjustDestination(Actor GoalActor, optional Vector Dest)
{
    GoalActor;
    Dest;
}

native final simulated function bool IsAliveAndWell()
{
}

simulated event ReplicatedEvent(name VarName)
{
    ReplicatedEvent(VarName);
    if (VarName == 'FlashCount')
    {
        FlashCountUpdated(Weapon, FlashCount, true);
    }
    else if (VarName == 'FlashLocation')
    {
        FlashLocationUpdated(Weapon, FlashLocation, true);
    }
    else if (VarName == 'FiringMode')
    {
        FiringModeUpdated(Weapon, FiringMode, true);
    }
    else if (VarName == 'DrivenVehicle')
    {
        if (DrivenVehicle != none)
        {
            NotifyTeamChanged();
        }
    }
    else if (VarName == 'PlayerReplicationInfo')
    {
        NotifyTeamChanged();
    }
    else if (VarName == 'Controller')
    {
        if (Controller != none && Controller.Pawn == none)
        {
            Controller.Pawn = self;
            if (PlayerController(Controller) != none && PlayerController(Controller).ViewTarget == Controller)
            {
                PlayerController(Controller).SetViewTarget(self);
            }
        }
    }
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
    MAT_SetSkelControlScale(SkelControlName, Scale);
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    MAT_SetMorphWeight(MorphNodeName, MorphWeight);
}

event FaceFXAsset GetActorFaceFXAsset()
{
    return Mesh.SkeletalMesh.FaceFXAsset;
}

simulated function FaceFXAudioFinished(AudioComponent AC)
{
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
}

simulated function bool CanActorPlayFaceFXAnim()
{
    return true;
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return Mesh != none && Mesh.IsPlayingFaceFXAnim();
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
}

event StopActorFaceFXAnim()
{
    Mesh.StopFaceFXAnim();
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}

event MAT_FinishAIGroup()
{
}

event MAT_BeginAIGroup(Vector StartLoc, Rotator StartRot)
{
    SetLocation(StartLoc);
    SetRotation(StartRot);
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    InterpolationFinished(InterpAction);
}

native function float GetShieldKnockBackTimeScale(int ShieldIndex)
{
    ShieldIndex;
}

native function float GetShieldKnockBackDistScale(int ShieldIndex)
{
    ShieldIndex;
}

native function Actor GetCurrentAttackTargetActor()
{
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    local InterpGroupAI MyGroup;
    
    if (InterpGroupInstAI(GroupInst) != none)
    {
        MyGroup = InterpGroupAI(GroupInst.Group);
        if (MyGroup != none && MyGroup.StageMarkActor != none)
        {
            SetLocation(MyGroup.StageMarkActor.Location);
            SetRotation(MyGroup.StageMarkActor.Rotation);
        }
    }
    InterpolationStarted(InterpAction, GroupInst);
}

native function MAT_SetSkelControlScale(name SkelControlName, float Scale)
{
    SkelControlName;
    Scale;
}

native function MAT_SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    MorphNodeName;
    MorphWeight;
}

native function MAT_AutoReduceSlotAnimWeight(array<AnimSlotInfo> SlotInfos, float RevertTime)
{
    SlotInfos;
    RevertTime;
}

native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos)
{
    SlotInfos;
}

native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    SlotName;
    ChannelIndex;
    InAnimSeqName;
    InPosition;
    bFireNotifies;
    bLooping;
    RootMotionLevel;
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, RootMotionLevel);
}

native function MAT_FinishAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}

native function MAT_BeginAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    MAT_BeginAnimControl(InInterpGroup);
}

simulated event bool RestoreAnimSetsToDefault()
{
    Mesh.AnimSets = default.Mesh.AnimSets;
    return true;
}

simulated event AnimSetListUpdated()
{
}

native final simulated function AddAnimSets(out const array<AnimSet> CustomAnimSets)
{
    CustomAnimSets;
}

simulated event BuildScriptAnimSetList()
{
}

native final simulated function UpdateAnimSetList()
{
}

simulated function ClearAnimNodes()
{
    SlotNodes.Length = 0;
}

simulated function CacheAnimNodes()
{
    local AnimNodeSlot SlotNode;
    
    foreach Mesh.AllAnimNodes(class'AnimNodeSlot', SlotNode)
    {
        SlotNodes[SlotNodes.Length] = SlotNode;
    }
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    PostInitAnimTree(SkelComp);
    ClearAnimNodes();
    CacheAnimNodes();
}

simulated event TriggerPushDown()
{
}

simulated event bool IsInContextActorRange()
{
}

native simulated function bool IsDoingASpecialMove()
{
}

native function Vector GetDefaultMeshTranslation()
{
}

native simulated function SetMeshTranslationOffset(Vector NewOffset, optional bool bForce)
{
    NewOffset;
    bForce;
}

native function bool IsLineCheckPhysMatResult()
{
}

native final function bool IsDesiredRotationLocked()
{
}

native final function bool IsDesiredRotationInUse()
{
}

native final function CheckDesiredRotation()
{
}

native final function ResetDesiredRotation()
{
}

native final function LockDesiredRotation(bool Lock, optional bool InUnlockWhenReached = false)
{
    Lock;
    InUnlockWhenReached;
}

native final function bool SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = false, optional bool InUnlockWhenReached = false, optional float InterpolationTime = -1.0)
{
    TargetDesiredRotation;
    InLockDesiredRotation;
    InUnlockWhenReached;
    InterpolationTime;
}

native final function bool PickWallAdjust(Vector WallHitNormal, Actor HitActor)
{
    WallHitNormal;
    HitActor;
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
        foreach TouchingActors(class'Actor', A)
        {
            if (A.FindEventsOfClass(class'SeqEvent_Touch', TouchEvents))
            {
                for (I = 0; I < TouchEvents.Length; I++)
                {
                    SeqEvent_Touch(TouchEvents[I]).NotifyTouchingPawnDied(self);
                }
                TouchEvents.Length = 0;
            }
        }
        foreach BasedActors(class'Actor', A)
        {
            A.PawnBaseDied();
        }
    }
    
    event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        SetPhysics(2);
        if (Physics == 0 && Momentum.Z < float(0))
        {
            Momentum.Z *= float(-1);
        }
        Velocity += float(3) * Momentum / (Mass + float(200));
        if (DamageType == none)
        {
            DamageType = class'DamageType';
        }
        Health -= Damage;
    }
    
    event Timer()
    {
        if (!PlayerCanSeeMe())
        {
            Destroy();
        }
        else
        {
            SetTimer(2.0, false);
        }
    }
    
    simulated singular event OutsideWorldBounds()
    {
        SetPhysics(0);
        SetHidden(true);
        LifeSpan = FMin(LifeSpan, 1.0);
    }
    
    function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
    {
    }
    
    event Landed(Vector HitNormal, Actor FloorActor)
    {
    }
    
    singular event BaseChange()
    {
    }
    
    simulated function PlayNextAnimation()
    {
    }
    
    simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
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
    
    Begin:
    Sleep(0.2);
    PlayDyingSound();
    Stop;
}

defaultproperties
{
    MaxStepHeight=35.0
    MaxJumpHeight=96.0
    WalkableFloorZ=0.7
    LedgeCheckThreshold=4.0
    bJumpCapable=True
    bCanJump=True
    bCanWalk=True
    bAllowLedgeOverhang=True
    bSimulateGravity=True
    bLOSHearing=True
    bLimitFallAccel=True
    bReplicateHealthToAll=True
    CrouchHeight=40.0
    CrouchRadius=34.0
    NonPreferredVehiclePathMultiplier=1.0
    XPMaxValue=1000
    DesiredSpeed=1.0
    MaxDesiredSpeed=1.0
    HearingThreshold=2800.0
    SightRadius=5000.0
    AvgPhysicsTime=0.1
    Mass=100.0
    MaxPitchLimit=3072
    GroundSpeed=600.0
    WaterSpeed=300.0
    AirSpeed=600.0
    LadderSpeed=200.0
    AccelRate=2048.0
    JumpZ=420.0
    OutofWaterZ=420.0
    MaxOutOfWaterStepHeight=40.0
    AirControl=0.05
    WalkingPct=0.5
    CrouchedPct=0.5
    MaxFallSpeed=1200.0
    AIMaxFallSpeedFactor=1.0
    BaseEyeHeight=64.0
    EyeHeight=54.0
    Health=100
    noise1time=-10.0
    noise2time=-10.0
    SoundDampening=1.0
    DamageScaling=1.0
    ControllerClass="AIController"
    LandMovementState="PlayerWalking"
    WaterMovementState="PlayerSwimming"
    CylinderComponent="Default__Pawn.CollisionCylinder"
    RBPushRadius=10.0
    RBPushStrength=50.0
    VehicleCheckRadius=150.0
    ViewPitchMin=-16384.0
    ViewPitchMax=16383.0
    AllowedYawError=2000
    InventoryManagerClass="InventoryManager"
    RootMotionInterpRate=1.0
    RefBoxBlendingMaxLineCheckDist=1000.0
    RootRotationFactor=1.0
    LedgeHeightToAvoidFallingWhenCombat=200.0
    ZAxisMovementMaxLineCheckDist=1000.0
    ZAxisMovementAdditionalRadius=30.0
    AbsKnockBackTotalTime=-1.0
    FootOffsetBlendingSpeed=0.2
    ThresholdHeightToCancelPushDownByIK=50.0
    bUpdateSimulatedPosition=True
    bCanBeDamaged=True
    bShouldBaseAtStartup=True
    bCanTeleport=True
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bProjTarget=True
    Components(0)="Default__Pawn.Sprite"
    Components(1)="Default__Pawn.CollisionCylinder"
    Components(2)="Default__Pawn.Arrow"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_BlockAll"
    NetPriority=2.0
    CollisionComponent="Default__Pawn.CollisionCylinder"
    RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
}
