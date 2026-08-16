class ParticleModuleUberLTISIVCL extends ParticleModuleUberBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) export noclear RawDistributionFloat Lifetime;
var(Size) export noclear RawDistributionVector StartSize;
var(Velocity) export noclear RawDistributionVector StartVelocity;
var(Velocity) export noclear RawDistributionFloat StartVelocityRadial;
var(Color) export noclear RawDistributionVector ColorOverLife;
var(Color) export noclear RawDistributionFloat AlphaOverLife;

defaultproperties
{
    Lifetime=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionLifetime",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartSize=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionStartSize",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartVelocity=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionStartVelocity",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 0000000000002041000000000000000000000000000000000000000000002041000000000000000000000000000000000000000000002041,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartVelocityRadial=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionStartVelocityRadial",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    ColorOverLife=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionColorOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaOverLife=(Distribution="Default__ParticleModuleUberLTISIVCL.DistributionAlphaOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 66e67f4366e67f4366e67f4366e67f43,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RequiredModules(0)="ParticleModuleLifetime"
    RequiredModules(1)="ParticleModuleSize"
    RequiredModules(2)="ParticleModuleVelocity"
    RequiredModules(3)="ParticleModuleColorOverLife"
    bSpawnModule=True
    bUpdateModule=True
}
