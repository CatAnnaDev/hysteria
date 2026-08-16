class GameCrowdAgent extends CrowdAgentBase
    abstract
    native
    placeable
    hidecategories(Navigation,Advanced,Attachment,Collision,Object);

enum EConformType
{
    CFM_NavMesh,
    CFM_BSP,
    CFM_World,
    CFM_None,
};

struct native BehaviorEntry
{
    var() GameCrowdAgentBehavior BehaviorArchetype;
    var() float BehaviorFrequency;
    var() bool bNeverRepeat;
    var bool bHasBeenUsed;
    var bool bCanBeUsed;
};

struct native RecentInteraction
{
    var name InteractionTag;
    var float InteractionDelay;
};

var GameCrowdGroup MyGroup;
var Vector PreferredVelocity;
var float AvoidanceShare;
var GameCrowdDestination CurrentDestination;
var GameCrowdDestination BehaviorDestination;
var GameCrowdDestination PreviousDestination;
var Vector ExternalForce;
var float InterpZTranslation;
var() int Health;
var(Behavior) float DeadBodyDuration;
var const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var transient int ConformTraceFrameCount;
var transient int AwareUpdateFrameCount;
var transient array<Actor> NearbyDynamics;
var transient array<GameCrowdForcePoint> RelevantAttractors;
var bool bUniformScale;
var(Pathing) bool bCheckForObstacles;
var(Pathing) bool bUseNavMeshPathing;
var bool bWantsSeePlayerNotification;
var(Movement) bool bAllowPitching;
var bool bHitObstacle;
var bool bBadHitNormal;
var bool bSimulateThisTick;
var(Movement) bool bClampMovementSpeed;
var bool bPotentialEncounter;
var bool bIsPanicked;
var bool bWantsGroupIdle;
var() bool bPreferVisibleDestination;
var() bool bPreferVisibleDestinationOnSpawn;
var bool bHasNotifiedSpawner;
var bool bIsInSpawnPool;
var(Movement) EConformType ConformType;
var(Movement) float ConformTraceDist;
var(Movement) int ConformTraceInterval;
var int CurrentConformTraceInterval;
var float LastGroundZ;
var(Pathing) float AwareRadius;
var(Pathing) int AwareUpdateInterval;
var(Pathing) float AvoidOtherStrength;
var(Pathing) float AvoidPlayerStrength;
var(Pathing) float AvoidOtherRadius;
var(Pathing) float GroupAttractionStrength;
var(Pathing) float MatchVelStrength;
var(Pathing) float FollowPathStrength;
var(Movement) float VelocityDamping;
var(Movement) float RotateToTargetSpeed;
var(Movement) float MaxYawRate;
var(Rendering) Vector MeshMinScale3D;
var(Rendering) Vector MeshMaxScale3D;
var float EyeZOffset;
var(LOD) float ProximityLODDist;
var(LOD) float VisibleProximityLODDist;
var Vector LastKnownGoodPosition;
var(Rendering) float GroundOffset;
var Vector IntermediatePoint;
var Vector SearchExtent;
var class<NavigationHandle> NavigationHandleClass;
var NavigationHandle NavigationHandle;
var int ObstacleCheckCount;
var float WalkableFloorZ;
var float LastPathingAttempt;
var float LastUpdateTime;
var(LOD) float NotVisibleLifeSpan;
var(LOD) float NotVisibleTickScalingFactor;
var GameCrowdAgent MyArchetype;
var(Movement) float MaxWalkingSpeed;
var(Movement) float MaxRunningSpeed;
var float MaxSpeed;
var array<RecentInteraction> RecentInteractions;
var float BeaconMaxDist;
var Vector BeaconOffset;
var const Texture2D BeaconTexture;
var const LinearColor BeaconColor;
var() SoundCue AmbientSoundCue;
var export editinline AudioComponent AmbientSoundComponent;
var GameCrowdAgentBehavior CurrentBehavior;
var(Behavior) array<BehaviorEntry> EncounterAgentBehaviors;
var(Behavior) array<BehaviorEntry> SeePlayerBehaviors;
var float MaxSeePlayerDistSq;
var(Behavior) float SeePlayerInterval;
var(Behavior) array<BehaviorEntry> SpawnBehaviors;
var(Behavior) array<BehaviorEntry> PanicBehaviors;
var(Behavior) array<BehaviorEntry> RandomBehaviors;
var(Behavior) float RandomBehaviorInterval;
var float ForceUpdateTime;
var float ReachThreshold;
var(Behavior) array<BehaviorEntry> GroupWaitingBehaviors;
var(Behavior) float DesiredGroupRadius;
var float DesiredGroupRadiusSq;
var float MaxLOSLifeDistanceSq;
var GameCrowdSpawnerInterface MySpawner;
var Vector SpawnOffset;
var float InitialLastRenderTime;

