class ParticleModuleRotationRateMultiplyLife extends ParticleModuleRotationRateBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Rotation) RawDistributionFloat LifeMultiplier;

defaultproperties
{
    LifeMultiplier=(Distribution="Default__ParticleModuleRotationRateMultiplyLife.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
