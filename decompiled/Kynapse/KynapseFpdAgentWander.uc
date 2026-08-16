class KynapseFpdAgentWander extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentWander);

var() const KynapseFpdTraversalDefinitionWander FpdWanderTraversal;
var() const float Speed;

defaultproperties
{
    Speed=4.0
    agentName="FpdWanderAgent"
    ClassName="Fpd::CWanderAgent"
}
