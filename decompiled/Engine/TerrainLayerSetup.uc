class TerrainLayerSetup extends Object
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct TerrainFilteredMaterial
{
    var() bool UseNoise;
    var() float NoiseScale;
    var() float NoisePercent;
    var() FilterLimit MinHeight;
    var() FilterLimit MaxHeight;
    var() FilterLimit MinSlope;
    var() FilterLimit MaxSlope;
    var() float Alpha;
    var() TerrainMaterial Material;
};

struct FilterLimit
{
    var() bool Enabled;
    var() float Base;
    var() float NoiseScale;
    var() float NoiseAmount;
};

var() const array<TerrainFilteredMaterial> Materials;

simulated function PostBeginPlay()
{
}

native final function SetMaterials(array<TerrainFilteredMaterial> NewMaterials)
{
    NewMaterials;
}

defaultproperties
{
}
