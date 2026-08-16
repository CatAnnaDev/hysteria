class AliceInventoryManager extends AliceGameInventoryManager
    notplaceable
    hidecategories(Navigation);

struct native AmmoStore
{
    var int Amount;
    var class<AliceGameWeapon> WeaponClass;
};

var bool bInfiniteAmmo;
var array<AmmoStore> AmmoStorage;
var array<Actor> MemoryFragmentArray;

function PassingComboInfomation(Weapon PreviousWeapon, Weapon NewWeapon)
{
    local WeaponForAliceMelee PreMeleeWeapon, NewMeleeWeapon;
    local WeaponForAliceRange PreRangeWeapon, NewRangeWeapon;
    
    PreMeleeWeapon = WeaponForAliceMelee(PreviousWeapon);
    PreRangeWeapon = WeaponForAliceRange(PreviousWeapon);
    NewMeleeWeapon = WeaponForAliceMelee(NewWeapon);
    NewRangeWeapon = WeaponForAliceRange(NewWeapon);
    if (PreviousWeapon != none && NewWeapon != none)
    {
        if (PreMeleeWeapon != none && NewMeleeWeapon != none)
        {
            if (PreMeleeWeapon.CurrentComboState >= 1 && int(PreMeleeWeapon.CurrentComboState) <= PreMeleeWeapon.ComboMaxIndex)
            {
                NewMeleeWeapon.CurrentComboState = byte(NewMeleeWeapon.ComboMaxIndex);
                NewMeleeWeapon.FlagComboFromOtherWeapon = true;
            }
            PreMeleeWeapon.CurrentComboState = 0;
        }
        else if (PreMeleeWeapon != none && NewRangeWeapon != none)
        {
            PreMeleeWeapon.CurrentComboState = 0;
            NewRangeWeapon.FlagComboFromOtherWeapon = true;
        }
        else if (PreRangeWeapon != none && NewMeleeWeapon != none)
        {
            NewMeleeWeapon.CurrentComboState = 0;
            NewMeleeWeapon.FlagComboFromOtherWeapon = false;
        }
        else if (PreRangeWeapon != none && NewRangeWeapon != none)
        {
            NewMeleeWeapon.FlagComboFromOtherWeapon = false;
        }
    }
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W;
    
    foreach InventoryActors(class'Engine.Weapon', W)
    {
        if (VorpalBlade(W) != none)
        {
            return W;
        }
    }
    return GetBestWeapon(bForceADifferentWeapon);
}

simulated function GetWeaponList(out array<AliceGameWeapon> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local AliceGameWeapon Weap;
    local int I;
    
    foreach InventoryActors(class'AliceGameWeapon', Weap)
    {
        if ((!bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo())
        {
            if (WeaponList.Length > 0)
            {
                for (I = 0; I < WeaponList.Length; I++)
                {
                    if (WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        break;
                    }
                }
                if (I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                continue;
            }
            WeaponList.Length = 1;
            WeaponList[0] = Weap;
        }
    }
}

function Inventory HasInventoryOfClass(class<Inventory> InvClass)
{
    local Inventory Inv;
    
    Inv = InventoryChain;
    while (Inv != none)
    {
        if (Inv.Class == InvClass)
        {
            return Inv;
        }
        Inv = Inv.Inventory;
    }
    return none;
}

function AddAmmoToWeapon(int AmountToAdd, class<AliceGameWeapon> WeaponClassToAddTo)
{
    local array<AliceGameWeapon> WeaponList;
    local int I;
    
    GetWeaponList(WeaponList);
    for (I = 0; I < WeaponList.Length; I++)
    {
        if (ClassIsChildOf(WeaponList[I].Class, WeaponClassToAddTo))
        {
            WeaponList[I].AddAmmo(AmountToAdd);
            return;
        }
    }
    for (I = 0; I < AmmoStorage.Length; I++)
    {
        if (AmmoStorage[I].WeaponClass == WeaponClassToAddTo)
        {
            AmmoStorage[I].Amount += AmountToAdd;
            return;
        }
    }
    I = AmmoStorage.Length;
    AmmoStorage.Length = AmmoStorage.Length + 1;
    AmmoStorage[I].Amount = AmountToAdd;
    AmmoStorage[I].WeaponClass = WeaponClassToAddTo;
}

function bool NeedsAmmo(class<AliceGameWeapon> TestWeapon)
{
    local array<AliceGameWeapon> WeaponList;
    local int I;
    
    GetWeaponList(WeaponList);
    for (I = 0; I < WeaponList.Length; I++)
    {
        if (WeaponList[I].Class == TestWeapon)
        {
            if (WeaponList[I].AmmoCount < WeaponList[I].MaxAmmoCount)
            {
                return true;
                continue;
            }
            return false;
        }
    }
    for (I = 0; I < AmmoStorage.Length; I++)
    {
        if (AmmoStorage[I].WeaponClass == TestWeapon)
        {
            if (AmmoStorage[I].Amount < TestWeapon.default.default.MaxAmmoCount)
            {
                return true;
                continue;
            }
            return false;
        }
    }
    return true;
}

function bool CheckWeaponUpgrade(int PickedWeaponLevel, int PickedUpgradeLevel, class<Inventory> InvClass)
{
    local VorpalBlade CurrentVorpalBlade;
    local TeapotCannon CurrentTeapotCannon;
    
    CurrentVorpalBlade = VorpalBlade(HasInventoryOfClass(class'VorpalBlade'));
    if (CurrentVorpalBlade != none && InvClass == class'VorpalBlade')
    {
        if (CurrentVorpalBlade.WeaponLevel == PickedWeaponLevel)
        {
            CurrentVorpalBlade.ChangeLevel(PickedUpgradeLevel);
            CurrentVorpalBlade.AnnounceWeaponUpgrade(PickedWeaponLevel, PickedUpgradeLevel);
            return true;
        }
    }
    CurrentTeapotCannon = TeapotCannon(HasInventoryOfClass(class'TeapotCannon'));
    if (CurrentTeapotCannon != none && InvClass == class'TeapotCannon')
    {
        if (CurrentTeapotCannon.WeaponLevel == PickedWeaponLevel)
        {
            CurrentTeapotCannon.ChangeLevel(PickedUpgradeLevel);
            CurrentTeapotCannon.AnnounceWeaponUpgrade(PickedWeaponLevel, PickedUpgradeLevel);
            return true;
        }
    }
    return false;
}

function int GetMemoryFragmentCount()
{
    return MemoryFragmentArray.Length;
}

function AddMemoryFragment(MemoryFragmentNormal MF)
{
    local string MemoryName;
    
    MemoryFragmentArray.AddItem(MF);
    if (!MF.IsA('SecretPickup') && !MF.IsA('BigSecretPickup'))
    {
        AliceGameInfo(WorldInfo.Game).ShowPickupMemoryFragmentTip(GetMemoryFragmentCount(), int(MF.MemoryFragmentType));
    }
    MemoryName = MF.MemoryName;
    AliceGameInfo(WorldInfo.Game).MemoriesCollected.AddItem(MemoryName);
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    if (AddInventory(NewItem, bDoNotActivate))
    {
        return true;
    }
    return false;
}

defaultproperties
{
    PendingFire(0)=0
    PendingFire(1)=0
    PendingFire(2)=0
    PendingFire(3)=0
    PendingFire(4)=0
    PendingFire(5)=0
}
