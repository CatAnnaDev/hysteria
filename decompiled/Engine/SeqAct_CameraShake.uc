class SeqAct_CameraShake extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() protectedwrite export editinline CameraShake Shake;
var() protectedwrite float ShakeScale;
var() protectedwrite bool bDoControllerVibration;
var() protectedwrite bool bRadialShake;
var() protectedwrite bool bOrientTowardRadialEpicenter;
var() bool bGamePlayCamera;
var() protectedwrite float RadialShake_InnerRadius;
var() protectedwrite float RadialShake_OuterRadius;
var() protectedwrite float RadialShake_Falloff;
var() protectedwrite ECameraAnimPlaySpace PlaySpace;
var Actor LocationActor;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    Shake="Default__SeqAct_CameraShake.Shake0"
    ShakeScale=1.0
    bDoControllerVibration=True
    RadialShake_InnerRadius=128.0
    RadialShake_OuterRadius=512.0
    RadialShake_Falloff=2.0
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Location",LinkVar="None",PropertyName="LocationActor",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Camera Shake"
    ObjCategory="Camera"
}
