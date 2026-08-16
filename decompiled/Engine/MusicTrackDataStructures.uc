class MusicTrackDataStructures extends Object
    native
    notplaceable;

struct native MusicTrackStruct
{
    var() SoundCue TheSoundCue;
    var() bool bAutoPlay;
    var() bool bPersistentAcrossLevels;
    var() float FadeInTime;
    var() float FadeInVolumeLevel;
    var() float FadeOutTime;
    var() float FadeOutVolumeLevel;
};

defaultproperties
{
}
