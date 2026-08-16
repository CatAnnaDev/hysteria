class KynapseBrainService extends Object
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

struct native BServicePeriodicTask
{
    var() const string taskName;
    var() const float Period;
};

struct native BServiceAperiodicTask
{
    var() const string taskName;
    var() const float Priority;
    var() const float tpf;
    var() const int maxCall;
};

var() const array<BServiceAperiodicTask> time_aperiodicTasksList;
var() const array<BServicePeriodicTask> time_periodicTasksList;
var() const string serviceName;
var() const string ClassName;

defaultproperties
{
}
