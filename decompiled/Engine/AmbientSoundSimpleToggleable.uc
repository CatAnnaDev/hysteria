class AmbientSoundSimpleToggleable extends AmbientSoundSimple
    native
    placeable
    hidecategories(Navigation,Audio)
    autoexpandcategories(Audio,AmbientSoundSimple,AmbientSoundSimpleToggleable);

struct CheckpointRecord
{
    var bool bCurrentlyPlaying;
};

var repnotify bool bCurrentlyPlaying;
var() bool bFadeOnToggle;
var() float FadeInDuration;
var() float FadeInVolumeLevel;
var() float FadeOutDuration;
var() float FadeOutVolumeLevel;

replication
{
    if (Role == 3)
        bCurrentlyPlaying;
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bCurrentlyPlaying = Record.bCurrentlyPlaying;
    if (bCurrentlyPlaying)
    {
        StartPlaying();
    }
    else
    {
        StopPlaying();
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bCurrentlyPlaying = bCurrentlyPlaying;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse || Action.InputLinks[2].bHasImpulse && !AudioComponent.bWasPlaying)
    {
        StartPlaying();
    }
    else
    {
        StopPlaying();
    }
    ForceNetRelevant();
}

simulated function StopPlaying()
{
    if (bFadeOnToggle)
    {
        AudioComponent.FadeOut(FadeOutDuration, FadeOutVolumeLevel);
    }
    else
    {
        AudioComponent.Stop();
    }
    bCurrentlyPlaying = false;
}

simulated function StartPlaying()
{
    if (bFadeOnToggle)
    {
        AudioComponent.FadeIn(FadeInDuration, FadeInVolumeLevel);
    }
    else
    {
        AudioComponent.Play();
    }
    bCurrentlyPlaying = true;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bCurrentlyPlaying')
    {
        if (bCurrentlyPlaying)
        {
            StartPlaying();
        }
        else
        {
            StopPlaying();
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    bCurrentlyPlaying = AudioComponent.bAutoPlay;
}

defaultproperties
{
    FadeInDuration=1.0
    FadeInVolumeLevel=1.0
    FadeOutDuration=1.0
    SoundCueInstance="Default__AmbientSoundSimpleToggleable.SoundCue0"
    SoundNodeInstance="Default__AmbientSoundSimpleToggleable.SoundNodeAmbient0"
    bAutoPlay=False
    AudioComponent="Default__AmbientSoundSimpleToggleable.AudioComponent0"
    SpriteComp="Default__AmbientSoundSimpleToggleable.Sprite"
    bStatic=False
    bNoDelete=True
    Components(0)="Default__AmbientSoundSimpleToggleable.Sprite"
    Components(1)="Default__AmbientSoundSimpleToggleable.DrawSoundRadius0"
    Components(2)="Default__AmbientSoundSimpleToggleable.AudioComponent0"
}
