class Controller extends Actor
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation)
    implements(Interface_NavigationHandle);

const LATENT_MOVETOWARD = 503;

struct native VisiblePortalInfo
{
    var Actor Source;
    var Actor Destination;
};

var const native noexport Pointer VfTable_IInterface_NavigationHandle;
var repnotify Pawn Pawn;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var const int PlayerNum;
var const Controller NextController;
var bool bIsPlayer;
var bool bGodMode;
var bool bAffectedByHitEffects;
var bool bSoaking;
var bool bSlowerZAcquire;
var bool bNotifyPostLanded;
var bool bNotifyApex;
var bool bAdvancedTactics;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var bool bForceStrafe;
var const bool bLOSflag;
var bool bSkipExtraLOSChecks;
var bool bNotifyFallingHitWall;
var bool bPreciseDestination;
var bool bSeeFriendly;
var bool bUsingPathLanes;
var input byte bFire;
var input byte bAltFire;
var float MinHitWall;
var class<NavigationHandle> NavigationHandleClass;
var NavigationHandle NavigationHandle;
var float MoveTimer;
var Actor MoveTarget;
var BasedPosition DestinationPosition;
var BasedPosition FocalPosition;
var Actor Focus;
var Actor GoalList[4];
var BasedPosition AdjustPosition;
var NavigationPoint StartSpot;
var array<NavigationPoint> RouteCache;
var ReachSpec CurrentPath;
var ReachSpec NextRoutePath;
var Vector CurrentPathDir;
var Actor RouteGoal;
var float RouteDist;
var float LastRouteFind;
var InterpActor PendingMover;
var Actor FailedMoveTarget;
var int MoveFailureCount;
var float GroundPitchTime;
var Vector ViewX;
var Vector ViewY;
var Vector ViewZ;
var Pawn ShotTarget;
var const Actor LastFailedReach;
var const float FailedReachTime;
var const Vector FailedReachLocation;
var float SightCounter;
var float SightCounterInterval;
var float InUseNodeCostMultiplier;
var int HighJumpNodeCostModifier;
var float MaxMoveTowardPawnTargetTime;
var Pawn Enemy;
var array<VisiblePortalInfo> VisiblePortals;
var float LaneOffset;
var const Rotator OldBasedRotation;
var Vector NavMeshPath_SearchExtent_Modifier;

replication
{
    if (bNetDirty && Role == 3)
        Pawn, PlayerReplicationInfo;
}

function RemoveSonarDetectedActor(Actor DesiredActor)
{
}

function AddSonarDetectedActor(Actor DesiredActor)
{
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    if (Pawn != none)
    {
        Pawn.InterpolationFinished(InterpAction);
    }
    InterpolationFinished(InterpAction);
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    if (Pawn != none)
    {
        Pawn.InterpolationStarted(InterpAction, GroupInst);
    }
    InterpolationStarted(InterpAction, GroupInst);
}

function float GetDestinationOffset()
{
}

function InitNavigationHandle()
{
    if (NavigationHandleClass != none)
    {
        NavigationHandle = new(self) NavigationHandleClass;
    }
}

function ReadyForLift()
{
}

function SendMessage(PlayerReplicationInfo Recipient, name MessageType, float Wait, optional class<DamageType> DamageType)
{
}

event CurrentLevelUnloaded()
{
}

function Actor GetRouteGoalAfter(int RouteIdx)
{
    if (RouteIdx + 1 < RouteCache.Length)
    {
        return RouteCache[RouteIdx + 1];
    }
    return RouteGoal;
}

event bool IsInCombat(optional bool bForceCheck)
{
}

event bool IsSpectating()
{
    return false;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Pawn != none)
    {
        Pawn.OnToggleHidden(Action);
    }
}

function NotifyAddInventory(Inventory NewItem)
{
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
    if (Pawn != none)
    {
        Pawn.OnModifyHealth(Action);
    }
}

simulated function bool NotifyCoverClaimViolation(Controller NewClaim, CoverLink Link, int SlotIdx)
{
}

simulated event NotifyCoverAdjusted()
{
}

simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx)
{
}

simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
    if (Pawn != none)
    {
        Pawn.OnSetVelocity(Action);
    }
    else
    {
        OnSetVelocity(Action);
    }
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    if (Pawn != none)
    {
        Pawn.OnSetPhysics(Action);
    }
    else
    {
        OnSetPhysics(Action);
    }
}

