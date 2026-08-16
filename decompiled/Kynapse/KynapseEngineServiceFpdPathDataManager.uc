class KynapseEngineServiceFpdPathDataManager extends KynapseEngineService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseEngineServiceFpdPathDataManager);

var() const int MaxRegisteredCallbacks;
var() const int AstarMemory;

defaultproperties
{
    MaxRegisteredCallbacks=32
    AstarMemory=6000
    serviceName="PathDataManager"
    ClassName="Fpd::PathDataManager"
}
