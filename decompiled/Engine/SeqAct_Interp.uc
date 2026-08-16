class SeqAct_Interp extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

struct native CameraCutInfo
{
    var Vector Location;
    var float TimeStamp;
};

struct native export SavedTransform
{
    var Vector Location;
    var Rotator Rotation;
};

var const native transient editoronly map<int, int> SavedActorTransforms;
var const native transient editoronly map<int, int> SavedActorVisibilities;
var() float PlayRate;
var float Position;
var() float ForceStartPosition;
var bool bIsPlaying;
var bool bPaused;
var transient bool bIsBeingEdited;
var() bool bLooping;
var() bool bRewindOnPlay;
var() bool bNoResetOnRewind;
var() bool bRewindIfAlreadyPlaying;
var bool bReversePlayback;
var() bool bInterpForPathBuilding;
var() bool bForceStartPos;
var() bool bClientSideOnly;
var() bool bSkipUpdateIfNotVisible;
var() bool bIsSkippable;
var transient bool bShouldShowGore;
var() bool bShowSkipUI;
var() bool bAutoReduceWeightToZeroWhenStop;
var() bool bRefreshBaseActorForAlice;
var(AliceMatinee) bool bAliceMatinee;
var bool bDisableAliceTranslateIK;
var(AliceMatinee) bool bDisableAliceFootIK;
var transient bool bInitBlend;
var() array<CoverLink> LinkedCover;
var export InterpData InterpData;
var array<InterpGroupInst> GroupInst;
var const class<MatineeActor> ReplicatedActorClass;
var const transient MatineeActor ReplicatedActor;
var() int PreferredSplitScreenNum;
var transient array<CameraCutInfo> CameraCuts;
var float TerminationTime;
var() const ViewTargetTransitionParams StartTransitionParams;
var() const ViewTargetTransitionParams EndTransitionParams;
var() float SkipUIDuration;
var() string UIText;
var() float AutoReduceWeightTime;
var(AliceMatinee) editconst Vector InitAliceActorLoc;
var(AliceMatinee) editconst Rotator InitAliceActorRot;
var(AliceMatinee) editconst Vector InitAliceCameraLoc;
var(AliceMatinee) editconst Rotator InitAliceCameraRot;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 3;
}

function Reset()
{
    SetPosition(0.0, false);
    if (bActive)
    {
        InputLinks[2].bHasImpulse = true;
    }
}

native final function AddPlayerToDirectorTracks(PlayerController PC)
{
    PC;
}

native final function Stop()
{
}

native final function SetPosition(float NewPosition, optional bool bJump = false)
{
    NewPosition;
    bJump;
}

defaultproperties
{
    PlayRate=1.0
    bDisableAliceTranslateIK=True
    bDisableAliceFootIK=True
    ReplicatedActorClass="MatineeActor"
    StartTransitionParams=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    EndTransitionParams=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    SkipUIDuration=4.0
    UIText="SKIP_CANCELMATINEE"
    AutoReduceWeightTime=1.0
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Reverse",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(3)=(LinkDesc="Pause",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(4)=(LinkDesc="Change Dir",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(5)=(LinkDesc="BlendOut",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(6)=(LinkDesc="BlendIn",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Completed",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Reversed",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Skipped",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="InterpData",LinkedVariables=(),LinkDesc="Data",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Matinee"
}
