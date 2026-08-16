class TerrainMaterial extends Object
    native
    notplaceable
    hidecategories(Object);

enum ETerrainMappingType
{
    TMT_Auto,
    TMT_XY,
    TMT_XZ,
    TMT_YZ,
};

struct native TerrainFoliageMesh
{
    var() StaticMesh StaticMesh;
    var() MaterialInterface Material;
    var() int Density;
    var() float MaxDrawRadius;
    var() float MinTransitionRadius;
    var() float MinScale;
    var() float MaxScale;
    var() float MinUniformScale;
    var() float MaxUniformScale;
    var() float MinThinningRadius;
    var() int Seed;
    var() float SwayScale;
    var() float AlphaMapThreshold;
    var() float SlopeRotationBlend;
};

var Matrix LocalToMapping;
var(Material) ETerrainMappingType MappingType;
var(Material) float MappingScale;
var(Material) float MappingRotation;
var(Material) float MappingPanU;
var(Material) float MappingPanV;
var(Material) MaterialInterface Material;
var(Displacement) Texture2D DisplacementMap;
var(Displacement) float DisplacementScale;
var(Foliage) array<TerrainFoliageMesh> FoliageMeshes;

defaultproperties
{
    MappingScale=4.0
    DisplacementScale=0.25
}