function string GetBehaviorString()
{
    local string BehaviorString;
    
    if (CurrentBehavior != none)
    {
        BehaviorString = CurrentBehavior.GetBehaviorString();
    }
    else
    {
        BehaviorString = "Moving between Destinations";
    }
    return BehaviorString;
}

function string GetDestString()
{
    local string DestString;
    
    DestString = (CurrentDestination == none ? "NO DESTINATION" : "" $ string(CurrentDestination));
    if (IsIdle())
    {
        DestString = (CurrentDestination != none && CurrentDestination.ReachedByAgent(self, Location, true) ? "Idle at " $ DestString : "Idle en route to " $ DestString);
    }
    else
    {
        DestString = "Moving to " $ DestString;
    }
    return DestString;
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    local float NameXL, TextXL, BehavXL, TextYL, YL, XL;
    local Vector ScreenLoc;
    local string ScreenName, DestString, BehaviorString;
    local FontRenderInfo FontInfo;
    
    ScreenLoc = Canvas.Project(Location + BeaconOffset);
    if (ScreenLoc.X < float(0) || ScreenLoc.X >= Canvas.ClipX || ScreenLoc.Y < float(0) || ScreenLoc.Y >= Canvas.ClipY)
    {
        return;
    }
    ScreenName = "Agent" @ string(self);
    if (MyGroup != none)
    {
        ScreenName = ScreenName $ " Group " $ string(MyGroup);
        DrawDebugLine(MyGroup.Members[0].Location, Location, 255, 0, 255, false);
    }
    ScreenName = ScreenName @ "Last Rendered" @ string(WorldInfo.TimeSeconds - LastRenderTime);
    Canvas.StrLen(ScreenName, NameXL, TextYL);
    XL = FMax(XL, NameXL);
    YL += TextYL;
    DestString = GetDestString();
    Canvas.StrLen(DestString, TextXL, TextYL);
    XL = FMax(XL, TextXL);
    YL += TextYL;
    BehaviorString = GetBehaviorString();
    Canvas.StrLen(BehaviorString, BehavXL, TextYL);
    XL = FMax(XL, BehavXL);
    YL += TextYL;
    Canvas.SetPos(ScreenLoc.X - 0.7 * XL, ScreenLoc.Y - 1.8 * YL);
    Canvas.DrawTile(BeaconTexture, 1.4 * XL, 1.2 * YL, 0.0, 0.0, 31.0, 31.0, BeaconColor);
    Canvas.DrawColor = class'Engine.HUD'.default.default.GreenColor;
    Canvas.SetPos(ScreenLoc.X - 0.5 * NameXL, ScreenLoc.Y - 1.7 * YL);
    FontInfo.bClipText = true;
    Canvas.DrawText(ScreenName, true, , , FontInfo);
    Canvas.SetPos(ScreenLoc.X - 0.5 * TextXL, ScreenLoc.Y - 1.7 * YL + 1.1 * TextYL);
    FontInfo.bClipText = true;
    Canvas.DrawText(DestString, true, , , FontInfo);
    Canvas.SetPos(ScreenLoc.X - 0.5 * BehavXL, ScreenLoc.Y - 1.7 * YL + 2.2 * TextYL);
    FontInfo.bClipText = true;
    Canvas.DrawText(BehaviorString, true, , , FontInfo);
    if (CurrentDestination != none)
    {
        DrawDebugLine(Location, CurrentDestination.Location, 255, 255, 0, false);
    }
}

