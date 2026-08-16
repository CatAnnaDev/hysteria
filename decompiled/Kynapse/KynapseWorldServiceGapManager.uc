class KynapseWorldServiceGapManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseWorldServiceGapManager);

var() const int MaxGaps;

defaultproperties
{
    MaxGaps=60
    serviceName="GapManager"
    ClassName="CGapManager"
}