function OnToggleAffectedByHitEffects(SeqAct_ToggleAffectedByHitEffects inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bAffectedByHitEffects = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bAffectedByHitEffects = false;
    }
    else
    {
        bAffectedByHitEffects = !bAffectedByHitEffects;
    }
}

function SetGodMode(bool GodModeSet)
{
    bGodMode = GodModeSet;
}

function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bGodMode = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bGodMode = false;
    }
    else
    {
        bGodMode = !bGodMode;
    }
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    if (Action != none)
    {
        if (Pawn != none)
        {
            Pawn.OnTeleport(Action);
        }
        else
        {
            OnTeleport(Action);
        }
    }
}

function bool IsDead()
{
}

simulated function string GetHumanReadableName()
{
    if (PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    else
    {
        return GetItemName(string(self));
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    if (Pawn == none)
    {
        if (PlayerReplicationInfo == none)
        {
            Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);
        }
        else
        {
            PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        DisplayDebug(HUD, out_YL, out_YPos);
        return;
    }
    Canvas.SetDrawColor(255, 0, 0);
    Canvas.DrawText("CONTROLLER " $ GetItemName(string(self)) $ " Pawn " $ GetItemName(string(Pawn)));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText(" bPreciseDestination:" @ string(bPreciseDestination));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        if (Enemy != none)
        {
            Canvas.DrawText("     STATE: " $ string(GetStateName()) $ " Enemy " $ Enemy.GetHumanReadableName(), false);
        }
        else
        {
            Canvas.DrawText("     STATE: " $ string(GetStateName()) $ " NO Enemy ", false);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}

native final function StopLatentExecution()
{
}

native final function bool InLatentExecution(int LatentActionNumber)
{
    LatentActionNumber;
}

event ReachedPreciseDestination()
{
}

event NotifyMissedJump()
{
}

event NotifyJumpApex()
{
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
}

event NotifyFallingHitWall(Vector HitNormal, Actor Wall)
{
}

event bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
}

event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
{
}

event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
}

simulated function bool LandingShake()
{
    return false;
}

simulated function bool IsAimingAt(Actor ATarget, float Epsilon)
{
    local Vector Loc;
    local Rotator Rot;
    
    GetPlayerViewPoint(Loc, Rot);
    return Normal(ATarget.Location - Loc) Dot vector(Rot) >= Epsilon;
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    if (Pawn != none)
    {
        Pawn.GetActorEyesViewPoint(out_Location, out_Rotation);
    }
    else
    {
        out_Location = Location;
        out_Rotation = Rotation;
    }
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = Location;
    out_Rotation = Rotation;
}

event bool HandlePathObstruction(Actor BlockedBy)
{
}

function UnderLift(LiftCenter Lift)
{
}

event bool MoverFinished()
{
    if (Pawn == none || PendingMover.MyMarker == none || PendingMover.MyMarker.ProceedWithMove(Pawn))
    {
        PendingMover = none;
        bPreparingMove = false;
        return true;
    }
    return false;
}

function WaitForMover(InterpActor M)
{
    PendingMover = M;
    M.bMonitorMover = true;
    bPreparingMove = true;
    Pawn.Acceleration = vect(0.0, 0.0, 0.0);
}

event bool AllowDetourTo(NavigationPoint N)
{
    return true;
}

event MayFall(bool bFloor, Vector FloorNormal)
{
}

native function EndClimbLadder()
{
}

event LongFall()
{
}

native(527) final latent function WaitForLanding(optional float waitDuration)
{
    waitDuration;
}

native(526) final function bool PickWallAdjust(Vector HitNormal)
{
    HitNormal;
}

event MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget)
{
}

native(520) final function bool ActorReachable(Actor anActor)
{
    anActor;
}

native(521) final function bool PointReachable(Vector aPoint)
{
    aPoint;
}

native final function Actor FindPathToIntercept(Pawn P, Actor InRouteGoal, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial)
{
    P;
    InRouteGoal;
    bWeightDetours;
    MaxPathLength;
    bReturnPartial;
}

native(525) final function NavigationPoint FindRandomDest()
{
}

native final function Actor FindPathTowardNearest(class<NavigationPoint> GoalClass, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial)
{
    GoalClass;
    bWeightDetours;
    MaxPathLength;
    bReturnPartial;
}

native(517) final function Actor FindPathToward(Actor anActor, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial)
{
    anActor;
    bWeightDetours;
    MaxPathLength;
    bReturnPartial;
}

