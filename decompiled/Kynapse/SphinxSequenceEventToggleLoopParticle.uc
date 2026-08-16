class SphinxSequenceEventToggleLoopParticle extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool bEnable;
var() const int ParticleID;

defaultproperties
{
    ParticleID=-1
    SequenceType="e_SphinxSequenceET_ToggleLoopParticle"
}
