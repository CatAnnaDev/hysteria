class PBRuleNodeMesh extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

struct native BuildingMeshInfo
{
    var() StaticMesh Mesh;
    var() float DimX;
    var() float DimZ;
    var() float Chance;
    var() export editinline DistributionVector Translation;
    var() export editinline DistributionVector Rotation;
    var() bool bMeshScaleTranslation;
    var() bool bOverrideMeshLightMapRes;
    var() int OverriddenMeshLightMapRes;
    var array<MaterialInterface> MaterialOverrides;
    var() array<BuildingMatOverrides> SectionOverrides;
};

struct native BuildingMatOverrides
{
    var() array<MaterialInterface> MaterialOptions;
};

var() array<BuildingMeshInfo> BuildingMeshes;
var() BuildingMeshInfo PartialOccludedBuildingMesh;
var() bool bDoOcclusionTest;
var() bool bBlockAll;

native function int PickRandomBuildingMesh()
{
}

defaultproperties
{
    PartialOccludedBuildingMesh=(Mesh="None",DimX=512.0,DimZ=512.0,Chance=1.0,Translation="None",Rotation="None",bMeshScaleTranslation=False,bOverrideMeshLightMapRes=False,OverriddenMeshLightMapRes=32,MaterialOverrides=(),SectionOverrides=())
    bDoOcclusionTest=True
}
