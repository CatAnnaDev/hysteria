class SphinxSequenceEventModifyRotateAndSpeed extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() Rotator SetRotation;
var() float SetSpeed;

defaultproperties
{
    SetRotation=(Pitch=20000,Yaw=20000,Roll=20000)
    SequenceType="e_SphinxSequenceET_ModifyRotateAndSpeed"
}
