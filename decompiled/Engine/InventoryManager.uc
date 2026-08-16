class InventoryManager extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var repretry Inventory InventoryChain;
var Weapon PendingWeapon;
var Weapon LastAttemptedSwitchToWeapon;
var bool bMustHoldWeapon;
var array<int> PendingFire;

replication
{
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == 3 && bNetDirty && bNetOwner)
        InventoryChain;
}

simulated function UpdateController()
{
    local Inventory Item;
    local Weapon Weap;
    
    Item = InventoryChain;
    while (Item != none)
    {
        Weap = Weapon(Item);
        if (Weap != none)
        {
            Weap.CacheAIController();
        }
        Item = Item.Inventory;
    }
}

reliable client simulated function ClientSyncWeapon(Weapon NewWeapon)
{
    local Weapon OldWeapon;
    
    if (NewWeapon == Instigator.Weapon)
    {
        LogInternal(string(self) @ "(Owned by" @ string(Owner) @ ") is trying to Sync to the currently active weapon (" $ string(NewWeapon) $ ")");
        return;
    }
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Forcing weapon:" @ string(NewWeapon) @ "from:" @ string(Instigator.Weapon), 'Inventory');
    OldWeapon = Instigator.Weapon;
    Instigator.Weapon = NewWeapon;
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, NewWeapon);
    if (NewWeapon != none)
    {
        Instigator.Weapon.Instigator = Instigator;
        if (WorldInfo.Game != none)
        {
            Instigator.MakeNoise(0.1, 'ChangedWeapon');
        }
        Instigator.Weapon.Activate();
    }
    if (Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
    local Weapon OldWeapon;
    
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "NewWeapon:" @ string(NewWeapon) @ "bOptionalSet:" @ string(bOptionalSet) @ "bDoNotActivate:" @ string(bDoNotActivate), 'Inventory');
    if (!bDoNotActivate)
    {
        OldWeapon = Instigator.Weapon;
        if (OldWeapon == none || OldWeapon.bDeleteMe || OldWeapon.IsInState('Inactive'))
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "OldWeapon == None or Inactive - Set new weapon right away" @ string(NewWeapon), 'Inventory');
            SetCurrentWeapon(NewWeapon);
            return;
        }
        if (OldWeapon == NewWeapon)
        {
            if (NewWeapon.IsInState('PendingClientWeaponSet'))
            {
                LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "OldWeapon == NewWeapon - but in PendingClientWeaponSet, so reset." @ string(NewWeapon), 'Inventory');
                SetCurrentWeapon(NewWeapon);
            }
            else
            {
                LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "OldWeapon == NewWeapon - abort" @ string(NewWeapon), 'Inventory');
            }
            return;
        }
        if (bOptionalSet)
        {
            if (OldWeapon.DenyClientWeaponSet() || Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
            {
                LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "bOptionalSet && (DenyClientWeaponSet() || bNeverSwitchOnPickup) - abort" @ string(NewWeapon), 'Inventory');
                LastAttemptedSwitchToWeapon = NewWeapon;
                return;
            }
        }
        if (PendingWeapon == none || !PendingWeapon.HasAnyAmmo() || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            if (!Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
            {
                LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Switch to new weapon:" @ string(NewWeapon), 'Inventory');
                SetCurrentWeapon(NewWeapon);
                return;
            }
        }
    }
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Send to inactive state" @ string(NewWeapon), 'Inventory');
    NewWeapon.GotoState('Inactive');
}

function PassingComboInfomation(Weapon PreviousWeapon, Weapon NewWeapon)
{
}

