class GameCrowdPopulationManager extends CrowdPopulationManagerBase
    native
    notplaceable
    hidecategories(Navigation)
    implements(Interface_NavigationHandle,GameCrowdSpawnerInterface);

var const native noexport Pointer VfTable_IInterface_NavigationHandle;
var bool bSpawningActive;
var bool bEnableCrowdLightEnvironment;
var bool bCastShadows;
var bool bForceObstacleChecking;
var bool bForceNavMeshPathing;
var bool bHaveInitialPopulation;
var() bool bWarmupPosition;
var float SpawnRate;
var int SpawnNum;
var float SplitScreenNumReduction;
var float Remainder;
var float AgentFrequencySum;
var array<AgentArchetypeInfo> AgentArchetypes;
var array<GameCrowdAgent> AgentPool;
var int MaxAgentPoolSize;
var int AgentCount;
var LightingChannelContainer AgentLightingChannel;
var float AgentWarmupTime;
var float SpawnPrioritizationInterval;
var int PrioritizationIndex;
var int PrioritizationUpdateIndex;
var array<GameCrowdDestination> PrioritizedSpawnPoints;
var float PlayerPositionPredictionTime;
var array<GameCrowdDestination> PotentialSpawnPoints;
var float MaxSpawnDist;
var float MaxSpawnDistSq;
var float MinBehindSpawnDistSq;
var int SpawnedCount;
var int PoolCount;
var int KilledCount;
var float HeadVisibilityOffset;
var float InitialPopulationPct;
var class<NavigationHandle> NavigationHandleClass;
var NavigationHandle NavigationHandle;
var GameCrowdAgent QueryingAgent;

function GameCrowdAgent CreateNewAgent(GameCrowdDestination SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup)
{
    local GameCrowdAgent Agent;
    local GameCrowdAgentSkeletal SkAgent;
    local Rotator SpawnRot;
    local Vector SpawnPos;
    local int I;
    
    GameCrowdSpawnInterface(SpawnLoc).GetSpawnPosition(none, SpawnPos, SpawnRot);
    if (AgentPool.Length > 0)
    {
        for (I = 0; I < AgentPool.Length; I++)
        {
            if (AgentPool[I].MyArchetype == AgentTemplate)
            {
                Agent = AgentPool[I];
                PoolCount++;
                AgentPool.Remove(I, 1);
                break;
            }
        }
        if (Agent != none)
        {
            Agent.SetLocation(SpawnPos);
            Agent.SetRotation(SpawnRot);
            Agent.ResetPooledAgent();
            Agent.InitializeAgent(SpawnLoc, AgentTemplate, NewGroup, AgentWarmupTime * 2.0 * FRand(), bWarmupPosition, true);
            Agent.MaxLOSLifeDistanceSq = 2.25 * MaxSpawnDistSq;
            Agent.VisibleProximityLODDist = FMin(Agent.VisibleProximityLODDist, MaxSpawnDist);
            Agent.ProximityLODDist = FMin(Agent.ProximityLODDist, Agent.VisibleProximityLODDist);
            SkAgent = GameCrowdAgentSkeletal(Agent);
            if (SkAgent != none)
            {
                SkAgent.MaxAnimationDistanceSq = FMin(SkAgent.MaxAnimationDistanceSq, MaxSpawnDistSq);
            }
            return Agent;
        }
    }
    Agent = Spawn(AgentTemplate.Class, , , SpawnPos, SpawnRot, AgentTemplate);
    SpawnedCount++;
    Agent.SetLighting(bEnableCrowdLightEnvironment, AgentLightingChannel, bCastShadows);
    if (bForceObstacleChecking)
    {
        Agent.bCheckForObstacles = true;
    }
    if (bForceNavMeshPathing)
    {
        Agent.bUseNavMeshPathing = true;
    }
    if (SpawnLoc.bWillBeVisible)
    {
        Agent.bPreferVisibleDestinationOnSpawn = Agent.bPreferVisibleDestination;
    }
    Agent.MySpawner = GameCrowdSpawnerInterface(self);
    Agent.InitializeAgent(SpawnLoc, AgentTemplate, NewGroup, AgentWarmupTime * 2.0 * FRand(), bWarmupPosition, bHaveInitialPopulation);
    AgentCount++;
    return Agent;
}

