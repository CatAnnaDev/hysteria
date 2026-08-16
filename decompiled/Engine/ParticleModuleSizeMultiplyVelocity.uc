class ParticleModuleSizeMultiplyVelocity extends ParticleModuleSizeBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Size) RawDistributionVector VelocityMultiplier;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

defaultproperties
{
    VelocityMultiplier=(Distribution="Default__ParticleModuleSizeMultiplyVelocity.DistributionVelocityMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MultiplyX=True
    MultiplyY=True
    MultiplyZ=True
    bSpawnModule=True
    bUpdateModule=True
}
