class FracturedStaticMeshActor extends Actor
    native
    placeable
    hidecategories(Navigation);

struct native DeferredPartToSpawn
{
    var int ChunkIndex;
    var Vector InitialVel;
    var Vector InitialAngVel;
    var float RelativeScale;
    var bool bExplosion;
};

var() int MaxPartsToSpawnAtOnce;
var() const export editconst editinline FracturedStaticMeshComponent FracturedStaticMeshComponent;
var const transient export editinline FracturedSkinnedMeshComponent SkinnedComponent;
var array<int> ChunkHealth;
var transient bool bHasShownMissingSoundWarning;
var() bool bBreakChunksOnActorTouch;
var() array<class<DamageType>> FracturedByDamageType;
var() float ChunkHealthScale;
var() array<ParticleSystem> OverrideFragmentDestroyEffects;
var() float FractureCullMinDistance;
var() float FractureCullMaxDistance;
var transient array<DeferredPartToSpawn> DeferredPartsToSpawn;
var PhysEffectInfo PartImpactEffect;
var SoundCue ExplosionFractureSound;
var SoundCue SingleChunkFractureSound;
var transient MaterialInterface MI_LoseChunkPreviousMaterial;

simulated function SetLoseChunkReplacementMaterial()
{
    local MaterialInterface LoseChunkOutsideMat;
    local FracturedStaticMesh FracMesh;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    if (FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride != none)
    {
        LoseChunkOutsideMat = FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride;
    }
    else
    {
        LoseChunkOutsideMat = FracMesh.LoseChunkOutsideMaterial;
    }
    if (LoseChunkOutsideMat != none)
    {
        MI_LoseChunkPreviousMaterial = FracturedStaticMeshComponent.GetMaterial(FracMesh.OutsideMaterialIndex).GetMaterial();
        FracturedStaticMeshComponent.SetMaterial(FracMesh.OutsideMaterialIndex, LoseChunkOutsideMat);
    }
}

simulated event HideFragmentsToMaximizeMemoryUsage()
{
    local array<byte> FragmentVis;
    local int I, Incr;
    
    Incr = 4;
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    I = 0;
    while (I < FragmentVis.Length)
    {
        if (FragmentVis[I] != 0 && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            FragmentVis[I] = 0;
        }
        I += Incr;
    }
    FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
}

simulated event HideOneFragment()
{
    local array<byte> FragmentVis;
    local int I;
    
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    for (I = 0; I < FragmentVis.Length; I++)
    {
        if (FragmentVis[I] != 0 && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            FragmentVis[I] = 0;
            FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
            return;
        }
    }
}

native simulated event ResetVisibility()
{
}

native simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
    Origin;
    Radius;
    RBStrength;
    bWantPhysChunksAndParticles;
}

