class PickupFactory extends NavigationPoint
    abstract
    native
    nativereplication
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var bool bOnlyReplicateHidden;
var repnotify bool bPickupHidden;
var bool bPredictRespawns;
var bool bIsSuperItem;
var bool bRespawnPaused;
var repnotify class<Inventory> InventoryType;
var float RespawnEffectTime;
var float MaxDesireability;
var transient export editinline PrimitiveComponent PickupMesh;
var PickupFactory ReplacementFactory;
var PickupFactory OriginalFactory;

replication
{
    if (bNetDirty && Role == 3)
        bPickupHidden;
    if (bNetInitial && Role == 3)
        InventoryType;
}

function bool DelayRespawn()
{
    return false;
}

event Destroyed()
{
    if (OriginalFactory != none)
    {
        OriginalFactory.ReplacementFactory = ReplacementFactory;
    }
    if (ReplacementFactory != none)
    {
        ReplacementFactory.OriginalFactory = OriginalFactory;
    }
}

simulated function SetPickupVisible()
{
    bForceNetUpdate = true;
    bPickupHidden = false;
    if (PickupMesh != none)
    {
        PickupMesh.SetHidden(false);
    }
}

simulated function SetPickupHidden()
{
    bForceNetUpdate = true;
    bPickupHidden = true;
    if (PickupMesh != none)
    {
        PickupMesh.SetHidden(true);
    }
}

function RespawnEffect()
{
}

function float GetRespawnTime()
{
    return InventoryType.default.default.RespawnTime;
}

function RecheckValidTouch()
{
}

function PickedUpBy(Pawn P)
{
    SetRespawn();
    TriggerEventClass(class'SeqEvent_PickupStatusChange', P, 1);
    if (P.Controller != none && P.Controller.MoveTarget == self)
    {
        P.SetAnchor(self);
        P.Controller.MoveTimer = -1.0;
    }
}

function GiveTo(Pawn P)
{
    SpawnCopyFor(P);
    PickedUpBy(P);
}

function bool ReadyToPickup(float MaxWait)
{
    return false;
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;
    
    Inv = Spawn(InventoryType);
    if (Inv != none)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
    }
}

event float DetourWeight(Pawn Other, float PathWeight)
{
    return ReplacementFactory != none ? ReplacementFactory.DetourWeight(Other, PathWeight) : 0.0;
}

function StartSleeping()
{
    GotoState('Sleeping');
}

function SetRespawn()
{
    if (InventoryType.default.default.RespawnTime != float(0) && WorldInfo.Game.ShouldRespawn(self))
    {
        StartSleeping();
    }
    else
    {
        GotoState('Disabled');
    }
}

function bool CheckForErrors()
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    
    HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0, 0.0, 10.0), Location, false);
    if (HitActor == none)
    {
        LogInternal(string(self) $ " FLOATING");
        return true;
    }
    return CheckForErrors();
}

function Reset()
{
    if (bIsSuperItem)
    {
        GotoState('Sleeping');
    }
    else
    {
        GotoState('Pickup');
    }
    Reset();
}

static function StaticPrecache(WorldInfo W)
{
}

simulated function SetPickupMesh()
{
    if (InventoryType.default.default.PickupFactoryMesh != none)
    {
        if (PickupMesh != none)
        {
            DetachComponent(PickupMesh);
            PickupMesh = none;
        }
        PickupMesh = new(self) InventoryType.default.default.PickupFactoryMesh.Class(InventoryType.default.default.PickupFactoryMesh);
        AttachComponent(PickupMesh);
        if (bPickupHidden)
        {
            SetPickupHidden();
        }
        else
        {
            SetPickupVisible();
        }
    }
}

simulated function ShutDown()
{
    GotoState('Disabled');
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    if (InventoryType == none)
    {
        WarnInternal("Disabling as no inventory type for " $ string(self));
        GotoState('Disabled');
    }
    else if (bIsSuperItem)
    {
        GotoState('WaitingForMatch');
    }
    else
    {
        SetInitialState();
    }
}

