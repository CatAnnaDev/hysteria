class AliceActorFactoryArchetypeAI extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() Pawn ArchetypePawn;
var() class<AIController> ControllerClass;
var() string PawnName;

defaultproperties
{
    ControllerClass="AliceGameKynapseAIController"
}
