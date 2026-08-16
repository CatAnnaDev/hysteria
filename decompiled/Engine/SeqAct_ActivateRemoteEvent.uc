class SeqAct_ActivateRemoteEvent extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() Actor Instigator;
var() name EventName;
var transient bool bStatusIsOk;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

defaultproperties
{
    EventName="DefaultEvent"
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Activate Remote Event"
    ObjCategory="Event"
}
