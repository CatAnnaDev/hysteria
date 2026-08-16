class KynapseWorldService extends Object
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

struct native WServicePeriodicTask
{
    var() const string taskName;
    var() const float Period;
};

struct native WServiceAperiodicTask
{
    var() const string taskName;
    var() const float Priority;
    var() const float tpf;
    var() const int maxCall;
};

var() const array<WServiceAperiodicTask> time_aperiodicTasksList;
var() const array<WServicePeriodicTask> time_periodicTasksList;
var() const string serviceName;
var() const string ClassName;

defaultproperties
{
}
