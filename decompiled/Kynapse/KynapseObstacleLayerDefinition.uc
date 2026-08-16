class KynapseObstacleLayerDefinition extends KynapseAiMeshLayerDefinition
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int maxMeshCount;
var() const int maxObstacles;
var() const string aiMeshAccessorClassName;
var() const string obstaclesAccessorClassName;
var() const KynapseTag pathdataTag;
var() const int MaxProjections;

defaultproperties
{
    maxMeshCount=30
    maxObstacles=100
    aiMeshAccessorClassName="Fpd::CAdditionalAiMeshAccessor"
    obstaclesAccessorClassName="CObstaclesAccessor_EntityOutline"
    MaxProjections=400
    ClassName="CObstaclesLayer"
}
