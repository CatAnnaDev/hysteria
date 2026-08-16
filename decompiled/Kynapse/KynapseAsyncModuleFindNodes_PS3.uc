class KynapseAsyncModuleFindNodes_PS3 extends KynapseAsyncModuleFindNodes
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int TaskCount;
var() const int MaxNodesPerRequest;

defaultproperties
{
    TaskCount=2
    MaxNodesPerRequest=200
    AsyncModuleName="FindNodesFromPositions_AsyncNearestReachable_AsyncModule_PS3"
    ClassName="Fpd::CFindNodesFromPositions_AsyncNearestReachable_AsyncModule_PS3"
}
