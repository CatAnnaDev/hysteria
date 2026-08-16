class AudioComponent extends ActorComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,ActorComponent);

struct native AudioComponentParam
{
    var() name ParamName;
    var() float FloatParam;
    var() SoundNodeWave WaveParam;
};

var() SoundCue SoundCue;
var const native SoundNode CueFirstNode;
var() editinline array<AudioComponentParam> InstanceParameters;
var bool bUseOwnerLocation;
var bool bAutoPlay;
var bool bAutoDestroy;
var bool bStopWhenOwnerDestroyed;
var bool bShouldRemainActiveIfDropped;
var bool bWasOccluded;
var transient bool bSuppressSubtitles;
var transient bool bWasPlaying;
var bool bAllowSpatialization;
var transient bool bFinished;
var transient bool bPreviewComponent;
var transient bool bIgnoreForFlushing;
var transient float StereoBleed;
var transient float LFEBleed;
var transient bool bEQFilterApplied;
var transient bool bAlwaysPlay;
var transient bool bIsUISound;
var transient bool bIsMusic;
var transient bool bNoReverb;
var const native duplicatetransient array<Pointer> WaveInstances;
var const native duplicatetransient array<byte> SoundNodeData;
var const native duplicatetransient map<int, int> SoundNodeOffsetMap;
var const native duplicatetransient MultiMap_Mirror SoundNodeResetWaveMap;
var const native duplicatetransient Pointer Listener;
var const native duplicatetransient float PlaybackTime;
var const native duplicatetransient PortalVolume PortalVolume;
var native duplicatetransient Vector Location;
var const native duplicatetransient Vector ComponentLocation;
var const transient Actor LastOwner;
var native float SubtitlePriority;
var float FadeInStartTime;
var float FadeInStopTime;
var float FadeInTargetVolume;
var float FadeOutStartTime;
var float FadeOutStopTime;
var float FadeOutTargetVolume;
var float AdjustVolumeStartTime;
var float AdjustVolumeStopTime;
var float AdjustVolumeTargetVolume;
var float CurrAdjustVolumeTargetVolume;
var const native SoundNode CurrentNotifyBufferFinishedHook;
var const native Vector CurrentLocation;
var const native Vector CachedCurrentLocation;
var const native int CachedReverbVolumeIndex;
var const native float CurrentVolume;
var const native float CurrentPitch;
var const native float CurrentHighFrequencyGain;
var const native int CurrentUseSpatialization;
var const native int CurrentUseSeamlessLooping;
var const native float CurrentVolumeMultiplier;
var const native float CurrentPitchMultiplier;
var const native float CurrentHighFrequencyGainMultiplier;
var const native float CurrentVoiceCenterChannelVolume;
var const native float CurrentVoiceRadioVolume;
var const native Double LastUpdateTime;
var const native float SourceInteriorVolume;
var const native float SourceInteriorLPF;
var const native float CurrentInteriorVolume;
var const native float CurrentInteriorLPF;
var() float VolumeMultiplier;
var() float PitchMultiplier;
var() float HighFrequencyGainMultiplier;
var float OcclusionCheckInterval;
var transient float LastOcclusionCheckTime;
var const export editinline DrawSoundRadiusComponent PreviewSoundRadius;
var delegate<OnAudioFinished> __OnAudioFinished__Delegate;
var delegate<OnQueueSubtitles> __OnQueueSubtitles__Delegate;

event OcclusionChanged(bool bNowOccluded)
{
    VolumeMultiplier *= (bNowOccluded ? 0.5 : 2.0);
}

delegate OnQueueSubtitles(array<SubtitleCue> Subtitles, float CueDuration)
{
}

delegate OnAudioFinished(AudioComponent AC)
{
}

native final function ResetToDefaults()
{
}

native final function SetWaveParameter(name InName, SoundNodeWave InWave)
{
    InName;
    InWave;
}

native final function SetFloatParameter(name InName, float InFloat)
{
    InName;
    InFloat;
}

native final function AdjustVolume(float AdjustVolumeDuration, float AdjustVolumeLevel)
{
    AdjustVolumeDuration;
    AdjustVolumeLevel;
}

native final function FadeOut(float FadeOutDuration, float FadeVolumeLevel)
{
    FadeOutDuration;
    FadeVolumeLevel;
}

native final function FadeIn(float FadeInDuration, float FadeVolumeLevel)
{
    FadeInDuration;
    FadeVolumeLevel;
}

native final function bool IsPlaying()
{
}

native final function Stop()
{
}

native final function Play()
{
}

defaultproperties
{
    bUseOwnerLocation=True
    bAllowSpatialization=True
    FadeInStopTime=-1.0
    FadeInTargetVolume=1.0
    FadeOutStopTime=-1.0
    FadeOutTargetVolume=1.0
    AdjustVolumeStopTime=-1.0
    AdjustVolumeTargetVolume=1.0
    CurrAdjustVolumeTargetVolume=1.0
    VolumeMultiplier=1.0
    PitchMultiplier=1.0
    HighFrequencyGainMultiplier=1.0
}
