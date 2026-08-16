class ParticleModuleTrailSpawn extends ParticleModuleTrailBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum ETrail2SpawnMethod
{
    PET2SM_Emitter,
    PET2SM_Velocity,
    PET2SM_Distance,
};

var(Spawn) export editinline noclear DistributionFloatParticleParameter SpawnDistanceMap;
var(Spawn) float MinSpawnVelocity;

defaultproperties
{
    SpawnDistanceMap="Default__ParticleModuleTrailSpawn.DistributionSpawnDistanceMap"
}
