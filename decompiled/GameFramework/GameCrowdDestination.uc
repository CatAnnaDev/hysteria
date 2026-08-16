class GameCrowdDestination extends GameCrowdInteractionPoint
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics)
    implements(GameCrowdSpawnInterface,EditorLinkSelectionInterface);

var const native noexport Pointer VfTable_IEditorLinkSelectionInterface;
var() bool bKillWhenReached;
var() bool bAllowAsPreviousDestination;
var bool bLastAllowableResult;
var() bool bAvoidWhenPanicked;
var() bool bSkipBehaviorIfPanicked;
var() bool bFleeDestination;
var() bool bMustReachExactly;
var bool bHasRestrictions;
var(Spawning) bool bAllowsSpawning;
var(Spawning) bool bLineSpawner;
var(Spawning) bool bSpawnAtEdge;
var() bool bSoftPerimeter;
var bool bIsVisible;
var bool bWillBeVisible;
var bool bCanSpawnHereNow;
var bool bIsBeyondSpawnDistance;
var bool bAdjacentToVisibleNode;
var bool bHasNavigationMesh;
var() duplicatetransient array<GameCrowdDestination> NextDestinations;
var() duplicatetransient GameCrowdDestinationQueuePoint QueueHead;
var() int Capacity;
var() float Frequency;
var int CustomerCount;
var(Restrictions) array<class<GameCrowdAgent>> SupportedAgentClasses;
var(Restrictions) array<Object> SupportedArchetypes;
var(Restrictions) array<class<GameCrowdAgent>> RestrictedAgentClasses;
var(Restrictions) array<Object> RestrictedArchetypes;
var float ExactReachTolerance;
var() name InteractionTag;
var() float InteractionDelay;
var(Spawning) float SpawnRadius;
var() array<BehaviorEntry> ReachedBehaviors;
var GameCrowdAgent AgentEnRoute;
var float Priority;
var float LastSpawnTime;
var transient GameCrowdPopulationManager MyPopMgr;

simulated function GetSpawnPosition(SeqAct_GameCrowdSpawner Spawner, out Vector SpawnPos, out Rotator SpawnRot)
{
    local Vector SpawnLine;
    local float RandScale;
    
    if (bLineSpawner)
    {
        RandScale = -1.0 + 2.0 * FRand();
        SpawnLine = vect(0.0, 1.0, 0.0) >> Rotation;
        SpawnPos = Location + RandScale * SpawnLine * SpawnRadius;
        SpawnRot.Yaw = Rotation.Yaw;
    }
    else
    {
        SpawnRot = RotRand(false);
        SpawnRot.Pitch = 0;
        if (bSpawnAtEdge)
        {
            SpawnPos = Location + (vect(1.0, 0.0, 0.0) * SpawnRadius >> SpawnRot);
        }
        else
        {
            SpawnPos = Location + (vect(1.0, 0.0, 0.0) * FRand() * SpawnRadius >> SpawnRot);
        }
    }
}

simulated event bool AllowableDestinationFor(GameCrowdAgent Agent)
{
    local int I, Num;
    
    bLastAllowableResult = bHasNavigationMesh;
    if (bLastAllowableResult)
    {
        bLastAllowableResult = !bIsBeyondSpawnDistance;
    }
    if (bLastAllowableResult)
    {
        bLastAllowableResult = bIsEnabled && Agent.CurrentBehavior != none ? Agent.CurrentBehavior.AllowThisDestination(self) : bAllowAsPreviousDestination || Agent.PreviousDestination != self;
    }
    if (bLastAllowableResult)
    {
        if (Agent.MyGroup != none)
        {
            bLastAllowableResult = CustomerCount + Agent.MyGroup.Members.Length <= Capacity;
        }
        else
        {
            bLastAllowableResult = CustomerCount < Capacity || QueueHead != none && QueueHead.HasSpace();
        }
    }
    if (bLastAllowableResult && InteractionTag != 'None')
    {
        I = Agent.RecentInteractions.Find('InteractionTag', InteractionTag);
        if (I != -1 && Agent.RecentInteractions[I].InteractionDelay == 0.0 || WorldInfo.TimeSeconds < Agent.RecentInteractions[I].InteractionDelay)
        {
            bLastAllowableResult = false;
            return false;
        }
        else if (I != -1)
        {
            Agent.RecentInteractions.Remove(I, 1);
        }
    }
    if (bLastAllowableResult && bHasRestrictions)
    {
        Num = SupportedAgentClasses.Length;
        bLastAllowableResult = Num == 0 && SupportedArchetypes.Length == 0;
        if (Num > 0)
        {
            for (I = 0; I < Num; I++)
            {
                if (ClassIsChildOf(Agent.Class, SupportedAgentClasses[I]))
                {
                    bLastAllowableResult = true;
                    break;
                }
            }
        }
        if (!bLastAllowableResult)
        {
            Num = SupportedArchetypes.Length;
            if (Num > 0)
            {
                for (I = 0; I < Num; I++)
                {
                    if (SupportedArchetypes[I] == Agent.MyArchetype)
                    {
                        bLastAllowableResult = true;
                        break;
                    }
                }
            }
        }
        if (bLastAllowableResult)
        {
            Num = RestrictedAgentClasses.Length;
            if (Num > 0)
            {
                for (I = 0; I < Num; I++)
                {
                    if (ClassIsChildOf(Agent.Class, RestrictedAgentClasses[I]))
                    {
                        bLastAllowableResult = false;
                        break;
                    }
                }
            }
        }
        if (bLastAllowableResult)
        {
            Num = RestrictedArchetypes.Length;
            if (Num > 0)
            {
                for (I = 0; I < Num; I++)
                {
                    if (RestrictedArchetypes[I] == Agent.MyArchetype)
                    {
                        bLastAllowableResult = false;
                        break;
                    }
                }
            }
        }
    }
    return bLastAllowableResult;
}

