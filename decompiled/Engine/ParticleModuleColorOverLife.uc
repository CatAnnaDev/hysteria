class ParticleModuleColorOverLife extends ParticleModuleColorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Color) RawDistributionVector ColorOverLife;
var(Color) RawDistributionFloat AlphaOverLife;
var(Color) bool bClampAlpha;

defaultproperties
{
    ColorOverLife=(Distribution="Default__ParticleModuleColorOverLife.DistributionColorOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaOverLife=(Distribution="Default__ParticleModuleColorOverLife.DistributionAlphaOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bClampAlpha=True
    bSpawnModule=True
    bUpdateModule=True
    bCurvesAsColor=True
}
