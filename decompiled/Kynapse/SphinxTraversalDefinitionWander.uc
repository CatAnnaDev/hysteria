class SphinxTraversalDefinitionWander extends KynapseFpdTraversalDefinition
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,KynapseClass);

var() const float MaxDistance;
var() const int TraversalAstarMemory;
var() const float MaxCost;
var() const int ExtractionBufferSize;
var() const float WanderDistance;
var() const float WanderPropagationAngle;

defaultproperties
{
    MaxDistance=50.0
    TraversalAstarMemory=150
    MaxCost=340282346638528859811704183484516925440.0
    ExtractionBufferSize=128
    WanderDistance=15.0
    WanderPropagationAngle=75.0
    ClassName="CVolumeHierarchicalWanderTraversal"
}