simulated function InitializePickup()
{
    if (InventoryType == none)
    {
        WarnInternal("No inventory type for" @ string(self));
        return;
    }
    bPredictRespawns = InventoryType.default.default.bPredictRespawns;
    MaxDesireability = InventoryType.default.default.MaxDesireability;
    SetPickupMesh();
    bIsSuperItem = InventoryType.default.default.bDelayedSpawn;
}

simulated event PreBeginPlay()
{
    InitializePickup();
    PreBeginPlay();
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bPickupHidden')
    {
        if (bPickupHidden)
        {
            SetPickupHidden();
        }
        else
        {
            SetPickupVisible();
        }
    }
    else if (VarName == 'InventoryType')
    {
        InitializePickup();
    }
}

state Disabled
{
    simulated event EndState(name NextStateName)
    {
        SetPickupVisible();
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        SetPickupHidden();
        SetCollision(false, false);
    }
    
    simulated event SetInitialState()
    {
        bScriptInitialized = true;
    }
    
    function StartSleeping()
    {
    }
    
    function Reset()
    {
    }
    
    function bool ReadyToPickup(float MaxWait)
    {
        return false;
    }
    
    Stop;
}

state Sleeping
{
    event EndState(name NextStateName)
    {
        SetPickupVisible();
    }
    
    event BeginState(name PreviousStateName)
    {
        SetPickupHidden();
    }
    
    function StartSleeping()
    {
    }
    
    function bool ReadyToPickup(float MaxWait)
    {
        return bPredictRespawns && !bRespawnPaused && LatentFloat <= MaxWait && LatentFloat > 0.0;
    }
    
    function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
    }
    
    Begin:
    bRespawnPaused = true;
    while (DelayRespawn())
    {
        Sleep(1.0);
    }
    bRespawnPaused = false;
    Sleep(GetRespawnTime() - RespawnEffectTime);
    Respawn:
    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('Pickup');
    Stop;
}

state WaitingForMatch
{
    event BeginState(name PreviousStateName)
    {
        SetPickupHidden();
    }
    
    function MatchStarting()
    {
        GotoState('Sleeping');
    }
    
    function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
    }
    
    Stop;
}

auto state Pickup
{
    event BeginState(name PreviousStateName)
    {
        TriggerEventClass(class'SeqEvent_PickupStatusChange', none, 0);
    }
    
    function CheckTouching()
    {
        local Pawn P;
        
        foreach TouchingActors(class'Pawn', P)
        {
            Touch(P, none, Location, Normal(Location - P.Location));
        }
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
        if (Other == none || !Other.bCanPickupInventory)
        {
            return false;
        }
        else if (Other.Controller == none)
        {
            SetTimer(0.2, false, 'RecheckValidTouch');
            return false;
        }
        else if (!FastTrace(Other.Location, Location))
        {
            SetTimer(0.5, false, 'RecheckValidTouch');
            return false;
        }
        if (WorldInfo.Game.PickupQuery(Other, InventoryType, self))
        {
            return true;
        }
        return false;
    }
    
    function bool ReadyToPickup(float MaxWait)
    {
        return true;
    }
    
    event float DetourWeight(Pawn Other, float PathWeight)
    {
        return InventoryType.static.DetourWeight(Other, PathWeight);
    }
    
    Begin:
    CheckTouching();
    Stop;
}

defaultproperties
{
    bOnlyReplicateHidden=True
    CylinderComponent="Default__PickupFactory.CollisionCylinder"
    GoodSprite="Default__PickupFactory.Sprite"
    BadSprite="Default__PickupFactory.Sprite2"
    bStatic=False
    bIgnoreEncroachers=True
    bAlwaysRelevant=True
    bCollideWhenPlacing=False
    bCollideActors=True
    Components(0)="Default__PickupFactory.Sprite"
    Components(1)="Default__PickupFactory.Sprite2"
    Components(2)="Default__PickupFactory.Arrow"
    Components(3)="Default__PickupFactory.CollisionCylinder"
    Components(4)="Default__PickupFactory.PathRenderer"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_TouchAll"
    TickGroup="TG_DuringAsyncWork"
    NetUpdateFrequency=1.0
    CollisionComponent="Default__PickupFactory.CollisionCylinder"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_PickupStatusChange"
}