event GameCrowdAgent SpawnAgent(GameCrowdDestination SpawnLoc)
{
    local GameCrowdAgent Agent;
    local float AgentPickValue, PickSum;
    local int I, PickedInfo;
    local GameCrowdAgent AgentTemplate;
    local GameCrowdGroup NewGroup;
    
    if (AgentFrequencySum == 0.0)
    {
        for (I = 0; I < AgentArchetypes.Length; I++)
        {
            if (GameCrowdAgent(AgentArchetypes[I].AgentArchetype) != none)
            {
                AgentFrequencySum = AgentFrequencySum + FMax(0.0, AgentArchetypes[I].FrequencyModifier);
            }
        }
    }
    AgentPickValue = AgentFrequencySum * FRand();
    PickedInfo = -1;
    for (I = 0; I < AgentArchetypes.Length; I++)
    {
        AgentTemplate = GameCrowdAgent(AgentArchetypes[I].AgentArchetype);
        if (AgentTemplate != none)
        {
            PickSum = PickSum + FMax(0.0, AgentArchetypes[I].FrequencyModifier);
            if (PickSum > AgentPickValue)
            {
                PickedInfo = I;
                break;
            }
        }
    }
    if (PickedInfo == -1)
    {
        return none;
    }
    if (AgentArchetypes[PickedInfo].GroupMembers.Length > 0)
    {
        NewGroup = new(none) class'GameCrowdGroup';
    }
    Agent = CreateNewAgent(SpawnLoc, AgentTemplate, NewGroup);
    for (I = 0; I < AgentArchetypes[PickedInfo].GroupMembers.Length; I++)
    {
        if (GameCrowdAgent(AgentArchetypes[PickedInfo].GroupMembers[I]) != none)
        {
            CreateNewAgent(SpawnLoc, GameCrowdAgent(AgentArchetypes[PickedInfo].GroupMembers[I]), NewGroup);
        }
    }
    return Agent;
}

function bool ValidateSpawnAt(GameCrowdDestination Candidate)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal, ViewLocation;
    local Rotator ViewRotation;
    local PlayerController PC;
    local float DistSq;
    
    if (Candidate.AtCapacity() || !Candidate.bIsEnabled || !Candidate.bAllowsSpawning)
    {
        return false;
    }
    if (bHaveInitialPopulation)
    {
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
            DistSq = VSizeSq(Candidate.Location - ViewLocation);
            if (DistSq < MaxSpawnDistSq && DistSq < MinBehindSpawnDistSq || Normal(Candidate.Location - ViewLocation) Dot vector(ViewRotation) > 0.7)
            {
                HitActor = PC.Trace(HitLocation, HitNormal, Candidate.Location + HeadVisibilityOffset * vect(0.0, 0.0, 1.0), ViewLocation, false, , , 1);
                if (HitActor == none)
                {
                    return false;
                }
            }
        }
    }
    return true;
}

function AddPrioritizedSpawnPoint(GameCrowdDestination GCD, Vector ViewLocation)
{
    local int I;
    
    GCD.Priority = 1.0 / VSize(GCD.Location - ViewLocation);
    if (GCD.bWillBeVisible)
    {
        GCD.Priority *= 10.0;
    }
    GCD.Priority *= FMin(WorldInfo.TimeSeconds - GCD.LastSpawnTime, 10.0);
    PrioritizationIndex = Min(PrioritizationIndex, PrioritizedSpawnPoints.Length);
    for (I = PrioritizationIndex; I < PrioritizedSpawnPoints.Length; I++)
    {
        if (PrioritizedSpawnPoints[I].Priority < GCD.Priority)
        {
            PrioritizedSpawnPoints.Insert(I, 1);
            PrioritizedSpawnPoints[I] = GCD;
            return;
        }
    }
    for (I = 0; I < PrioritizationIndex; I++)
    {
        if (PrioritizedSpawnPoints[I].Priority < GCD.Priority)
        {
            PrioritizedSpawnPoints.Insert(I, 1);
            PrioritizedSpawnPoints[I] = GCD;
            return;
        }
    }
    PrioritizedSpawnPoints.Insert(PrioritizationIndex, 1);
    PrioritizedSpawnPoints[PrioritizationIndex] = GCD;
    PrioritizationIndex++;
    if (PrioritizationIndex >= PrioritizedSpawnPoints.Length)
    {
        PrioritizationIndex = 0;
    }
}

