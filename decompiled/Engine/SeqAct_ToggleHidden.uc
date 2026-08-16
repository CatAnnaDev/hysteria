class SeqAct_ToggleHidden extends SeqAct_Toggle
    notplaceable
    hidecategories(Object);

var() bool bToggleBasedActors;
var() array<class<Actor>> IgnoreBasedClasses;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

defaultproperties
{
    InputLinks(0)=(LinkDesc="Hide",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="UnHide",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Toggle",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Toggle Hidden"
}
