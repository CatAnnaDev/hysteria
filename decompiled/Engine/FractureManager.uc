class FractureManager extends Actor
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

const FSM_DEFAULTRECYCLETIME = 0.2;

var int FSMPartPoolSize;
var() bool bEnableAntiVibration;
var() bool bEnableSpawnChunkEffectForRadialDamage;
var() float DestroyVibrationLevel;
var() float DestroyMinAngVel;
var() float ExplosionVelScale;
var array<FracturedStaticMeshPart> PartPool;
var array<int> FreeParts;
var transient array<FracturedStaticMeshActor> ActorsWithDeferredPartsToSpawn;

simulated function Tick(float DeltaTime)
{
    Tick(DeltaTime);
    SpawnDeferredParts();
}

simulated function SpawnDeferredParts()
{
    local int CurActorIndex;
    
    if (ActorsWithDeferredPartsToSpawn.Length > 0)
    {
        for (CurActorIndex = 0; CurActorIndex < ActorsWithDeferredPartsToSpawn.Length; ++CurActorIndex)
        {
            if (ActorsWithDeferredPartsToSpawn[CurActorIndex].SpawnDeferredParts())
            {
                ActorsWithDeferredPartsToSpawn.Remove(CurActorIndex, 1);
                --CurActorIndex;
            }
        }
    }
}

simulated event ReturnPartActor(FracturedStaticMeshPart Part)
{
    FreeParts.AddItem(Part.PartPoolIndex);
}

simulated event FracturedStaticMeshPart SpawnPartActor(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation)
{
    local FracturedStaticMeshPart NewPart;
    
    NewPart = GetFSMPart(Parent, SpawnLocation, SpawnRotation);
    if (NewPart != none)
    {
        NewPart.SetTimer(10.0, false, 'TryToCleanUp');
    }
    return NewPart;
}

native function FracturedStaticMeshPart GetFSMPart(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation)
{
    Parent;
    SpawnLocation;
    SpawnRotation;
}

native simulated function ResetPoolVisibility()
{
}

native function CreateFSMParts()
{
}

final simulated function CleanUpFSMParts()
{
    local int Idx;
    
    for (Idx = 0; Idx < PartPool.Length; Idx++)
    {
        PartPool[Idx].Destroy();
        PartPool[Idx] = none;
    }
}

simulated event Destroyed()
{
    Destroyed();
    CleanUpFSMParts();
}

simulated event PreBeginPlay()
{
    PreBeginPlay();
    CreateFSMParts();
}

native function float GetFSMFractureCullDistanceScale()
{
}

native function float GetFSMRadialSpawnChanceScale()
{
}

native function float GetFSMDirectSpawnChanceScale()
{
}

native function float GetNumFSMPartsScale()
{
}

simulated event SpawnChunkDestroyEffect(ParticleSystem Effect, Box ChunkBox, Vector ChunkDir, float Scale)
{
    local Vector ChunkMiddle;
    local ParticleSystemComponent EffectComp;
    
    ChunkMiddle = 0.5 * (ChunkBox.Min + ChunkBox.Max);
    EffectComp = WorldInfo.MyEmitterPool.SpawnEmitter(Effect, ChunkMiddle, rotator(ChunkDir));
    EffectComp.SetScale(Scale);
}

defaultproperties
{
    FSMPartPoolSize=50
    DestroyVibrationLevel=3.0
    DestroyMinAngVel=2.5
    ExplosionVelScale=1.0
    CollisionType="COLLIDE_CustomDefault"
}
