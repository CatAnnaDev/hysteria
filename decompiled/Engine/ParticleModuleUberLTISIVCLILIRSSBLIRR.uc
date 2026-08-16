class ParticleModuleUberLTISIVCLILIRSSBLIRR extends ParticleModuleUberBase
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
var(Location) export noclear RawDistributionVector StartLocation;
var(Rotation) export noclear RawDistributionFloat StartRotation;
var(Size) export noclear RawDistributionVector SizeLifeMultiplier;
var(Size) bool SizeMultiplyX;
var(Size) bool SizeMultiplyY;
var(Size) bool SizeMultiplyZ;
var(Rotation) export noclear RawDistributionFloat StartRotationRate;

defaultproperties
{
    Lifetime=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionLifetime",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartSize=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartSize",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartVelocity=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartVelocity",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 0000000000002041000000000000000000000000000000000000000000002041000000000000000000000000000000000000000000002041,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartVelocityRadial=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartVelocityRadial",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    ColorOverLife=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionColorOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaOverLife=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionAlphaOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 66e67f4366e67f4366e67f4366e67f43,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartLocation=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartLocation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartRotation=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartRotation",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=2,LookupTable=// [raw] 000000000000803f000000000000803f000000000000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SizeLifeMultiplier=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SizeMultiplyX=True
    SizeMultiplyY=True
    SizeMultiplyZ=True
    StartRotationRate=(Distribution="Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartRotationRate",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RequiredModules(0)="ParticleModuleLifetime"
    RequiredModules(1)="ParticleModuleSize"
    RequiredModules(2)="ParticleModuleVelocity"
    RequiredModules(3)="ParticleModuleColorOverLife"
    RequiredModules(4)="ParticleModuleLocation"
    RequiredModules(5)="ParticleModuleRotation"
    RequiredModules(6)="ParticleModuleSizeMultiplyLife"
    RequiredModules(7)="ParticleModuleRotationRate"
    bSpawnModule=True
    bUpdateModule=True
}
