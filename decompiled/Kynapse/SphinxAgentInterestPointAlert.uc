class SphinxAgentInterestPointAlert extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentInterestPointAlert);

var() bool IPAlertIsOn;

defaultproperties
{
    IPAlertIsOn=True
    agentName="SphinxInterestPointAlertAgent"
    ClassName="SphinxInterestPointAlertAgent"
}
