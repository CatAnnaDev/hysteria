class UIDataProvider_OnlinePlayerStorage extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot);

struct native PlayerStorageArrayProvider
{
    var int PlayerStorageId;
    var name PlayerStorageName;
    var UIDataProvider_OnlinePlayerStorageArray Provider;
};

var OnlinePlayerStorage Profile;
var const name ProviderName;
var bool bWasErrorLastRead;
var array<PlayerStorageArrayProvider> PlayerStorageArrayProviders;

function OnSettingValueUpdated(name SettingName)
{
    local int ProviderIdx;
    local UIDataProvider_OnlinePlayerStorageArray ArrayProvider;
    
    for (ProviderIdx = 0; ProviderIdx < PlayerStorageArrayProviders.Length; ProviderIdx++)
    {
        if (SettingName == PlayerStorageArrayProviders[ProviderIdx].PlayerStorageName)
        {
            ArrayProvider = PlayerStorageArrayProviders[ProviderIdx].Provider;
            ArrayProviderPropertyChanged(ArrayProvider, SettingName);
            break;
        }
    }
}

function ArrayProviderPropertyChanged(UIDataProvider SourceProvider, optional name PropTag)
{
    local int Index;
    local delegate<OnDataProviderPropertyChange> Subscriber;
    
    for (Index = 0; Index < ProviderChangedNotifies.Length; Index++)
    {
        Subscriber = ProviderChangedNotifies[Index];
        OnDataProviderPropertyChange(SourceProvider, PropTag);
    }
}

event bool SaveStorageData()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            return WriteData(PlayerInterface, byte(Player.ControllerId), Profile);
        }
    }
    return false;
}

function RefreshStorageData()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) && PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
        {
            LogInternal("Login change...requerying storage data");
            if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == false)
            {
                NotifyPropertyChanged();
            }
        }
    }
}

function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local PlayerController PC;
    local ELoginStatus LoginStatus;
    local UniqueNetId NetId;
    
    if (int(LocalUserNum) == Player.ControllerId)
    {
        if (Player != none)
        {
            PC = Player.Actor;
            OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
            if (OnlineSub != none && PC != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
                {
                    LoginStatus = PlayerInterface.GetLoginStatus(byte(Player.ControllerId));
                    PlayerInterface.GetUniquePlayerId(byte(Player.ControllerId), NetId);
                    if (LoginStatus == 0 || PC.PlayerReplicationInfo.UniqueId != NetId)
                    {
                        Profile.SetToDefaults();
                    }
                }
            }
        }
        RefreshStorageData();
    }
}

function OnReadStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (bWasSuccessful == true)
    {
        if (!bWasErrorLastRead)
        {
            NotifyPropertyChanged();
        }
        else
        {
            OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
            if (OnlineSub != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
                {
                    bWasErrorLastRead = false;
                    if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == false)
                    {
                        bWasErrorLastRead = true;
                    }
                }
            }
        }
    }
    else
    {
        bWasErrorLastRead = true;
        LogInternal("Failed to read online storage data", 'DevOnline');
    }
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local int ControllerId;
    
    if (Profile != none && Profile.__NotifySettingValueUpdated__Delegate == OnSettingValueUpdated)
    {
        Profile.__NotifySettingValueUpdated__Delegate = None;
    }
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            ControllerId = (Player != none ? Player.ControllerId : 0);
            ClearReadCompleteDelegate(PlayerInterface, byte(ControllerId));
        }
    }
    OnUnregister();
}

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnRegister(InPlayer);
    if (Player != none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
                AddReadCompleteDelegate(PlayerInterface, byte(Player.ControllerId));
                if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == false)
                {
                    bWasErrorLastRead = true;
                }
            }
        }
    }
    if (Profile != none)
    {
        Profile.__NotifySettingValueUpdated__Delegate = OnSettingValueUpdated;
    }
}

function ClearReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}

function AddReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.AddReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}

function bool WriteData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.WritePlayerStorage(LocalUserNum, PlayerStorage);
}

function bool ReadData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.ReadPlayerStorage(LocalUserNum, PlayerStorage);
}

defaultproperties
{
    ProviderName="PlayerStorageData"
    WriteAccessType="ACCESS_WriteAll"
}
