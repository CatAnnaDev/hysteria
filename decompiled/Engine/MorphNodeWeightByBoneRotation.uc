class MorphNodeWeightByBoneRotation extends MorphNodeWeightBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

var const transient float Angle;
var const transient float NodeWeight;
var() name BoneName;
var() EAxis BoneAxis;
var() bool bInvertBoneAxis;
var(Material) bool bControlMaterialParameter;
var() array<BoneAngleMorph> WeightArray;
var(Material) int MaterialSlotId;
var(Material) name ScalarParameterName;
var transient MaterialInstanceConstant MaterialInstanceConstant;

defaultproperties
{
    BoneAxis="AXIS_Y"
    WeightArray(0)=(Angle=0.0,TargetWeight=0.0)
    WeightArray(1)=(Angle=90.0,TargetWeight=1.0)
    NodeConns(0)=(ChildNodes=(),ConnName="In",DrawY=0)
}
