class ParticleModuleTypeDataRibbon extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum ETrailsRenderAxisOption
{
    Trails_CameraUp,
    Trails_SourceUp,
    Trails_WorldUp,
};

var int MaxTessellationBetweenParticles;
var(Trail) int SheetsPerTrail;
var(Trail) int MaxTrailCount;
var(Trail) int MaxParticleInTrailCount;
var(Trail) bool bDeadTrailsOnDeactivate;
var(Trail) bool bClipSourceSegement;
var(Trail) bool bEnablePreviousTangentRecalculation;
var(Trail) bool bTangentRecalculationEveryFrame;
var(Rendering) bool bRenderGeometry;
var(Rendering) bool bRenderSpawnPoints;
var(Rendering) bool bRenderTangents;
var(Rendering) bool bRenderTessellation;
var(Trail) ETrailsRenderAxisOption RenderAxis;
var(Spawn) float TangentSpawningScalar;
var(Rendering) float TilingDistance;
var(Rendering) float DistanceTessellationStepSize;
var(Rendering) float TangentTessellationScalar;

defaultproperties
{
    MaxTessellationBetweenParticles=25
    SheetsPerTrail=1
    MaxTrailCount=1
    MaxParticleInTrailCount=500
    bDeadTrailsOnDeactivate=True
    bClipSourceSegement=True
    bEnablePreviousTangentRecalculation=True
    bRenderGeometry=True
    DistanceTessellationStepSize=15.0
    TangentTessellationScalar=5.0
}
