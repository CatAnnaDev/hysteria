class SeqAct_PrepareMapChange extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() name MainLevelName;
var() array<name> InitiallyLoadedSecondaryLevelNames;
var() bool bIsHighPriority;
var transient bool bStatusIsOk;

defaultproperties
{
    InputLinks(0)=(LinkDesc="PrepareLoad",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Prepare Map Change"
    ObjCategory="Level"
}
