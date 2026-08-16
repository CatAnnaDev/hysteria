class ParticleModuleSizeScale extends ParticleModuleSizeBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var() RawDistributionVector SizeScale;
var() bool EnableX;
var() bool EnableY;
var() bool EnableZ;

defaultproperties
{
    SizeScale=(Distribution="Default__ParticleModuleSizeScale.DistributionSizeScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    EnableX=True
    EnableY=True
    EnableZ=True
    bUpdateModule=True
}
