class KynapseWorldServiceFpdPathObjectManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const array<KynapseEntityDefinitionStaticPathObject> POEntityDefs;

defaultproperties
{
    serviceName="PathObjectManager"
    ClassName="Fpd::CPathObjectManager"
}
