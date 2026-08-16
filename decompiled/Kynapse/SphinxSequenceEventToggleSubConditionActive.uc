class SphinxSequenceEventToggleSubConditionActive extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() int ConditionIndex;
var() bool NearGroupSubConditionCheckActive;
var() bool FarGroupSubConditionCheckActive;
var(AdvancedParam) array<byte> DetailToggle;

defaultproperties
{
    NearGroupSubConditionCheckActive=True
    FarGroupSubConditionCheckActive=True
    SequenceType="e_SphinxSequenceET_ToggleSubConditionActive"
}
