class SeqEvent_ParticleEvent extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

enum EParticleEventOutputType
{
    ePARTICLEOUT_Spawn,
    ePARTICLEOUT_Death,
    ePARTICLEOUT_Collision,
    ePARTICLEOUT_Kismet,
};

var EParticleEventOutputType EventType;
var Vector EventPosition;
var float EventEmitterTime;
var Vector EventVelocity;
var float EventParticleTime;
var Vector EventNormal;
var() bool UseRelfectedImpactVector;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 0;
}

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=False
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Type",LinkVar="None",PropertyName="EventType",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Pos",LinkVar="None",PropertyName="EventPosition",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="ETime",LinkVar="None",PropertyName="EventEmitterTime",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(4)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Vel",LinkVar="None",PropertyName="EventVelocity",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(5)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="PTime",LinkVar="None",PropertyName="EventParticleTime",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(6)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Normal",LinkVar="None",PropertyName="EventNormal",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="ParticleEvent"
    ObjCategory="Particles"
}
