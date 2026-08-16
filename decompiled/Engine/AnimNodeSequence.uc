class AnimNodeSequence extends AnimNode
    native
    notplaceable
    hidecategories(Object,Object,Object);

enum ERootRotationOption
{
    RRO_Default,
    RRO_Discard,
    RRO_Extract,
};

enum ERootBoneAxis
{
    RBA_Default,
    RBA_Discard,
    RBA_Translate,
};

var() const name AnimSeqName;
var() float Rate;
var() bool bPlaying;
var() bool bLooping;
var() bool bCauseActorAnimEnd;
var() bool bCauseActorAnimPlay;
var() bool bZeroRootRotation;
var() bool bZeroRootTranslation;
var() bool bDisableWarningWhenAnimNotFound;
var() bool bNoNotifies;
var() bool bForceRefposeWhenNotPlaying;
var bool bIsIssuingNotifies;
var(Group) bool bForceAlwaysSlave;
var(Group) const bool bSynchronize;
var(Group) const bool bReverseSync;
var(Display) bool bShowTimeLineSlider;
var(Camera) bool bLoopCameraAnim;
var(Camera) bool bRandomizeCameraAnimLoopStartTime;
var transient bool bNeedClampAdvancedTime;
var const bool bEditorOnlyAddRefPoseToAdditiveAnimation;
var transient bool bExtendAnimTimeForFakeRootMotion;
var() const float CurrentTime;
var const transient float PreviousTime;
var const transient AnimSequence AnimSeq;
var const transient int AnimLinkupIndex;
var() float NotifyWeightThreshold;
var(Group) const name SynchGroupName;
var(Group) float SynchPosOffset;
var Texture2D DebugTrack;
var Texture2D DebugCarat;
var(Camera) CameraAnim CameraAnim;
var transient CameraAnimInst ActiveCameraAnimInstance;
var(Camera) float CameraAnimScale;
var(Camera) float CameraAnimPlayRate;
var transient float ClampAdvancedTime;
var() const ERootBoneAxis RootBoneOption[3];
var() const ERootRotationOption RootRotationOption[3];

native final function SetRootBoneRotationOption(optional ERootRotationOption AxisX = 0, optional ERootRotationOption AxisY = 0, optional ERootRotationOption AxisZ = 0)
{
    AxisX;
    AxisY;
    AxisZ;
}

native final function SetRootBoneAxisOption(optional ERootBoneAxis AxisX = 0, optional ERootBoneAxis AxisY = 0, optional ERootBoneAxis AxisZ = 0)
{
    AxisX;
    AxisY;
    AxisZ;
}

native function float GetTimeLeft()
{
}

native function float GetAnimPlaybackLength()
{
}

native function float GetGlobalPlayRate()
{
}

native function float GetGroupRelativePosition()
{
}

native function float FindGroupPosition(float GroupRelativePosition)
{
    GroupRelativePosition;
}

native function float FindGroupRelativePosition(float GroupRelativePosition)
{
    GroupRelativePosition;
}

native function float GetNormalizedPosition()
{
}

native function SetPosition(float NewTime, bool bFireNotifies)
{
    NewTime;
    bFireNotifies;
}

native function ReplayAnim()
{
}

native function StopAnim()
{
}

native function PlayAnim(optional bool bLoop = false, optional float InRate = 1.0, optional float StartTime = 0.0)
{
    bLoop;
    InRate;
    StartTime;
}

native function SetAnim(name Sequence)
{
    Sequence;
}

defaultproperties
{
    Rate=1.0
    bSynchronize=True
    DebugTrack="EditorResources.AnimPlayerTrack"
    DebugCarat="EditorResources.AnimPlayerCarat"
    CameraAnimScale=1.0
    CameraAnimPlayRate=1.0
}
