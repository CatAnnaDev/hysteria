class SeqAct_CameraLookAt extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bAffectCamera;
var() bool bAlwaysFocus;
var deprecated bool bAdjustCamera;
var() bool bTurnInPlace;
var() bool bIgnoreTrace;
var() bool bAffectHead;
var() bool bRotatePlayerWithCamera;
var() bool bToggleGodMode;
var() bool bLeaveCameraRotation;
var() bool bDisableInput;
var bool bUsedTimer;
var() bool bCheckLineOfSight;
var() Vector2D InterpSpeedRange;
var() Vector2D InFocusFOV;
var() name FocusBoneName;
var() string TextDisplay;
var() float TotalTime;
var() float CameraFOV;
var transient float RemainingTime;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 3;
}

defaultproperties
{
    bAffectCamera=True
    bTurnInPlace=True
    bDisableInput=True
    InterpSpeedRange=(X=3.0,Y=3.0)
    InFocusFOV=(X=1.0,Y=1.0)
    CameraFOV=-1.0
    bLatentExecution=True
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Succeeded",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(3)=(Links=(),LinkDesc="Failed",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Focus",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Look At"
    ObjCategory="Camera"
}
