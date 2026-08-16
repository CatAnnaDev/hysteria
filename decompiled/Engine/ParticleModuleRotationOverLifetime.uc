class ParticleModuleRotationOverLifetime extends ParticleModuleRotationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Rotation) RawDistributionFloat RotationOverLife;
var(Rotation) bool Scale;

defaultproperties
{
    RotationOverLife=(Distribution="Default__ParticleModuleRotationOverLifetime.DistributionRotOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Scale=True
    bUpdateModule=True
}
