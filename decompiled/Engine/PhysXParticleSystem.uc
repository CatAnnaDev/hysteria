class PhysXParticleSystem extends Object
    native
    notplaceable
    hidecategories(Object);

enum EPacketSizeMultiplier
{
    EPSM_4,
    EPSM_8,
    EPSM_16,
    EPSM_32,
    EPSM_64,
    EPSM_128,
};

enum ESimulationMethod
{
    ESM_SPH,
    ESM_NO_PARTICLE_INTERACTION,
    ESM_MIXED_MODE,
};

var(Buffer) int MaxParticles;
var(Buffer) int ParticleSpawnReserve;
var(Collision) const ERBCollisionChannel RBChannel;
var(SdkExpert) ESimulationMethod SimulationMethod;
var(SdkExpert) EPacketSizeMultiplier PacketSizeMultiplier;
var(Collision) const RBCollisionChannelContainer RBCollideWithChannels;
var(Collision) float CollisionDistance;
var(Collision) float RestitutionWithStaticShapes;
var(Collision) float RestitutionWithDynamicShapes;
var(Collision) float FrictionWithStaticShapes;
var(Collision) float FrictionWithDynamicShapes;
var(Collision) bool bDynamicCollision;
var(Dynamics) bool bDisableGravity;
var(SdkExpert) bool bStaticCollision;
var(SdkExpert) bool bTwoWayCollision;
var transient bool bDestroy;
var transient bool bSyncFailed;
var transient bool bIsInGame;
var(Dynamics) float MaxMotionDistance;
var(Dynamics) float Damping;
var(Dynamics) Vector ExternalAcceleration;
var(SdkExpert) float RestParticleDistance;
var(SdkExpert) float RestDensity;
var(SdkExpert) float KernelRadiusMultiplier;
var(SdkExpert) float Stiffness;
var(SdkExpert) float Viscosity;
var(SdkExpert) float CollisionResponseCoefficient;
var native Pointer CascadeScene;
var native Pointer PSys;

defaultproperties
{
    MaxParticles=4095
    RBChannel="RBCC_EffectPhysics"
    SimulationMethod="ESM_NO_PARTICLE_INTERACTION"
    PacketSizeMultiplier="EPSM_16"
    RBCollideWithChannels=(Default=True,Nothing=False,Pawn=False,Vehicle=False,Water=False,GameplayPhysics=True,EffectPhysics=False,Untitled1=False,Untitled2=False,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=True,SoftBody=False,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    CollisionDistance=10.0
    RestitutionWithStaticShapes=0.5
    RestitutionWithDynamicShapes=0.5
    FrictionWithStaticShapes=0.05
    FrictionWithDynamicShapes=0.5
    bDynamicCollision=True
    bStaticCollision=True
    MaxMotionDistance=64.0
    RestParticleDistance=64.0
    RestDensity=1000.0
    KernelRadiusMultiplier=2.0
    Stiffness=20.0
    Viscosity=6.0
    CollisionResponseCoefficient=0.2
}
