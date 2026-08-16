class KynapseFpdAgentFollow extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentFollow);

var() const float DistFromEntity;
var() const float AngleFromEntity;
var() const float MinimalImportantMove;
var() const float Speed;
var() const string AperiodicTask;

defaultproperties
{
    DistFromEntity=1.0
    AngleFromEntity=180.0
    MinimalImportantMove=1.0
    Speed=8.0
    AperiodicTask="Fpd::CFollowAgent::ComputeRealDestination"
    time_aperiodicTasksList(0)=(taskName="Fpd::CFollowAgent::ComputeRealDestination",Priority=1.0,tpf=1.0,maxCall=10000)
    agentName="FpdFollowAgent"
    ClassName="Fpd::CFollowAgent"
}
