class SphinxSequenceEventChangeCollisionType extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var int dumysize;
var() bool bBlockVB;
var() bool bBlockHH;
var() bool bBlockES;
var() bool bBlockTC;
var() ECollisionType CollisionType;

defaultproperties
{
    bBlockVB=True
    bBlockHH=True
    bBlockES=True
    bBlockTC=True
    SequenceType="e_SphinxSequenceET_ChangeCollisionType"
}