native(518) final function Actor FindPathTo(Vector aPoint, optional int MaxPathLength, optional bool bReturnPartial)
{
    aPoint;
    MaxPathLength;
    bReturnPartial;
}

native(508) final latent function FinishRotation()
{
}

event SetupSpecialPathAbilities()
{
}

native(502) final latent function MoveToward(Actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk = Pawn != none ? Pawn.bIsWalking : false)
{
    NewTarget;
    ViewFocus;
    DestinationOffset;
    bUseStrafing;
    bShouldWalk;
}

native final latent function MoveToDirectNonPathPos(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = Pawn != none ? Pawn.bIsWalking : false)
{
    NewDestination;
    ViewFocus;
    DestinationOffset;
    bShouldWalk;
}

native(500) final latent function MoveTo(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = Pawn != none ? Pawn.bIsWalking : false)
{
    NewDestination;
    ViewFocus;
    DestinationOffset;
    bShouldWalk;
}

event EnemyNotVisible()
{
}

event SeeMonster(Pawn Seen)
{
}

event SeePlayer(Pawn Seen)
{
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
}

native(531) final function Pawn PickTarget(class<Pawn> TargetClass, out float bestAim, out float bestDist, Vector FireDir, Vector projStart, float MaxRange)
{
    TargetClass;
    bestAim;
    bestDist;
    FireDir;
    projStart;
    MaxRange;
}

native(537) final function bool CanSeeByPoints(Vector ViewLocation, Vector TestLocation, Rotator ViewRotation)
{
    ViewLocation;
    TestLocation;
    ViewRotation;
}

native(533) final function bool CanSee(Pawn Other)
{
    Other;
}

native(514) final function bool LineOfSightTo(Actor Other, optional Vector chkLocation, optional bool bTryAlternateTargetLoc)
{
    Other;
    chkLocation;
    bTryAlternateTargetLoc;
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
}

reliable client simulated function bool ClientSetWeapon(class<Weapon> WeaponClass)
{
    local Inventory Inv;
    
    if (Pawn == none)
    {
        return false;
    }
    Inv = Pawn.FindInventoryType(WeaponClass);
    if (Weapon(Inv) != none)
    {
        Pawn.SetActiveWeapon(Weapon(Inv));
        return true;
    }
    return false;
}

reliable client simulated function ClientSwitchToBestWeapon(optional bool bForceNewWeapon)
{
    SwitchToBestWeapon(bForceNewWeapon);
}

exec function SwitchToBestWeapon(optional bool bForceNewWeapon)
{
    if (Pawn == none || Pawn.InvManager == none)
    {
        return;
    }
    Pawn.InvManager.SwitchToBestWeapon(bForceNewWeapon);
}

function ReceiveProjectileWarning(Projectile Proj)
{
}

function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
}

function InstantWarnTarget(Actor InTarget, Weapon FiredWeapon, Vector FireDir)
{
    local Pawn P;
    
    P = Pawn(InTarget);
    if (P != none && P.Controller != none)
    {
        P.Controller.ReceiveWarning(Pawn, -1.0, FireDir);
    }
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    if (Pawn != none)
    {
        return Pawn.GetBaseAimRotation();
    }
    return Rotation;
}

function HandlePickup(Inventory Inv)
{
}

function RoundHasEnded(optional Actor EndRoundFocus)
{
    GotoState('RoundEnded');
}

event StopFiring()
{
    bFire = 0;
    if (Pawn != none)
    {
        Pawn.StopFiring();
    }
}

function bool FireWeaponAt(Actor inActor)
{
}

event float RatePickup(Actor PickupHolder, class<Inventory> inPickup)
{
}

function WarnProjExplode(Projectile Proj)
{
}

function NotifyProjLanded(Projectile Proj)
{
    if (Proj != none && Pawn != none)
    {
        Pawn.TriggerEventClass(class'SeqEvent_ProjectileLanded', Proj);
    }
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    if (Pawn != none)
    {
        Pawn.TriggerEventClass(class'SeqEvent_SeeDeath', KilledPawn);
    }
    if (Enemy == KilledPawn)
    {
        Enemy = none;
    }
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    GotoState('RoundEnded');
}

function SetCharacter(string inCharacter)
{
}

function ServerGivePawn()
{
}

reliable server function ServerRestartPlayer()
{
    if (WorldInfo.NetMode != 3 && Pawn != none)
    {
        ServerGivePawn();
    }
}

native simulated function byte GetTeamNum()
{
}

