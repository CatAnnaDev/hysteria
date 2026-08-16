class TerrainComponent extends PrimitiveComponent
    native
    noexport
    notplaceable;

struct TerrainBVTree
{
    var const native array<int> Nodes;
};

struct TerrainkDOPTree
{
    var const native array<int> Nodes;
    var const native array<int> Triangles;
};

var const array<ShadowMap2D> ShadowMaps;
var const array<Guid> IrrelevantLights;
var const native transient Pointer TerrainObject;
var const int SectionBaseX;
var const int SectionBaseY;
var const int SectionSizeX;
var const int SectionSizeY;
var const int TrueSectionSizeX;
var const int TrueSectionSizeY;
var const native Pointer LightMap;
var const native transient array<int> PatchBounds;
var const native transient array<int> PatchBatches;
var const native transient array<int> BatchMaterials;
var const native transient int FullBatch;
var const native transient Pointer PatchBatchOffsets;
var const native transient Pointer WorkingOffsets;
var const native transient Pointer PatchBatchTriangles;
var const native transient Pointer PatchCachedTessellationValues;
var const native transient Pointer TesselationLevels;
var const native transient TerrainBVTree BVTree;
var const native transient array<Vector> CollisionVertices;
var const native Pointer RBHeightfield;
var const bool bDisplayCollisionLevel;

defaultproperties
{
    ReplacementPrimitive="None"
    bAllowCullDistanceVolume=False
    bUseAsOccluder=True
    bAcceptsStaticDecals=True
    CastShadow=True
    bAcceptsLights=True
    bUsePrecomputedShadows=True
    CollideActors=True
    BlockActors=True
    BlockZeroExtent=True
    BlockNonZeroExtent=True
    BlockRigidBody=True
}
