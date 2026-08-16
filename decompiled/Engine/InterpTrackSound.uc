class InterpTrackSound extends InterpTrackVectorBase
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native SoundTrackKey
{
    var float Time;
    var float Volume;
    var float Pitch;
    var() SoundCue Sound;
};

var array<SoundTrackKey> Sounds;
var() bool bPlayOnReverse;
var() bool bContinueSoundOnMatineeEnd;
var() bool bSuppressSubtitles;

defaultproperties
{
    TrackInstClass="InterpTrackInstSound"
    TrackTitle="Sound"
}
