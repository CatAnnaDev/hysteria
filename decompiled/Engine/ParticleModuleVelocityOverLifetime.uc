class ParticleModuleVelocityOverLifetime extends ParticleModuleVelocityBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Velocity) RawDistributionVector VelOverLife;
var(Velocity) export bool Absolute;

defaultproperties
{
    VelOverLife=(Distribution="Default__ParticleModuleVelocityOverLifetime.DistributionVelOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
