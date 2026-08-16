class ParticleModuleLocationSkeleton extends ParticleModuleLocation
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,Object);

var float TotalBoneLength;
var array<float> BoneLengths;
var() int StartBoneIndex;
var() bool bFilterBones;
var() array<name> BoneNames;

defaultproperties
{
    StartBoneIndex=3
    StartLocation=(Distribution="Default__ParticleModuleLocationSkeleton.DistributionStartLocation")
}
