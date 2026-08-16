class SphinxSequenceEventTeleport extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() int TeleRadius;
var() int TeleAngle;
var int CandidatePositionNumber;
var Vector TeleportLocation;

defaultproperties
{
    TeleRadius=300
    TeleAngle=150
    CandidatePositionNumber=5
    SequenceType="e_SphinxSequenceET_Teleport"
}
