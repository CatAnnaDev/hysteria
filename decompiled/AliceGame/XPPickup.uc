class XPPickup extends AliceXPPickupFactory
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
    IdleParticle="Default__XPPickup.GlowEffect"
    PickupParticle="Default__XPPickup.PickupEffect"
    StaticMesh="Default__XPPickup.PickupMeshComp"
    BaseMesh="Default__XPPickup.BaseMeshComp"
    LightEnvironment="Default__XPPickup.PickupLightEnvironment"
    PickUpWaveForm="Default__XPPickup.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__XPPickup.CollisionCylinder"
    Components(0)="Default__XPPickup.CollisionCylinder"
    Components(1)="Default__XPPickup.PathRenderer"
    Components(2)="Default__XPPickup.PickupLightEnvironment"
    Components(3)="Default__XPPickup.BaseMeshComp"
    Components(4)="Default__XPPickup.PickupMeshComp"
    Components(5)="Default__XPPickup.GlowEffect"
    Components(6)="Default__XPPickup.PickupEffect"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__XPPickup.CollisionCylinder"
}
