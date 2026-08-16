class KynapseFpdAgentShoot extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdAgentFlee);

var() const float GunRange;
var() const float DangerousConeAngle;
var() const float LineOfFireValidityInterval;
var() const int NumPotentialSideSteps;
var() const float SideStepAngle;
var() const float Speed;
var() const string CheckLineOfFireTask;

defaultproperties
{
    GunRange=30.0
    LineOfFireValidityInterval=0.5
    NumPotentialSideSteps=20
    SideStepAngle=10.0
    Speed=1.0
    CheckLineOfFireTask="Fpd::CShootAgent::CheckLineOfFireTask"
    time_aperiodicTasksList(0)=(taskName="Fpd::CShootAgent::CheckLineOfFireTask",Priority=1.0,tpf=1.0,maxCall=10000)
    agentName="FpdShootAgent"
    ClassName="Fpd::CShootAgent"
}
