class SoundNodeModulatorContinuous extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var() RawDistributionFloat PitchModulation;
var() RawDistributionFloat VolumeModulation;

defaultproperties
{
    PitchModulation=(Distribution="Default__SoundNodeModulatorContinuous.DistributionPitch",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=2,LookupTable=// [raw] 3333733f6666863f3333733f6666863f3333733f6666863f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    VolumeModulation=(Distribution="Default__SoundNodeModulatorContinuous.DistributionVolume",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=2,LookupTable=// [raw] 3333733f6666863f3333733f6666863f3333733f6666863f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
