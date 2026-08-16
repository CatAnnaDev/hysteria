class KynapseFpdAgentHide extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentHide);

var() const KynapseFpdTraversalDefinitionHide FpdHideTraversal;
var() const float Speed;
var() const bool StopWhenHidden;
var() const string CheckIfHiddenTask;
var() const int MaxDangerousEntities;
var() const int MaxDangerousPoints;

defaultproperties
{
    Speed=1.0
    CheckIfHiddenTask="Fpd::CHideAgent::CheckIfHiddenTask"
    MaxDangerousEntities=8
    MaxDangerousPoints=8
    time_aperiodicTasksList(0)=(taskName="Fpd::CHideAgent::CheckIfHiddenTask",Priority=1.0,tpf=1.0,maxCall=10000)
    agentName="FpdHideAgent"
    ClassName="Fpd::CHideAgent"
}