simulated function ChangedWeapon()
{
    local Weapon OldWeapon;
    
    OldWeapon = Instigator.Weapon;
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "PendingWeapon:'" $ string(PendingWeapon) $ "'" @ "bMustHoldWeapon:'" $ string(bMustHoldWeapon) $ "'", 'Inventory');
    if (PendingWeapon == none && bMustHoldWeapon)
    {
        if (OldWeapon != none)
        {
            OldWeapon.Activate();
            PendingWeapon = OldWeapon;
        }
    }
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "switch from" @ string(OldWeapon) @ "to" @ string(PendingWeapon), 'Inventory');
    Instigator.Weapon = PendingWeapon;
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, PendingWeapon);
    if (PendingWeapon != none)
    {
        PendingWeapon.Instigator = Instigator;
        if (WorldInfo.Game != none)
        {
            Instigator.MakeNoise(0.1, 'ChangedWeapon');
        }
        PendingWeapon.Activate();
        PendingWeapon = none;
    }
    if (Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
}

simulated function ClearPendingWeapon()
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "PendingWeapon:'" $ string(PendingWeapon) $ "'", 'Inventory');
    if (PendingWeapon != none)
    {
        PendingWeapon.GotoState('Inactive');
        PendingWeapon = none;
    }
}

simulated function bool CancelWeaponChange()
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "PendingWeapon:'" $ string(PendingWeapon) $ "'", 'Inventory');
    if (PendingWeapon == none && bMustHoldWeapon)
    {
        PendingWeapon = Instigator.Weapon;
    }
    return false;
}

simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "SetPendingWeapon to" @ string(DesiredWeapon), 'Inventory');
    PendingWeapon = DesiredWeapon;
}

private final simulated function InternalSetCurrentWeapon(Weapon DesiredWeapon)
{
    Instigator.PrevWeapon = Instigator.Weapon;
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "PrevWeapon:" @ string(Instigator.PrevWeapon) @ "DesiredWeapon:" @ string(DesiredWeapon), 'Inventory');
    if (Instigator.PrevWeapon != none && DesiredWeapon == Instigator.PrevWeapon && !Instigator.PrevWeapon.IsInState('WeaponPuttingDown'))
    {
        if (!DesiredWeapon.IsInState('Inactive') && !DesiredWeapon.IsInState('PendingClientWeaponSet'))
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "DesiredWeapon == PrevWeapon - abort" @ string(DesiredWeapon.GetStateName()), 'Inventory');
            return;
        }
    }
    SetPendingWeapon(DesiredWeapon);
    PassingComboInfomation(Instigator.PrevWeapon, DesiredWeapon);
    if (Instigator.PrevWeapon != none && Instigator.PrevWeapon != DesiredWeapon && !Instigator.PrevWeapon.bDeleteMe && !Instigator.PrevWeapon.IsInState('Inactive'))
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Try to put down previous weapon first.", 'Inventory');
        Instigator.PrevWeapon.TryPutDown();
    }
    else
    {
        ChangedWeapon();
    }
}

reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
    InternalSetCurrentWeapon(DesiredWeapon);
}

reliable client simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
    InternalSetCurrentWeapon(DesiredWeapon);
    if (Role < 3)
    {
        ServerSetCurrentWeapon(DesiredWeapon);
    }
}

