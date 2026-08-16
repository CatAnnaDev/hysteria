class SeqAct_CameraFade extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() Color FadeColor;
var deprecated Vector2D FadeAlpha;
var() float FadeOpacity;
var() float FadeTime;
var() bool bPersistFade;
var float FadeTimeRemaining;
var transient array<PlayerController> CachedPCs;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    FadeOpacity=1.0
    FadeTime=1.0
    bPersistFade=True
    bLatentExecution=True
    bAutoActivateOutputLinks=False
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Fade"
    ObjCategory="Camera"
}
