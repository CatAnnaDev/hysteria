class SeqAct_CauseAliceDamage extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bPainCausing;
var() bool bKnockBack;
var() bool bInvincible;
var() bool bOnlyOnce;
var() float DamagePerSec;
var() float PainInterval;
var() EDamageStrengthType KnockBackType;
var() KnockBackParameters KnockBackParameter;
var() Actor DirectionActor;

defaultproperties
{
    bKnockBack=True
    PainInterval=1.0
    KnockBackParameter=(KnockBackScale=180.0,KnockBackTotalTime=0.4,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Float",LinkedVariables=(),LinkDesc="Damage",LinkVar="None",PropertyName="Damage",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="CauseAliceDamage"
    ObjCategory="Actor"
}
