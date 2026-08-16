class KynapseWorldServiceAsyncManager_PS3 extends KynapseWorldServiceAsyncManager
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

const nbTaskSetPriorities = 8;

var() const int TaskSetContention;
var() const int TaskSetPriorities[8];

defaultproperties
{
    TaskSetContention=6
    TaskSetPriorities=1
    TaskSetPriorities[1]=1
    TaskSetPriorities[2]=1
    TaskSetPriorities[3]=1
    TaskSetPriorities[4]=1
    TaskSetPriorities[5]=1
    TaskSetPriorities[6]=1
    TaskSetPriorities[7]=1
    AsyncModulesList(0)="Default__KynapseWorldServiceAsyncManager_PS3.AsyncModuleCanGo_PS3"
    AsyncModulesList(1)="Default__KynapseWorldServiceAsyncManager_PS3.AsyncModuleGapDA_PS3"
    AsyncModulesList(2)="Default__KynapseWorldServiceAsyncManager_PS3.AsyncModuleFindNodes_PS3"
    AsyncModulesList(3)="Default__KynapseWorldServiceAsyncManager_PS3.AsyncModuleSelectPathNode_PS3"
    serviceName="AsyncManager_PS3"
    ClassName="CAsyncManager_PS3"
}
