class ParticleModuleTypeDataPhysX extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

struct native PhysXEmitterVerticalLodProperties
{
    var() float WeightForFifo;
    var() float WeightForSpawnLod;
    var() float SpawnLodRateVsLifeBias;
    var() float RelativeFadeoutTime;
};

var(PhysXEmitter) PhysXParticleSystem PhysXParSys;
var(PhysXEmitter) PhysXEmitterVerticalLodProperties VerticalLod;
var(PhysXEmitter) float Smoothness;
var(PhysXEmitter) bool UseSPHFluid;

defaultproperties
{
    VerticalLod=(WeightForFifo=1.0,WeightForSpawnLod=1.0,SpawnLodRateVsLifeBias=1.0,RelativeFadeoutTime=0.0)
}
