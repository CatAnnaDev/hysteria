class MorphNodeMultiPose extends MorphNodeBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

var transient array<MorphTarget> Targets;
var() array<name> MorphNames;
var() array<float> Weights;

native final function bool UpdateMorphTarget(MorphTarget Target, float InWeight)
{
    Target;
    InWeight;
}

native final function RemoveMorphTarget(name MorphTargetName)
{
    MorphTargetName;
}

native final function bool AddMorphTarget(name MorphTargetName, optional float InWeight = 1.0)
{
    MorphTargetName;
    InWeight;
}

defaultproperties
{
}
