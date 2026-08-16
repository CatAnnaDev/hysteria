class KynapseFpdAgentFlee extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentFlee);

var() const KynapseFpdTraversalDefinitionFlee FpdFleeTraversal;
var() const float Speed;
var() const bool StopWhenSafe;
var() const float FindSafePlaceInterval;
var() const string CheckDangerVisible;
var() const int MaxDangerousEntities;
var() const int MaxDangerousPoints;

defaultproperties
{
    Speed=1.0
    FindSafePlaceInterval=0.5
    CheckDangerVisible="Fpd::CFleeAgent::CheckDangerVisible"
    MaxDangerousEntities=8
    MaxDangerousPoints=8
    time_periodicTasksList(0)=(taskName="Fpd::CFleeAgent::CheckDangerVisible",Period=1000.0)
    agentName="FpdFleeAgent"
    ClassName="Fpd::CFleeAgent"
}
