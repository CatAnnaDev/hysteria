class MorphNodeWeightByBoneAngle extends MorphNodeWeightBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native BoneAngleMorph
{
    var() float Angle;
    var() float TargetWeight;
};

var const transient float Angle;
var const transient float NodeWeight;
var(BaseBone) name BaseBoneName;
var(BaseBone) EAxis BaseBoneAxis;
var(AngleBone) EAxis AngleBoneAxis;
var(BaseBone) bool bInvertBaseBoneAxis;
var(AngleBone) bool bInvertAngleBoneAxis;
var(Material) bool bControlMaterialParameter;
var(AngleBone) name AngleBoneName;
var(Material) int MaterialSlotId;
var(Material) name ScalarParameterName;
var transient MaterialInstanceConstant MaterialInstanceConstant;
var() array<BoneAngleMorph> WeightArray;

defaultproperties
{
    BaseBoneAxis="AXIS_X"
    AngleBoneAxis="AXIS_X"
    WeightArray(0)=(Angle=0.0,TargetWeight=0.0)
    WeightArray(1)=(Angle=180.0,TargetWeight=1.0)
    NodeConns(0)=(ChildNodes=(),ConnName="In",DrawY=0)
}
