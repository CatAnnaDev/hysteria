class SeqAct_IsInObjectList extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bCheckForAllObjects;
var transient bool bObjectFound;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    bCheckForAllObjects=True
    InputLinks(0)=(LinkDesc="Test if in List",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="In List",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Not in List",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Object(s)ToTest",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_ObjectList",LinkedVariables=(),LinkDesc="ObjectListVar",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="IsIn ObjectList"
    ObjCategory="Object List"
}
