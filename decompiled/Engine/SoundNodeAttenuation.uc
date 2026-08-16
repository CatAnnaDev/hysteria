class SoundNodeAttenuation extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

enum ESoundDistanceCalc
{
    SOUNDDISTANCE_Normal,
    SOUNDDISTANCE_InfiniteXYPlane,
    SOUNDDISTANCE_InfiniteXZPlane,
    SOUNDDISTANCE_InfiniteYZPlane,
};

enum SoundDistanceModel
{
    ATTENUATION_Linear,
    ATTENUATION_Logarithmic,
    ATTENUATION_Inverse,
    ATTENUATION_LogReverse,
    ATTENUATION_NaturalSound,
    ATTENUATION_Reverse,
};

var(Attenuation) bool bAttenuate;
var(Attenuation) bool bSpatialize;
var(LowPassFilter) bool bAttenuateWithLPF;
var editconst deprecated bool bAttenuateWithLowPassFilter;
var(Attenuation) float dBAttenuationAtMax;
var(Attenuation) SoundDistanceModel DistanceAlgorithm;
var(Attenuation) ESoundDistanceCalc DistanceType;
var editconst deprecated SoundDistanceModel DistanceModel;
var(Attenuation) float RadiusMin;
var(Attenuation) float RadiusMax;
var(Attenuation) float ReverseMinVolume;
var(LowPassFilter) float LPFRadiusMin;
var(LowPassFilter) float LPFRadiusMax;
var editconst deprecated RawDistributionFloat MinRadius;
var editconst deprecated RawDistributionFloat MaxRadius;
var editconst deprecated RawDistributionFloat LPFMinRadius;
var editconst deprecated RawDistributionFloat LPFMaxRadius;

defaultproperties
{
    bAttenuate=True
    bSpatialize=True
    dBAttenuationAtMax=-60.0
    RadiusMin=400.0
    RadiusMax=4000.0
    LPFRadiusMin=3000.0
    LPFRadiusMax=6000.0
}
