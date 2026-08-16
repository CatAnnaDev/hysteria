class SphinxSequenceEventChangeFightConditionIndex extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int ConditionIndex;
var() const bool bCleanOldInfo;
var() const bool bBreakCurrentPackage;
var() bool ReturnPrevConditionIndex;

defaultproperties
{
    ConditionIndex=-1
    bCleanOldInfo=True
    SequenceType="e_SphinxSequenceET_ChangeConditionIndex"
}
