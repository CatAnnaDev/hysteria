class KynapseFpdTraversalDefinitionHide extends KynapseFpdTraversalDefinition
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,KynapseClass);

var() const float MaxDistance;
var() const float MaxCost;

defaultproperties
{
    MaxDistance=50.0
    MaxCost=340282346638528859811704183484516925440.0
    ClassName="Fpd::CHidingTraversal"
}
