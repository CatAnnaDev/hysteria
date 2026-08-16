class ParticleModuleEventReceiverSpawn extends ParticleModuleEventReceiverBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,Object);

var deprecated EParticleEventType EventGeneratorType;
var deprecated name EventName;
var(Spawn) RawDistributionFloat SpawnCount;
var(Spawn) bool bUseParticleTime;
var(Location) bool bUsePSysLocation;
var(Velocity) bool bInheritVelocity;
var(Velocity) RawDistributionVector InheritVelocityScale;

defaultproperties
{
    SpawnCount=(Distribution="Default__ParticleModuleEventReceiverSpawn.RequiredDistributionSpawnCount",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    InheritVelocityScale=(Distribution="Default__ParticleModuleEventReceiverSpawn.RequiredDistributionInheritVelocityScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
