class ParticleModuleTypeDataTrail2 extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Trail) int TessellationFactor;
var float TessellationFactorDistance;
var(Trail) float TessellationStrength;
var(Trail) int TextureTile;
var int Sheets;
var(Trail) int MaxTrailCount;
var(Trail) int MaxParticleInTrailCount;
var(Trail) bool bClipSourceSegement;
var(Trail) bool bUseMinParticleDistanceForTessellation;
var(Trail) bool bUseLoopSpawn;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;
var(Rendering) bool RenderAsTrailOfBlade;
var(Trail) float MinParticleDistance;
var(Trail) Vector LocalBasePoints[2];
var(Trail) float MinTessellationDistance;

defaultproperties
{
    TessellationFactor=1
    TessellationStrength=25.0
    TextureTile=1
    Sheets=1
    MaxTrailCount=1
    bUseMinParticleDistanceForTessellation=True
    RenderGeometry=True
    MinParticleDistance=10.0
    LocalBasePoints[1]=(X=0.0,Y=0.0,Z=-10.0)
}
