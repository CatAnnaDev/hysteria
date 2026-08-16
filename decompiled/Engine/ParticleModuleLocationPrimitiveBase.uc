class ParticleModuleLocationPrimitiveBase extends ParticleModuleLocationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Location) bool Positive_X;
var(Location) bool Positive_Y;
var(Location) bool Positive_Z;
var(Location) bool Negative_X;
var(Location) bool Negative_Y;
var(Location) bool Negative_Z;
var(Location) bool SurfaceOnly;
var(Location) bool Velocity;
var(Location) RawDistributionFloat VelocityScale;
var(Location) RawDistributionVector StartLocation;

defaultproperties
{
    Positive_X=True
    Positive_Y=True
    Positive_Z=True
    Negative_X=True
    Negative_Y=True
    Negative_Z=True
    VelocityScale=(Distribution="Default__ParticleModuleLocationPrimitiveBase.DistributionVelocityScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartLocation=(Distribution="Default__ParticleModuleLocationPrimitiveBase.DistributionStartLocation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
}
