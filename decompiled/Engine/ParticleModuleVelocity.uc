class ParticleModuleVelocity extends ParticleModuleVelocityBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Velocity) RawDistributionVector StartVelocity;
var(Velocity) RawDistributionFloat StartVelocityRadial;

defaultproperties
{
    StartVelocity=(Distribution="Default__ParticleModuleVelocity.DistributionStartVelocity",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartVelocityRadial=(Distribution="Default__ParticleModuleVelocity.DistributionStartVelocityRadial",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
}
