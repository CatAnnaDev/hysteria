class SeqAct_SpecialCameraBehavior extends SeqAct_LatentWithInterpData
    native
    notplaceable
    hidecategories(Object);

var() bool bIsTargetCamera;
var bool bIsPlaying;
var InterpTrackMove CameraTrack;
var AlicePlayerController AlicePC;
var float ElapsedTime;
var float TotalTrackTime;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    bIsTargetCamera=True
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Completed",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set Special Camera Behavior"
    ObjCategory="Camera"
}
