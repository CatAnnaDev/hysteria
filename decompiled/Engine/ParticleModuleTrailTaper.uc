class ParticleModuleTrailTaper extends ParticleModuleTrailBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ETrailTaperMethod
{
    PETTM_None,
    PETTM_Full,
    PETTM_Partial,
};

var(Taper) ETrailTaperMethod TaperMethod;
var(Taper) RawDistributionFloat TaperFactor;

defaultproperties
{
    TaperFactor=(Distribution="Default__ParticleModuleTrailTaper.DistributionTaperFactor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
