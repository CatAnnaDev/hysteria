class ParticleModuleMeshRotationRateMultiplyLife extends ParticleModuleRotationRateBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Rotation) RawDistributionVector LifeMultiplier;

defaultproperties
{
    LifeMultiplier=(Distribution="Default__ParticleModuleMeshRotationRateMultiplyLife.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
