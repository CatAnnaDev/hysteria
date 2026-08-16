class DroppedPickup extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var Inventory Inventory;
var repnotify class<Inventory> InventoryClass;
var NavigationPoint PickupCache;
var repnotify bool bFadeOut;

replication
{
    if (Role == 3)
        InventoryClass, bFadeOut;
}

function RecheckValidTouch()
{
}

function PickedUpBy(Pawn P)
{
    Destroy();
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

event Landed(Vector HitNormal, Actor FloorActor)
{
    bForceNetUpdate = true;
    bNetDirty = true;
    NetUpdateFrequency = 3.0;
    AddToNavigation();
}

function float DetourWeight(Pawn Other, float PathWeight)
{
    return Inventory.DetourWeight(Other, PathWeight);
}

event EncroachedBy(Actor Other)
{
    Destroy();
}

simulated event SetPickupParticles(ParticleSystemComponent PickupParticles)
{
    local ParticleSystemComponent Comp;
    
    if (PickupParticles != none && WorldInfo.NetMode != 1)
    {
        Comp = new(self) PickupParticles.Class(PickupParticles);
        AttachComponent(Comp);
        Comp.SetActive(true);
    }
}

simulated event SetPickupMesh(PrimitiveComponent PickupMesh)
{
    local ActorComponent Comp;
    
    if (PickupMesh != none && WorldInfo.NetMode != 1)
    {
        Comp = new(self) PickupMesh.Class(PickupMesh);
        AttachComponent(Comp);
    }
}

function Reset()
{
    Destroy();
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'InventoryClass')
    {
        SetPickupMesh(InventoryClass.default.default.DroppedPickupMesh);
        SetPickupParticles(InventoryClass.default.default.DroppedPickupParticles);
    }
    else if (VarName == 'bFadeOut')
    {
        GotoState('FadeOut');
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

event Destroyed()
{
    if (Inventory != none)
    {
        Inventory.Destroy();
    }
}

native final function RemoveFromNavigation()
{
}

native final function AddToNavigation()
{
}

state FadeOut extends Pickup
{
    simulated event BeginState(name PreviousStateName)
    {
        bFadeOut = true;
        RotationRate.Yaw = 60000;
        SetPhysics(5);
        LifeSpan = 1.0;
    }
    
    Stop;
}

auto state Pickup
{
    event EndState(name NextStateName)
    {
        RemoveFromNavigation();
    }
    
    event BeginState(name PreviousStateName)
    {
        AddToNavigation();
    }
    
    function CheckTouching()
    {
        local Pawn P;
        
        foreach TouchingActors(class'Pawn', P)
        {
            Touch(P, none, Location, vect(0.0, 0.0, 1.0));
        }
    }
    
    event Timer()
    {
        GotoState('FadeOut');
    }
    
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;
        
        P = Pawn(Other);
        if (P != none && ValidTouch(P))
        {
            GiveTo(P);
        }
    }
    
    function RecheckValidTouch()
    {
        CheckTouching();
    }
    
    function bool ValidTouch(Pawn Other)
    {
        if (Other == none || !Other.bCanPickupInventory || Other.DrivenVehicle == none && Other.Controller == none)
        {
            return false;
        }
        if (Physics == 2 && Other == Instigator && Velocity.Z > float(0))
        {
            return false;
        }
        if (!FastTrace(Other.Location, Location))
        {
            SetTimer(0.5, false, 'RecheckValidTouch');
            return false;
        }
        if (WorldInfo.Game.PickupQuery(Other, Inventory.Class, self))
        {
            return true;
        }
        return false;
    }
    
    Begin:
    CheckTouching();
    Stop;
}

defaultproperties
{
    bIgnoreRigidBodyPawns=True
    bOrientOnSlope=True
    bUpdateSimulatedPosition=True
    bOnlyDirtyReplication=True
    bShouldBaseAtStartup=True
    bCollideActors=True
    bCollideWorld=True
    Components(0)="Default__DroppedPickup.Sprite"
    Components(1)="Default__DroppedPickup.CollisionCylinder"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=8.0
    NetPriority=1.4
    CollisionComponent="Default__DroppedPickup.CollisionCylinder"
    RotationRate=(Pitch=0,Yaw=5000,Roll=0)
}
