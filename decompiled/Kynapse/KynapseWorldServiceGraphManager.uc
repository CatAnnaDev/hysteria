class KynapseWorldServiceGraphManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

struct native Pathdata
{
    var() const string pathdataName;
    var() const KynapseWorldServiceMapBuilder mapBuilder;
    var() const bool usesPathObjectManager;
    var() const array<additionalData> additionalDataList_Pathdata;
};

struct native additionalData
{
    var() const string ClassName;
};

defaultproperties
{
    serviceName="GraphManager"
    ClassName="CUnrealGraphManager"
}
