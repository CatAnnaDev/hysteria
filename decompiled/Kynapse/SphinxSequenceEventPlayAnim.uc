class SphinxSequenceEventPlayAnim extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const editconst name AnimName;
var() const int AnimNameIndex;
var() const Rotator PlayRotator;
var(SequenceCondition) const bool bCleanConditionHitPlayerInfo;
var(SwitchLockOnTarget) const bool EnableSwitchLockOnTarget;
var(Advance) const bool DoBreakWhenSwitchPackage;
var(SwitchLockOnTarget) const int LockIndex;

defaultproperties
{
    PlayRotator=(Pitch=0,Yaw=20000,Roll=0)
    DoBreakWhenSwitchPackage=True
    LockIndex=-1
}
