class KynapseEntityDefinitionActive extends KynapseEntityDefinition
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display);

var() const string EntityClassName;
var() const string ActionClassName;
var() const export editinline KynapseBrain KynapseBrainDefinition;
var() const KynapseProfileDefinition Profile;
var() const KynapseMesh AiMesh;
var() const KynapseTag DefaultDataTag;

defaultproperties
{
    EntityClassName="CUnrealEntity"
    ActionClassName="SphinxNpcAction"
    KynapseBrainDefinition="Default__KynapseEntityDefinitionActive.unrealFpdBrain"
}
