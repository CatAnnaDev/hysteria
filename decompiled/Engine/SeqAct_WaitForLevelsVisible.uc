class SeqAct_WaitForLevelsVisible extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() array<name> LevelNames;
var() bool bShouldBlockOnLoad;
var bool bStartTextureStreamingWaiting;
var bool bWaitingForTheEndOfLoadingMovie;
var int PawnPhysics;

defaultproperties
{
    bShouldBlockOnLoad=True
    PawnPhysics=-1
    InputLinks(0)=(LinkDesc="Wait",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Wait for Levels to be visible"
    ObjCategory="Level"
}
