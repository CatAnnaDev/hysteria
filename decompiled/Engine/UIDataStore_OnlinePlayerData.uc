class UIDataStore_OnlinePlayerData extends UIDataStore_Remote
    native
    notplaceable
    transient
    config(Engine)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var UIDataProvider_OnlineFriends FriendsProvider;
var UIDataProvider_OnlinePlayers PlayersProvider;
var UIDataProvider_OnlineClanMates ClanMatesProvider;
var LocalPlayer Player;
var string PlayerNick;
var int NumNewDownloads;
var int NumTotalDownloads;
var config string ProfileSettingsClassName;
var class<OnlineProfileSettings> ProfileSettingsClass;
var UIDataProvider_OnlineProfileSettings ProfileProvider;
var config string PlayerStorageClassName;
var class<OnlinePlayerStorage> PlayerStorageClass;
var UIDataProvider_OnlinePlayerStorage StorageProvider;
var UIDataProvider_OnlineFriendMessages FriendMessagesProvider;
var UIDataProvider_PlayerAchievements AchievementsProvider;
var config string FriendsProviderClassName;
var class<UIDataProvider_OnlineFriends> FriendsProviderClass;
var config string PlayersProviderClassName;
var class<UIDataProvider_OnlinePlayers> PlayersProviderClass;
var config string ClanMatesProviderClassName;
var class<UIDataProvider_OnlineClanMates> ClanMatesProviderClass;
var config string FriendMessagesProviderClassName;
var class<UIDataProvider_OnlineFriendMessages> FriendMessagesProviderClass;
var config string AchievementsProviderClassName;
var class<UIDataProvider_PlayerAchievements> AchievementsProviderClass;
var config string PartyChatProviderClassName;
var class<UIDataProvider_OnlinePartyChatList> PartyChatProviderClass;
var UIDataProvider_OnlinePartyChatList PartyChatProvider;

static event OnlinePlayerStorage GetCachedPlayerStorage(int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlayerStorage Result;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Result = PlayerInterface.GetPlayerStorage(byte(ControllerId));
        }
    }
    return Result;
}

static event OnlineProfileSettings GetCachedPlayerProfile(int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local OnlineProfileSettings Result;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Result = PlayerInterface.GetProfileSettings(byte(ControllerId));
        }
    }
    return Result;
}

event bool SaveProfileData()
{
    if (ProfileProvider != none)
    {
        return ProfileProvider.SaveStorageData();
    }
    return false;
}

function OnDownloadableContentQueryDone(bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        if (bWasSuccessful == true)
        {
            OnlineSub.ContentInterface.GetAvailableDownloadCounts(byte(Player.ControllerId), NumNewDownloads, NumTotalDownloads);
            RefreshSubscribers();
        }
        else
        {
            LogInternal("Failed to query for downloaded content");
        }
    }
}

function ClearDelegates()
{
    FriendsProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    FriendMessagesProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    PlayersProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    ClanMatesProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    ProfileProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    AchievementsProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    StorageProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
}

function RegisterDelegates()
{
    FriendsProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    FriendMessagesProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    PlayersProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    ClanMatesProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    ProfileProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    AchievementsProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    StorageProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
}

function OnPlayerDataChange()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerNick = OnlineSub.PlayerInterface.GetPlayerNickname(byte(Player.ControllerId));
            RefreshSubscribers();
        }
    }
}

function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (int(LocalUserNum) == Player.ControllerId)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) && PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
            {
                if (NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
                {
                    OnlineSub.ContentInterface.QueryAvailableDownloads(byte(Player.ControllerId));
                }
                PlayerNick = PlayerInterface.GetPlayerNickname(byte(Player.ControllerId));
            }
            else
            {
                PlayerNick = "";
                NumNewDownloads = 0;
                NumTotalDownloads = 0;
            }
        }
        RefreshSubscribers();
    }
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (Player != none)
    {
        ClearDelegates();
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                OnlineSub.PlayerInterfaceEx.ClearProfileDataChangedDelegate(byte(Player.ControllerId), OnPlayerDataChange);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
            {
                OnlineSub.ContentInterface.ClearQueryAvailableDownloadsComplete(byte(Player.ControllerId), OnDownloadableContentQueryDone);
            }
        }
    }
}

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Player = InPlayer;
    if (Player != none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                OnlineSub.PlayerInterfaceEx.AddProfileDataChangedDelegate(byte(Player.ControllerId), OnPlayerDataChange);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
            {
                OnlineSub.ContentInterface.AddQueryAvailableDownloadsComplete(byte(Player.ControllerId), OnDownloadableContentQueryDone);
            }
        }
        else if (ProfileProvider != none && ProfileProvider.Profile != none)
        {
            ProfileProvider.Profile.SetToDefaults();
        }
        RegisterDelegates();
        OnLoginChange(byte(Player.ControllerId));
    }
}

native final function OnSettingProviderChanged(UIDataProvider SourceProvider, optional name SettingsName)
{
    SourceProvider;
    SettingsName;
}

defaultproperties
{
    PlayerNick="PlayerNickNameHere"
    PartyChatProviderClassName="Engine.UIDataProvider_OnlinePartyChatList"
    Tag="OnlinePlayerData"
}
