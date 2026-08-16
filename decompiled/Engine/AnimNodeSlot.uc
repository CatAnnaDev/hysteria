class AnimNodeSlot extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var const bool bIsPlayingCustomAnim;
var() bool bEarlyAnimEndNotify;
var() bool bSkipBlendWhenNotRendered;
var() bool bAdditiveAnimationsOverrideSource;
var const float PendingBlendOutTime;
var const int CustomChildIndex;
var const int TargetChildIndex;
var array<float> TargetWeight;
var const float BlendTimeToGo;
var const transient AnimNodeSynch SynchNode;

native final function AddToSynchGroup(name GroupName)
{
    GroupName;
}

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

native final function AnimNodeSequence GetCustomAnimNodeSeq()
{
}

native final function SetActorAnimEndNotification(bool bNewStatus)
{
    bNewStatus;
}

native final function SetCustomAnim(name AnimName)
{
    AnimName;
}

native final function StopCustomAnim(float BlendOutTime)
{
    BlendOutTime;
}

native final function name GetPlayedAnimation()
{
}

native final function bool PlayCustomAnimByDuration(name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride = true)
{
    AnimName;
    Duration;
    BlendInTime;
    BlendOutTime;
    bLooping;
    bOverride;
}

native final function float PlayCustomAnim(name AnimName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime)
{
    AnimName;
    Rate;
    BlendInTime;
    BlendOutTime;
    bLooping;
    bOverride;
    StartTime;
}

defaultproperties
{
    bEarlyAnimEndNotify=True
    bSkipBlendWhenNotRendered=True
    TargetWeight(0)=1.0
    Children(0)=(Name="Source",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Channel 01",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    NodeName="SlotName"
}
