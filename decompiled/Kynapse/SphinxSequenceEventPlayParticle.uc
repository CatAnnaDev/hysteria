class SphinxSequenceEventPlayParticle extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const ParticleSystem Particle;
var() name Socket;
var() name Bone;
var() float DrawScale;
var() int ComponentIndex;
var() bool bAttach;
var() bool bIgnoreOwnerHiddenIfAttached;
var() bool bLoadIfPhysXLevel0;
var() bool bLoadIfPhysXLevel1;
var() bool bLoadIfPhysXLevel2;

defaultproperties
{
    DrawScale=1.0
    bIgnoreOwnerHiddenIfAttached=True
    bLoadIfPhysXLevel0=True
    bLoadIfPhysXLevel1=True
    bLoadIfPhysXLevel2=True
    SequenceType="e_SphinxSequenceET_PlayParticle"
}