function AnalyzeSpawnPoints(int StartIndex, int StopIndex, Vector ViewLocation, Vector PredictionLocation)
{
    local Actor HitActor;
    local int I, J;
    local GameCrowdDestination GCD, NextGCD;
    local Vector HitLocation, HitNormal;
    
    if (StartIndex >= PotentialSpawnPoints.Length)
    {
        return;
    }
    for (I = StartIndex; I < Min(StopIndex, PotentialSpawnPoints.Length); I++)
    {
        GCD = PotentialSpawnPoints[I];
        if (GCD == none)
        {
            PotentialSpawnPoints.Remove(I--, 1);
            continue;
        }
        GCD.bIsVisible = true;
        GCD.bAdjacentToVisibleNode = false;
        GCD.bWillBeVisible = false;
        GCD.Priority = 0.0;
        GCD.bIsBeyondSpawnDistance = FMin(VSizeSq(ViewLocation - GCD.Location), VSizeSq(PredictionLocation - GCD.Location)) > MaxSpawnDistSq;
        GCD.bCanSpawnHereNow = false;
        GCD.bHasNavigationMesh = true;
        if (GCD.bIsEnabled && GCD.bAllowsSpawning)
        {
            if (bForceNavMeshPathing && NavigationHandle.LineCheck(GCD.Location, GCD.Location - vect(0.0, 0.0, 3.0) * GCD.CylinderComponent.CollisionHeight, vect(0.0, 0.0, 0.0)))
            {
                GCD.bHasNavigationMesh = false;
                continue;
            }
            if (!GCD.bIsBeyondSpawnDistance)
            {
                GCD.bCanSpawnHereNow = true;
                HitActor = Trace(HitLocation, HitNormal, GCD.Location, ViewLocation, false);
                if (HitActor != none)
                {
                    GCD.bIsVisible = false;
                    HitActor = Trace(HitLocation, HitNormal, GCD.Location, PredictionLocation, false);
                    if (HitActor == none)
                    {
                        GCD.bWillBeVisible = true;
                    }
                }
                continue;
            }
            for (J = 0; J < GCD.NextDestinations.Length; J++)
            {
                NextGCD = GCD.NextDestinations[J];
                if (NextGCD != none && NextGCD.bIsVisible && NextGCD.bCanSpawnHereNow && !NextGCD.bIsBeyondSpawnDistance)
                {
                    GCD.bAdjacentToVisibleNode = true;
                    GCD.bCanSpawnHereNow = true;
                    GCD.bIsVisible = false;
                }
            }
        }
    }
    for (I = StartIndex; I < StopIndex; I++)
    {
        GCD = PotentialSpawnPoints[I];
        PrioritizedSpawnPoints.RemoveItem(GCD);
        if (!GCD.bIsVisible && GCD.bCanSpawnHereNow)
        {
            if (GCD.bWillBeVisible || GCD.bAdjacentToVisibleNode)
            {
                AddPrioritizedSpawnPoint(GCD, ViewLocation);
                continue;
            }
            for (J = 0; J < GCD.NextDestinations.Length; J++)
            {
                if (GCD.NextDestinations[J] != none && GCD.NextDestinations[J].bCanSpawnHereNow && GCD.NextDestinations[J].bIsVisible)
                {
                    AddPrioritizedSpawnPoint(GCD, ViewLocation);
                    break;
                }
            }
        }
    }
}

