class KynapseEntityDefinitionStaticPathObject extends KynapseEntityDefinitionPathObject
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display);

var() const int TypeId;
var() const string TypeName;

defaultproperties
{
    TypeId=-1
    PoolCount=5
    MaxLinkedEdges=512
}
