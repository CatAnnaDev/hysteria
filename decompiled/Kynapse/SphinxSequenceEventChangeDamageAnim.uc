class SphinxSequenceEventChangeDamageAnim extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

enum EDamageStrengthTypeSphinx
{
    EDSTRS_Weak,
    EDSTRS_Light,
    EDSTRS_Medium,
    EDSTRS_Heavy,
    EDSTRS_HeaveyWithoutKnockback,
};

var() const int AnimIndex;
var() const EDamageStrengthTypeSphinx DamageStrength;
var() Rotator DamageRotationRate;
var() bool bKnockBack;
var() bool bPhysicalAnim;

defaultproperties
{
    AnimIndex=-1
    SequenceType="e_SphinxSequenceET_ChangeDamageAnim"
}
