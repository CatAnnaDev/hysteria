class KynapseFpdModifierCanGo_AiMesh extends KynapseFpdModifierCanGo
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdModifierCanGo_AiMesh);

var() const array<KynapseAiMeshLayerDefinition> Layers;
var() const array<KynapseAiMeshLayerDefinition> PathObjectLayers;

defaultproperties
{
    ClassName="SphnixCanGo_AiMesh"
}
