class SeqAct_CastToInt extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var() bool bTruncate;
var float Value;
var int IntResult;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Int",LinkVar="None",PropertyName="Value",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Result",LinkVar="None",PropertyName="IntResult",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Cast To Int"
    ObjCategory="Math"
}
