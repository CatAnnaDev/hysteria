class FoliageFactory extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

struct native FoliageMesh
{
    var() StaticMesh InstanceStaticMesh;
    var() MaterialInterface Material;
    var() float MaxDrawRadius;
    var() float MinTransitionRadius;
    var() float MinThinningRadius;
    var() Vector MinScale;
    var() Vector MaxScale;
    var() float MinUniformScale;
    var() float MaxUniformScale;
    var() float SwayScale;
    var() int Seed;
    var() float SurfaceAreaPerInstance;
    var() bool bCreateInstancesOnBSP;
    var() bool bCreateInstancesOnStaticMeshes;
    var() bool bCreateInstancesOnTerrain;
    var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
    var export editinline FoliageComponent Component;
};

var(Foliage) const array<FoliageMesh> Meshes;
var(Foliage) const float VolumeFalloffRadius;
var(Foliage) const float VolumeFalloffExponent;
var(Foliage) const float SurfaceDensityUpFacing;
var(Foliage) const float SurfaceDensityDownFacing;
var(Foliage) const float SurfaceDensitySideFacing;
var(Foliage) const float FacingFalloffExponent;
var(Foliage) const int MaxInstanceCount;

defaultproperties
{
    VolumeFalloffExponent=1.0
    SurfaceDensityUpFacing=1.0
    SurfaceDensityDownFacing=1.0
    SurfaceDensitySideFacing=1.0
    FacingFalloffExponent=2.0
    MaxInstanceCount=10000
    BrushComponent="Default__FoliageFactory.BrushComponent0"
    bHidden=False
    bMovable=False
    Components(0)="Default__FoliageFactory.BrushComponent0"
    CollisionComponent="Default__FoliageFactory.BrushComponent0"
}
