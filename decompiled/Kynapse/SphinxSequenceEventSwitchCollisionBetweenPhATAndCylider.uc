class SphinxSequenceEventSwitchCollisionBetweenPhATAndCylider extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var int Dummy;
var() bool SwitchToCyliderCollision;
var() bool SwitchToPhATCollision;

defaultproperties
{
    SwitchToCyliderCollision=True
    SequenceType="e_SphinxSequenceET_SwitchCollisionBetweenPhATAndCylider"
}
