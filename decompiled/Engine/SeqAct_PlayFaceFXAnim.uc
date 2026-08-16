class SeqAct_PlayFaceFXAnim extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() FaceFXAnimSet FaceFXAnimSetRef;
var() string FaceFXGroupName;
var() string FaceFXAnimName;
var() SoundCue SoundCueToPlay;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Play FaceFX Anim"
    ObjCategory="Sound"
}
