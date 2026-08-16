class TerrainWeightMapTexture extends Texture2D
    native
    notplaceable
    hidecategories(Object,Object);

struct TerrainWeightedMaterial
{
};

var const Terrain ParentTerrain;
var const native array<Pointer> WeightedMaterials;

defaultproperties
{
}
