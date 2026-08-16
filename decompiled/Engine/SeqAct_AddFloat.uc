class SeqAct_AddFloat extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var() float ValueA;
var() float ValueB;
var float FloatResult;
var int IntResult;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="A",LinkVar="None",PropertyName="ValueA",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="B",LinkVar="None",PropertyName="ValueB",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="FloatResult",LinkVar="None",PropertyName="FloatResult",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="IntResult",LinkVar="None",PropertyName="IntResult",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Add Float"
    ObjCategory="Math"
}
