class SeqAct_InteractInLondon extends SequenceAction
    notplaceable
    hidecategories(Object);

var() string PressX_Icon;
var() string Describle_Icon;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Turn On",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Turn Off",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Interact In London"
    ObjCategory="Alice"
}