native simulated function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    PC;
    Canvas;
    CameraPosition;
    CameraDir;
}

event Vector GeneratePathToActor(Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
    local Vector NextDest;
    
    LastPathingAttempt = WorldInfo.TimeSeconds;
    NextDest = Goal.Location;
    if (NavigationHandle == none)
    {
        InitNavigationHandle();
    }
    if (NavigationHandle != none && !NavigationHandle.ActorReachable(Goal))
    {
        class'Engine.NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Goal);
        class'Engine.NavMeshGoal_At'.static.AtActor(NavigationHandle, Goal, WithinDistance, bAllowPartialPath);
        if (NavigationHandle.FindPath())
        {
            NavigationHandle.GetNextMoveLocation(NextDest, SearchExtent.X);
        }
        NavigationHandle.ClearConstraints();
    }
    return NextDest;
}

event InitNavigationHandle()
{
    if (NavigationHandleClass != none)
    {
        NavigationHandle = new(self) NavigationHandleClass;
    }
}

event OverlappedActorEvent(Actor A)
{
}

function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (Health > 0)
    {
        Health -= DamageAmount;
        if (Health <= 0)
        {
            Health = -1;
            SetCollision(false, false, false);
            PlayDeath(Normal(Momentum) * DamageType.default.default.KDamageImpulse + vect(0.0, 0.0, 1.0) * DamageType.default.default.KDeathUpKick);
        }
    }
}

simulated event FireDeathEvent()
{
    TriggerEventClass(class'Engine.SeqEvent_Death', self);
}

native function PlayDeath(Vector KillMomentum)
{
    KillMomentum;
}

event UpdateIntermediatePoint(optional Actor DestinationActor)
{
    if (DestinationActor == none)
    {
        if (CurrentBehavior != none)
        {
            DestinationActor = CurrentBehavior.GetDestinationActor();
        }
        else
        {
            DestinationActor = CurrentDestination;
        }
        if (DestinationActor == none)
        {
            return;
        }
    }
    if (!bUseNavMeshPathing)
    {
        IntermediatePoint = DestinationActor.Location;
    }
    else
    {
        IntermediatePoint = GeneratePathToActor(DestinationActor);
        if (IntermediatePoint == vect(0.0, 0.0, 0.0))
        {
            IntermediatePoint = DestinationActor.Location;
        }
    }
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitNormal;
    local float Radius;
    
    Radius = 20.0;
    if (Trace(out_CamLoc, HitNormal, Location - vector(out_CamRot) * Radius * float(20), Location, false) == none)
    {
        out_CamLoc = Location - vector(out_CamRot) * Radius * float(20);
    }
    return false;
}

native function bool IsIdle()
{
}

native final function SetCurrentBehavior(GameCrowdAgentBehavior BehaviorArchetype)
{
    BehaviorArchetype;
}

event StopBehavior()
{
    if (CurrentBehavior != none)
    {
        CurrentBehavior.StopBehavior();
        CurrentBehavior = none;
    }
}

function ActivateInstancedBehavior(GameCrowdAgentBehavior NewBehaviorObject)
{
    StopBehavior();
    CurrentBehavior = NewBehaviorObject;
    CurrentBehavior.InitBehavior(self);
}

event ActivateBehavior(GameCrowdAgentBehavior NewBehaviorArchetype)
{
    StopBehavior();
    if (NewBehaviorArchetype == none)
    {
        WarnInternal("Illegal behavior " $ string(NewBehaviorArchetype) $ " for " $ string(self));
        return;
    }
    SetCurrentBehavior(NewBehaviorArchetype);
    CurrentBehavior.InitBehavior(self);
}

function ResetSeePlayer()
{
    bWantsSeePlayerNotification = true;
}

