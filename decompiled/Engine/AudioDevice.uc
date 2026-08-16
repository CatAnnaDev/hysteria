class AudioDevice extends Subsystem
    native
    notplaceable
    transient
    config(Engine);

enum ETTSSpeaker
{
    TTSSPEAKER_Paul,
    TTSSPEAKER_Harry,
    TTSSPEAKER_Frank,
    TTSSPEAKER_Dennis,
    TTSSPEAKER_Kit,
    TTSSPEAKER_Betty,
    TTSSPEAKER_Ursula,
    TTSSPEAKER_Rita,
    TTSSPEAKER_Wendy,
};

enum EDebugState
{
    DEBUGSTATE_None,
    DEBUGSTATE_IsolateDryAudio,
    DEBUGSTATE_IsolateReverb,
    DEBUGSTATE_TestLPF,
    DEBUGSTATE_TestStereoBleed,
    DEBUGSTATE_TestLFEBleed,
    DEBUGSTATE_DisableLPF,
};

enum ESoundClassName
{
    Master,
};

struct native AudioClassInfo
{
    var const int NumResident;
    var const int SizeResident;
    var const int NumRealTime;
    var const int SizeRealTime;
};

struct native Listener
{
    var const PortalVolume PortalVolume;
    var Vector Location;
    var Vector Up;
    var Vector Right;
    var Vector Front;
};

var const config int MaxChannels;
var const config int CommonAudioPoolSize;
var const config float LowPassFilterResonance;
var const config float MinCompressedDurationEditor;
var const config float MinCompressedDurationGame;
var const native Pointer CommonAudioPool;
var const native int CommonAudioPoolFreeBytes;
var const native int TransferManagerWaitTag;
var const native bool bNeedTransferManagerFlushAndSync;
var const native bool bGameWasTicking;
var const transient export editinline array<AudioComponent> AudioComponents;
var const native array<Pointer> Sources;
var const native array<Pointer> FreeSources;
var const native map<int, int> WaveInstanceSourceMap;
var const native array<Listener> Listeners;
var const native QWord CurrentTick;
var() map<int, int> SoundClasses;
var map<int, int> SourceSoundClasses;
var map<int, int> CurrentSoundClasses;
var map<int, int> DestinationSoundClasses;
var const native map<int, int> SoundModes;
var const native Pointer Effects;
var const native name BaseSoundModeName;
var const native SoundMode CurrentMode;
var const native Double SoundModeStartTime;
var const native Double SoundModeFadeInStartTime;
var const native Double SoundModeFadeInEndTime;
var const native Double SoundModeEndTime;
var const native int ListenerVolumeIndex;
var const native InteriorSettings ListenerInteriorSettings;
var const native Double InteriorStartTime;
var const native Double InteriorEndTime;
var const native Double ExteriorEndTime;
var const native Double InteriorLPFEndTime;
var const native Double ExteriorLPFEndTime;
var const native float InteriorVolumeInterp;
var const native float InteriorLPFInterp;
var const native float ExteriorVolumeInterp;
var const native float ExteriorLPFInterp;
var const export editinline AudioComponent TestAudioComponent;
var const native Pointer TextToSpeech;
var const native EDebugState DebugState;
var transient float TransientMasterVolume;
var transient float LastUpdateTime;

native final function bool SetSoundMode(name NewMode)
{
    NewMode;
}

defaultproperties
{
    TransientMasterVolume=1.0
}
