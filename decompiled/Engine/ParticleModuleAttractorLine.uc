class ParticleModuleAttractorLine extends ParticleModuleAttractorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Attractor) Vector EndPoint0;
var(Attractor) Vector EndPoint1;
var(Attractor) RawDistributionFloat Range;
var(Attractor) RawDistributionFloat Strength;

defaultproperties
{
    Range=(Distribution="Default__ParticleModuleAttractorLine.DistributionRange",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Strength=(Distribution="Default__ParticleModuleAttractorLine.DistributionStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bUpdateModule=True
    bSupported3DDrawMode=True
}
