class AnimNotify_Sound extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() SoundCue SoundCue;
var() bool bFollowActor;
var() bool bIgnoreIfActorHidden;
var() name BoneName;
var() float PercentToPlay;
var() float VolumeMultiplier;
var() float PitchMultiplier;

defaultproperties
{
    bFollowActor=True
    PercentToPlay=1.0
    VolumeMultiplier=1.0
    PitchMultiplier=1.0
}
