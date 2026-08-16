class SphinxSequenceEventToggleLoopSound extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bEnable;
var() const int SoundID;
var() const float FadeTime;

defaultproperties
{
    SoundID=-1
    FadeTime=0.1
    SequenceType="e_SphinxSequenceET_ToggleLoopSound"
}
