class ParticleModuleKillHeight extends ParticleModuleKillBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Kill) RawDistributionFloat Height;
var(Kill) bool bAbsolute;
var(Kill) bool bFloor;

defaultproperties
{
    Height=(Distribution="Default__ParticleModuleKillHeight.DistributionHeight",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bUpdateModule=True
    bSupported3DDrawMode=True
}