function PrioritizeSpawnPoints(float DeltaSeconds)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal, ViewLocation, PredictionLocation;
    local PlayerController PC;
    local int UpdateNum;
    local Rotator ViewRotation;
    
    foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
    {
        PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
        PredictionLocation = ViewLocation + PlayerPositionPredictionTime * PC.ViewTarget.Velocity;
        break;
    }
    if (PC == none || PotentialSpawnPoints.Length == 0)
    {
        return;
    }
    HitActor = PC.Trace(HitLocation, HitNormal, PredictionLocation, ViewLocation, false);
    if (HitActor != none)
    {
        PredictionLocation = (7.0 * HitLocation + 3.0 * ViewLocation) / 10.0;
    }
    UpdateNum = Max(1, int(DeltaSeconds * float(PotentialSpawnPoints.Length) / SpawnPrioritizationInterval));
    if (PrioritizationUpdateIndex + UpdateNum >= PotentialSpawnPoints.Length)
    {
        AnalyzeSpawnPoints(PrioritizationUpdateIndex, PotentialSpawnPoints.Length, ViewLocation, PredictionLocation);
        UpdateNum = Max(0, UpdateNum - (PotentialSpawnPoints.Length - PrioritizationUpdateIndex));
        PrioritizationUpdateIndex = 0;
    }
    AnalyzeSpawnPoints(PrioritizationUpdateIndex, Min(PotentialSpawnPoints.Length, PrioritizationUpdateIndex + UpdateNum), ViewLocation, PredictionLocation);
    PrioritizationUpdateIndex += UpdateNum;
}

function GameCrowdDestination PickSpawnPoint()
{
    local int StartingIndex;
    local GameCrowdDestination Candidate;
    
    StartingIndex = Min(PrioritizationIndex, PrioritizedSpawnPoints.Length);
    while (PrioritizationIndex < PrioritizedSpawnPoints.Length)
    {
        Candidate = PrioritizedSpawnPoints[PrioritizationIndex];
        PrioritizationIndex++;
        if (ValidateSpawnAt(Candidate))
        {
            return Candidate;
        }
    }
    PrioritizationIndex = 0;
    while (PrioritizationIndex < StartingIndex)
    {
        Candidate = PrioritizedSpawnPoints[PrioritizationIndex];
        PrioritizationIndex++;
        if (ValidateSpawnAt(Candidate))
        {
            return Candidate;
        }
    }
    return none;
}