simulated function NextWeapon()
{
    local Weapon StartWeapon, CandidateWeapon, W;
    local bool bBreakNext;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(class'Weapon', W)
    {
        if (bBreakNext || StartWeapon == none)
        {
            CandidateWeapon = W;
            break;
        }
        if (W == StartWeapon)
        {
            bBreakNext = true;
        }
    }
    if (CandidateWeapon == none)
    {
        foreach InventoryActors(class'Weapon', W)
        {
            CandidateWeapon = W;
            break;
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}

simulated function PrevWeapon()
{
    local Weapon CandidateWeapon, StartWeapon, W;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != none)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(class'Weapon', W)
    {
        if (W == StartWeapon)
        {
            break;
        }
        CandidateWeapon = W;
    }
    if (CandidateWeapon == none)
    {
        foreach InventoryActors(class'Weapon', W)
        {
            CandidateWeapon = W;
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon BestWeapon;
    
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "bForceADifferentWeapon:" @ string(bForceADifferentWeapon), 'Inventory');
    if (bForceADifferentWeapon || PendingWeapon == none || AIController(Instigator.Controller) != none)
    {
        BestWeapon = GetBestWeapon(bForceADifferentWeapon);
        if (BestWeapon == none)
        {
            return;
        }
        if (BestWeapon == Instigator.Weapon)
        {
            BestWeapon = none;
            PendingWeapon = none;
            Instigator.Weapon.Activate();
        }
    }
    Instigator.Controller.StopFiring();
    SetCurrentWeapon(BestWeapon);
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W, BestWeapon;
    local float Rating, BestRating;
    
    foreach InventoryActors(class'Weapon', W)
    {
        if (W.HasAnyAmmo())
        {
            if (bForceADifferentWeapon && IsActiveWeapon(W))
            {
                break;
            }
            Rating = W.GetWeaponRating();
            if (BestWeapon == none || Rating > BestRating)
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }
    }
    return BestWeapon;
}

simulated function float GetWeaponRatingFor(Weapon W)
{
    local float Rating;
    
    if (!W.HasAnyAmmo())
    {
        return -1.0;
    }
    if (!Instigator.IsHumanControlled())
    {
        Rating = W.GetAIRating();
        if (IsActiveWeapon(W) && Instigator.Controller != none && Instigator.Controller.Enemy != none)
        {
            Rating += 0.21;
        }
    }
    else
    {
        Rating = 1.0;
    }
    return Rating;
}

simulated function bool IsActiveWeapon(Weapon ThisWeapon)
{
    return ThisWeapon == Instigator.Weapon;
}

simulated function StopFire(byte FireModeNum)
{
    if (Instigator.Weapon != none)
    {
        Instigator.Weapon.StopFire(FireModeNum);
    }
}

simulated function StartFire(byte FireModeNum)
{
    if (Instigator.Weapon != none)
    {
        Instigator.Weapon.StartFire(FireModeNum);
    }
    else
    {
        SwitchToBestWeapon();
        if (Instigator.Weapon != none)
        {
            Instigator.Weapon.StartFire(FireModeNum);
        }
    }
}

simulated function DrawHUD(HUD H)
{
    local Inventory Inv;
    
    foreach InventoryActors(class'Inventory', Inv)
    {
        if (Inv.bRenderOverlays)
        {
            Inv.RenderOverlays(H);
        }
    }
    if (Instigator.Weapon != none)
    {
        Instigator.Weapon.ActiveRenderOverlays(H);
    }
}

simulated function OwnerEvent(name EventName)
{
    local Inventory Inv;
    
    foreach InventoryActors(class'Inventory', Inv)
    {
        if (Inv.bReceiveOwnerEvents)
        {
            Inv.OwnerEvent(EventName);
        }
    }
}

function OwnerDied()
{
    OwnerEvent('Died');
    Destroy();
    if (Instigator.InvManager == self)
    {
        Instigator.InvManager = none;
    }
}

function int ModifyDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType)
{
    return Damage;
}

simulated event DiscardInventory()
{
    local Inventory Inv;
    local Vector TossVelocity;
    local bool bBelowKillZ;
    
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
    bBelowKillZ = Instigator == none || Instigator.Location.Z < WorldInfo.KillZ;
    foreach InventoryActors(class'Inventory', Inv)
    {
        if (Inv.bDropOnDeath && !bBelowKillZ)
        {
            TossVelocity = vector(Instigator.GetViewRotation());
            TossVelocity = TossVelocity * (Instigator.Velocity Dot TossVelocity + 500.0) + 250.0 * VRand() + vect(0.0, 0.0, 250.0);
            Inv.DropFrom(Instigator.Location, TossVelocity);
            continue;
        }
        Inv.Destroy();
    }
    Instigator.Weapon = none;
    PendingWeapon = none;
}

simulated function RemoveClassFromInventory(class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    local Inventory Inv;
    
    Inv = FindInventoryType(DesiredClass, bAllowSubclass);
    while (Inv != none)
    {
        RemoveFromInventory(Inv);
        Inv = FindInventoryType(DesiredClass, bAllowSubclass);
    }
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    local Inventory Item;
    local bool bFound;
    
    if (ItemToRemove != none)
    {
        if (InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;
        }
        else
        {
            Item = InventoryChain;
            while (Item != none)
            {
                if (Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    break;
                }
                Item = Item.Inventory;
            }
        }
        if (bFound)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "removed" @ string(ItemToRemove), 'Inventory');
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
        }
        if (ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = none;
        }
        if (Instigator.Health > 0 && Instigator.Weapon == none && Instigator.Controller != none)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Calling ClientSwitchToBestWeapon", 'Inventory');
            Instigator.Controller.ClientSwitchToBestWeapon(true);
        }
    }
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local Inventory Item, LastItem;
    
    if (NewItem != none && !NewItem.bDeleteMe)
    {
        if (InventoryChain == none)
        {
            InventoryChain = NewItem;
        }
        else
        {
            Item = InventoryChain;
            while (Item != none)
            {
                if (Item == NewItem)
                {
                    return false;
                }
                LastItem = Item;
                Item = Item.Inventory;
            }
            LastItem.Inventory = NewItem;
        }
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "adding" @ string(NewItem) @ "bDoNotActivate:" @ string(bDoNotActivate), 'Inventory');
        NewItem.SetOwner(Instigator);
        NewItem.Instigator = Instigator;
        NewItem.InvManager = self;
        NewItem.GivenTo(Instigator, bDoNotActivate);
        Instigator.TriggerEventClass(class'SeqEvent_GetInventory', NewItem);
        return true;
    }
    return false;
}

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local Inventory Inv;
    
    if (NewInventoryItemClass != none)
    {
        Inv = Spawn(NewInventoryItemClass, Owner);
        if (Inv != none)
        {
            if (!AddInventory(Inv, bDoNotActivate))
            {
                WarnInternal("InventoryManager::CreateInventory - Couldn't Add newly created inventory" @ string(Inv));
                Inv.Destroy();
                Inv = none;
            }
        }
        else
        {
            WarnInternal("InventoryManager::CreateInventory - Couldn't spawn inventory" @ string(NewInventoryItemClass));
        }
    }
    return Inv;
}

