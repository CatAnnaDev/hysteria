class SphinxSequenceEventModifyPawnHealth extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int Value;
var() const bool bSetHealthValue;
var() float absolute_HealthSetValue;

defaultproperties
{
    SequenceType="e_SphinxSequenceET_ModifyPawnHealth"
}
