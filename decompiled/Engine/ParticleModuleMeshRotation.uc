class ParticleModuleMeshRotation extends ParticleModuleRotationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Rotation) RawDistributionVector StartRotation;
var(Rotation) bool bInheritParent;

defaultproperties
{
    StartRotation=(Distribution="Default__ParticleModuleMeshRotation.DistributionStartRotation",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 000000000000b4430000000000000000000000000000b4430000b4430000b4430000000000000000000000000000b4430000b4430000b443,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
}
