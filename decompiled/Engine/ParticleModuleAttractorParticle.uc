class ParticleModuleAttractorParticle extends ParticleModuleAttractorBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum EAttractorParticleSelectionMethod
{
    EAPSM_Random,
    EAPSM_Sequential,
};

var(Attractor) export noclear name EmitterName;
var(Attractor) RawDistributionFloat Range;
var(Attractor) bool bStrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bRenewSource;
var(Attractor) bool bInheritSourceVel;
var(Attractor) RawDistributionFloat Strength;
var(Location) EAttractorParticleSelectionMethod SelectionMethod;
var int LastSelIndex;

defaultproperties
{
    Range=(Distribution="Default__ParticleModuleAttractorParticle.DistributionRange",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bStrengthByDistance=True
    Strength=(Distribution="Default__ParticleModuleAttractorParticle.DistributionStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