function TryRandomBehavior()
{
    local bool bFoundBehavior;
    local int I;
    
    if (CurrentBehavior == none && WorldInfo.TimeSeconds - LastRenderTime < 0.1)
    {
        if (!PickBehaviorFrom(RandomBehaviors))
        {
            for (I = 0; I < RandomBehaviors.Length; I++)
            {
                if (!RandomBehaviors[I].bNeverRepeat || !RandomBehaviors[I].bHasBeenUsed)
                {
                    bFoundBehavior = true;
                    break;
                }
            }
            if (!bFoundBehavior)
            {
                ClearTimer('TryRandomBehavior');
            }
        }
    }
}

event NotifySeePlayer(PlayerController PC)
{
    local bool bFoundBehavior;
    local int I;
    
    bWantsSeePlayerNotification = false;
    if (CurrentBehavior == none)
    {
        if (!PickBehaviorFrom(SeePlayerBehaviors, PC.Pawn.Location))
        {
            for (I = 0; I < SeePlayerBehaviors.Length; I++)
            {
                if (!SeePlayerBehaviors[I].bNeverRepeat || !SeePlayerBehaviors[I].bHasBeenUsed)
                {
                    bFoundBehavior = true;
                    break;
                }
            }
            if (!bFoundBehavior)
            {
                SeePlayerInterval = 0.0;
            }
        }
    }
    if (SeePlayerInterval > 0.0)
    {
        SetTimer((0.8 + 0.4 * FRand()) * SeePlayerInterval, false, 'ResetSeePlayer');
    }
}

function PlaySpawnBehavior()
{
    if (CurrentBehavior == none)
    {
        PickBehaviorFrom(SpawnBehaviors);
    }
}

event HandlePotentialAgentEncounter()
{
    if (CurrentBehavior == none)
    {
        PickBehaviorFrom(EncounterAgentBehaviors);
    }
}

simulated event StopIdleAnimation()
{
}

simulated event PlayIdleAnimation()
{
}

simulated function OnPlayAgentAnimation(SeqAct_PlayAgentAnimation Action)
{
    CurrentDestination.ReachedDestination(self);
}