function InitPlayerReplicationInfo()
{
    PlayerReplicationInfo = Spawn(WorldInfo.Game.PlayerReplicationInfoClass, self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
    if (PlayerReplicationInfo.PlayerName == "")
    {
        PlayerReplicationInfo.PlayerName = class'GameInfo'.default.default.DefaultPlayerName;
    }
}

function NotifyBeginDying(Pawn inPawn)
{
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
}

function EnemyJustTeleported()
{
    LineOfSightTo(Enemy);
}

native final function bool BeyondFogDistance(Vector ViewPoint, Vector OtherPoint)
{
    ViewPoint;
    OtherPoint;
}

function Restart(bool bVehicleTransition)
{
    Pawn.Restart();
    if (!bVehicleTransition)
    {
        Enemy = none;
    }
    if (bVehicleTransition == false && Pawn.InvManager != none)
    {
        Pawn.InvManager.UpdateController();
    }
}

function CleanupPRI()
{
    PlayerReplicationInfo.Destroy();
    PlayerReplicationInfo = none;
}

event Destroyed()
{
    if (Role == 3)
    {
        if (bIsPlayer && WorldInfo.Game != none)
        {
            WorldInfo.Game.Logout(self);
        }
        if (PlayerReplicationInfo != none)
        {
            if (!PlayerReplicationInfo.bOnlySpectator && PlayerReplicationInfo.Team != none)
            {
                PlayerReplicationInfo.Team.RemoveFromTeam(self);
            }
            CleanupPRI();
        }
    }
    Destroyed();
}

event NotifyPostLanded()
{
}

function bool GamePlayEndedState()
{
    return false;
}

function PawnDied(Pawn inPawn)
{
    local int Idx;
    
    if (inPawn != Pawn)
    {
        return;
    }
    TriggerEventClass(class'SeqEvent_Death', self);
    for (Idx = 0; Idx < LatentActions.Length; Idx++)
    {
        if (LatentActions[Idx] != none)
        {
            LatentActions[Idx].AbortFor(self);
        }
    }
    LatentActions.Length = 0;
    if (Pawn != none)
    {
        SetLocation(Pawn.Location);
        Pawn.UnPossessed();
    }
    Pawn = none;
    if (bIsPlayer)
    {
        if (!GamePlayEndedState())
        {
            GotoState('Dead');
        }
    }
    else
    {
        Destroy();
    }
}

event UnPossess()
{
    if (Pawn != none)
    {
        Pawn.UnPossessed();
        Pawn = none;
    }
}

function UpdateSex()
{
    if (Vehicle(Pawn) != none && Vehicle(Pawn).Driver != none)
    {
        PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;
    }
    else
    {
        PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
    }
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    if (inPawn.Controller != none)
    {
        inPawn.Controller.UnPossess();
    }
    inPawn.PossessedBy(self, bVehicleTransition);
    Pawn = inPawn;
    if (PlayerReplicationInfo != none)
    {
        UpdateSex();
    }
    SetFocalPoint(Pawn.Location + float(512) * vector(Pawn.Rotation), true);
    Restart(bVehicleTransition);
    if (Pawn.Weapon == none)
    {
        ClientSwitchToBestWeapon();
    }
}

function OnPossess(SeqAct_Possess inAction)
{
    local Pawn OldPawn;
    local Vehicle V;
    
    V = Vehicle(Pawn);
    if (inAction.bTryToLeaveVehicle && V != none)
    {
        V.DriverLeave(true);
    }
    if (inAction.PawnToPossess != none)
    {
        V = Vehicle(inAction.PawnToPossess);
        if (Pawn != none && V != none)
        {
            V.TryToDrive(Pawn);
        }
        else
        {
            OldPawn = Pawn;
            UnPossess();
            Possess(inAction.PawnToPossess, false);
            if (inAction.bKillOldPawn && OldPawn != none)
            {
                OldPawn.Destroy();
            }
        }
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'PlayerReplicationInfo')
    {
        if (PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.ClientInitialize(self);
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

reliable client simulated function ClientSetRotation(Rotator NewRotation, optional bool bResetCamera)
{
    SetRotation(NewRotation);
    if (Pawn != none)
    {
        NewRotation.Pitch = 0;
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation);
    }
}

reliable client simulated function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    SetRotation(NewRotation);
    if (Pawn != none)
    {
        if (Rotation.Pitch > Pawn.MaxPitchLimit && Rotation.Pitch < 65536 - Pawn.MaxPitchLimit)
        {
            if (Rotation.Pitch < 32768)
            {
                NewRotation.Pitch = Pawn.MaxPitchLimit;
            }
            else
            {
                NewRotation.Pitch = 65536 - Pawn.MaxPitchLimit;
            }
        }
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation);
        Pawn.SetLocation(NewLocation);
    }
}

function Reset()
{
    Reset();
    Enemy = none;
    StartSpot = none;
    bAdjusting = false;
    bPreparingMove = false;
    MoveTimer = -1.0;
    MoveTarget = none;
    CurrentPath = none;
    RouteGoal = none;
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (!bDeleteMe && WorldInfo.NetMode != 3)
    {
        if (bIsPlayer)
        {
            InitPlayerReplicationInfo();
        }
        InitNavigationHandle();
    }
    SightCounter = SightCounterInterval * FRand();
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
    Pawn.SetSkelControlScale(SkelControlName, Scale);
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    Pawn.SetMorphWeight(MorphNodeName, MorphWeight);
}

event StopActorFaceFXAnim()
{
    Pawn.StopActorFaceFXAnim();
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return Pawn.PlayActorFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}

simulated event BreakByAI(EInterruptByAIType Type)
{
}

simulated event ActiveAIEventTrigger(EInterruptByAIType Type, optional int Info1 = 0, optional int Info2 = 0)
{
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    Pawn.FinishAnimControl(InInterpGroup);
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    Pawn.SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, RootMotionLevel);
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    Pawn.BeginAnimControl(InInterpGroup);
}

