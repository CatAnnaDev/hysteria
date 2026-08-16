class ParticleModuleAttractorPoint extends ParticleModuleAttractorBase
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
var(Attractor) bool bFollowAlice;
var(Attractor) float ParticleVelocityToAlice;
var(Attractor) float AttractorDelayTime;

defaultproperties
{
    Position=(Distribution="Default__ParticleModuleAttractorPoint.DistributionPosition",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Range=(Distribution="Default__ParticleModuleAttractorPoint.DistributionRange",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Strength=(Distribution="Default__ParticleModuleAttractorPoint.DistributionStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StrengthByDistance=True
    bUpdateModule=True
    bSupported3DDrawMode=True
}
