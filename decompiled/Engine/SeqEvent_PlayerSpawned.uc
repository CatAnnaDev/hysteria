class SeqEvent_PlayerSpawned extends SequenceEvent
    notplaceable
    hidecategories(Object);

var Object SpawnPoint;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Spawn Point",LinkVar="None",PropertyName="SpawnPoint",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Player Spawned"
    ObjCategory="Player"
}
