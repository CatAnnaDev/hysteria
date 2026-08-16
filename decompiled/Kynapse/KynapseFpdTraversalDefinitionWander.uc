class KynapseFpdTraversalDefinitionWander extends KynapseFpdTraversalDefinition
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,KynapseClass);

var() const float MaxDistance;
var() const float MaxCost;
var() const float WanderDistance;
var() const float WanderPropagationAngle;

defaultproperties
{
    MaxDistance=340282346638528859811704183484516925440.0
    MaxCost=340282346638528859811704183484516925440.0
    WanderDistance=15.0
    WanderPropagationAngle=150.0
    ClassName="Fpd::CWanderTraversal"
}
