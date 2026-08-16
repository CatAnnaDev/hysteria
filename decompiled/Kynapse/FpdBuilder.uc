class FpdBuilder extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(FpdBuilder);

const nbMaxAdditionalData = 4;

enum EDisplayInEditorType
{
    DisplayEditor_None,
    DisplayEditor_All_Always,
    DisplayEditor_Links_Always,
    DisplayEditor_All_Selected,
    DisplayEditor_Links_Selected,
    DisplayEditor_PO_Only,
};

enum E_FB_ProjectType
{
    E_FB_Dynamic,
    E_FB_Direct,
    E_FB_Default,
};

enum EPrelinkCanGoCbk
{
    CanGo_AiMesh,
    CanGo_Capsule,
};

struct native StaticPathobjectEntry
{
    var int Uid;
    var KynapseEntityDefinitionStaticPathObject PathobjectDefinition;
    var int POD_Mask;
    var array<LinkedEdgeStruct> SeedEdges;
};

struct native LinkedEdgeStruct
{
    var Vector Start;
    var Vector End;
    var int Uid;
};

struct native FpdBuilderParams
{
    var const E_FB_ProjectType ProjectType;
    var const int RuntimeMemory;
    var const string TargetDirectory;
    var const string TargetName;
    var const string PoDefPath;
    var array<FpdBuilderGraphParamsList> GraphsList;
    var const string WorkspaceFilename;
};

struct native FpdBuilderGraphParamsList
{
    var array<FpdBuilderGraphParams> Graphs;
    var const int alternateId;
};

struct native FpdBuilderGraphParams
{
    var() const string Name;
    var() const string GraphPath;
    var() const int NbVertices;
    var() const int NbEdges;
    var() const int GraphFileSize;
    var() const Box BoundingBox;
};

struct native PrelinkProcessParams
{
    var array<SectorDefinitionList> sectorsList;
};

struct native SectorDefinitionList
{
    var array<SectorDefinition> sectors;
    var const int alternateId;
};

struct native SectorDefinition
{
    var string inputGraphPath;
    var string inputAIMeshPath;
    var string outputGraphPath;
    var Box BoundingBox;
    var int Id;
};

var const bool Active;
var() bool displayInGame;
var() const PrelinkProcessParams preLinkerProcess;
var() const FpdBuilderParams FpdBuilder;
var() KynapseTag DataTag;
var() const export editinline KynapseFpdDatabase database;
var() const export editinline array<KynapseAdditionalData> AdditionalDataList;
var() EDisplayInEditorType displayInEditor;

defaultproperties
{
    Active=True
    FpdBuilder=(ProjectType="E_FB_Direct",RuntimeMemory=2048,TargetDirectory="./",TargetName="FpdPathdata",PoDefPath="",GraphsList=(),WorkspaceFilename="./")
}
