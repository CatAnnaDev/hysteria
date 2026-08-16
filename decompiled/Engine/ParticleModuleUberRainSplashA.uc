class ParticleModuleUberRainSplashA extends ParticleModuleUberBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) RawDistributionFloat Lifetime;
var(Size) RawDistributionVector StartSize;
var(Rotation) RawDistributionVector StartRotation;
var(Rotation) bool bInheritParent;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;
var(Size) RawDistributionVector LifeMultiplier;
var(Color) RawDistributionVector ColorOverLife;
var(Color) RawDistributionFloat AlphaOverLife;

defaultproperties
{
    Lifetime=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionLifetime",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartSize=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionStartSize",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartRotation=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionStartRotation",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 000000000000b4430000000000000000000000000000b4430000b4430000b4430000000000000000000000000000b4430000b4430000b443,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MultiplyX=True
    MultiplyY=True
    MultiplyZ=True
    LifeMultiplier=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    ColorOverLife=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionColorOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaOverLife=(Distribution="Default__ParticleModuleUberRainSplashA.DistributionAlphaOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 66e67f4366e67f4366e67f4366e67f43,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
}
