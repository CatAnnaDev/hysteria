class KynapseActorFactoryAI extends ActorFactoryAI
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() KynapseEntityDefinitionActive kynapseDefinition;

defaultproperties
{
    kynapseDefinition="KynapseDefaultDefinitions.DefaultPawnHierDef"
    ControllerClass="KynapseAIController"
}
