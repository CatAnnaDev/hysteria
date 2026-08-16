class AnimNodePlayCustomAnim extends AnimNodeBlend
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var bool bIsPlayingCustomAnim;
var float CustomPendingBlendOutTime;

final function SetRootBoneAxisOption(optional ERootBoneAxis AxisX = 0, optional ERootBoneAxis AxisY = 0, optional ERootBoneAxis AxisZ = 0)
{
    local AnimNodeSequence AnimSeq;
    
    AnimSeq = GetCustomAnimNodeSeq();
    if (AnimSeq != none)
    {
        AnimSeq.SetRootBoneAxisOption(AxisX, AxisY, AxisZ);
    }
    else
    {
        WarnInternal(string(GetFuncName()) @ "Custom AnimNodeSequence not found for" @ string(self));
    }
}

final function AnimNodeSequence GetCustomAnimNodeSeq()
{
    return AnimNodeSequence(Children[1].Anim);
}

final function SetActorAnimEndNotification(bool bNewStatus)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Children[1].Anim);
    if (SeqNode != none)
    {
        SeqNode.bCauseActorAnimEnd = bNewStatus;
    }
}

final function SetCustomAnim(name AnimName)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Children[1].Anim);
    if (SeqNode != none)
    {
        SeqNode.SetAnim(AnimName);
    }
}

native final function StopCustomAnim(float BlendOutTime)
{
    BlendOutTime;
}

native final function PlayCustomAnimByDuration(name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride)
{
    AnimName;
    Duration;
    BlendInTime;
    BlendOutTime;
    bLooping;
    bOverride;
}

native final function float PlayCustomAnim(name AnimName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride)
{
    AnimName;
    Rate;
    BlendInTime;
    BlendOutTime;
    bLooping;
    bOverride;
}

defaultproperties
{
    Children(0)=(Name="Normal",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Custom",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    NodeName="CustomAnim"
}
