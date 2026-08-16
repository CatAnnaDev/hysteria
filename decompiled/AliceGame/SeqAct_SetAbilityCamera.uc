class SeqAct_SetAbilityCamera extends SequenceAction
    notplaceable
    hidecategories(Object);

var() AliceCameraProperties CameraProperties;
var() ViewTargetTransitionParams TransitionParamsOn;
var() ViewTargetTransitionParams TransitionParamsOff;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    CameraProperties=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    TransitionParamsOn=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    TransitionParamsOff=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    InputLinks(0)=(LinkDesc="On",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Off",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Set Ability Camera Properties"
    ObjCategory="Camera"
}
