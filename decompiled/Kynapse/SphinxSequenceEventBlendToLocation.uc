class SphinxSequenceEventBlendToLocation extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() int Index;
var() float BlendSpeed;
var() Rotator RotationRate;
var(Temp) bool UsingNewBlendingCode_RemoveIfNoBug;

defaultproperties
{
    BlendSpeed=100.0
    RotationRate=(Pitch=0,Yaw=20000,Roll=0)
    SequenceType="e_SphinxSequenceET_BlendToLocation"
}