simulated function InitializeAgent(Actor SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup, float AgentWarmupTime, bool bWarmupPosition, bool bCheckWarmupVisibility)
{
    local bool bGroupDestination, bRealPreferVisible;
    local GameCrowdDestination SpawnDest;
    local float TryPct, MaxSpawnDist, DestDist, StartDist;
    local Vector TryLoc;
    local Actor HitActor;
    local Vector HitLocation, HitNormal, ViewLocation, YAdjust;
    local Rotator ViewRotation;
    local PlayerController PC;
    local bool bVisibleTryLoc;
    
    MyArchetype = AgentTemplate;
    LastRenderTime = WorldInfo.TimeSeconds + AgentWarmupTime * (0.5 + FRand());
    InitialLastRenderTime = LastRenderTime;
    if (NewGroup != none)
    {
        NewGroup.AddMember(self);
        if (NewGroup.Members.Length > 1)
        {
            bGroupDestination = true;
            SetCurrentDestination(NewGroup.Members[0].CurrentDestination);
        }
    }
    if (!bGroupDestination)
    {
        SpawnDest = GameCrowdDestination(SpawnLoc);
        if (SpawnDest != none)
        {
            SetCurrentDestination(SpawnDest);
            bRealPreferVisible = bPreferVisibleDestination;
            bPreferVisibleDestination = bPreferVisibleDestinationOnSpawn || !SpawnDest.bWillBeVisible;
            LastRenderTime = WorldInfo.TimeSeconds;
            CurrentDestination.ReachedDestination(self);
            bPreferVisibleDestination = bRealPreferVisible;
            if (CurrentDestination == none)
            {
                WarnInternal("INITIALIZING - NO CURRENTDESTINATION AFTER REACHING " $ string(SpawnDest));
            }
            if (bWarmupPosition)
            {
                foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
                {
                    PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
                    break;
                }
                if (NewGroup == none || NewGroup.Members.Length == 0)
                {
                    TryPct = FRand();
                    MaxSpawnDist = (NotEqual_InterfaceInterface(MySpawner, GameCrowdSpawnerInterface(none)) ? MySpawner.GetMaxSpawnDist() : 0.0);
                    if (SpawnDest.bIsBeyondSpawnDistance && NotEqual_InterfaceInterface(MySpawner, GameCrowdSpawnerInterface(none)))
                    {
                        DestDist = VSize(CurrentDestination.Location - ViewLocation);
                        if (CurrentDestination.bIsBeyondSpawnDistance || DestDist > MaxSpawnDist)
                        {
                            TryPct = (DestDist < VSizeSq(SpawnDest.Location - ViewLocation) ? 1.0 : 0.0);
                        }
                        else
                        {
                            StartDist = VSize(SpawnDest.Location - ViewLocation);
                            if (StartDist > DestDist)
                            {
                                TryPct = 1.0 - (MaxSpawnDist - DestDist) / (StartDist - DestDist);
                                TryPct *= 0.9;
                            }
                            else
                            {
                                TryPct = 0.0;
                            }
                        }
                    }
                    else if (!SpawnDest.bWillBeVisible)
                    {
                        TryPct = 0.5 * TryPct + 0.5;
                    }
                    else
                    {
                        TryPct *= 0.9;
                    }
                    TryLoc = TryPct * CurrentDestination.Location + (float(1) - TryPct) * SpawnDest.Location;
                    bVisibleTryLoc = false;
                    if (bCheckWarmupVisibility && !SpawnDest.bIsBeyondSpawnDistance)
                    {
                        HitActor = PC.Trace(HitLocation, HitNormal, TryLoc, ViewLocation, false);
                        if (HitActor == none)
                        {
                            TryPct *= 0.5;
                            TryLoc = TryPct * CurrentDestination.Location + (float(1) - TryPct) * SpawnDest.Location;
                            HitActor = PC.Trace(HitLocation, HitNormal, TryLoc, ViewLocation, false);
                            if (HitActor == none)
                            {
                                bVisibleTryLoc = true;
                            }
                        }
                    }
                    if (!bVisibleTryLoc)
                    {
                        SpawnOffset = TryLoc;
                        HitActor = Trace(HitLocation, HitNormal, TryLoc, CurrentDestination.Location, false);
                        if (HitActor == none)
                        {
                            TryPct = 2.0 * FRand() - 1.0;
                            YAdjust = TryLoc + TryPct * AvoidOtherRadius * Normal((CurrentDestination.Location - SpawnDest.Location) Cross vect(0.0, 0.0, 1.0));
                            HitActor = Trace(HitLocation, HitNormal, YAdjust, CurrentDestination.Location, false);
                            if (HitActor == none)
                            {
                                TryLoc = YAdjust;
                            }
                            HitActor = Trace(HitLocation, HitNormal, TryLoc - vect(0.0, 0.0, 250.0), TryLoc, false);
                            if (HitActor != none)
                            {
                                TryLoc.Z = HitLocation.Z + GroundOffset + 5.0;
                            }
                            SetLocation(TryLoc);
                            if (SpawnDest.bWillBeVisible && CurrentDestination.bIsVisible && FRand() < 0.5)
                            {
                                PreviousDestination = CurrentDestination;
                                CurrentDestination.DecrementCustomerCount(self);
                                CurrentDestination = none;
                                BehaviorDestination = none;
                                SetCurrentDestination(SpawnDest);
                            }
                        }
                    }
                }
                else
                {
                    TryLoc = SpawnOffset;
                    TryPct = 2.0 * FRand() - 1.0;
                    YAdjust = TryLoc + TryPct * AvoidOtherRadius * Normal((CurrentDestination.Location - SpawnDest.Location) Cross vect(0.0, 0.0, 1.0));
                    HitActor = Trace(HitLocation, HitNormal, YAdjust, CurrentDestination.Location, false);
                    if (HitActor == none)
                    {
                        TryLoc = YAdjust;
                    }
                    HitActor = Trace(HitLocation, HitNormal, TryLoc - vect(0.0, 0.0, 250.0), TryLoc, false);
                    if (HitActor != none)
                    {
                        TryLoc.Z = HitLocation.Z + GroundOffset + 5.0;
                    }
                    SetLocation(TryLoc);
                }
            }
        }
    }
    LastKnownGoodPosition = Location;
    LastKnownGoodPosition.Z += EyeZOffset;
    if (SpawnBehaviors.Length > 0)
    {
        PlaySpawnBehavior();
    }
    UpdateIntermediatePoint();
}

