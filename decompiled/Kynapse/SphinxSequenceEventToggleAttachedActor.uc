class SphinxSequenceEventToggleAttachedActor extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bActive;
var() const int ActorID;
var() const int HP;

defaultproperties
{
    bActive=True
    HP=1
    SequenceType="e_SphinxSequenceET_ToggleAttachedActor"
}
