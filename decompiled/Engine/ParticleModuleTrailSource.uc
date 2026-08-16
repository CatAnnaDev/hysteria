class ParticleModuleTrailSource extends ParticleModuleTrailBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum ETrail2SourceMethod
{
    PET2SRCM_Default,
    PET2SRCM_Particle,
    PET2SRCM_Actor,
};

var(Source) ETrail2SourceMethod SourceMethod;
var(Source) EParticleSourceSelectionMethod SelectionMethod;
var(Source) name SourceName;
var(Source) RawDistributionFloat SourceStrength;
var(Source) bool bLockSourceStength;
var(Source) bool bInheritRotation;
var(Source) int SourceOffsetCount;
var(Source) editfixedsize array<Vector> SourceOffsetDefaults;

defaultproperties
{
    SelectionMethod="EPSSM_Sequential"
    SourceStrength=(Distribution="Default__ParticleModuleTrailSource.DistributionSourceStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000c8420000c8420000c8420000c842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
