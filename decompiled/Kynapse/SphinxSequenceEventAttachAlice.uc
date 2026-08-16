class SphinxSequenceEventAttachAlice extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() float AttachTime;
var() const editconst name AttachAnimName;
var() const int AttachAnimIndex;
var() const editconst name DetachAnimName;
var() const int DetachAnimIndex;
var() const Rotator PlayRotator;

defaultproperties
{
    PlayRotator=(Pitch=0,Yaw=20000,Roll=0)
    SequenceType="e_SphinxSequenceET_AttchAlice"
}
