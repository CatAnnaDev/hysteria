class ParticleModuleBeamNoise extends ParticleModuleBeamBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(LowFreq) bool bLowFreq_Enabled;
var(LowFreq) bool bNRScaleEmitterTime;
var(LowFreq) bool bSmooth;
var const bool bNoiseLock;
var(LowFreq) bool bOscillate;
var(LowFreq) bool bUseNoiseTangents;
var(LowFreq) bool bTargetNoise;
var(LowFreq) bool bApplyNoiseScale;
var(LowFreq) int Frequency;
var(LowFreq) int Frequency_LowRange;
var(LowFreq) RawDistributionVector NoiseRange;
var(LowFreq) RawDistributionFloat NoiseRangeScale;
var(LowFreq) RawDistributionVector NoiseSpeed;
var(LowFreq) float NoiseLockRadius;
var(LowFreq) float NoiseLockTime;
var(LowFreq) float NoiseTension;
var(LowFreq) RawDistributionFloat NoiseTangentStrength;
var(LowFreq) int NoiseTessellation;
var(LowFreq) float FrequencyDistance;
var(LowFreq) RawDistributionFloat NoiseScale;

defaultproperties
{
    NoiseRange=(Distribution="Default__ParticleModuleBeamNoise.DistributionNoiseRange",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000484200004842000048420000484200004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    NoiseRangeScale=(Distribution="Default__ParticleModuleBeamNoise.DistributionNoiseRangeScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    NoiseSpeed=(Distribution="Default__ParticleModuleBeamNoise.DistributionNoiseSpeed",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000484200004842000048420000484200004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    NoiseLockRadius=1.0
    NoiseTension=0.5
    NoiseTangentStrength=(Distribution="Default__ParticleModuleBeamNoise.DistributionNoiseTangentStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00007a4300007a4300007a4300007a43,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    NoiseTessellation=1
    NoiseScale=(Distribution="Default__ParticleModuleBeamNoise.DistributionNoiseScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
