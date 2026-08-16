class ParticleModuleRequired extends ParticleModule
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Cascade);

enum EEmitterNormalsMode
{
    ENM_CameraFacing,
    ENM_Spherical,
    ENM_Cylindrical,
};

enum EParticleSortMode
{
    PSORTMODE_None,
    PSORTMODE_ViewProjDepth,
    PSORTMODE_DistanceToView,
    PSORTMODE_Age_OldestFirst,
    PSORTMODE_Age_NewestFirst,
};

var(Emitter) MaterialInterface Material;
var(Emitter) EParticleScreenAlignment ScreenAlignment;
var(Emitter) EParticleSortMode SortMode;
var EParticleBurstMethod ParticleBurstMethod;
var(SubUV) EParticleSubUVInterpMethod InterpolationMethod;
var(Normals) EEmitterNormalsMode EmitterNormalsMode;
var(Emitter) bool bUseLocalSpace;
var(Emitter) bool bKillOnDeactivate;
var(Emitter) bool bKillOnCompleted;
var deprecated bool bRequiresSorting;
var(Emitter) bool bUseLegacyEmitterTime;
var(Duration) bool bEmitterDurationUseRange;
var(Duration) bool bDurationRecalcEachLoop;
var(Delay) bool bEmitterDelayUseRange;
var(Delay) bool bDelayFirstLoopOnly;
var(SubUV) bool bScaleUV;
var bool bDirectUV;
var(Rendering) bool bUseMaxDrawCount;
var(Duration) float EmitterDuration;
var(Duration) float EmitterDurationLow;
var(Duration) int EmitterLoops;
var RawDistributionFloat SpawnRate;
var export noclear array<ParticleBurst> BurstList;
var(Delay) float EmitterDelay;
var(Delay) float EmitterDelayLow;
var(SubUV) int SubImages_Horizontal;
var(SubUV) int SubImages_Vertical;
var float RandomImageTime;
var(SubUV) int RandomImageChanges;
var(Rendering) int MaxDrawCount;
var(Rendering) float DownsampleThresholdScreenFraction;
var(Normals) Vector NormalsSphereCenter;
var(Normals) Vector NormalsCylinderDirection;

defaultproperties
{
    bUseLegacyEmitterTime=True
    bUseMaxDrawCount=True
    EmitterDuration=1.0
    SpawnRate=(Distribution="Default__ParticleModuleRequired.RequiredDistributionSpawnRate",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SubImages_Horizontal=1
    SubImages_Vertical=1
    MaxDrawCount=500
    NormalsSphereCenter=(X=0.0,Y=0.0,Z=100.0)
    NormalsCylinderDirection=(X=0.0,Y=0.0,Z=1.0)
    bSpawnModule=True
    bUpdateModule=True
}
