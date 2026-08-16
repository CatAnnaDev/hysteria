class KynapseAsyncModuleGapDA_PS3 extends KynapseAsyncModuleGapDA
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int TaskCount;
var() const int CanGoResultQueueDepth;
var() const int MaxPassivePerRequest;

defaultproperties
{
    TaskCount=3
    CanGoResultQueueDepth=200
    MaxPassivePerRequest=200
    AsyncModuleName="Goto_AsyncGapDA_AsyncModule_PS3"
    ClassName="Fpd::CGoto_AsyncGapDA_AsyncModule_PS3"
}
