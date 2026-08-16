class SeqAct_SetSoundMode extends SequenceAction
    notplaceable
    hidecategories(Object);

var() SoundMode SoundMode;
var() bool bTopPriority;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 3;
}

event Activated()
{
    local PlayerController PC;
    
    PC = GetWorldInfo().GetALocalPlayerController();
    if (PC != none)
    {
        PC.OnSetSoundMode(self);
    }
}

defaultproperties
{
    bCallHandler=False
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Set Sound Mode"
    ObjCategory="Sound"
}
