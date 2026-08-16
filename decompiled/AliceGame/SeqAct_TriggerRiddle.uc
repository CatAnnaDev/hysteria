class SeqAct_TriggerRiddle extends SequenceAction
    notplaceable
    hidecategories(Object);

var() int RiddleID;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Turn On",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Trigger Riddle"
    ObjCategory="Alice"
}
