class SeqAct_Delay extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var const bool bDelayActive;
var() bool bStartWillRestart;
var const float DefaultDuration;
var() float Duration;
var const float LastUpdateTime;
var const float RemainingTime;

native function ResetDelayActive()
{
}

function Reset()
{
    ResetDelayActive();
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    DefaultDuration=1.0
    Duration=1.0
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Pause",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Duration",LinkVar="None",PropertyName="Duration",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Delay"
    ObjCategory="Misc"
}
