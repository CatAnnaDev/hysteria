class AnimTree extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

struct native PreviewAnimSetsStruct
{
    var() name DisplayName;
    var() array<AnimSet> PreviewAnimSets;
};

struct native PreviewSocketStruct
{
    var() name DisplayName;
    var() name SocketName;
    var() SkeletalMesh PreviewSkelMesh;
    var() StaticMesh PreviewStaticMesh;
};

struct native PreviewSkelMeshStruct
{
    var() name DisplayName;
    var() SkeletalMesh PreviewSkelMesh;
    var() array<MorphTargetSet> PreviewMorphSets;
};

struct native SkelControlListHead
{
    var name BoneName;
    var export editinline SkelControlBase ControlHead;
    var editoronly int DrawY;
};

struct native AnimGroup
{
    var const transient array<AnimNodeSequence> SeqNodes;
    var const transient AnimNodeSequence SynchMaster;
    var const transient AnimNodeSequence NotifyMaster;
    var() const name GroupName;
    var() const float RateScale;
    var const float SynchPctPosition;
};

var() array<AnimGroup> AnimGroups;
var deprecated array<name> PrioritizedSkelBranches;
var() array<name> ComposePrePassBoneNames;
var() array<name> ComposePostPassBoneNames;
var export editinline array<MorphNodeBase> RootMorphNodes;
var export editinline array<SkelControlListHead> SkelControlLists;
var array<BoneAtom> SavedPose;
var bool bUseSavedPose;
var transient editoronly bool bBeingEdited;
var editoronly int MorphConnDrawY;
var() editoronly float PreviewPlayRate;
var editoronly deprecated SkeletalMesh PreviewSkelMesh;
var editoronly deprecated SkeletalMesh SocketSkelMesh;
var editoronly deprecated StaticMesh SocketStaticMesh;
var editoronly deprecated name SocketName;
var editoronly deprecated array<AnimSet> PreviewAnimSets;
var editoronly deprecated array<MorphTargetSet> PreviewMorphSets;
var() editoronly array<PreviewSkelMeshStruct> PreviewMeshList;
var editoronly int PreviewMeshIndex;
var() editoronly array<PreviewSocketStruct> PreviewSocketList;
var editoronly int PreviewSocketIndex;
var() editoronly array<PreviewAnimSetsStruct> PreviewAnimSetList;
var editoronly int PreviewAnimSetListIndex;
var editoronly int PreviewAnimSetIndex;
var editoronly Vector PreviewCamPos;
var editoronly Rotator PreviewCamRot;
var editoronly Vector PreviewFloorPos;
var editoronly int PreviewFloorYaw;

native final function int GetGroupIndex(name GroupName)
{
    GroupName;
}

native final function float GetGroupRateScale(name GroupName)
{
    GroupName;
}

native final function SetGroupRateScale(name GroupName, float NewRateScale)
{
    GroupName;
    NewRateScale;
}

native final function float GetGroupRelativePosition(name GroupName)
{
    GroupName;
}

native final function ForceGroupRelativePosition(name GroupName, float RelativePosition)
{
    GroupName;
    RelativePosition;
}

native final function AnimNodeSequence GetGroupNotifyMaster(name GroupName)
{
    GroupName;
}

native final function AnimNodeSequence GetGroupSynchMaster(name GroupName)
{
    GroupName;
}

native final function bool SetAnimGroupForNode(AnimNodeSequence SeqNode, name GroupName, optional bool bCreateIfNotFound)
{
    SeqNode;
    GroupName;
    bCreateIfNotFound;
}

native final function SetUseSavedPose(bool bUseSaved)
{
    bUseSaved;
}

native final function MorphNodeBase FindMorphNode(name InNodeName)
{
    InNodeName;
}

native final function SkelControlBase FindSkelControl(name InControlName)
{
    InControlName;
}

defaultproperties
{
    PreviewPlayRate=1.0
    Children(0)=(Name="Child",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
}
