class HealthPickup extends AliceHealthPickupFactory
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

var float LeftLifeTimeWhenPause;
var bool bInCinematicMode;

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    if (bInCinematicMode)
    {
        LifeSpan = LeftLifeTimeWhenPause;
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    LifeSpan = Lifetime;
    PickupItemRotationRate = IdleRotation;
    SetCollisionSize(CollisionRadius, CollisionHeight);
}

defaultproperties
{
    IdleParticle="Default__HealthPickup.GlowEffect"
    PickupParticle="Default__HealthPickup.PickupEffect"
    StaticMesh="Default__HealthPickup.PickupMeshComp"
    BaseMesh="Default__HealthPickup.BaseMeshComp"
    LightEnvironment="Default__HealthPickup.PickupLightEnvironment"
    PickUpWaveForm="Default__HealthPickup.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__HealthPickup.CollisionCylinder"
    Components(0)="Default__HealthPickup.CollisionCylinder"
    Components(1)="Default__HealthPickup.PathRenderer"
    Components(2)="Default__HealthPickup.PickupLightEnvironment"
    Components(3)="Default__HealthPickup.BaseMeshComp"
    Components(4)="Default__HealthPickup.PickupMeshComp"
    Components(5)="Default__HealthPickup.GlowEffect"
    Components(6)="Default__HealthPickup.PickupEffect"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__HealthPickup.CollisionCylinder"
}
