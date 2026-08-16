class AliceDroppedItemPickup extends AliceDroppedPickup
    notplaceable
    hidecategories(Navigation);

var float MaxDesireability;
var SoundCue PickupSound;

function PickedUpBy(Pawn P)
{
    PlaySound(PickupSound);
    PickedUpBy(P);
}

function DroppedFrom(Pawn P)
{
}

event Destroyed()
{
    Destroyed();
    if (Inventory != none)
    {
        Inventory.Destroy();
    }
}

event PostBeginPlay()
{
    Inventory = Spawn(InventoryClass);
    PostBeginPlay();
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
}

function float BotDesireability(Pawn Bot, Controller C)
{
}

defaultproperties
{
    PickupParticles="Default__AliceDroppedItemPickup.GlowEffect"
    MyLightEnvironment="Default__AliceDroppedItemPickup.DroppedPickupLightEnvironment"
    InventoryClass="AlicePickupInventory"
    Components(0)="Default__AliceDroppedItemPickup.Sprite"
    Components(1)="Default__AliceDroppedItemPickup.CollisionCylinder"
    Components(2)="Default__AliceDroppedItemPickup.DroppedPickupLightEnvironment"
    Components(3)="Default__AliceDroppedItemPickup.GlowEffect"
    CollisionComponent="Default__AliceDroppedItemPickup.CollisionCylinder"
}
