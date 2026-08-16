class SeqAct_ForceFeedback extends SequenceAction
    notplaceable
    hidecategories(Object);

var() editinline ForceFeedbackWaveform FFWaveform;
var() class<WaveFormBase> PredefinedWaveForm;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Force Feedback"
    ObjCategory="Misc"
}
