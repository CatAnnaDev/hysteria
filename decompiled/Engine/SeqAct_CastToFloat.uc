class SeqAct_CastToFloat extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var int Value;
var float FloatResult;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Int",LinkVar="None",PropertyName="Value",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Result",LinkVar="None",PropertyName="FloatResult",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Cast To Float"
    ObjCategory="Math"
}
