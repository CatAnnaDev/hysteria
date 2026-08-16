class ParticleModuleLocationDirect extends ParticleModuleLocationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Location) RawDistributionVector Location;
var(Location) RawDistributionVector LocationOffset;
var(Location) RawDistributionVector ScaleFactor;
var(Location) RawDistributionVector Direction;

defaultproperties
{
    Location=(Distribution="Default__ParticleModuleLocationDirect.DistributionLocation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    LocationOffset=(Distribution="Default__ParticleModuleLocationDirect.DistributionLocationOffset",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    ScaleFactor=(Distribution="Default__ParticleModuleLocationDirect.DistributionScaleFactor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Direction=(Distribution="Default__ParticleModuleLocationDirect.DistributionDirection",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
