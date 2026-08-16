class KynapseAsyncModuleCanGo_PS3 extends KynapseAsyncModule
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int TaskCount;

defaultproperties
{
    TaskCount=3
    AsyncModuleName="CanGo_AiMesh_AsyncModule_PS3"
    ClassName="Fpd::CCanGo_AiMesh_AsyncModule_PS3"
}