event NotifyPathChanged()
{
}

native final function Vector GetAdjustLocation()
{
}

native final function SetAdjustLocation(Vector NewLoc, bool bAdjust, optional bool bOffsetFromBase)
{
    NewLoc;
    bAdjust;
    bOffsetFromBase;
}

native final function Vector GetDestinationPosition()
{
}

native final function SetDestinationPosition(Vector Dest, optional bool bOffsetFromBase)
{
    Dest;
    bOffsetFromBase;
}

native final function Vector GetFocalPoint()
{
}

native final function SetFocalPoint(Vector FP, optional bool bOffsetFromBase)
{
    FP;
    bOffsetFromBase;
}

native function RouteCache_RemoveIndex(int InIndex, optional int Count = 1)
{
    InIndex;
    Count;
}

native function RouteCache_RemoveItem(NavigationPoint Nav)
{
    Nav;
}

native function RouteCache_InsertItem(NavigationPoint Nav, optional int Idx = 0)
{
    Nav;
    Idx;
}

native function RouteCache_AddItem(NavigationPoint Nav)
{
    Nav;
}

native function RouteCache_Empty()
{
}

native function bool IsLocalPlayerController()
{
}

state RoundEnded
{
    event BeginState(name PreviousStateName)
    {
        if (Pawn != none)
        {
            Pawn.TurnOff();
            StopFiring();
            if (!bIsPlayer)
            {
                Pawn.UnPossessed();
                Pawn = none;
            }
        }
        if (!bIsPlayer)
        {
            Destroy();
        }
    }
    
    function bool GamePlayEndedState()
    {
        return true;
    }
    
    function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
    {
    }
    
    function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
    }
    
    function Falling()
    {
    }
    
    function bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
    {
    }
    
    function bool NotifyBump(Actor Other, Vector HitNormal)
    {
    }
    
    function KilledBy(Pawn EventInstigator)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

state Dead
{
    reliable server function ServerRestartPlayer()
    {
        if (WorldInfo.NetMode == 3)
        {
            return;
        }
        if (Pawn != none)
        {
            UnPossess();
        }
        WorldInfo.Game.RestartPlayer(self);
    }
    
    function PawnDied(Pawn P)
    {
        if (WorldInfo.NetMode != 3)
        {
            WarnInternal(string(self) @ "Pawndied while dead");
        }
    }
    
    function bool IsDead()
    {
        return true;
    }
    
    function KilledBy(Pawn EventInstigator)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

defaultproperties
{
    bAffectedByHitEffects=True
    bSlowerZAcquire=True
    MinHitWall=-1.0
    NavigationHandleClass="NavigationHandle"
    SightCounterInterval=0.2
    MaxMoveTowardPawnTargetTime=1.2
    bHidden=True
    bOnlyRelevantToOwner=True
    bHiddenEd=True
    CollisionType="COLLIDE_CustomDefault"
    RotationRate=(Pitch=30000,Yaw=30000,Roll=2048)
}
