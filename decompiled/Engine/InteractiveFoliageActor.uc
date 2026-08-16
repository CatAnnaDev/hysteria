class InteractiveFoliageActor extends StaticMeshActor
    native
    placeable
    hidecategories(Navigation);

var export editinline CylinderComponent CylinderComponent;
var transient Vector TouchingActorEntryPosition;
var transient Vector FoliageVelocity;
var transient Vector FoliageForce;
var transient Vector FoliagePosition;
var(FoliagePhysics) float FoliageDamageImpulseScale;
var(FoliagePhysics) float FoliageTouchImpulseScale;
var(FoliagePhysics) float FoliageStiffness;
var(FoliagePhysics) float FoliageStiffnessQuadratic;
var(FoliagePhysics) float FoliageDamping;
var(FoliagePhysics) float MaxDamageImpulse;
var(FoliagePhysics) float MaxTouchImpulse;
var(FoliagePhysics) float MaxForce;
var float Mass;

native simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Other;
    OtherComp;
    HitLocation;
    HitNormal;
}

native simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
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
    CylinderComponent="Default__InteractiveFoliageActor.CollisionCylinder"
    FoliageDamageImpulseScale=20.0
    FoliageTouchImpulseScale=10.0
    FoliageStiffness=10.0
    FoliageStiffnessQuadratic=0.3
    FoliageDamping=2.0
    MaxDamageImpulse=100000.0
    MaxTouchImpulse=1000.0
    MaxForce=100000.0
    Mass=1.0
    StaticMeshComponent="Default__InteractiveFoliageActor.FoliageMeshComponent0"
    bStatic=False
    bNoDelete=True
    bWorldGeometry=False
    bBlockActors=False
    bProjTarget=True
    Components(0)="Default__InteractiveFoliageActor.FoliageMeshComponent0"
    Components(1)="Default__InteractiveFoliageActor.CollisionCylinder"
    TickGroup="TG_DuringAsyncWork"
    CollisionComponent="Default__InteractiveFoliageActor.CollisionCylinder"
}
