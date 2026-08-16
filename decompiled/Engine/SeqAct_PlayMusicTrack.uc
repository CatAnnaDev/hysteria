class SeqAct_PlayMusicTrack extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() MusicTrackStruct MusicTrack;

defaultproperties
{
    MusicTrack=(TheSoundCue="None",bAutoPlay=False,bPersistentAcrossLevels=False,FadeInTime=5.0,FadeInVolumeLevel=1.0,FadeOutTime=5.0,FadeOutVolumeLevel=0.0)
    ObjName="Play Music Track"
    ObjCategory="Sound"
}
