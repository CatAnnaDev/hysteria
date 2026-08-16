class SeqAct_ToggleSpawnXPAndHP extends SequenceAction
    notplaceable
    hidecategories(Object);

var() bool CanSpawnHealth;
var() bool CanSpawnXP;
var() bool ForceUseManualXP;
var() bool ForceUseManualHP;

defaultproperties
{
    CanSpawnHealth=True
    CanSpawnXP=True
    InputLinks(0)=(LinkDesc="Active",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="ToggleSpawnXPAndHP"
    ObjCategory="Toggle"
}