simulated event Inventory FindInventoryType(class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    local Inventory Inv;
    
    foreach InventoryActors(DesiredClass, Inv)
    {
        if (bAllowSubclass || Inv.Class == DesiredClass)
        {
            return Inv;
        }
    }
    return none;
}

function bool HandlePickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local Inventory Inv;
    
    if (InventoryChain == none)
    {
        return true;
    }
    foreach InventoryActors(class'Inventory', Inv)
    {
        if (Inv.DenyPickupQuery(ItemClass, Pickup))
        {
            return false;
        }
    }
    return true;
}

event Destroyed()
{
    DiscardInventory();
}

function SetupFor(Pawn P)
{
    Instigator = P;
    SetOwner(P);
}

native final iterator function InventoryActors(class<Inventory> BaseClass, out Inventory Inv)
{
    BaseClass;
    Inv;
}

simulated function ClearAllPendingFire(Weapon InWeapon)
{
    local int I;
    
    for (I = 0; I < PendingFire.Length; I++)
    {
        PendingFire[I] = 0;
    }
}

simulated function bool IsPendingFire(Weapon InWeapon, int InFiringMode)
{
    return bool(PendingFire[InFiringMode]);
}

simulated function ClearPendingFire(Weapon InWeapon, int InFiringMode)
{
    if (InFiringMode < PendingFire.Length)
    {
        PendingFire[InFiringMode] = 0;
    }
}

simulated function SetPendingFire(Weapon InWeapon, int InFiringMode)
{
    if (InFiringMode < PendingFire.Length)
    {
        PendingFire[InFiringMode] = 1;
    }
}

simulated function int GetPendingFireLength(Weapon InWeapon)
{
    return PendingFire.Length;
}

event PostBeginPlay()
{
    PostBeginPlay();
    Instigator = Pawn(Owner);
}

defaultproperties
{
    bHidden=True
    bOnlyRelevantToOwner=True
    bReplicateInstigator=True
    bReplicateMovement=False
    bOnlyDirtyReplication=True
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
    NetPriority=1.4
}
