class SphinxSequenceEventSetHideComponent extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bHide;
var() const int ComponentID;

defaultproperties
{
    bHide=True
    SequenceType="e_SphinxSequenceET_SetHideComponent"
}
