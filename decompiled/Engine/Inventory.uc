class Inventory extends Actor
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

var repretry Inventory Inventory;
var repretry InventoryManager InvManager;
var const localized databinding string ItemName;
var bool bRenderOverlays;
var bool bReceiveOwnerEvents;
var bool bDropOnDeath;
var bool bDelayedSpawn;
var bool bPredictRespawns;
var() float RespawnTime;
var float MaxDesireability;
var() const localized databinding string PickupMessage;
var() SoundCue PickupSound;
var() string PickupForce;
var class<DroppedPickup> DroppedPickupClass;
var export editinline PrimitiveComponent DroppedPickupMesh;
var export editinline PrimitiveComponent PickupFactoryMesh;
var export editinline ParticleSystemComponent DroppedPickupParticles;

replication
{
    if (Role == 3 && bNetDirty && bNetOwner)
        Inventory, InvManager;
}

function OwnerEvent(name EventName)
{
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local DroppedPickup P;
    
    if (Instigator != none && Instigator.InvManager != none)
    {
        Instigator.InvManager.RemoveFromInventory(self);
    }
    if (DroppedPickupClass == none || DroppedPickupMesh == none)
    {
        Destroy();
        return;
    }
    P = Spawn(DroppedPickupClass, , , StartLocation);
    if (P == none)
    {
        Destroy();
        return;
    }
    P.SetPhysics(2);
    P.Inventory = self;
    P.InventoryClass = Class;
    P.Velocity = StartVelocity;
    P.Instigator = Instigator;
    P.SetPickupMesh(DroppedPickupMesh);
    P.SetPickupParticles(DroppedPickupParticles);
    Instigator = none;
    GotoState('None');
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    if (ItemClass == Class)
    {
        return true;
    }
    return false;
}

function ItemRemovedFromInvManager()
{
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    SetOwner(NewOwner);
    Instigator = NewOwner;
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ string(NewOwner) @ "Weapon:" @ string(self), 'Inventory');
    if (NewOwner != none && NewOwner.Controller != none)
    {
        NewOwner.Controller.NotifyAddInventory(self);
    }
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ string(thisPawn) @ "Weapon:" @ string(self), 'Inventory');
    Instigator = thisPawn;
    ClientGivenTo(thisPawn, bDoNotActivate);
}

function AnnouncePickup(Pawn Other)
{
    Other.HandlePickup(self);
    if (PickupSound != none)
    {
        Other.PlaySound(PickupSound);
    }
}

final function GiveTo(Pawn Other)
{
    if (Other != none && Other.InvManager != none)
    {
        Other.InvManager.AddInventory(self);
    }
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
    return 0.0;
}

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
    local Inventory AlreadyHas;
    local float desire;
    
    desire = default.MaxDesireability;
    if (default.RespawnTime < float(10))
    {
        AlreadyHas = P.FindInventoryType(default.Class);
        if (AlreadyHas != none)
        {
            return -1.0;
        }
    }
    return desire;
}

event Destroyed()
{
    if (Pawn(Owner) != none && Pawn(Owner).InvManager != none)
    {
        Pawn(Owner).InvManager.RemoveFromInventory(self);
    }
}

simulated function string GetHumanReadableName()
{
    return default.ItemName;
}

simulated function ActiveRenderOverlays(HUD H)
{
}

simulated function RenderOverlays(HUD H)
{
}

defaultproperties
{
    MaxDesireability=0.1
    PickupMessage="Snagged an item."
    DroppedPickupClass="DroppedPickup"
    bHidden=True
    bOnlyRelevantToOwner=True
    bReplicateMovement=False
    bOnlyDirtyReplication=True
    Components(0)="Default__Inventory.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    NetPriority=1.4
}
