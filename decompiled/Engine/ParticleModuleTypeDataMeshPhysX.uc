class ParticleModuleTypeDataMeshPhysX extends ParticleModuleTypeDataMesh
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object,Object);

enum EPhysXMeshRotationMethod
{
    PMRM_Disabled,
    PMRM_Spherical,
    PMRM_Box,
    PMRM_LongBox,
    PMRM_FlatBox,
    PMRM_Velocity,
};

var(PhysXEmitter) PhysXParticleSystem PhysXParSys;
var(PhysXEmitter) EPhysXMeshRotationMethod PhysXRotationMethod;
var(PhysXEmitter) float FluidRotationCoefficient;
var native Pointer RenderInstance;
var(PhysXEmitter) PhysXEmitterVerticalLodProperties VerticalLod;

defaultproperties
{
    PhysXRotationMethod="PMRM_Spherical"
    FluidRotationCoefficient=5.0
    VerticalLod=(WeightForFifo=1.0,WeightForSpawnLod=1.0,SpawnLodRateVsLifeBias=1.0,RelativeFadeoutTime=0.0)
}
