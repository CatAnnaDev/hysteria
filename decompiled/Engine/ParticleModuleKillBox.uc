class ParticleModuleKillBox extends ParticleModuleKillBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Kill) RawDistributionVector LowerLeftCorner;
var(Kill) RawDistributionVector UpperRightCorner;
var(Kill) bool bAbsolute;
var(Kill) bool bKillInside;

defaultproperties
{
    LowerLeftCorner=(Distribution="Default__ParticleModuleKillBox.DistributionLowerLeftCorner",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    UpperRightCorner=(Distribution="Default__ParticleModuleKillBox.DistributionUpperRightCorner",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bUpdateModule=True
    bSupported3DDrawMode=True
}
