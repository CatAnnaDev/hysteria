class ParticleModuleSpawn extends ParticleModuleSpawnBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,ParticleModuleSpawnBase);

var(Spawn) RawDistributionFloat Rate;
var(Spawn) RawDistributionFloat RateScale;
var(Burst) EParticleBurstMethod ParticleBurstMethod;
var(Burst) export noclear array<ParticleBurst> BurstList;

defaultproperties
{
    Rate=(Distribution="Default__ParticleModuleSpawn.RequiredDistributionSpawnRate",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000a0410000a0410000a0410000a041,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RateScale=(Distribution="Default__ParticleModuleSpawn.RequiredDistributionSpawnRateScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    LODDuplicate=False
}
