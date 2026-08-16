class SeqAct_ToggleInput extends SeqAct_Toggle
    notplaceable
    hidecategories(Object);

var() bool bToggleMovement;
var() bool bToggleTurning;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

defaultproperties
{
    bToggleMovement=True
    bToggleTurning=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=True,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Toggle Input"
}
