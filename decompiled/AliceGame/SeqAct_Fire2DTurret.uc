class SeqAct_Fire2DTurret extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bKeepFiring;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Shoot",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Fire 2DTurret"
    ObjCategory="Actor"
}
