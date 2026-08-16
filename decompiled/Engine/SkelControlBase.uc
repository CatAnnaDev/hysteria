class SkelControlBase extends AnimObject
    abstract
    native
    notplaceable
    hidecategories(Object,Object);

enum EBoneControlSpace
{
    BCS_WorldSpace,
    BCS_ActorSpace,
    BCS_ComponentSpace,
    BCS_ParentBoneSpace,
    BCS_BoneSpace,
    BCS_OtherBoneSpace,
    BCS_BaseMeshSpace,
};

var(Controller) name ControlName;
var(Controller) float ControlStrength;
var(Controller) float BlendInTime;
var(Controller) float BlendOutTime;
var(Controller) AlphaBlendType BlendType;
var(Controller) bool bPostPhysicsController;
var(Controller) bool bSetStrengthFromAnimNode;
var transient bool bInitializedCachedNodeList;
var(Controller) bool bControlledByAnimMetada;
var(Controller) bool bPropagateSetActive;
var() bool bIgnoreWhenNotRendered;
var bool bShouldTickInScript;
var() editconst deprecated bool bEnableEaseInOut;
var float StrengthTarget;
var transient float BlendTimeToGo;
var(Controller) array<name> StrengthAnimNodeNameList;
var transient array<AnimNode> CachedNodeList;
var transient float AnimMetadataWeight;
var transient array<AnimNodeSequence> AnimMetadataCachedAnimNodeSeqList;
var(Controller) float BoneScale;
var transient int ControlTickTag;
var(Controller) int IgnoreAtOrAboveLOD;
var SkelControlBase NextControl;
var deprecated int ControlPosX;
var deprecated int ControlPosY;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
}

native final function SetSkelControlStrength(float NewStrength, float InBlendTime)
{
    NewStrength;
    InBlendTime;
}

native final function SetSkelControlActive(bool bInActive)
{
    bInActive;
}

defaultproperties
{
    ControlStrength=1.0
    BlendInTime=0.2
    BlendOutTime=0.2
    StrengthTarget=1.0
    BoneScale=1.0
    IgnoreAtOrAboveLOD=1000
}
