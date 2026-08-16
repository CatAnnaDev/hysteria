class ParticleModuleBeamSource extends ParticleModuleBeamBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Source) Beam2SourceTargetMethod SourceMethod;
var(Source) Beam2SourceTargetTangentMethod SourceTangentMethod;
var(Source) name SourceName;
var(Source) bool bSourceAbsolute;
var(Source) bool bLockSource;
var(Source) bool bLockSourceTangent;
var(Source) bool bLockSourceStength;
var(Source) RawDistributionVector Source;
var(Source) RawDistributionVector SourceTangent;
var(Source) RawDistributionFloat SourceStrength;

defaultproperties
{
    Source=(Distribution="Default__ParticleModuleBeamSource.DistributionSource",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000484200004842000048420000484200004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SourceTangent=(Distribution="Default__ParticleModuleBeamSource.DistributionSourceTangent",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 000000000000803f0000803f00000000000000000000803f0000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SourceStrength=(Distribution="Default__ParticleModuleBeamSource.DistributionSourceStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000c8410000c8410000c8410000c841,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
