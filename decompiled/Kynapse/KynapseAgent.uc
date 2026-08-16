class KynapseAgent extends Object
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

struct native AgentPeriodicTask
{
    var() const string taskName;
    var() const float Period;
};

struct native AgentAperiodicTask
{
    var() const string taskName;
    var() const float Priority;
    var() const float tpf;
    var() const int maxCall;
};

var() const array<AgentAperiodicTask> time_aperiodicTasksList;
var() const array<AgentPeriodicTask> time_periodicTasksList;
var() const string agentName;
var() const string ClassName;

defaultproperties
{
}
