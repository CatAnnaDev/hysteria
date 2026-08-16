class SphinxSequenceEventRunAnotherPackage extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const name PackageName;
var const int PackageNameIndex;
var bool PackageNameIndexInited;
var() bool NeedReturnToCurrentPackage;

defaultproperties
{
    PackageNameIndex=-1
    SequenceType="e_SphinxSequenceET_RunAnotherPackage"
}
