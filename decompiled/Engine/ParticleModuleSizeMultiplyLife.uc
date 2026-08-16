class ParticleModuleSizeMultiplyLife extends ParticleModuleSizeBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Size) RawDistributionVector LifeMultiplier;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

defaultproperties
{
    LifeMultiplier=(Distribution="Default__ParticleModuleSizeMultiplyLife.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MultiplyX=True
    MultiplyY=True
    MultiplyZ=True
    bSpawnModule=True
    bUpdateModule=True
}