simulated function SetLighting(bool bEnableLightEnvironment, LightingChannelContainer AgentLightingChannel, bool bCastShadows)
{
    if (bEnableLightEnvironment)
    {
        LightEnvironment.SetEnabled(true);
    }
    else
    {
        DetachComponent(LightEnvironment);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Canvas Canvas;
    
    DisplayDebug(HUD, out_YL, out_YPos);
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
    Canvas.DrawText("Location:" @ string(Location) @ "Rotation:" @ string(Rotation) @ " Speed: " $ string(VSize(Velocity)) @ "ZVel" @ string(Velocity.Z), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("Hit obestacle:" @ string(bHitObstacle) @ "BadHitNormal:" @ string(bBadHitNormal) @ "count" @ string(ObstacleCheckCount), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("Current conform interval:" @ string(CurrentConformTraceInterval) @ "Base Conform Interval:" @ string(ConformTraceInterval) @ " Last Ground Z " @ string(LastGroundZ), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (CurrentDestination == none)
    {
        Canvas.DrawText("NO DESTINATION", false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    else
    {
        if (NavigationHandle != none)
        {
            NavigationHandle.DrawPathCache();
        }
        T = "DESTINATION " $ string(CurrentDestination);
        if (MyGroup != none)
        {
            T = T $ " Group " $ string(MyGroup);
            DrawDebugLine(MyGroup.Members[0].Location, Location, 255, 128, 0, false);
        }
        Canvas.DrawText(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        if (IntermediatePoint == CurrentDestination.Location)
        {
            DrawDebugLine(IntermediatePoint, Location, 0, 128, 255, false);
        }
        else
        {
            DrawDebugLine(IntermediatePoint, Location, 0, 255, 0, false);
            DrawDebugLine(CurrentDestination.Location, Location, 255, 255, 0, false);
        }
    }
}

simulated function Destroyed()
{
    Destroyed();
    if (NotEqual_InterfaceInterface(MySpawner, GameCrowdSpawnerInterface(none)) && !bHasNotifiedSpawner)
    {
        bHasNotifiedSpawner = true;
        MySpawner.AgentDestroyed(self);
    }
    if (CurrentDestination != none)
    {
        CurrentDestination.DecrementCustomerCount(self);
        CurrentDestination = none;
    }
    if (MyGroup != none)
    {
        MyGroup.RemoveMember(self);
    }
}

function ResetPooledAgent()
{
    bIsInSpawnPool = false;
    SetHidden(false);
    BehaviorDestination = none;
    PreviousDestination = none;
    LifeSpan = 0.0;
    Health = default.Health;
    TimeSinceLastTick = 0.0;
    LastKnownGoodPosition = Location;
    LastKnownGoodPosition.Z += EyeZOffset;
    ForceUpdateTime = WorldInfo.TimeSeconds;
    SetMaxSpeed();
    if (RandomBehaviors.Length > 0)
    {
        SetTimer((0.8 + 0.4 * FRand()) * RandomBehaviorInterval, true, 'TryRandomBehavior');
    }
}

event KillAgent()
{
    if (bIsInSpawnPool)
    {
        return;
    }
    if (NotEqual_InterfaceInterface(MySpawner, GameCrowdSpawnerInterface(none)) && MySpawner.AddToAgentPool(self))
    {
        SetHidden(true);
        if (CurrentDestination != none)
        {
            CurrentDestination.DecrementCustomerCount(self);
            CurrentDestination = none;
        }
        if (MyGroup != none)
        {
            MyGroup.RemoveMember(self);
        }
        Health = -1;
        TimeSinceLastTick = -1000.0;
        ClearAllTimers();
        BehaviorDestination = none;
        PreviousDestination = none;
        LifeSpan = 0.0;
        StopBehavior();
    }
    else
    {
        LifeSpan = -0.1;
        TimeSinceLastTick = 1000.0;
    }
}

simulated function PostBeginPlay()
{
    local Vector AgentScale3D;
    local int I;
    local float MaxSeePlayerDist;
    
    PostBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    if (bUniformScale)
    {
        AgentScale3D = MeshMinScale3D + FRand() * (MeshMaxScale3D - MeshMinScale3D);
    }
    else
    {
        AgentScale3D.X = RandRange(MeshMinScale3D.X, MeshMaxScale3D.X);
        AgentScale3D.Y = RandRange(MeshMinScale3D.Y, MeshMaxScale3D.Y);
        AgentScale3D.Z = RandRange(MeshMinScale3D.Z, MeshMaxScale3D.Z);
    }
    SetDrawScale3D(AgentScale3D);
    LastKnownGoodPosition = Location;
    LastKnownGoodPosition.Z += EyeZOffset;
    ForceUpdateTime = WorldInfo.TimeSeconds;
    SetMaxSpeed();
    if (AmbientSoundCue != none)
    {
        AmbientSoundComponent = new(self) class'Engine.AudioComponent';
        if (AmbientSoundComponent != none)
        {
            AttachComponent(AmbientSoundComponent);
            AmbientSoundComponent.SoundCue = AmbientSoundCue;
            AmbientSoundComponent.Play();
        }
    }
    bWantsSeePlayerNotification = SeePlayerBehaviors.Length > 0;
    for (I = 0; I < SeePlayerBehaviors.Length; I++)
    {
        MaxSeePlayerDist = FMax(MaxSeePlayerDist, SeePlayerBehaviors[I].BehaviorArchetype.MaxPlayerDistance);
    }
    MaxSeePlayerDistSq = MaxSeePlayerDist * MaxSeePlayerDist;
    DesiredGroupRadiusSq = DesiredGroupRadius * DesiredGroupRadius;
    if (RandomBehaviors.Length > 0)
    {
        SetTimer((0.8 + 0.4 * FRand()) * RandomBehaviorInterval, true, 'TryRandomBehavior');
    }
}

function SetMaxSpeed()
{
    MaxSpeed = (IsPanicked() ? MaxRunningSpeed : MaxWalkingSpeed);
}

event SetCurrentDestination(GameCrowdDestination NewDest)
{
    if (NewDest != CurrentDestination)
    {
        if (CurrentBehavior != none)
        {
            CurrentBehavior.ChangingDestination(NewDest);
        }
        CurrentDestination = NewDest;
        CurrentDestination.IncrementCustomerCount(self);
        ReachThreshold = (CurrentDestination.bSoftPerimeter ? 0.5 + 0.5 * FRand() : 1.0);
    }
    if (CurrentDestination.bFleeDestination && !IsPanicked())
    {
        SetPanic(none, true);
    }
}

event WaitForGroupMembers()
{
    local int I;
    
    PickBehaviorFrom(GroupWaitingBehaviors);
    if (CurrentBehavior != none)
    {
        CurrentBehavior.ActionTarget = MyGroup.Members[0];
        for (I = 0; I < MyGroup.Members.Length; I++)
        {
            if (MyGroup.Members[I] != none && !MyGroup.Members[I].bDeleteMe && VSizeSq(MyGroup.Members[I].Location - Location) > DesiredGroupRadiusSq && MyGroup.Members[I].Velocity Dot (Location - MyGroup.Members[I].Location) > 0.0)
            {
                CurrentBehavior.ActionTarget = MyGroup.Members[I];
                break;
            }
        }
    }
}

function bool PickBehaviorFrom(array<BehaviorEntry> BehaviorList, optional Vector BestCameraLoc = vect(0.0, 0.0, 0.0))
{
    local Vector cameraLoc;
    local Rotator cameraRot;
    local PlayerController PC;
    local float BestDistSq, NewDistSq;
    local int I;
    local float FreqSum, RandPick;
    
    if (BestCameraLoc == vect(0.0, 0.0, 0.0))
    {
        BestDistSq = 90000000.0;
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            PC.GetPlayerViewPoint(cameraLoc, cameraRot);
            NewDistSq = VSizeSq(cameraLoc - Location);
            if (NewDistSq < BestDistSq)
            {
                BestDistSq = NewDistSq;
                BestCameraLoc = cameraLoc;
            }
        }
    }
    for (I = 0; I < BehaviorList.Length; I++)
    {
        if (BehaviorList[I].BehaviorArchetype == none)
        {
            WarnInternal(string(self) @ string(MyArchetype) $ " No behavior archetype for behaviorentry " $ string(I));
            continue;
        }
        BehaviorList[I].bCanBeUsed = (!BehaviorList[I].bHasBeenUsed || !BehaviorList[I].bNeverRepeat) && BehaviorList[I].BehaviorArchetype.CanBeUsedBy(self, BestCameraLoc);
        if (BehaviorList[I].bCanBeUsed)
        {
            FreqSum += BehaviorList[I].BehaviorFrequency;
        }
    }
    RandPick = FMax(1.0, FreqSum) * FRand();
    if (RandPick >= FreqSum)
    {
        return false;
    }
    for (I = 0; I < BehaviorList.Length; I++)
    {
        if (BehaviorList[I].bCanBeUsed)
        {
            RandPick -= BehaviorList[I].BehaviorFrequency;
            if (RandPick < 0.0)
            {
                ActivateBehavior(BehaviorList[I].BehaviorArchetype);
                BehaviorList[I].bHasBeenUsed = true;
                return true;
            }
        }
    }
    return false;
}

function SetPanic(Actor PanicActor, bool bNewPanic)
{
    if (bNewPanic)
    {
        if (!IsPanicked())
        {
            PickBehaviorFrom(PanicBehaviors);
        }
        if (CurrentBehavior != none)
        {
            CurrentBehavior.ActivatedBy(PanicActor);
        }
    }
    else if (IsPanicked())
    {
        StopBehavior();
    }
}

native function bool IsPanicked()
{
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    Health = -1;
    LifeSpan = -0.1;
}

defaultproperties
{
    AvoidanceShare=0.5
    Health=100
    DeadBodyDuration=10.0
    LightEnvironment="Default__GameCrowdAgent.MyLightEnvironment"
    bUniformScale=True
    bUseNavMeshPathing=True
    bClampMovementSpeed=True
    bPreferVisibleDestinationOnSpawn=True
    ConformTraceDist=35.0
    ConformTraceInterval=10
    CurrentConformTraceInterval=10
    AwareRadius=200.0
    AwareUpdateInterval=30
    AvoidOtherStrength=1000.0
    AvoidPlayerStrength=10000.0
    AvoidOtherRadius=100.0
    GroupAttractionStrength=50.0
    MatchVelStrength=0.6
    FollowPathStrength=300.0
    VelocityDamping=0.001
    RotateToTargetSpeed=30000.0
    MaxYawRate=40000.0
    MeshMinScale3D=(X=1.0,Y=1.0,Z=1.0)
    MeshMaxScale3D=(X=1.0,Y=1.0,Z=1.0)
    EyeZOffset=40.0
    ProximityLODDist=2000.0
    VisibleProximityLODDist=5000.0
    GroundOffset=40.0
    SearchExtent=(X=15.0,Y=15.0,Z=40.0)
    NavigationHandleClass="Engine.NavigationHandle"
    WalkableFloorZ=0.7
    NotVisibleLifeSpan=5.5
    NotVisibleTickScalingFactor=0.02
    MaxWalkingSpeed=100.0
    MaxRunningSpeed=300.0
    BeaconMaxDist=1500.0
    BeaconOffset=(X=0.0,Y=0.0,Z=140.0)
    BeaconTexture="EngineResources.WhiteSquareTexture"
    BeaconColor=(R=0.5,G=0.5,B=0.5,A=0.5)
    RandomBehaviorInterval=30.0
    ReachThreshold=1.0
    DesiredGroupRadius=200.0
    MaxLOSLifeDistanceSq=400000000.0
    bCollideActors=True
    bProjTarget=True
    bNoEncroachCheck=True
    Components(0)="Default__GameCrowdAgent.MyLightEnvironment"
    Physics="PHYS_Interpolating"
    TickGroup="TG_DuringAsyncWork"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(5)="Engine.SeqEvent_Death"
}
