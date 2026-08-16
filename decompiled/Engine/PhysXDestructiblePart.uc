class PhysXDestructiblePart extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var transient int FirstChunk;
var transient int NumChunks;
var PhysXDestructibleStructure Structure;
var PhysXDestructibleActor DestructibleActor;
var PhysXDestructibleAsset DestructibleAsset;
var export editinline LightEnvironmentComponent LightEnvironment;
var export editinline array<SkeletalMeshComponent> SkeletalMeshComponents;
var array<byte> NumChunksRemaining;
var byte NumMeshesRemaining;

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

native event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Damage;
    EventInstigator;
    HitLocation;
    Momentum;
    DamageType;
    HitInfo;
    DamageCauser;
}

defaultproperties
{
    LightEnvironment="Default__PhysXDestructiblePart.LightEnvironment0"
    bAlwaysRelevant=True
    bUpdateSimulatedPosition=True
    bNetInitialRotation=True
    bReplicateRigidBodyLocation=True
    bCollideActors=True
    bBlockActors=True
    bProjTarget=True
    bNoEncroachCheck=True
    bEdShouldSnap=True
    Components(0)="Default__PhysXDestructiblePart.LightEnvironment0"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_PostAsyncWork"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_ConstraintBroken"
    SupportedEvents(5)="SeqEvent_RigidBodyCollision"
}
