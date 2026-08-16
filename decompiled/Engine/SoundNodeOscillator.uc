class SoundNodeOscillator extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var(Oscillator) bool bModulateVolume;
var(Oscillator) bool bModulatePitch;
var(Oscillator) float AmplitudeMin;
var(Oscillator) float AmplitudeMax;
var(Oscillator) float FrequencyMin;
var(Oscillator) float FrequencyMax;
var(Oscillator) float OffsetMin;
var(Oscillator) float OffsetMax;
var(Oscillator) float CenterMin;
var(Oscillator) float CenterMax;
var deprecated RawDistributionFloat Amplitude;
var deprecated RawDistributionFloat Frequency;
var deprecated RawDistributionFloat Offset;
var deprecated RawDistributionFloat Center;

defaultproperties
{
}
