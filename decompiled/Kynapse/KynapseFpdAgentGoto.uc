class KynapseFpdAgentGoto extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentGoto);

var() const float Speed;

defaultproperties
{
    Speed=4.0
    agentName="FpdGotoAgent"
    ClassName="Fpd::CGotoAgent"
}
