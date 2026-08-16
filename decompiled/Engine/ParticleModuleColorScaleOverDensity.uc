class ParticleModuleColorScaleOverDensity extends ParticleModuleColorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Color) RawDistributionVector ColorScaleOverDensity;
var(Color) RawDistributionFloat AlphaScaleOverDensity;

defaultproperties
{
    ColorScaleOverDensity=(Distribution="Default__ParticleModuleColorScaleOverDensity.DistributionColorScaleOverDensity",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaScaleOverDensity=(Distribution="Default__ParticleModuleColorScaleOverDensity.DistributionAlphaScaleOverDensity",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
