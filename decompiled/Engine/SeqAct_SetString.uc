class SeqAct_SetString extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var string Target;
var() string Value;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 0;
}

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="Value",LinkVar="None",PropertyName="Value",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="String"
}
