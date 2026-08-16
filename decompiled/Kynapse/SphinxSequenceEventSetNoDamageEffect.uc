class SphinxSequenceEventSetNoDamageEffect extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool NoDamageEffect;
var() bool BlockVorpalBlade;
var() bool BlockHobbyHorse;
var() bool BlockEyeStaff;
var() bool BlockTeapotCannon;
var() bool BlockNPCProject;

defaultproperties
{
    BlockVorpalBlade=True
    BlockHobbyHorse=True
    BlockEyeStaff=True
    BlockTeapotCannon=True
    BlockNPCProject=True
    SequenceType="e_SphinxSequenceET_SetNoDamageEffect"
}
