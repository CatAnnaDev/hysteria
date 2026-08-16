class SeqAct_ConvertToString extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bIncludeVarComment;
var() string VarSeparator;
var() int NumberOfInputs;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    bIncludeVarComment=True
    VarSeparator=", "
    NumberOfInputs=1
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Inputs",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=True,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="Output",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Convert To String"
    ObjCategory="Misc"
}
