class AnimNode_MultiBlendPerBone extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

enum EBlendType
{
    EBT_ParentBoneSpace,
    EBT_MeshSpace,
};

enum EWeightCheck
{
    EWC_AnimNodeSlotNotPlaying,
    EWC_ChildIndexFullWeight,
    EWC_ChildIndexNotFullWeight,
    EWC_ChildIndexRelevant,
    EWC_ChildIndexNotRelevant,
};

struct native PerBoneMaskInfo
{
    var() array<BranchInfo> BranchList;
    var() float DesiredWeight;
    var() float BlendTimeToGo;
    var() array<WeightRule> WeightRuleList;
    var() bool bWeightBasedOnNodeRules;
    var() bool bDisableForNonLocalHumanPlayers;
    var transient bool bPendingBlend;
    var transient array<float> PerBoneWeights;
    var transient array<byte> TransformReqBone;
    var transient int TransformReqBoneIndex;
};

struct native BranchInfo
{
    var() name BoneName;
    var() float PerBoneWeightIncrease;
};

struct native WeightRule
{
    var() WeightNodeRule FirstNode;
    var() WeightNodeRule SecondNode;
};

struct native WeightNodeRule
{
    var() name NodeName;
    var AnimNodeBlendBase CachedNode;
    var AnimNodeSlot CachedSlotNode;
    var() EWeightCheck WeightCheck;
    var() int ChildIndex;
};

var const transient Pawn PawnOwner;
var() editfixedsize editinline array<PerBoneMaskInfo> MaskList;
var() EBlendType RotationBlendType;

native final function SetMaskWeight(int MaskIndex, float DesiredWeight, float BlendTime)
{
    MaskIndex;
    DesiredWeight;
    BlendTime;
}

defaultproperties
{
    Children(0)=(Name="Source",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bSkipTickWhenZeroWeight=True
    CategoryDesc="Filter"
}
