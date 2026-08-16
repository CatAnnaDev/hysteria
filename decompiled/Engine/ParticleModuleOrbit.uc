class ParticleModuleOrbit extends ParticleModuleOrbitBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,Orbit);

enum EOrbitChainMode
{
    EOChainMode_Add,
    EOChainMode_Scale,
    EOChainMode_Link,
};

struct native OrbitOptions
{
    var() bool bProcessDuringSpawn;
    var() bool bProcessDuringUpdate;
    var() bool bUseEmitterTime;
};

var(Chaining) EOrbitChainMode ChainMode;
var(Offset) RawDistributionVector OffsetAmount;
var(Offset) OrbitOptions OffsetOptions;
var(Rotation) RawDistributionVector RotationAmount;
var(Rotation) OrbitOptions RotationOptions;
var(RotationRate) RawDistributionVector RotationRateAmount;
var(RotationRate) OrbitOptions RotationRateOptions;

defaultproperties
{
    ChainMode="EOChainMode_Link"
    OffsetAmount=(Distribution="Default__ParticleModuleOrbit.DistributionOffsetAmount",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 0000000000004842000000000000000000000000000000000000484200000000000000000000000000000000000000000000484200000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    OffsetOptions=(bProcessDuringSpawn=True,bProcessDuringUpdate=False,bUseEmitterTime=False)
    RotationAmount=(Distribution="Default__ParticleModuleOrbit.DistributionRotationAmount",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 000000000000803f0000000000000000000000000000803f0000803f0000803f0000000000000000000000000000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RotationOptions=(bProcessDuringSpawn=True,bProcessDuringUpdate=False,bUseEmitterTime=False)
    RotationRateAmount=(Distribution="Default__ParticleModuleOrbit.DistributionRotationRateAmount",Type=0,Op=2,LookupTableNumElements=2,LookupTableChunkSize=6,LookupTable=// [raw] 000000000000803f0000000000000000000000000000803f0000803f0000803f0000000000000000000000000000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    RotationRateOptions=(bProcessDuringSpawn=True,bProcessDuringUpdate=False,bUseEmitterTime=False)
    bSpawnModule=True
    bUpdateModule=True
}
