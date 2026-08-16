class ParticleModuleSubUVMovie extends ParticleModuleSubUV
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,Object,SubUV);

var(FlipBook) bool bUseEmitterTime;
var(FlipBook) RawDistributionFloat FrameRate;
var(FlipBook) int StartingFrame;

defaultproperties
{
    FrameRate=(Distribution="Default__ParticleModuleSubUVMovie.DistributionFrameRate",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000f0410000f0410000f0410000f041,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartingFrame=1
    SubImageIndex=(Distribution="Default__ParticleModuleSubUVMovie.DistributionSubImage")
}
