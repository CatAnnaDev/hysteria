class SeqAct_SetBool extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var() bool DefaultValue;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Bool",LinkedVariables=(),LinkDesc="Value",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Bool",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Bool"
}
