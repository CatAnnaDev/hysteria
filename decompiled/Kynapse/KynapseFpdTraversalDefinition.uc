class KynapseFpdTraversalDefinition extends Object
    abstract
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,KynapseClass);

struct native FpdTraversalAperiodicTask
{
    var() const string taskName;
    var() const float Priority;
    var() const float tpf;
    var() const int maxCall;
};

var(TimeSlicing) const FpdTraversalAperiodicTask AperiodicTask;
var() const int InstanceCount;
var(KynapseClass) const string ClassName;

defaultproperties
{
    AperiodicTask=(taskName="NoTask",Priority=1.0,tpf=4.0,maxCall=1000)
    InstanceCount=1
}