function Tick(float DeltaSeconds)
{
    local GameCrowdDestination PickedSpawnPoint;
    local float CurrentSpawnRate;
    local bool bSpawnedAgent;
    
    if (!bSpawningActive || AgentCount >= SpawnNum)
    {
        return;
    }
    CurrentSpawnRate = SpawnRate;
    Remainder += FMin(DeltaSeconds, 0.05) * CurrentSpawnRate;
    if (!bHaveInitialPopulation)
    {
        Remainder = FMax(Remainder, InitialPopulationPct * float(SpawnNum));
    }
    PrioritizeSpawnPoints(DeltaSeconds);
    if (Remainder > 1.0)
    {
        while (Remainder > 1.0 && AgentCount < SpawnNum)
        {
            PickedSpawnPoint = PickSpawnPoint();
            if (PickedSpawnPoint != none)
            {
                PickedSpawnPoint.LastSpawnTime = WorldInfo.TimeSeconds;
                SpawnAgent(PickedSpawnPoint);
                Remainder -= 1.0;
                bSpawnedAgent = true;
                continue;
            }
            Remainder = 0.0;
        }
        bHaveInitialPopulation = bHaveInitialPopulation || bSpawnedAgent;
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local int RenderedNum, LOSNum, SimNum, ActualCount, WTFNum, DistanceBucket[10], I;
    local Actor HitActor;
    local Vector HitNormal, HitLocation, ViewLocation;
    local Rotator ViewRotation;
    local PlayerController PC;
    local GameCrowdAgent GCD;
    local float Dist;
    
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("SpawnedList " $ string(AgentCount) $ " out of " $ string(SpawnNum));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
    {
        PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
        break;
    }
    foreach DynamicActors(class'GameCrowdAgent', GCD)
    {
        if (EqualEqual_InterfaceInterface(GCD.MySpawner, GameCrowdSpawnerInterface(self)))
        {
            ActualCount++;
            if (GCD.Health > 0)
            {
                if (GCD.bSimulateThisTick)
                {
                    SimNum++;
                }
                if (WorldInfo.TimeSeconds - GCD.LastRenderTime < 1.0 && GCD.LastRenderTime != GCD.InitialLastRenderTime)
                {
                    RenderedNum++;
                    LOSNum++;
                }
                else
                {
                    HitActor = PC.Trace(HitLocation, HitNormal, GCD.Location, ViewLocation, false);
                    if (HitActor == none)
                    {
                        LOSNum++;
                    }
                    else if (GCD.CurrentDestination == none || !GCD.CurrentDestination.bIsVisible && !GCD.CurrentDestination.bWillBeVisible)
                    {
                        WTFNum++;
                    }
                }
            }
            Dist = VSize(ViewLocation - GCD.Location);
            DistanceBucket[Min(9, int(5.0 * Dist / MaxSpawnDist))]++;
        }
    }
    if (ActualCount != AgentCount)
    {
        Canvas.DrawText("WARNING:  ActualCount " $ string(ActualCount) $ " does not match AgentCount " $ string(AgentCount));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    Canvas.DrawText("Spawned " $ string(SpawnedCount) $ " recycled " $ string(PoolCount) $ " Killed from pool " $ string(KilledCount));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("Agents Rendered " $ string(RenderedNum) $ " in LOS " $ string(LOSNum) $ " Simulated this tick " $ string(SimNum) $ " Not useful " $ string(WTFNum));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("Distance Buckets");
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    for (I = 0; I < 9; I++)
    {
        Canvas.DrawText(" (<" $ string(0.2 * MaxSpawnDist * float(I + 1)) $ ")" $ string(DistanceBucket[I]));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}

function bool AddToAgentPool(GameCrowdAgent Agent)
{
    if (AgentPool.Length >= MaxAgentPoolSize)
    {
        if (MaxAgentPoolSize == 0)
        {
            return false;
        }
        KilledCount++;
        AgentPool[0].LifeSpan = -0.1;
        AgentPool[0].TimeSinceLastTick = 1000.0;
        AgentPool.Remove(0, 1);
    }
    AgentPool[AgentPool.Length] = Agent;
    return true;
}

function AgentDestroyed(GameCrowdAgent Agent)
{
    AgentCount--;
}

function OnGameCrowdPopulationManagerToggle(SeqAct_GameCrowdPopulationManagerToggle inAction)
{
    local GameCrowdAgent Agent;
    local int I;
    
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bSpawningActive = true;
        if (inAction.WarmupPct > 0.0)
        {
            InitialPopulationPct = FMax(0.0, inAction.WarmupPct - float(AgentCount / SpawnNum));
            bHaveInitialPopulation = false;
        }
        if (inAction.bClearOldArchetypes)
        {
            AgentArchetypes.Length = 0;
        }
        if (inAction.CrowdAgentList != none)
        {
            for (I = 0; I < inAction.CrowdAgentList.ListOfAgents.Length; I++)
            {
                AgentArchetypes[AgentArchetypes.Length] = inAction.CrowdAgentList.ListOfAgents[I];
            }
        }
        MaxSpawnDist = inAction.MaxSimulationDistance;
        MaxSpawnDistSq = MaxSpawnDist * MaxSpawnDist;
        MinBehindSpawnDistSq = MaxSpawnDistSq * 0.0625;
        bCastShadows = inAction.bCastShadows;
        bEnableCrowdLightEnvironment = inAction.bEnableCrowdLightEnvironment;
        SpawnRate = inAction.SpawnRate;
        SpawnNum = inAction.MaxAgents;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bSpawningActive = false;
        if (inAction.bKillAgentsInstantly)
        {
            foreach DynamicActors(class'GameCrowdAgent', Agent)
            {
                if (EqualEqual_InterfaceInterface(Agent.MySpawner, GameCrowdSpawnerInterface(self)))
                {
                    Agent.Destroy();
                }
            }
        }
    }
}

function RemoveSpawnPoint(GameCrowdDestination GCD)
{
    GCD.MyPopMgr = none;
}

function AddSpawnPoint(GameCrowdDestination GCD)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local int J;
    local bool bInsertedSpawnPoint;
    local Vector ViewLocation, PredictionLocation;
    local Rotator ViewRotation;
    local PlayerController PC;
    
    if (GCD.MyPopMgr != none)
    {
        return;
    }
    GCD.MyPopMgr = self;
    if (GCD.bAllowsSpawning)
    {
        PotentialSpawnPoints[PotentialSpawnPoints.Length] = GCD;
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
            PredictionLocation = ViewLocation + PlayerPositionPredictionTime * PC.ViewTarget.Velocity;
            break;
        }
        GCD.bIsBeyondSpawnDistance = FMin(VSizeSq(ViewLocation - GCD.Location), VSizeSq(PredictionLocation - GCD.Location)) > MaxSpawnDistSq;
        GCD.bCanSpawnHereNow = GCD.bIsEnabled && GCD.bAllowsSpawning && !GCD.bIsBeyondSpawnDistance;
        GCD.bIsVisible = true;
        if (GCD.bCanSpawnHereNow)
        {
            HitActor = Trace(HitLocation, HitNormal, GCD.Location, ViewLocation, false);
            if (HitActor == none)
            {
                GCD.Priority = 1.0 / VSizeSq(GCD.Location - ViewLocation);
                bInsertedSpawnPoint = false;
                for (J = 0; J < PrioritizedSpawnPoints.Length; J++)
                {
                    if (PrioritizedSpawnPoints[J].Priority < GCD.Priority)
                    {
                        PrioritizedSpawnPoints.Insert(J, 1);
                        PrioritizedSpawnPoints[J] = GCD;
                        bInsertedSpawnPoint = true;
                        break;
                    }
                }
                if (!bInsertedSpawnPoint)
                {
                    PrioritizedSpawnPoints[PrioritizedSpawnPoints.Length] = GCD;
                }
            }
        }
    }
}

