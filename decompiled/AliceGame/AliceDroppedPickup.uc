class AliceDroppedPickup extends DroppedPickup
    native
    notplaceable
    hidecategories(Navigation);

var() float YawRotationRate;
var export editinline PrimitiveComponent PickupMesh;
var export editinline ParticleSystemComponent PickupParticles;
var float StartScale;
var bool bRotatingPickup;
var bool bPickupable;
var export editinline LightEnvironmentComponent MyLightEnvironment;

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    local float DotP, Offset;
    
    Landed(HitNormal, FloorActor);
    if (PickupMesh != none)
    {
        DotP = HitNormal Dot vect(0.0, 0.0, 1.0);
        if (DotP != 0.0 && DotP < 1.0)
        {
            Offset = Sqrt(1.0 - Square(DotP)) * CylinderComponent(CollisionComponent).CollisionRadius / DotP;
        }
        if (class<AliceGameWeapon>(InventoryClass) != none)
        {
        }
        PickupMesh.SetTranslation(vect(0.0, 0.0, -1.0) * Offset);
        if (PickupParticles != none)
        {
            PickupParticles.SetTranslation(vect(0.0, 0.0, -1.0) * Offset);
        }
    }
}

function GiveTo(Pawn P)
{
    if (Inventory != none)
    {
        Inventory.AnnouncePickup(P);
        Inventory.GiveTo(P);
        Inventory = none;
    }
    PickedUpBy(P);
}

simulated event SetPickupParticles(ParticleSystemComponent NewPickupParticles)
{
    if (NewPickupParticles != none && WorldInfo.NetMode != 1)
    {
        PickupParticles = new(self) NewPickupParticles.Class(NewPickupParticles);
        AttachComponent(PickupParticles);
        PickupParticles.SetActive(true);
    }
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    if (NewPickupMesh != none && WorldInfo.NetMode != 1)
    {
        PickupMesh = new(self) NewPickupMesh.Class(NewPickupMesh);
        if (class<AliceGameWeapon>(InventoryClass) != none)
        {
            PickupMesh.SetScale(PickupMesh.Scale * 1.2);
        }
        PickupMesh.SetLightEnvironment(MyLightEnvironment);
        AttachComponent(PickupMesh);
    }
}

event PreBeginPlay()
{
    PreBeginPlay();
    bPickupable = Instigator == none || Instigator.Health <= 0;
}

state FadeOut
{
    simulated function BeginState(name PreviousStateName)
    {
        bFadeOut = true;
        if (PickupMesh != none)
        {
            StartScale = PickupMesh.Scale;
        }
        if (PickupParticles != none)
        {
            PickupParticles.DeactivateSystem();
        }
        LifeSpan = 1.0;
        YawRotationRate = 60000.0;
    }
    
    Stop;
}

auto state Pickup
{
    simulated event Landed(Vector HitNormal, Actor FloorActor)
    {
        Global.Landed(HitNormal, FloorActor);
        if (Role == 3 && !bPickupable)
        {
            bPickupable = true;
            CheckTouching();
        }
    }
    
    function bool ValidTouch(Pawn Other)
    {
        return bPickupable ? ValidTouch(Other) : false;
    }
    
    Stop;
}

defaultproperties
{
    YawRotationRate=32768.0
    PickupParticles="Default__AliceDroppedPickup.GlowEffect"
    bRotatingPickup=True
    bPickupable=True
    MyLightEnvironment="Default__AliceDroppedPickup.DroppedPickupLightEnvironment"
    bDestroyedByInterpActor=True
    Components(0)="Default__AliceDroppedPickup.Sprite"
    Components(1)="Default__AliceDroppedPickup.CollisionCylinder"
    Components(2)="Default__AliceDroppedPickup.DroppedPickupLightEnvironment"
    Components(3)="Default__AliceDroppedPickup.GlowEffect"
    CollisionComponent="Default__AliceDroppedPickup.CollisionCylinder"
}
