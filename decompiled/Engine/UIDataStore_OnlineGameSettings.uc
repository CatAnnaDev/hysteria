class UIDataStore_OnlineGameSettings extends UIDataStore_Settings
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

struct native GameSettingsCfg
{
    var class<OnlineGameSettings> GameSettingsClass;
    var UIDataProvider_Settings Provider;
    var OnlineGameSettings GameSettings;
    var name SettingsName;
};

var const array<GameSettingsCfg> GameSettingsCfgList;
var const class<UIDataProvider_Settings> SettingsProviderClass;
var int SelectedIndex;

event Unregistered(LocalPlayer PlayerOwner)
{
    local int CfgIndex;
    local UIDataProvider_Settings Provider;
    
    Unregistered(PlayerOwner);
    for (CfgIndex = 0; CfgIndex < GameSettingsCfgList.Length; CfgIndex++)
    {
        Provider = GameSettingsCfgList[CfgIndex].Provider;
        if (Provider != none)
        {
            Provider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
        }
    }
}

event Registered(LocalPlayer PlayerOwner)
{
    local int CfgIndex;
    local UIDataProvider_Settings Provider;
    
    Registered(PlayerOwner);
    for (CfgIndex = 0; CfgIndex < GameSettingsCfgList.Length; CfgIndex++)
    {
        Provider = GameSettingsCfgList[CfgIndex].Provider;
        if (Provider != none)
        {
            Provider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged, false);
        }
    }
}

event MoveToPrevious()
{
    local int NewIndex;
    
    NewIndex = Max(SelectedIndex - 1, 0);
    if (SelectedIndex != NewIndex)
    {
        SetCurrentByIndex(NewIndex);
    }
}

event MoveToNext()
{
    local int NewIndex;
    
    NewIndex = Min(SelectedIndex + 1, GameSettingsCfgList.Length - 1);
    if (SelectedIndex != NewIndex)
    {
        SetCurrentByIndex(NewIndex);
    }
}

event SetCurrentByName(name SettingsName)
{
    local int Index;
    
    for (Index = 0; Index < GameSettingsCfgList.Length; Index++)
    {
        if (GameSettingsCfgList[Index].SettingsName == SettingsName)
        {
            SetCurrentByIndex(Index);
            return;
        }
    }
    LogInternal("Invalid name (" $ string(SettingsName) $ ") specified to SetCurrentByName() on " $ string(self));
}

event SetCurrentByIndex(int NewIndex)
{
    if (NewIndex >= 0 && NewIndex < GameSettingsCfgList.Length)
    {
        SelectedIndex = NewIndex;
        NotifyPropertyChanged('SelectedIndex');
        RefreshSubscribers(, true, GetCurrentProvider());
    }
    else
    {
        LogInternal("Invalid index (" $ string(NewIndex) $ ") specified to SetCurrentByIndex() on " $ string(self));
    }
}

event UIDataProvider_Settings GetCurrentProvider()
{
    return GameSettingsCfgList[SelectedIndex].Provider;
}

event OnlineGameSettings GetCurrentGameSettings()
{
    return GameSettingsCfgList[SelectedIndex].GameSettings;
}

event bool CreateGame(byte ControllerIndex)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            return GameInterface.CreateOnlineGame(ControllerIndex, 'Game', GameSettingsCfgList[SelectedIndex].GameSettings);
        }
        else
        {
            WarnInternal("OnlineSubsystem does not support the game interface. Can't create online games");
        }
    }
    else
    {
        WarnInternal("No OnlineSubsystem present. Can't create online games");
    }
    return false;
}

native final function OnSettingProviderChanged(UIDataProvider SourceProvider, optional name SettingsName)
{
    SourceProvider;
    SettingsName;
}

defaultproperties
{
    SettingsProviderClass="UIDataProvider_Settings"
    Tag="OnlineGameSettings"
    WriteAccessType="ACCESS_WriteAll"
}