simulated function bool AtCapacity()
{
    return CustomerCount >= Capacity;
}

simulated event IncrementCustomerCount(GameCrowdAgent ArrivingAgent)
{
    if (CustomerCount >= Capacity || QueueHead != none && QueueHead.bPendingAdvance)
    {
        if (QueueHead != none && QueueHead.HasSpace())
        {
            if (AgentEnRoute != none && AgentEnRoute.CurrentBehavior == none && !ReachedByAgent(AgentEnRoute, AgentEnRoute.Location, false) && VSizeSq(ArrivingAgent.Location - Location) < VSizeSq(AgentEnRoute.Location - Location))
            {
                QueueHead.AddCustomer(AgentEnRoute, self);
                AgentEnRoute = ArrivingAgent;
            }
            else
            {
                QueueHead.AddCustomer(ArrivingAgent, self);
            }
        }
        else
        {
            WarnInternal(string(self) $ " added customer " $ string(ArrivingAgent) $ " beyond capacity with queue " $ string(QueueHead));
        }
    }
    else
    {
        AgentEnRoute = ArrivingAgent;
        CustomerCount++;
    }
}

simulated event DecrementCustomerCount(GameCrowdAgent DepartingAgent)
{
    local GameCrowdDestinationQueuePoint QP;
    local bool bIsInQueue;
    
    if (DepartingAgent.CurrentDestination == self)
    {
        QP = QueueHead;
        while (QP != none)
        {
            if (QP.QueuedAgent == DepartingAgent)
            {
                bIsInQueue = true;
                QP.ClearQueue(DepartingAgent);
                break;
            }
            QP = QP.NextQueuePosition;
        }
        if (!bIsInQueue)
        {
            CustomerCount--;
            if (QueueHead != none && QueueHead.HasCustomer())
            {
                QueueHead.AdvanceCustomerTo(self);
            }
        }
    }
}

simulated function PickNewDestinationFor(GameCrowdAgent Agent, bool bIgnoreRestrictions)
{
    local int I;
    local float DestinationFrequencySum, DestinationPickValue;
    
    DecrementCustomerCount(Agent);
    Agent.CurrentDestination = none;
    Agent.BehaviorDestination = none;
    for (I = 0; I < NextDestinations.Length; I++)
    {
        if (NextDestinations[I] != none && bIgnoreRestrictions || NextDestinations[I].AllowableDestinationFor(Agent))
        {
            DestinationFrequencySum += NextDestinations[I].Frequency * (!bIsVisible && Agent.bPreferVisibleDestination && NextDestinations[I].bIsVisible || NextDestinations[I].bWillBeVisible ? 2.0 : 1.0);
        }
    }
    DestinationPickValue = DestinationFrequencySum * FRand();
    DestinationFrequencySum = 0.0;
    for (I = 0; I < NextDestinations.Length; I++)
    {
        if (NextDestinations[I] != none && bIgnoreRestrictions || NextDestinations[I].bLastAllowableResult)
        {
            DestinationFrequencySum += NextDestinations[I].Frequency * (!bIsVisible && Agent.bPreferVisibleDestination && NextDestinations[I].bIsVisible || NextDestinations[I].bWillBeVisible ? 2.0 : 1.0);
            if (DestinationPickValue < DestinationFrequencySum)
            {
                Agent.SetCurrentDestination(NextDestinations[I]);
                Agent.PreviousDestination = self;
                Agent.UpdateIntermediatePoint();
                break;
            }
        }
    }
    Agent.PreviousDestination = self;
}

