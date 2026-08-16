class SeqAct_LevelStreamingBase extends SeqAct_Latent
    abstract
    native
    notplaceable
    hidecategories(Object);

var() bool bMakeVisibleAfterLoad;
var() bool bShouldBlockOnLoad;
var bool bStartTextureStreamingWaiting;
var int PawnPhysics;

defaultproperties
{
    bMakeVisibleAfterLoad=True
    PawnPhysics=-1
    InputLinks(0)=(LinkDesc="Load",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Unload",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjCategory="Level"
}
