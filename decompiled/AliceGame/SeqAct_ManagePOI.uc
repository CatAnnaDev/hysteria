class SeqAct_ManagePOI extends SequenceAction
    native
    notplaceable
    config(Game)
    hidecategories(Object);

enum EManagePOIOutputType
{
    eMPOIOUTPUT_Out,
    eMPOIOUTPUT_Expired,
    eMPOIOUTPUT_LookAt,
    eMPOIOUTPUT_LookAway,
};

enum EManagePOIInputType
{
    eMPOIINPUT_On,
    eMPOIINPUT_Off,
};

var() config string POI_DisplayName;
var bool POI_bEnabled;
var() config bool POI_bForceLookCheckLineOfSight;
var() config bool POI_bFOVLineOfSightCheck;
var() config bool POI_bDisableOtherPOIs;
var() config bool POI_bLeavePlayerFacingPOI;
var() bool POI_bOverrideCamera;
var bool bIsDone;
var() config float POI_IconDuration;
var() config EPOIForceLookType POI_ForceLookType;
var() config float POI_ForceLookDuration;
var() config int POI_LookAtPriority;
var() config float POI_DesiredFOV;
var() config int POI_FOVCount;
var() config float POI_EnableDuration;
var() Vector POI_CameraOffset;
var AlicePointOfInterest POI;

defaultproperties
{
    POI_IconDuration=5.0
    bLatentExecution=True
    bAutoActivateOutputLinks=False
    InputLinks(0)=(LinkDesc="On",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Off",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Expired",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Look At",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(3)=(Links=(),LinkDesc="Look Away",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="POI",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="POI Manager"
    ObjCategory="Alice"
}