function float GetMaxSpawnDist()
{
    return MaxSpawnDist;
}

event NotifyPathChanged()
{
}

function PostBeginPlay()
{
    local GameCrowdDestination GCD;
    
    PostBeginPlay();
    if (class'Engine.Engine'.static.IsSplitScreen())
    {
        SpawnNum = int(SplitScreenNumReduction * float(SpawnNum));
    }
    if (!bDeleteMe)
    {
        WorldInfo.PopulationManager = self;
    }
    if (NavigationHandleClass != none)
    {
        NavigationHandle = new(self) NavigationHandleClass;
    }
    MaxSpawnDistSq = MaxSpawnDist * MaxSpawnDist;
    foreach AllActors(class'GameCrowdDestination', GCD)
    {
        AddSpawnPoint(GCD);
    }
}

defaultproperties
{
    bSpawningActive=True
    bForceNavMeshPathing=True
    bWarmupPosition=True
    SpawnRate=50.0
    SpawnNum=700
    SplitScreenNumReduction=0.5
    MaxAgentPoolSize=20
    AgentLightingChannel=(bInitialized=True,BSP=False,Static=False,Dynamic=False,CompositeDynamic=False,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,PhysXLighting_1=False,PhysXLighting_2=False,PhysXLighting_3=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=True)
    AgentWarmupTime=2.0
    SpawnPrioritizationInterval=0.4
    PlayerPositionPredictionTime=5.0
    MaxSpawnDist=20000.0
    MinBehindSpawnDistSq=25000000.0
    HeadVisibilityOffset=40.0
    InitialPopulationPct=0.5
    NavigationHandleClass="Engine.NavigationHandle"
    bHidden=True
    bSkipActorPropertyReplication=True
    bOnlyDirtyReplication=True
    NetUpdateFrequency=10.0
}