simulated event ReachedDestination(GameCrowdAgent Agent)
{
    local int I, J;
    local SeqEvent_CrowdAgentReachedDestination ReachedEvent;
    local bool bEventActivated;
    
    if (bKillWhenReached)
    {
        DecrementCustomerCount(Agent);
        Agent.CurrentDestination = none;
        Agent.KillAgent();
        return;
    }
    if (InteractionTag != 'None')
    {
        I = Agent.RecentInteractions.Add(1);
        Agent.RecentInteractions[I].InteractionTag = InteractionTag;
        if (InteractionDelay > 0.0)
        {
            Agent.RecentInteractions[I].InteractionDelay = WorldInfo.TimeSeconds + InteractionDelay;
        }
    }
    if (Agent.BehaviorDestination != self && Agent.CurrentBehavior == none || Agent.CurrentBehavior.AllowBehaviorAt(self))
    {
        if (ReachedBehaviors.Length > 0)
        {
            Agent.PickBehaviorFrom(ReachedBehaviors);
        }
        for (I = 0; I < GeneratedEvents.Length; I++)
        {
            ReachedEvent = SeqEvent_CrowdAgentReachedDestination(GeneratedEvents[I]);
            if (ReachedEvent != none)
            {
                Agent.BehaviorDestination = self;
                for (J = 0; J < ReachedEvent.OutputLinks[0].Links.Length; J++)
                {
                    ReachedEvent.OutputLinks[0].Links[J].LinkedOp.bActive = false;
                }
                bEventActivated = ReachedEvent.CheckActivate(self, Agent);
                break;
            }
        }
    }
    if (!bEventActivated && NextDestinations.Length > 0)
    {
        PickNewDestinationFor(Agent, false);
        if (Agent.CurrentDestination == none)
        {
            if (WorldInfo.TimeSeconds - Agent.LastRenderTime > Agent.default.NotVisibleLifeSpan)
            {
                Agent.KillAgent();
            }
            else
            {
                PickNewDestinationFor(Agent, true);
            }
        }
    }
    if (Agent.MyGroup != none)
    {
        Agent.MyGroup.UpdateDestinations(Agent.CurrentDestination);
    }
}

simulated function Destroyed()
{
    Destroyed();
    if (MyPopMgr != none)
    {
        MyPopMgr.RemoveSpawnPoint(self);
    }
}

simulated function PostBeginPlay()
{
    local int I;
    local GameCrowdPopulationManager PopMgr;
    
    PostBeginPlay();
    bHasRestrictions = SupportedAgentClasses.Length > 0 || SupportedArchetypes.Length > 0 || RestrictedAgentClasses.Length > 0 || RestrictedArchetypes.Length > 0;
    if (QueueHead != none || Capacity < 10 || bKillWhenReached)
    {
        bAllowsSpawning = false;
    }
    for (I = 0; I < ReachedBehaviors.Length; I++)
    {
        if (ReachedBehaviors[I].BehaviorArchetype == none)
        {
            WarnInternal(string(self) $ " missing BehaviorArchetype at ReachedBehavior " $ string(I));
            ReachedBehaviors.Remove(I, 1);
            I--;
        }
    }
    PopMgr = GameCrowdPopulationManager(WorldInfo.PopulationManager);
    if (PopMgr != none)
    {
        PopMgr.AddSpawnPoint(self);
    }
}

native simulated function bool ReachedByAgent(GameCrowdAgent Agent, Vector TestPosition, bool bTestExactly)
{
    Agent;
    TestPosition;
    bTestExactly;
}

defaultproperties
{
    bSkipBehaviorIfPanicked=True
    bAllowsSpawning=True
    bSoftPerimeter=True
    bHasNavigationMesh=True
    Capacity=1000
    Frequency=1.0
    ExactReachTolerance=3.0
    SpawnRadius=200.0
    CylinderComponent="Default__GameCrowdDestination.CollisionCylinder"
    bStatic=True
    bForceAllowKismetModification=True
    Components(0)="Default__GameCrowdDestination.CollisionCylinder"
    Components(1)="Default__GameCrowdDestination.Sprite"
    Components(2)="Default__GameCrowdDestination.ConnectionRenderer"
    CollisionComponent="Default__GameCrowdDestination.CollisionCylinder"
    SupportedEvents(0)="SeqEvent_CrowdAgentReachedDestination"
}
