class ParticleModuleColor extends ParticleModuleColorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Color) RawDistributionVector StartColor;
var(Color) RawDistributionFloat StartAlpha;
var(Color) bool bClampAlpha;

defaultproperties
{
    StartColor=(Distribution="Default__ParticleModuleColor.DistributionStartColor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartAlpha=(Distribution="Default__ParticleModuleColor.DistributionStartAlpha",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bClampAlpha=True
    bSpawnModule=True
    bCurvesAsColor=True
}
