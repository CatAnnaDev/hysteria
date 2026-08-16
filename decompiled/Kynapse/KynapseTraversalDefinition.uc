class KynapseTraversalDefinition extends Object
    abstract
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,KynapseClass);

struct native TraversalAperiodicTask
{
    var() const string taskName;
    var() const float Priority;
    var() const float tpf;
    var() const int maxCall;
};

var(TimeSlicing) const TraversalAperiodicTask AperiodicTask;
var() const float MaxDistance;
var() const int MaxEdgeCount;
var() const int InstanceCount;
var(KynapseClass) const string ClassName;

defaultproperties
{
    AperiodicTask=(taskName="NoTask",Priority=1.0,tpf=1.0,maxCall=100)
    MaxDistance=100.0
    MaxEdgeCount=4500
    InstanceCount=1
}
