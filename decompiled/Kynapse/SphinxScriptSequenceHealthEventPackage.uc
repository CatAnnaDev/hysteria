class SphinxScriptSequenceHealthEventPackage extends SphinxScriptSequenceEventPackage
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int AbsoulteHealthValue;
var() const int HealthPercent;
var() const bool CanBreakBySubCondition;
var() const bool ShouldReturnOriginalPackage;

defaultproperties
{
    AbsoulteHealthValue=-1
}
