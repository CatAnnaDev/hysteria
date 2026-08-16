class SphinxSequenceEventChangeAttachedActorDamageAnim extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const int ActorID;
var() const EDamageStrengthTypeSphinx DamageStrength;
var() const int AnimIndex;

defaultproperties
{
    SequenceType="e_SphinxSequenceET_ChangeAttachedActorDamageAnim"
}
