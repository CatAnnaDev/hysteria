class KynapseAsyncModuleSelectPathNode extends KynapseAsyncModule
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int MaxSimultaneousRequests;

defaultproperties
{
    MaxSimultaneousRequests=200
}
