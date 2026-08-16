class SeqAct_ActorFactory extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

enum EPointSelection
{
    PS_Normal,
    PS_Random,
    PS_Reverse,
};

var() bool bEnabled;
var bool bIsSpawning;
var() bool bCheckSpawnCollision;
var() export editinline ActorFactory Factory;
var() EPointSelection PointSelection;
var() array<Actor> SpawnPoints;
var() array<Vector> SpawnLocations;
var() array<Vector> SpawnOrientations;
var() int SpawnCount;
var() float SpawnDelay;
var int LastSpawnIdx;
var int SpawnedCount;
var float RemainingDelay;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 0;
}

defaultproperties
{
    bEnabled=True
    bCheckSpawnCollision=True
    SpawnCount=1
    SpawnDelay=0.5
    LastSpawnIdx=-1
    InputLinks(0)=(LinkDesc="Spawn Actor",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Disable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(3)=(LinkDesc="Toggle",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Spawn Point",LinkVar="None",PropertyName="SpawnPoints",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Spawned",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Spawn Count",LinkVar="None",PropertyName="SpawnCount",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Spawn Location",LinkVar="None",PropertyName="SpawnLocations",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(4)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Spawn Direction",LinkVar="None",PropertyName="SpawnOrientations",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Actor Factory"
    ObjCategory="Actor"
}
