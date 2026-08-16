class ParticleModuleUberRainImpacts extends ParticleModuleUberBase
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
var(Location) bool bIsUsingCylinder;
var(Location) bool bPositive_X;
var(Location) bool bPositive_Y;
var(Location) bool bPositive_Z;
var(Location) bool bNegative_X;
var(Location) bool bNegative_Y;
var(Location) bool bNegative_Z;
var(Location) bool bSurfaceOnly;
var(Location) bool bVelocity;
var(Location) bool bRadialVelocity;
var(Size) RawDistributionVector LifeMultiplier;
var(Location) RawDistributionFloat PC_VelocityScale;
var(Location) RawDistributionVector PC_StartLocation;
var(Location) RawDistributionFloat PC_StartRadius;
var(Location) RawDistributionFloat PC_StartHeight;
var(Location) CylinderHeightAxis PC_HeightAxis;
var(Color) RawDistributionVector ColorOverLife;
var(Color) RawDistributionFloat AlphaOverLife;

defaultproperties
{
    Lifetime=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionLifetime",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartSize=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionStartSize",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartRotation=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionStartRotation",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 000000000000b4430000000000000000000000000000b4430000b4430000b4430000000000000000000000000000b4430000b4430000b443,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MultiplyX=True
    MultiplyY=True
    MultiplyZ=True
    bIsUsingCylinder=True
    bPositive_X=True
    bPositive_Y=True
    bPositive_Z=True
    bNegative_X=True
    bNegative_Y=True
    bNegative_Z=True
    bRadialVelocity=True
    LifeMultiplier=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionLifeMultiplier",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    PC_VelocityScale=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionPC_VelocityScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    PC_StartLocation=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionPC_StartLocation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    PC_StartRadius=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionPC_StartRadius",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    PC_StartHeight=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionPC_StartHeight",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    PC_HeightAxis="PMLPC_HEIGHTAXIS_Z"
    ColorOverLife=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionColorOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    AlphaOverLife=(Distribution="Default__ParticleModuleUberRainImpacts.DistributionAlphaOverLife",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 66e67f4366e67f4366e67f4366e67f43,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
    bSupported3DDrawMode=True
}
