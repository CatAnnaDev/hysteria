class ParticleModuleTypeDataIsosurfacePhysX extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(PhysXEmitter) PhysXParticleSystem PhysXParSys;
var(PhysXEmitter) PhysXEmitterVerticalLodProperties VerticalLod;
var(PhysXEmitter) float CellSize;
var(PhysXEmitter) float IsoLevel;
var(PhysXEmitter) int KernelSize;
var(PhysXEmitter) int LatticeSize;
var(PhysXEmitter) int MaxTrianglePerParticle;

defaultproperties
{
    VerticalLod=(WeightForFifo=1.0,WeightForSpawnLod=1.0,SpawnLodRateVsLifeBias=1.0,RelativeFadeoutTime=0.0)
    CellSize=25.0
    IsoLevel=0.25
    KernelSize=2
    LatticeSize=7
    MaxTrianglePerParticle=100
}
