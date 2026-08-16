class ParticleModuleColorScaleOverLife extends ParticleModuleColorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Color) RawDistributionVector ColorScaleOverLife;
var(Color) RawDistributionFloat AlphaScaleOverLife;
var(Color) bool bEmitterTime;

defaultproperties
{
    ColorScaleOverLife=(Distribution="Default__ParticleModuleColorScaleOverLife.DistributionColorScaleOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaScaleOverLife=(Distribution="Default__ParticleModuleColorScaleOverLife.DistributionAlphaScaleOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
    bCurvesAsColor=True
}