simulated event Explode()
{
    local array<byte> FragmentVis;
    local int I;
    local Vector SpawnDir;
    local FracturedStaticMesh FracMesh;
    local FracturedStaticMeshPart FracPart;
    local float PartScale;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
    for (I = 0; I < FragmentVis.Length; I++)
    {
        if (FragmentVis[I] != 0 && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
        {
            SpawnDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(I);
            PartScale = FracMesh.ExplosionPhysicsChunkScaleMin + FRand() * (FracMesh.ExplosionPhysicsChunkScaleMax - FracMesh.ExplosionPhysicsChunkScaleMin);
            FracPart = SpawnPart(I, 0.5 * SpawnDir * FracMesh.ChunkLinVel + Velocity, 0.5 * VRand() * FracMesh.ChunkAngVel, PartScale, true);
            if (FracPart != none)
            {
                FracPart.FracturedStaticMeshComponent.SetRBCollidesWithChannel(14, false);
            }
            FragmentVis[I] = 0;
        }
    }
    FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local array<byte> FragmentVis;
    local Vector ChunkDir, MomentumDir;
    local FracturedStaticMesh FracMesh;
    local FracturedStaticMeshPart FracPart;
    local array<FracturedStaticMeshPart> NoCollParts;
    local int TotalVisible;
    local array<int> IgnoreFrags;
    local Box ChunkBox;
    local ParticleSystem EffectPSys;
    local float PhysChance, PartScale;
    local byte bWantPhysChunksAndParticles;
    local Pawn InstigatorPawn;
    local WorldFractureSettings FractureSettings;
    local Vector NewHitLocation, HitNormal;
    
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (DamageType != none && !DamageType.default.default.bCausesFracture || !IsFracturedByDamageType(DamageType))
    {
        return;
    }
    if (HitInfo.HitComponent == none)
    {
        if (Momentum == vect(0.0, 0.0, 0.0))
        {
            Momentum = Location - HitLocation;
        }
        TraceComponent(NewHitLocation, HitNormal, FracturedStaticMeshComponent, HitLocation + float(100) * Normal(Momentum), HitLocation, , HitInfo, true);
    }
    if (HitInfo.Item == FracturedStaticMeshComponent.GetCoreFragmentIndex() || !FracturedStaticMeshComponent.IsFragmentVisible(HitInfo.Item) || !FracturedStaticMeshComponent.IsFragmentDestroyable(HitInfo.Item))
    {
        return;
    }
    if (EventInstigator != none)
    {
        InstigatorPawn = EventInstigator.Pawn;
    }
    else if (DamageCauser != none)
    {
        InstigatorPawn = DamageCauser.Instigator;
    }
    if (!FractureEffectIsRelevant(false, InstigatorPawn, bWantPhysChunksAndParticles))
    {
        return;
    }
    if (RB_LineImpulseActor(DamageCauser) != none)
    {
        ChunkHealth[HitInfo.Item] = 0;
    }
    else if (DamageType != none)
    {
        ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage * DamageType.default.default.FracturedMeshDamage);
    }
    else
    {
        ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage);
    }
    if (ChunkHealth[HitInfo.Item] <= 0)
    {
        FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
        FractureSettings = WorldInfo.GetWorldFractureSettings();
        FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
        TotalVisible = FracturedStaticMeshComponent.GetNumVisibleFragments();
        if (Physics == 10)
        {
            if (TotalVisible == 1)
            {
                return;
            }
        }
        if (TotalVisible == FragmentVis.Length)
        {
            SetLoseChunkReplacementMaterial();
        }
        FragmentVis[HitInfo.Item] = 0;
        ChunkDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(HitInfo.Item);
        MomentumDir = Normal(Momentum);
        if (VSize(ChunkDir) < 0.01 || MomentumDir Dot ChunkDir > -0.2)
        {
            ChunkDir += MomentumDir;
        }
        ChunkDir.Z = float(Max(int(ChunkDir.Z), 0));
        ChunkDir.Z /= FracMesh.ChunkLinHorizontalScale;
        ChunkDir = Normal(ChunkDir);
        if (WorldInfo.NetMode != 1)
        {
            PhysChance = (FractureSettings.bEnableChanceOfPhysicsChunkOverride ? FractureSettings.ChanceOfPhysicsChunkOverride : FracMesh.ChanceOfPhysicsChunk);
            PhysChance *= WorldInfo.MyFractureManager.GetFSMDirectSpawnChanceScale();
            if (bWantPhysChunksAndParticles == 1 && FracMesh.bSpawnPhysicsChunks && FRand() < PhysChance && !FracturedStaticMeshComponent.IsNoPhysFragment(HitInfo.Item))
            {
                PartScale = FracMesh.NormalPhysicsChunkScaleMin + FRand() * (FracMesh.NormalPhysicsChunkScaleMax - FracMesh.NormalPhysicsChunkScaleMin);
                FracPart = SpawnPart(HitInfo.Item, ChunkDir * FracMesh.ChunkLinVel + Velocity, VRand() * FracMesh.ChunkAngVel, PartScale, false);
                if (FracPart != none)
                {
                    FracPart.FracturedStaticMeshComponent.DisableRBCollisionWithSMC(FracturedStaticMeshComponent, true);
                }
            }
            if (bWantPhysChunksAndParticles == 1)
            {
                if (OverrideFragmentDestroyEffects.Length > 0)
                {
                    EffectPSys = OverrideFragmentDestroyEffects[Rand(OverrideFragmentDestroyEffects.Length)];
                }
                else if (FracMesh.FragmentDestroyEffects.Length > 0)
                {
                    EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.Length)];
                }
                if (EffectPSys != none && WorldInfo.MyFractureManager != none)
                {
                    ChunkBox = FracturedStaticMeshComponent.GetFragmentBox(HitInfo.Item);
                    WorldInfo.MyFractureManager.SpawnChunkDestroyEffect(EffectPSys, ChunkBox, ChunkDir, FracMesh.FragmentDestroyEffectScale);
                }
            }
        }
        if (FracturedStaticMeshComponent.GetCoreFragmentIndex() == -1 && !FracMesh.bFixIsolatedChunks)
        {
            IgnoreFrags[0] = HitInfo.Item;
            if (FracPart != none)
            {
                NoCollParts[0] = FracPart;
            }
            BreakOffIsolatedIslands(FragmentVis, IgnoreFrags, ChunkDir, NoCollParts, bWantPhysChunksAndParticles == 1 ? true : false);
        }
        FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
        if (Physics == 10)
        {
            FracturedStaticMeshComponent.RecreatePhysState();
        }
    }
}

native protected final simulated function RemoveDecals(int IndexToRemoveDecalsFrom)
{
    IndexToRemoveDecalsFrom;
}

