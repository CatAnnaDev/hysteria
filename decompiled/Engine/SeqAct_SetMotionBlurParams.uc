class SeqAct_SetMotionBlurParams extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() float MotionBlurAmount;
var() float InterpolateSeconds;
var float InterpolateElapsed;
var float OldMotionBlurAmount;

defaultproperties
{
    MotionBlurAmount=0.1
    InterpolateSeconds=2.0
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Disable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Motion Blur"
    ObjCategory="Camera"
}
