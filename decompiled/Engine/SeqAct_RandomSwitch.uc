class SeqAct_RandomSwitch extends SeqAct_Switch
    native
    notplaceable
    hidecategories(Object);

var array<int> AutoDisabledIndices;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    InputLinks(0)=(LinkDesc="In",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Reset",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Active Link",LinkVar="None",PropertyName="Indices",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Random"
}
