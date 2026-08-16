class SeqAct_ParticleEventGenerator extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bEnabled;
var() bool bUseEmitterLocation;
var Actor Instigator;
var array<string> EventNames;
var float EventTime;
var Vector EventLocation;
var Vector EventDirection;
var Vector EventVelocity;
var Vector EventNormal;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 0;
}

defaultproperties
{
    bEnabled=True
    InputLinks(0)=(LinkDesc="Trigger Event",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Disable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(3)=(LinkDesc="Toggle",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="EventNames",LinkVar="None",PropertyName="EventNames",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="EventTime",LinkVar="None",PropertyName="EventTime",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Location",LinkVar="None",PropertyName="EventLocation",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(4)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Direction",LinkVar="None",PropertyName="EventDirection",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(5)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Velocity",LinkVar="None",PropertyName="EventVelocity",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(6)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Normal",LinkVar="None",PropertyName="EventNormal",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="ParticleEvent Generator"
    ObjCategory="Particles"
}
