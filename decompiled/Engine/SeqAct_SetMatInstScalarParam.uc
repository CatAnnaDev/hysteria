class SeqAct_SetMatInstScalarParam extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() MaterialInstanceConstant MatInst;
var() name ParamName;
var() float ScalarValue;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="ScalarValue",LinkVar="None",PropertyName="ScalarValue",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set ScalarParam"
    ObjCategory="Material Instance"
}
