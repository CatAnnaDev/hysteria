class SeqAct_PlayAnimation extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() const AnimSet DesiredAnimSet;
var() const name DesiredAnimName;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bLooping;
var() bool bUpperBodyOnly;
var() bool bUseRootMotion;
var transient bool bStopped;
var transient bool bAnimSetAdded;
var transient AnimNodeSequence PickUpSeq;

defaultproperties
{
    BlendInTime=0.2
    BlendOutTime=0.2
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="NotUse",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Play Animation"
    ObjCategory="Animation"
}
