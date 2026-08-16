class KynapseWorldServiceAIMeshManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

struct native AiMesh
{
    var() const string aiMeshName;
    var() const KynapseWorldServiceMapBuilder mapBuilder;
};

defaultproperties
{
    serviceName="AIMeshManager"
    ClassName="CUnrealMeshManager"
}