simulated function bool FractureEffectIsRelevant(bool bForceDedicated, Pawn EffectInstigator, out byte bWantPhysChunksAndParticles)
{
    local bool bResult;
    local PlayerController P;
    local float FinalMinDistance, FinalCullDistance;
    
    bWantPhysChunksAndParticles = 1;
    if (EffectInstigator == none)
    {
        return true;
    }
    else
    {
        if (WorldInfo.NetMode == 1)
        {
            return bForceDedicated;
        }
        if (WorldInfo.NetMode == 2 && WorldInfo.Game.NumPlayers > 1)
        {
            if (bForceDedicated)
            {
                return true;
            }
            if (EffectInstigator != none && EffectInstigator.IsHumanControlled() && EffectInstigator.IsLocallyControlled())
            {
                return true;
            }
        }
        else if (EffectInstigator != none && EffectInstigator.IsHumanControlled())
        {
            return true;
        }
        FinalMinDistance = FractureCullMinDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
        FinalCullDistance = FractureCullMaxDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
        foreach LocalPlayerControllers(class'PlayerController', P)
        {
            if (P.ViewTarget != none)
            {
                if (P.Pawn == EffectInstigator && EffectInstigator != none)
                {
                    return true;
                    continue;
                }
                if (CheckMaxEffectDistance(P, Location, FinalMinDistance))
                {
                    return true;
                }
                bResult = CheckMaxEffectDistance(P, Location, FinalCullDistance);
                break;
            }
        }
        if (bResult)
        {
            if (WorldInfo.TimeSeconds - LastRenderTime < 0.5)
            {
                return true;
            }
            else
            {
                bWantPhysChunksAndParticles = 0;
                return true;
            }
        }
        else
        {
            bWantPhysChunksAndParticles = 0;
            return false;
        }
    }
}

simulated function bool IsFracturedByDamageType(class<DamageType> dmgType)
{
    local int I;
    
    if (FracturedByDamageType.Length == 0)
    {
        return true;
    }
    for (I = 0; I < FracturedByDamageType.Length; I++)
    {
        if (dmgType == FracturedByDamageType[I])
        {
            return true;
        }
    }
    return false;
}

native simulated event bool SpawnDeferredParts()
{
}

native simulated event BreakOffIsolatedIslands(out array<byte> FragmentVis, array<int> IgnoreFrags, Vector ChunkDir, array<FracturedStaticMeshPart> DisableCollWithPart, bool bWantPhysChunks)
{
    FragmentVis;
    IgnoreFrags;
    ChunkDir;
    DisableCollWithPart;
    bWantPhysChunks;
}

native final simulated function ResetHealth()
{
}

simulated event PostBeginPlay()
{
    local PhysicalMaterial PhysMat;
    
    PostBeginPlay();
    ResetHealth();
    if (!bBreakChunksOnActorTouch)
    {
        SetTickIsDisabled(true);
    }
    PhysMat = FracturedStaticMeshComponent.GetFracturedMeshPhysMaterial();
    if (PhysMat != none)
    {
        PartImpactEffect = PhysMat.FindPhysEffectInfo(0);
        PhysMat.FindFractureSounds(ExplosionFractureSound, SingleChunkFractureSound);
    }
    ResetVisibility();
}

native final simulated function FracturedStaticMeshPart SpawnPartMulti(array<int> ChunkIndices, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion)
{
    ChunkIndices;
    InitialVel;
    InitialAngVel;
    RelativeScale;
    bExplosion;
}

native final simulated function FracturedStaticMeshPart SpawnPart(int ChunkIndex, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion)
{
    ChunkIndex;
    InitialVel;
    InitialAngVel;
    RelativeScale;
    bExplosion;
}

defaultproperties
{
    MaxPartsToSpawnAtOnce=6
    FracturedStaticMeshComponent="Default__FracturedStaticMeshActor.FracturedStaticMeshComponent0"
    SkinnedComponent="Default__FracturedStaticMeshActor.FracturedSkinnedComponent0"
    ChunkHealthScale=1.0
    FractureCullMinDistance=512.0
    FractureCullMaxDistance=4096.0
    bNoDelete=True
    bWorldGeometry=True
    bRouteBeginPlayEvenIfStatic=False
    bGameRelevant=True
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    bProjTarget=True
    bEdShouldSnap=True
    bPathColliding=True
    Components(0)="Default__FracturedStaticMeshActor.LightEnvironment0"
    Components(1)="Default__FracturedStaticMeshActor.FracturedSkinnedComponent0"
    Components(2)="Default__FracturedStaticMeshActor.FracturedStaticMeshComponent0"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__FracturedStaticMeshActor.FracturedStaticMeshComponent0"
}
