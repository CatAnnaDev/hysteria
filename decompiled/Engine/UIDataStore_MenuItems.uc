class UIDataStore_MenuItems extends UIDataStore_GameResource
    native
    notplaceable
    transient
    config(UI)
    hidecategories(Object,UIRoot);

var const name CurrentGameSettingsTag;
var const native transient MultiMap_Mirror OptionProviders;
var transient array<UIDataProvider_MenuItem> DynamicProviders;

event Unregistered(LocalPlayer PlayerOwner)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    Unregistered(PlayerOwner);
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlineGameSettings'.default.default.Tag));
    if (GameSettingsDataStore != none)
    {
        GameSettingsDataStore.RemovePropertyNotificationChangeRequest(OnGameSettingsChanged);
    }
}

event Registered(LocalPlayer PlayerOwner)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    Registered(PlayerOwner);
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlineGameSettings'.default.default.Tag));
    if (GameSettingsDataStore != none)
    {
        GameSettingsDataStore.AddPropertyNotificationChangeRequest(OnGameSettingsChanged);
    }
}

function OnGameSettingsChanged(UIDataProvider SourceProvider, optional name PropTag)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(SourceProvider);
    if (GameSettingsDataStore != none && PropTag == 'SelectedIndex')
    {
        RefreshSubscribers(CurrentGameSettingsTag, true, self);
    }
}

native function GetSet(name SetName, out array<UIDataProvider_MenuItem> OutProviders)
{
    SetName;
    OutProviders;
}

native function AppendToSet(name SetName, int NumOptions)
{
    SetName;
    NumOptions;
}

native function ClearSet(name SetName)
{
    SetName;
}

defaultproperties
{
    CurrentGameSettingsTag="CurrentGameSettings"
    Tag="MenuItems"
}
