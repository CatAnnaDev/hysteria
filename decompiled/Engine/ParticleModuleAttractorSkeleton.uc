class ParticleModuleAttractorSkeleton extends ParticleModuleAttractorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Attractor) RawDistributionVector Position;
var(Attractor) RawDistributionFloat Range;
var(Attractor) RawDistributionFloat Strength;
var(Attractor) bool StrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bOverrideVelocity;
var(Attractor) bool bUseWorldSpacePosition;
var(Attractor) bool bAlwaysSnapToBone;

defaultproperties
{
    Position=(Distribution="Default__ParticleModuleAttractorSkeleton.DistributionPosition",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Range=(Distribution="Default__ParticleModuleAttractorSkeleton.DistributionRange",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Strength=(Distribution="Default__ParticleModuleAttractorSkeleton.DistributionStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StrengthByDistance=True
    bUpdateModule=True
}
