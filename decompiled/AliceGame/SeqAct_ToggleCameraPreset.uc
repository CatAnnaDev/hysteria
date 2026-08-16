class SeqAct_ToggleCameraPreset extends SequenceAction
    notplaceable
    hidecategories(Object);

var() CameraPresetStyle CameraPreset;
var() ViewTargetTransitionParams TransitionParamsOn;
var() ViewTargetTransitionParams TransitionParamsOff;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    TransitionParamsOn=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    TransitionParamsOff=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    InputLinks(0)=(LinkDesc="On",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Off",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Toggle Camera Preset"
    ObjCategory="Camera"
}
