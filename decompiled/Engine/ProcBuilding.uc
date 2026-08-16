class ProcBuilding extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

const PROCBUILDING_VERSION = 1;
const ROOF_MINZ = 0.7;

enum EBuildingStatsBrowserColumns
{
    BSBC_Name,
    BSBC_Ruleset,
    BSBC_NumStaticMeshComps,
    BSBC_NumInstancedStaticMeshComps,
    BSBC_NumInstancedTris,
    BSBC_LightmapMemBytes,
    BSBC_ShadowmapMemBytes,
    BSBC_LODDiffuseMemBytes,
    BSBC_LODLightingMemBytes,
};

enum EPBCornerType
{
    EPBC_Default,
    EPBC_Chamfer,
    EPBC_Round,
};

enum EScopeEdge
{
    EPSA_Top,
    EPSA_Bottom,
    EPSA_Left,
    EPSA_Right,
    EPSA_None,
};

struct native PBMemUsageInfo
{
    var ProcBuilding Building;
    var ProcBuildingRuleset Ruleset;
    var int NumStaticMeshComponent;
    var int NumInstancedStaticMeshComponents;
    var int NumInstancedTris;
    var int LightmapMemBytes;
    var int ShadowmapMemBytes;
    var int LODDiffuseMemBytes;
    var int LODLightingMemBytes;
};

struct native PBMaterialParam
{
    var() name ParamName;
    var() LinearColor Color;
};

struct native PBFracMeshCompInfo
{
    var export editinline FracturedStaticMeshComponent FracMeshComp;
    var int TopLevelScopeIndex;
};

struct native PBMeshCompInfo
{
    var export editinline StaticMeshComponent MeshComp;
    var int TopLevelScopeIndex;
};

struct native PBEdgeInfo
{
    var Vector EdgeEnd;
    var Vector EdgeStart;
    var int ScopeAIndex;
    var EScopeEdge ScopeAEdge;
    var int ScopeBIndex;
    var EScopeEdge ScopeBEdge;
    var float EdgeAngle;
};

struct native PBFaceUVInfo
{
    var Vector2D Offset;
    var Vector2D Size;
};

struct native PBScopeProcessInfo
{
    var ProcBuilding OwningBuilding;
    var ProcBuildingRuleset Ruleset;
    var name RulesetVariation;
    var bool bGenerateLODPoly;
    var bool bPartOfNonRect;
};

struct native PBScope2D
{
    var Matrix ScopeFrame;
    var float DimX;
    var float DimZ;
};

var() editoronly ProcBuildingRuleset Ruleset;
var() const editconst array<PBMeshCompInfo> BuildingMeshCompInfos;
var() const editconst array<PBFracMeshCompInfo> BuildingFracMeshCompInfos;
var() const export editconst editinline StaticMeshComponent SimpleMeshComp;
var() bool bGenerateRoofMesh;
var() bool bGenerateFloorMesh;
var() bool bApplyRulesToRoof;
var() bool bApplyRulesToFloor;
var() bool bSplitWallsAtRoofLevels;
var() bool bSplitWallsAtWallEdges;
var transient bool bQuickEdited;
var() bool bBuildingBrushCollision;
var(Debug) bool bDebugDrawEdgeInfo;
var(Debug) bool bDebugDrawScopes;
var const export editinline array<StaticMeshComponent> LODMeshComps;
var editoronly array<PBFaceUVInfo> LODMeshUVInfos;
var editoronly array<PBScope2D> TopLevelScopes;
var int NumMeshedTopLevelScopes;
var editoronly array<PBFaceUVInfo> TopLevelScopeUVInfos;
var editoronly array<PBScopeProcessInfo> TopLevelScopeInfos;
var editoronly array<PBEdgeInfo> EdgeInfos;
var float MaxFacadeZ;
var float MinFacadeZ;
var transient array<ProcBuilding> OverlappingBuildings;
var() float SimpleMeshMassiveLODDistance;
var() float RenderToTexturePullBackAmount;
var() int RoofLightmapRes;
var() int NonRectWallLightmapRes;
var() editoronly float LODRenderToTextureScale;
var() name ParamSwatchName;
var() array<PBMaterialParam> BuildingMaterialParams;
var editoronly array<MaterialInstanceConstant> BuildingMatParamMICs;
var() const duplicatetransient editconst StaticMeshActor LowLODPersistentActor;
var transient export editinline StaticMeshComponent CurrentSimpleMeshComp;
var transient Actor CurrentSimpleMeshActor;
var editoronly array<ProcBuilding> AttachedBuildings;
var const int BuildingInstanceVersion;

native function int FindEdgeForTopLevelScope(int TopLevelScopeIndex, EScopeEdge Edge)
{
    TopLevelScopeIndex;
    Edge;
}

native function BreakFractureComponent(FracturedStaticMeshComponent Comp, Vector BoxMin, Vector BoxMax)
{
    Comp;
    BoxMin;
    BoxMax;
}

native function GetAllGroupedProcBuildings(out array<ProcBuilding> OutSet)
{
    OutSet;
}

native function ProcBuilding GetBaseMostBuilding()
{
}

native function array<StaticMeshComponent> FindComponentsForTopLevelScope(int TopLevelScopeIndex)
{
    TopLevelScopeIndex;
}

native function ClearBuildingMeshes()
{
}

defaultproperties
{
    bGenerateRoofMesh=True
    bSplitWallsAtRoofLevels=True
    bSplitWallsAtWallEdges=True
    bBuildingBrushCollision=True
    SimpleMeshMassiveLODDistance=10000.0
    RenderToTexturePullBackAmount=125.0
    RoofLightmapRes=64
    NonRectWallLightmapRes=64
    LODRenderToTextureScale=1.0
    LowLODPersistentActor="None"
    BrushColor=(B=135,G=255,R=222,A=255)
    bColored=True
    BrushComponent="Default__ProcBuilding.BrushComponent0"
    bHidden=False
    bWorldGeometry=True
    bRouteBeginPlayEvenIfStatic=False
    bGameRelevant=True
    bMovable=False
    bBlockActors=True
    bForceOctreeSNFilter=True
    bPathColliding=True
    Components(0)="Default__ProcBuilding.BrushComponent0"
    CollisionComponent="Default__ProcBuilding.BrushComponent0"
}
