class ProcBuildingRuleset extends Object
    native
    notplaceable
    hidecategories(Object);

enum EProcBuildingAxis
{
    EPBAxis_X,
    EPBAxis_Z,
};

struct native PBParamSwatch
{
    var() name SwatchName;
    var() array<PBMaterialParam> Params;
};

struct native PBVariationInfo
{
    var() name VariationName;
    var() bool bMeshOnTopOfFacePoly;
};

var export editinline PBRuleNodeBase RootRule;
var transient editoronly bool bBeingEdited;
var() bool bEnableInteriorTexture;
var() bool bLODOnlyRoof;
var() MaterialInterface DefaultRoofMaterial;
var() MaterialInterface DefaultFloorMaterial;
var() MaterialInterface DefaultNonRectWallMaterial;
var() float RoofZOffset;
var() float NotRoofZOffset;
var() float FloorZOffset;
var() float NotFloorZOffset;
var() float RoofPolyInset;
var() float FloorPolyInset;
var() float BuildingLODSpecular;
var() float RoofEdgeScopeRaise;
var() Texture LODCubemap;
var() Texture InteriorTexture;
var() array<PBVariationInfo> Variations;
var() array<PBParamSwatch> ParamSwatches;
var editoronly array<PBRuleNodeComment> Comments;

defaultproperties
{
    bEnableInteriorTexture=True
    BuildingLODSpecular=2.0
}
