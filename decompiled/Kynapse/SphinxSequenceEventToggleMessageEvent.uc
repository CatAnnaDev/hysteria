class SphinxSequenceEventToggleMessageEvent extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bAcceptStrikeBack;
var() const bool bAcceptShieldReact;

defaultproperties
{
    bAcceptStrikeBack=True
    bAcceptShieldReact=True
    SequenceType="e_SphinxSequenceET_ToggleMessageEvent"
}
