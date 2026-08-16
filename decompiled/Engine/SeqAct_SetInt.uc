class SeqAct_SetInt extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var int Target;
var() array<int> Value;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Value",LinkVar="None",PropertyName="Value",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Int"
}
