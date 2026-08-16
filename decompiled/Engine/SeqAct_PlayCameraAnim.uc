class SeqAct_PlayCameraAnim extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() CameraAnim CameraAnim;
var() bool bLoop;
var() bool bRandomStartTime;
var transient bool bStopped;
var() bool bGamePlayCamera;
var() float BlendInTime;
var() float BlendOutTime;
var() float Rate;
var() float IntensityScale;
var() ECameraAnimPlaySpace PlaySpace;
var() Actor UserDefinedSpaceActor;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    BlendInTime=0.2
    BlendOutTime=0.2
    Rate=1.0
    IntensityScale=1.0
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Play CameraAnim"
    ObjCategory="Camera"
}
