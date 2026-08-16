class SeqAct_Switch extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() int LinkCount;
var() int IncrementAmount;
var() bool bLooping;
var() bool bAutoDisableLinks;
var() array<int> Indices;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    LinkCount=1
    IncrementAmount=1
    Indices(0)=1
    OutputLinks(0)=(Links=(),LinkDesc="Link 1",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Index",LinkVar="None",PropertyName="Indices",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Switch"
    ObjCategory="Switch"
}
