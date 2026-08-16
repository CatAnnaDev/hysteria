class SphinxAgentFollow extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentFollow);

var() const float DistFromEntity;
var() const float AngleFromEntity;
var() const float MinimalImportantMove;
var() const float Speed;
var() const string AperiodicTask;

defaultproperties
{
    agentName="SphinxFollowAgent"
    ClassName="SphinxFollowAgent"
}
