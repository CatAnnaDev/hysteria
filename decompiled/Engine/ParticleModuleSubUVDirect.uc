class ParticleModuleSubUVDirect extends ParticleModuleSubUVBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(SubUV) RawDistributionVector SubUVPosition;
var(SubUV) RawDistributionVector SubUVSize;

defaultproperties
{
    SubUVPosition=(Distribution="Default__ParticleModuleSubUVDirect.DistributionSubImagePosition",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SubUVSize=(Distribution="Default__ParticleModuleSubUVDirect.DistributionSubImageSize",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bUpdateModule=True
}
