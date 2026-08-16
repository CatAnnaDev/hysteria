class SphinxSequenceEventToggleAttachedActorHidden extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bHidden;
var() const int ActorID;

defaultproperties
{
    bHidden=True
    SequenceType="e_SphinxSequenceET_ToggleAttachedActorHidden"
}
