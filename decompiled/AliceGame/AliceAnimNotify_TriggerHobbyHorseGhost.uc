class AliceAnimNotify_TriggerHobbyHorseGhost extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() ParticleSystem AliceGhostEffectTemplate;
var() int MaxProjectionNumber;
var() int CheckRadius;
var() int DamageValue;
var() EDamageStrengthType GhostDmgStrength;
var() float GhostSpeed;
var() float HeightGap;
var() float HalfAngleGap;

defaultproperties
{
    MaxProjectionNumber=3
    CheckRadius=3000
    DamageValue=5
    GhostDmgStrength="EDSTR_Medium"
    GhostSpeed=100.0
    HeightGap=50.0
    HalfAngleGap=120.0
}
