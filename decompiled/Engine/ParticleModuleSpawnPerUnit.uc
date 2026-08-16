class ParticleModuleSpawnPerUnit extends ParticleModuleSpawnBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Spawn) float UnitScalar;
var(Spawn) RawDistributionFloat SpawnPerUnit;
var(Spawn) bool bIgnoreSpawnRateWhenMoving;
var(Spawn) float MovementTolerance;

defaultproperties
{
    UnitScalar=50.0
    SpawnPerUnit=(Distribution="Default__ParticleModuleSpawnPerUnit.RequiredDistributionSpawnPerUnit",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MovementTolerance=0.1
    bSpawnModule=True
}
