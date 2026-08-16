class SeqAct_GameCrowdPopulationManagerToggle extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() float WarmupPct;
var() bool bKillAgentsInstantly;
var() bool bClearOldArchetypes;
var() bool bEnableCrowdLightEnvironment;
var() bool bCastShadows;
var() GameCrowd_ListOfAgents CrowdAgentList;
var() int MaxAgents;
var() float SpawnRate;
var() float MaxSimulationDistance;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

event FindPopMgrTarget()
{
    Targets[0] = GameCrowdPopulationManager(GetWorldInfo().PopulationManager);
    if (Targets[0] == none)
    {
        Targets[0] = GetWorldInfo().Spawn(class'GameCrowdPopulationManager');
    }
}

defaultproperties
{
    MaxAgents=700
    SpawnRate=50.0
    MaxSimulationDistance=20000.0
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Population Manager Toggle"
    ObjCategory="Crowd"
}
