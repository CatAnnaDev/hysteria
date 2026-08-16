class SphinxSequenceEventSetSonarInfo extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bActive;
var() const int ComponentID;
var() const int AttachedActorID;

defaultproperties
{
    bActive=True
    ComponentID=-1
    AttachedActorID=-1
    SequenceType="e_SphinxSequenceET_SetSonarInfo"
}
