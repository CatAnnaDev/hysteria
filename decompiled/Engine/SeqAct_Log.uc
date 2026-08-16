class SeqAct_Log extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bOutputToScreen;
var() bool bIncludeObjComment;
var() float TargetDuration;
var() Vector TargetOffset;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    bOutputToScreen=True
    bIncludeObjComment=True
    TargetDuration=-1.0
    VariableLinks(0)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="String",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Float",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Bool",LinkedVariables=(),LinkDesc="Bool",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(4)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Int",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(5)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(6)=(ExpectedType="SeqVar_ObjectList",LinkedVariables=(),LinkDesc="Obj List",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Log"
    ObjCategory="Misc"
}
