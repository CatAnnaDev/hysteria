class AliceHealthPickupFactory extends AliceItemPickupFactory
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

var(Pickup) int Health;
var(Pickup) float Lifetime;
var(Pickup) float CollisionRadius;
var(Pickup) float CollisionHeight;
var(Pickup) export editinline ParticleSystemComponent IdleParticle;
var(Pickup) export editinline ParticleSystemComponent PickupParticle;
var(Pickup) Vector NormalAliceOffset;
var(Pickup) Vector ShrinkAliceOffset;
var(Pickup) Rotator FlyingRotation;
var Vector AliceOldLocation;
var bool bPicked;

function PickedUpBy(Pawn P)
{
    bPicked = true;
    PickedUpBy(P);
}

function bool IsValidPick()
{
    local float Distance;
    local Vector Aliceloc;
    
    Aliceloc = WorldInfo.GetLocalPlayerPawn().Location;
    Distance = VSize(Aliceloc - Location);
    if (!bEnablePick)
    {
        return false;
    }
    if (Distance < Abs(PickupRadius))
    {
        return true;
    }
    else
    {
        return false;
    }
}

event Tick(float DeltaTime)
{
    if (!bPicked && IsValidPick())
    {
        if (Physics != 4)
        {
            SetPhysics(4);
        }
        if (!bPlayingFlySound)
        {
            PlaySound(FlyingSound);
            bPlayingFlySound = true;
        }
        LineTrail(DeltaTime);
    }
}

function ShowAmmoCollision()
{
    DrawDebugCylinder(Location, Location, PickupRadius, 100, 255, 0, 0, true);
}

simulated function SetPickupHidden()
{
    IdleParticle.DeactivateSystem();
    IdleParticle.SetHidden(true);
    PickupParticle.SetActive(true);
    Disable('Tick');
    SetPickupHidden();
}

simulated function SetPickupVisible()
{
    IdleParticle.SetActive(true);
    SetPickupVisible();
}

function int HealAmount(Pawn Recipient)
{
    local AlicePawn P;
    
    P = AlicePawn(Recipient);
    if (P != none)
    {
        return int(FClamp(float(P.HealthMax - Recipient.Health), 0.0, float(Health)));
    }
    return int(FClamp(float(Recipient.HealthMax - Recipient.Health), 0.0, float(Health)));
}

function SpawnCopyFor(Pawn Recipient)
{
    if (Recipient.Health > 0)
    {
        Recipient.Health += HealAmount(Recipient);
        Recipient.PlaySound(PickupSound);
        Recipient.MakeNoise(0.2);
        if (AlicePawn(Recipient) != none)
        {
            AliceGameInfo(WorldInfo.Game).UpdateAliceHealth(Recipient.Health, Recipient.HealthMax);
        }
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    LifeSpan = Lifetime;
    PickupItemRotationRate = IdleRotation;
    SetCollisionSize(CollisionRadius, CollisionHeight);
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        if (!ValidTouch(Other))
        {
            return false;
        }
        if (bFlyingToAlice)
        {
            return true;
        }
        return true;
    }
    
    Stop;
}

defaultproperties
{
    Health=50
    Lifetime=30.0
    CollisionRadius=20.0
    CollisionHeight=20.0
    ShrinkAliceOffset=(X=0.0,Y=0.0,Z=-40.0)
    FlyingRotation=(Pitch=0,Yaw=100000,Roll=0)
    PickupSound="SFX_Combat.PowerUp_CardHit_Cue"
    FlyingSound="SFX_Combat.PowerUp_CardFly_Cue"
    StaticMesh="Default__AliceHealthPickupFactory.PickupMeshComp"
    IdleRotation=(Pitch=0,Yaw=20000,Roll=0)
    bRotatingPickup=True
    BaseMesh="Default__AliceHealthPickupFactory.BaseMeshComp"
    LightEnvironment="Default__AliceHealthPickupFactory.PickupLightEnvironment"
    PickUpWaveForm="Default__AliceHealthPickupFactory.ForceFeedbackWaveformPickUp"
    MaxDesireability=0.2
    bNotBased=True
    CylinderComponent="Default__AliceHealthPickupFactory.CollisionCylinder"
    bMovable=True
    bCollideWorld=True
    Components(0)="Default__AliceHealthPickupFactory.CollisionCylinder"
    Components(1)="Default__AliceHealthPickupFactory.PathRenderer"
    Components(2)="Default__AliceHealthPickupFactory.PickupLightEnvironment"
    Components(3)="Default__AliceHealthPickupFactory.BaseMeshComp"
    Components(4)="Default__AliceHealthPickupFactory.PickupMeshComp"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__AliceHealthPickupFactory.CollisionCylinder"
}
