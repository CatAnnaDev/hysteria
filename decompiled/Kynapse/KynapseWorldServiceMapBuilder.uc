class KynapseWorldServiceMapBuilder extends KynapseStandardPathdataGenerationService
    native
    placeable
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseStandardPathdataGenerationService,KynapseWorldServiceMapBuilder);

enum ECollisionModel
{
    A_Sphere,
    B_SweptSphere,
};

enum EProcessStep
{
    A_Exploration,
    B_Analysis,
    C_GraphCreation,
    D_GraphOptimization,
};

struct native HidingDataParams
{
    var() const bool GenerateHidingPoints;
    var() const float MaxDistanceToWall;
    var() const int SmallRaycastDelta;
    var() const float MinDistanceBetweenVertices;
    var() const int MinConeOfVisionSize;
};

struct native AdvancedParams
{
    var() const int LocalMapSize;
    var() const int MaxMapSize;
    var() const bool SimulateGroundAroundBoundingBox;
    var() const bool ForbidCollidingEdge;
    var() const float OverConnectionRatio;
    var() const int ComponentSizeMin;
    var() const ECollisionModel CollisionModel;
};

struct native ProcessParams
{
    var() const EProcessStep FirstStep;
    var() const EProcessStep LastStep;
    var EProcessStep dummy1;
    var EProcessStep dummy2;
};

struct native AccuracyParams
{
    var() const float Pitch;
    var() const float graphAccuracy;
    var() const float nbSectors;
    var() const float edgeRadius;
    var() const float MaxDeltaHeight;
};

struct native PhysicalParams
{
    var() const float entityHeight;
    var() const float StepLength;
    var() const float stepMax;
    var() const float holeMax;
    var() const bool CheckGroundSlope;
    var() const float groundSlopeMax;
    var() const float groundSlopeMin;
};

var const string Filename;
var() duplicatetransient KynapseMesh outputAiMesh;
var duplicatetransient KynapseUDG outputUDG;
var() const bool useUDGAlts;
var const bool ExploreAll;
var() const editinline array<KynapseExclusionVolume> exclusionAreas;
var const array<KynapseLocalRecomputationVolume> areasToExplore;
var Pointer areasToExplorePointer;
var() const PhysicalParams Physical;
var() const AccuracyParams Accuracy;
var() const ProcessParams Process;
var() const AdvancedParams Advanced;
var Pointer displayAIMesh;
var() const HidingDataParams hidingData;

defaultproperties
{
    Filename="pathdata"
    Physical=(entityHeight=1.8,StepLength=0.3,stepMax=0.3,holeMax=0.5,CheckGroundSlope=True,groundSlopeMax=45.0,groundSlopeMin=45.0)
    Accuracy=(Pitch=0.2,graphAccuracy=1.5,nbSectors=64.0,edgeRadius=0.58,MaxDeltaHeight=100.0)
    Process=(FirstStep="A_Exploration",LastStep="D_GraphOptimization",dummy1="A_Exploration",dummy2="A_Exploration")
    Advanced=(LocalMapSize=50,MaxMapSize=20000000,SimulateGroundAroundBoundingBox=True,ForbidCollidingEdge=False,OverConnectionRatio=1.2,ComponentSizeMin=1,CollisionModel="A_Sphere")
    hidingData=(GenerateHidingPoints=False,MaxDistanceToWall=2.0,SmallRaycastDelta=1,MinDistanceBetweenVertices=3.0,MinConeOfVisionSize=25)
    Active=True
    DistEdgeMax=8.0
    EntityRadius=0.57
    Modifiers(0)="Default__KynapseWorldServiceMapBuilder.ModJumps"
    Modifiers(1)="Default__KynapseWorldServiceMapBuilder.ModLadders"
    Components(0)="Default__KynapseWorldServiceMapBuilder.Sprite"
    Components(1)="Default__KynapseWorldServiceMapBuilder.PathdataRenderer"
}
