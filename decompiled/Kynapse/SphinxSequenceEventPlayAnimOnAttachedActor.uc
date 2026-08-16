class SphinxSequenceEventPlayAnimOnAttachedActor extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int ActorID;
var() const int AnimIndex;

defaultproperties
{
    ActorID=-1
    AnimIndex=-1
    SequenceType="e_SphinxSequenceET_PlayAnimOnAttachedActor"
}
