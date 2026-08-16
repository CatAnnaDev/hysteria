class SoundNodeModulator extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var(Modulation) float PitchMin;
var(Modulation) float PitchMax;
var(Modulation) float VolumeMin;
var(Modulation) float VolumeMax;
var deprecated RawDistributionFloat PitchModulation;
var deprecated RawDistributionFloat VolumeModulation;

defaultproperties
{
    PitchMin=0.95
    PitchMax=1.05
    VolumeMin=0.95
    VolumeMax=1.05
}
