class KynapseStandardPathdataGenerationService extends Actor
    abstract
    native
    placeable
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug)
    autoexpandcategories(KynapseStandardPathdataGenerationService);

struct native AdditionalDataParams
{
    var() const export editinline array<KynapseAdditionalData> VerticesAdditionalData;
    var() const export editinline array<KynapseAdditionalData> EdgesAdditionalData;
};

var const bool Active;
var() const bool displayInEditor;
var const bool displayInGame;
var const bool streamed;
var() bool UseKynapseDataPackage;
var Pointer displayGraph;
var() const editinline KynapseExplorationVolume ExplorationBoundingBox;
var() const editinline array<Actor> seeds;
var() const float DistEdgeMax;
var() const float EntityRadius;
var() duplicatetransient string displayNameInPie;
var() duplicatetransient editconst KynapseGraph outputGraph;
var() duplicatetransient editconst KynapseGraph outputLinkedGraph;
var() duplicatetransient editconst KynapseMesh outputLinkedAiMesh;
var Pointer loadedGraph;
var Pointer loadedAIMesh;
var() const KynapseTag DataTag;
var() const duplicatetransient editconst Guid MapBuilderGuid;
var const int Uid;
var() const AdditionalDataParams additionalData;
var() export editinline array<KynapsePathdataGenerationModifier> Modifiers;

defaultproperties
{
    Modifiers(0)="Default__KynapseStandardPathdataGenerationService.ModJumps"
    Modifiers(1)="Default__KynapseStandardPathdataGenerationService.ModLadders"
    Components(0)="Default__KynapseStandardPathdataGenerationService.Sprite"
    Components(1)="Default__KynapseStandardPathdataGenerationService.PathdataRenderer"
    CollisionType="COLLIDE_CustomDefault"
}
