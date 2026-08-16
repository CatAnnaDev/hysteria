class KynapseWorldServiceAsyncManager extends KynapseWorldService
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const editinline array<KynapseAsyncModule> AsyncModulesList;

defaultproperties
{
    serviceName="AsyncManager"
    ClassName="CAsyncManager"
}
