class ParticleModuleTypeDataBeam extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum EBeamEndPointMethod
{
    PEBEPM_Calculated,
    PEBEPM_Distribution,
    PEBEPM_Distribution_Constant,
};

enum EBeamMethod
{
    PEBM_Distance,
    PEBM_EndPoints,
    PEBM_EndPoints_Interpolated,
    PEBM_UserSet_EndPoints,
    PEBM_UserSet_EndPoints_Interpolated,
};

var(Beam) EBeamMethod BeamMethod;
var(Beam) EBeamEndPointMethod EndPointMethod;
var(Beam) RawDistributionFloat Distance;
var(Beam) RawDistributionVector EndPoint;
var(Beam) int TessellationFactor;
var(Beam) RawDistributionFloat EmitterStrength;
var(Beam) RawDistributionFloat TargetStrength;
var(Beam) RawDistributionVector EndPointDirection;
var(Beam) int TextureTile;
var(Beam) bool RenderGeometry;
var(Beam) bool RenderDirectLine;
var(Beam) bool RenderLines;
var(Beam) bool RenderTessellation;

defaultproperties
{
    Distance=(Distribution="Default__ParticleModuleTypeDataBeam.DistributionDistance",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    EndPoint=(Distribution="Default__ParticleModuleTypeDataBeam.DistributionEndPoint",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TessellationFactor=1
    EmitterStrength=(Distribution="Default__ParticleModuleTypeDataBeam.DistributionEmitterStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00007a4400007a4400007a4400007a44,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TargetStrength=(Distribution="Default__ParticleModuleTypeDataBeam.DistributionTargetStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00007a4400007a4400007a4400007a44,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    EndPointDirection=(Distribution="Default__ParticleModuleTypeDataBeam.DistributionEndPointDirection",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 000000000000803f0000803f00000000000000000000803f0000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RenderGeometry=True
    bSpawnModule=True
    bUpdateModule=True
}
