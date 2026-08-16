class MorphNodePose extends MorphNodeBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native MorphMaterialParameter
{
    var() int MorphMaterialSlotID;
    var() name ScalarParameterName;
    var transient MaterialInstanceConstant MaterialInstanceConstant;
};

var transient MorphTarget Target;
var() name MorphName;
var() float Weight;
var() array<MorphMaterialParameter> MorphMaterials;

native final function SetMorphTarget(name MorphTargetName)
{
    MorphTargetName;
}

defaultproperties
{
    Weight=1.0
}
