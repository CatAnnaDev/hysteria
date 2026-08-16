class SeqAct_SetVelocity extends SequenceAction
    notplaceable
    hidecategories(Object);

var() Vector VelocityDir;
var() float VelocityMag;
var() bool bVelocityRelativeToActorRotation;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 0;
}

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Velocity Dir",LinkVar="None",PropertyName="VelocityDir",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Velocity Mag",LinkVar="None",PropertyName="VelocityMag",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set Velocity"
    ObjCategory="Actor"
}
