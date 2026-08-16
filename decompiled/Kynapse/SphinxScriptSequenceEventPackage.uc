class SphinxScriptSequenceEventPackage extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

var() const string EventPackageNameTag;
var const bool bIsInAttackProcess;
var() const export editinline array<SphinxSequenceEventBase> ScriptEvents;
var array<SphinxSequenceEventBase> EditorOnlyBackupScriptEvents;

defaultproperties
{
    EventPackageNameTag="none"
}
