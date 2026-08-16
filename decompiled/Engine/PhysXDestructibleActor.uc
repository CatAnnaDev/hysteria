class PhysXDestructibleActor extends FracturedStaticMeshActor
    native
    placeable
    hidecategories(Navigation);

struct native SpawnBasis
{
    var Vector Location;
    var Rotator Rotation;
    var float Scale;
};

var export editinline PhysXDestructibleComponent DestructibleComponent;
var export editinline LightEnvironmentComponent LightEnvironment;
var PhysXDestructible PhysXDestructible;
var PhysXDestructibleStructure Structure;
var array<int> PartFirstChunkIndices;
var array<PhysXDestructiblePart> Parts;
var array<int> Neighbors;
var(Destructible) editinline PhysXDestructibleParameters DestructibleParameters;
var native transient float LinearSize;
var native transient bool bPlayFractureSound;
var(Destructible) const bool bSupportChunksTouchWorld;
var(Destructible) const bool bSupportChunksInSupportFragment;
var native transient array<SpawnBasis> EffectBases;
var native transient Pointer VolumeFill;
var(Destructible) const int PerFrameProcessBudget;
var(Destructible) const int SupportDepth;
var byte NumPartsRemaining;

simulated event Explode()
{
}

native simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    InstigatedBy;
    BaseDamage;
    DamageRadius;
    DamageType;
    Momentum;
    HurtOrigin;
    bFullDamage;
    DamageCauser;
    DamageFalloffExponent;
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int Item;
    
    Item = HitInfo.Item;
    HitInfo.Item = FracturedStaticMeshComponent.GetCoreFragmentIndex();
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    HitInfo.Item = Item;
    NativeTakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

native function NativeTakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Damage;
    EventInstigator;
    HitLocation;
    Momentum;
    DamageType;
    HitInfo;
    DamageCauser;
}

native function NativeSpawnEffects()
{
}

event Destroyed()
{
    Destroyed();
    Term();
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    Init();
}

simulated event SpawnEffects()
{
    local int I;
    local EmitterSpawnable Effect;
    local FracturedStaticMesh FracMesh;
    local ParticleSystem EffectPSys;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    if (FracMesh.FragmentDestroyEffects.Length > 0 && EffectBases.Length > 0)
    {
        EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.Length)];
        if (EffectPSys != none)
        {
            for (I = 0; I < EffectBases.Length; I++)
            {
                Effect = Spawn(class'EmitterSpawnable', self, , EffectBases[I].Location, EffectBases[I].Rotation);
                Effect.SetTemplate(EffectPSys, true);
                Effect.ParticleSystemComponent.SetScale(FracMesh.FragmentDestroyEffectScale * EffectBases[I].Scale);
                Effect.LifeSpan = 1.0;
            }
            EffectBases.Remove(0, EffectBases.Length);
        }
    }
}

native function Term()
{
}

native function Init()
{
}

defaultproperties
{
    DestructibleParameters=(DamageThreshold=5.0,DamageToRadius=0.1,DamageCap=0.0,ForceToDamage=0.0,FractureSound="None",CrumbleParticleSystem="None",CrumbleParticleSize=10.0,bAccumulateDamage=True,ScaledDamageToRadius=0.0,DepthParameters=())
    bSupportChunksTouchWorld=True
    PerFrameProcessBudget=100
    FracturedStaticMeshComponent="Default__PhysXDestructibleActor.FracturedStaticMeshComponent0"
    SkinnedComponent="Default__PhysXDestructibleActor.FracturedSkinnedComponent0"
    bWorldGeometry=False
    bNoEncroachCheck=True
    Components(0)="Default__PhysXDestructibleActor.LightEnvironment0"
    Components(1)="Default__PhysXDestructibleActor.FracturedSkinnedComponent0"
    Components(2)="Default__PhysXDestructibleActor.FracturedStaticMeshComponent0"
    CollisionComponent="Default__PhysXDestructibleActor.FracturedStaticMeshComponent0"
}
