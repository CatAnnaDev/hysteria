class PlayerOwnerDataStore extends UIDataStore_GameState
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

struct native PlayerDataProviderTypes
{
    var const class<PlayerOwnerDataProvider> PlayerOwnerDataProviderClass;
    var const class<CurrentWeaponDataProvider> CurrentWeaponDataProviderClass;
    var const class<WeaponDataProvider> WeaponDataProviderClass;
    var const class<PowerupDataProvider> PowerupDataProviderClass;
};

var const PlayerDataProviderTypes ProviderTypes;
var PlayerOwnerDataProvider PlayerData;
var CurrentWeaponDataProvider CurrentWeapon;
var array<WeaponDataProvider> WeaponList;
var array<PowerupDataProvider> PowerupList;

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return NotifyGameSessionEnded();
}

final function ClearDataProviders()
{
    local int I;
    
    LogInternal(">>" @ "(" $ string(Name) $ ") PlayerOwnerDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
    if (PlayerData != none)
    {
        PlayerData.CleanupDataProvider();
    }
    if (CurrentWeapon != none)
    {
        CurrentWeapon.CleanupDataProvider();
    }
    for (I = 0; I < WeaponList.Length; I++)
    {
        WeaponList[I].CleanupDataProvider();
    }
    for (I = 0; I < PowerupList.Length; I++)
    {
        PowerupList[I].CleanupDataProvider();
    }
    PlayerData = none;
    CurrentWeapon = none;
    WeaponList.Length = 0;
    PowerupList.Length = 0;
    LogInternal("<<" @ "(" $ string(Name) $ ") PlayerOwnerDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
}

function SetPlayerDataProvider(PlayerDataProvider NewPlayerData)
{
    LogInternal(">>" @ "(" $ string(Name) $ ") PlayerOwnerDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
    if (NewPlayerData != none)
    {
        LogInternal("(" $ string(Name) $ ") PlayerOwnerDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "creating new PlayerOwnerDataProvider for" @ string(NewPlayerData) @ "and linking to 'PlayerOwner' data store" @ string(self), 'DevDataStore');
        if (PlayerData != none)
        {
            PlayerData.CleanupDataProvider();
        }
        PlayerData = new ProviderTypes.PlayerOwnerDataProviderClass;
    }
    if (PlayerData != none)
    {
        PlayerData.SetPlayerDataProvider(NewPlayerData);
        RefreshSubscribers();
    }
    LogInternal("<<" @ "(" $ string(Name) $ ") PlayerOwnerDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
}

defaultproperties
{
    ProviderTypes=(PlayerOwnerDataProviderClass="PlayerOwnerDataProvider",CurrentWeaponDataProviderClass="CurrentWeaponDataProvider",WeaponDataProviderClass="WeaponDataProvider",PowerupDataProviderClass="PowerupDataProvider")
    Tag="PlayerOwner"
}
