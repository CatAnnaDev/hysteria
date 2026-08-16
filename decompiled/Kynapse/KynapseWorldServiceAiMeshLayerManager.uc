class KynapseWorldServiceAiMeshLayerManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseWorldServiceAiMeshLayerManager);

var() const array<KynapseAiMeshLayerDefinition> Layers;

defaultproperties
{
    Layers(0)="KynapseDefaultDefinitions.ObstacleLayer"
    serviceName="AiMeshLayerManager"
    ClassName="CAiMeshLayerManager"
}
