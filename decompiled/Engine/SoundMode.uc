class SoundMode extends Object
    native
    notplaceable
    hidecategories(Object);

struct native SoundClassAdjuster
{
    var() transient ESoundClassName SoundClassName;
    var() editconst name SoundClass;
    var() float VolumeAdjuster;
    var() float PitchAdjuster;
    var() bool bApplyToChildren;
};

struct native AudioEQEffect
{
    var native transient Double RootTime;
    var(HighPass) float HFFrequency;
    var(HighPass) float HFGain;
    var(BandPass) float MFCutoffFrequency;
    var(BandPass) float MFBandwidth;
    var(BandPass) float MFGain;
    var(LowPass) float LFFrequency;
    var(LowPass) float LFGain;
};

var(EQ) bool bApplyEQ;
var(EQ) AudioEQEffect EQSettings;
var(SoundClasses) array<SoundClassAdjuster> SoundClassEffects;
var() float InitialDelay;
var() float FadeInTime;
var() float Duration;
var() float FadeOutTime;

defaultproperties
{
    EQSettings=(HFFrequency=2000.0,HFGain=1.0,MFCutoffFrequency=1000.0,MFBandwidth=1.0,MFGain=1.0,LFFrequency=600.0,LFGain=1.0)
    FadeInTime=0.2
    Duration=-1.0
    FadeOutTime=0.2
}
