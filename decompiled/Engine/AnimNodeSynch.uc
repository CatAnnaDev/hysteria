class AnimNodeSynch extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native SynchGroup
{
    var array<AnimNodeSequence> SeqNodes;
    var transient AnimNodeSequence MasterNode;
    var() name GroupName;
    var() bool bFireSlaveNotifies;
    var() float RateScale;
};

var() array<SynchGroup> Groups;

native final function SetGroupRateScale(name GroupName, float NewRateScale)
{
    GroupName;
    NewRateScale;
}

native final function float GetRelativePosition(name GroupName)
{
    GroupName;
}

native final function ForceRelativePosition(name GroupName, float RelativePosition)
{
    GroupName;
    RelativePosition;
}

native final function AnimNodeSequence GetMasterNodeOfGroup(name GroupName)
{
    GroupName;
}

native final function RemoveNodeFromGroup(AnimNodeSequence SeqNode, name GroupName)
{
    SeqNode;
    GroupName;
}

native final function AddNodeToGroup(AnimNodeSequence SeqNode, name GroupName)
{
    SeqNode;
    GroupName;
}

defaultproperties
{
    Children(0)=(Name="Input",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
}
