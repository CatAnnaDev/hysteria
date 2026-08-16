class SphinxSequenceEventToggleCriticalUI extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool Actived;
var() const int TargetSocketIndex;

defaultproperties
{
    Actived=True
    SequenceType="e_SphinxSequenceET_ToggleCriticalUI"
}
