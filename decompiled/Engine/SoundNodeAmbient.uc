class SoundNodeAmbient extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object)
    autoexpandcategories(Attenuation,LowPassFilter,Modulation,Sounds,Spatialization);

struct native AmbientSoundSlot
{
    var() SoundNodeWave Wave;
    var() float PitchScale;
    var() float VolumeScale;
    var() float Weight;
};

var(Attenuation) bool bAttenuate;
var(Attenuation) bool bSpatialize;
var(LowPassFilter) bool bAttenuateWithLPF;
var deprecated bool bAttenuateWithLowPassFilter;
var(Attenuation) float dBAttenuationAtMax;
var(Attenuation) SoundDistanceModel DistanceModel;
var(Attenuation) float RadiusMin;
var(Attenuation) float RadiusMax;
var(LowPassFilter) float LPFRadiusMin;
var(LowPassFilter) float LPFRadiusMax;
var(Modulation) float PitchMin;
var(Modulation) float PitchMax;
var(Modulation) float VolumeMin;
var(Modulation) float VolumeMax;
var(Sounds) array<AmbientSoundSlot> SoundSlots;
var deprecated SoundNodeWave Wave;
var deprecated RawDistributionFloat MinRadius;
var deprecated RawDistributionFloat MaxRadius;
var deprecated RawDistributionFloat LPFMinRadius;
var deprecated RawDistributionFloat LPFMaxRadius;
var deprecated RawDistributionFloat PitchModulation;
var deprecated RawDistributionFloat VolumeModulation;

defaultproperties
{
    bAttenuate=True
    bSpatialize=True
    dBAttenuationAtMax=-60.0
    RadiusMin=2000.0
    RadiusMax=5000.0
    LPFRadiusMin=3500.0
    LPFRadiusMax=7000.0
    PitchMin=1.0
    PitchMax=1.0
    VolumeMin=0.7
    VolumeMax=0.7
}
