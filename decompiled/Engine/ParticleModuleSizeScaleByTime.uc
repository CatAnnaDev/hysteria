class ParticleModuleSizeScaleByTime extends ParticleModuleSizeBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var() RawDistributionVector SizeScaleByTime;
var() bool bEnableX;
var() bool bEnableY;
var() bool bEnableZ;

defaultproperties
{
    SizeScaleByTime=(Distribution="Default__ParticleModuleSizeScaleByTime.DistributionSizeScaleByTime",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bEnableX=True
    bEnableY=True
    bEnableZ=True
    bSpawnModule=True
    bUpdateModule=True
}
