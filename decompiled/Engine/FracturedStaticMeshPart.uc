class FracturedStaticMeshPart extends FracturedStaticMeshActor
    native
    notplaceable
    hidecategories(Navigation);

var float DestroyPartRadiusFactor;
var transient FracturedStaticMeshActor BaseFracturedMeshActor;
var bool bHasBeenRecycled;
var bool bChangeRBChannelWhenAsleep;
var bool bCompositeThatExplodesOnImpact;
var float LastSpawnTime;
var int PartPoolIndex;
var float FracPartGravScale;
var ERBCollisionChannel AsleepRBChannel;
var Vector OldVelocity;
var float CurrentVibrationLevel;
var float LastImpactSoundTime;

simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
    if (bCompositeThatExplodesOnImpact)
    {
        BreakOffPartsInRadius(Origin, Radius, RBStrength, bWantPhysChunksAndParticles);
    }
}

simulated event Explode()
{
    if (!bHasBeenRecycled)
    {
        Explode();
        RecyclePart(true);
    }
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    RecyclePart(true);
}

simulated function TryToCleanUp()
{
    if (WorldInfo.TimeSeconds - BaseFracturedMeshActor.SkinnedComponent.LastRenderTime > 1.0)
    {
        RecyclePart(true);
    }
    else
    {
        SetTimer(2.0, false, 'TryToCleanUp');
    }
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    FracturedStaticMeshComponent.AddImpulse(Normal(Momentum) * DamageType.default.default.KDamageImpulse, HitLocation);
}

native simulated function RecyclePart(bool bAddToFreePool)
{
    bAddToFreePool;
}

native simulated function Initialize()
{
}

defaultproperties
{
    DestroyPartRadiusFactor=10.0
    FracPartGravScale=2.0
    AsleepRBChannel="RBCC_GameplayPhysics"
    FracturedStaticMeshComponent="Default__FracturedStaticMeshPart.FracturedStaticMeshComponent0"
    SkinnedComponent="None"
    bNoDelete=False
    bWorldGeometry=False
    bNetInitialRotation=True
    bMovable=True
    bBlockActors=False
    bNoEncroachCheck=True
    bPathColliding=False
    Components(0)="Default__FracturedStaticMeshPart.FracturedStaticMeshComponent0"
    Physics="PHYS_RigidBody"
    TickGroup="TG_PostAsyncWork"
    LifeSpan=15.0
    CollisionComponent="Default__FracturedStaticMeshPart.FracturedStaticMeshComponent0"
}
