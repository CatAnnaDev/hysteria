class SeqAct_SetVector extends SeqAct_SetSequenceVariable
    notplaceable
    hidecategories(Object);

var() Vector DefaultValue;

event Activated()
{
    local bool bIgnoreDefault;
    local SeqVar_Vector VectVar;
    local Vector Value;
    
    foreach LinkedVariables(class'SeqVar_Vector', VectVar, "Value")
    {
        bIgnoreDefault = true;
        Value += VectVar.VectValue;
    }
    if (!bIgnoreDefault)
    {
        Value = DefaultValue;
    }
    foreach LinkedVariables(class'SeqVar_Vector', VectVar, "Target")
    {
        VectVar.VectValue = Value;
    }
}

defaultproperties
{
    bCallHandler=False
    VariableLinks(0)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Value",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Vector"
}
