class SeqAct_AliceTransition extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() float MorphTime;
var name CurMorphName;
var name NextMorphName;
var float ElapsedTime;
var AlicePlayerController APC;

defaultproperties
{
    MorphTime=1.0
    NextMorphName="AliceTMorph"
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="AliceTransition"
    ObjCategory="Alice"
}
