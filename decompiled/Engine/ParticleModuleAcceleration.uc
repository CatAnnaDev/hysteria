class ParticleModuleAcceleration extends ParticleModuleAccelerationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Acceleration) RawDistributionVector Acceleration;
var(Acceleration) bool bApplyOwnerScale;

defaultproperties
{
    Acceleration=(Distribution="Default__ParticleModuleAcceleration.DistributionAcceleration",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
