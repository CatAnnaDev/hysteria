class SeqAct_SetParticleSysParam extends SequenceAction
    notplaceable
    hidecategories(Object);

var() export editinline array<ParticleSysParam> InstanceParameters;
var() bool bOverrideScalar;
var() float ScalarValue;

defaultproperties
{
    bOverrideScalar=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Scalar Value",LinkVar="None",PropertyName="ScalarValue",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set Particle Param"
    ObjCategory="Particles"
}
