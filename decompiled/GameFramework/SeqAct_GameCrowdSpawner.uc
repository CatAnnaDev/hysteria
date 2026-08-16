class SeqAct_GameCrowdSpawner extends SeqAct_Latent
    abstract
    native
    notplaceable
    hidecategories(Object);

struct native AgentArchetypeInfo
{
    var() Object AgentArchetype;
    var() float FrequencyModifier;
    var() array<Object> GroupMembers;
};

var bool bSpawningActive;
var() bool bCycleSpawnLocs;
var() bool bRespawnDeadAgents;
var bool bHasReducedNumberDueToSplitScreen;
var(Lighting) bool bEnableCrowdLightEnvironment;
var() bool bForceObstacleChecking;
var() bool bForceNavMeshPathing;
var() bool bOnlySpawnHidden;
var() bool bWarmupPosition;
var(Lighting) bool bCastShadows;
var int NextDestinationIndex;
var transient array<Actor> SpawnLocs;
var transient int LastSpawnLocIndex;
var() float SpawnRate;
var() int SpawnNum;
var() float SpawnRadius;
var() float SplitScreenNumReduction;
var float Remainder;
var float AgentFrequencySum;
var() GameCrowd_ListOfAgents CrowdAgentList;
var transient array<AgentArchetypeInfo> AgentArchetypes;
var transient array<GameCrowdAgent> SpawnedList;
var(Lighting) LightingChannelContainer AgentLightingChannel;
var GameCrowdReplicationActor RepActor;
var() float AgentWarmupTime;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 3;
}

function GameCrowdAgent CreateNewAgent(Actor SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup)
{
    local GameCrowdAgent Agent;
    local Rotator SpawnRot;
    local Vector SpawnPos;
    
    if (NotEqual_InterfaceInterface(GameCrowdSpawnInterface(SpawnLoc), GameCrowdSpawnInterface(none)))
    {
        GameCrowdSpawnInterface(SpawnLoc).GetSpawnPosition(self, SpawnPos, SpawnRot);
    }
    else
    {
        SpawnRot = RotRand(false);
        SpawnRot.Pitch = 0;
        SpawnPos = SpawnLoc.Location + (vect(1.0, 0.0, 0.0) * FRand() * SpawnRadius >> SpawnRot);
    }
    Agent = SpawnLoc.Spawn(AgentTemplate.Class, SpawnLoc, , SpawnPos, SpawnRot, AgentTemplate);
    Agent.SetLighting(bEnableCrowdLightEnvironment, AgentLightingChannel, bCastShadows);
    if (bForceObstacleChecking)
    {
        Agent.bCheckForObstacles = true;
    }
    if (bForceNavMeshPathing)
    {
        Agent.bUseNavMeshPathing = true;
    }
    Agent.InitializeAgent(SpawnLoc, AgentTemplate, NewGroup, AgentWarmupTime * 2.0 * FRand(), bWarmupPosition, true);
    SpawnedList[SpawnedList.Length] = Agent;
    return Agent;
}

event GameCrowdAgent SpawnAgent(Actor SpawnLoc)
{
    local GameCrowdAgent Agent;
    local float AgentPickValue, PickSum;
    local int I, PickedInfo;
    local GameCrowdAgent AgentTemplate;
    local GameCrowdGroup NewGroup;
    
    if (AgentFrequencySum == 0.0)
    {
        if (CrowdAgentList != none)
        {
            AgentArchetypes.Length = 0;
            for (I = 0; I < CrowdAgentList.ListOfAgents.Length; I++)
            {
                AgentArchetypes[AgentArchetypes.Length] = CrowdAgentList.ListOfAgents[I];
            }
        }
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
    SpawnedAgent(Agent);
    for (I = 0; I < AgentArchetypes[PickedInfo].GroupMembers.Length; I++)
    {
        if (GameCrowdAgent(AgentArchetypes[PickedInfo].GroupMembers[I]) != none)
        {
            CreateNewAgent(SpawnLoc, GameCrowdAgent(AgentArchetypes[PickedInfo].GroupMembers[I]), NewGroup);
        }
    }
    return Agent;
}

native simulated function UpdateSpawning(float DeltaSeconds)
{
    DeltaSeconds;
}

native simulated function KillAgents()
{
}

native simulated function CacheSpawnerVars()
{
}

native function SpawnedAgent(GameCrowdAgent NewAgent)
{
    NewAgent;
}

defaultproperties
{
    bRespawnDeadAgents=True
    bOnlySpawnHidden=True
    SpawnRate=10.0
    SpawnNum=100
    SpawnRadius=200.0
    SplitScreenNumReduction=0.5
    AgentLightingChannel=(bInitialized=True,BSP=False,Static=False,Dynamic=False,CompositeDynamic=False,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,PhysXLighting_1=False,PhysXLighting_2=False,PhysXLighting_3=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=True)
    AgentWarmupTime=5.0
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Destroy All",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Agent Spawned",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Spawn Points",LinkVar="None",PropertyName="SpawnPoints",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Spawned Agent",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Crowd Spawner (New)"
    ObjCategory="Crowd"
}
