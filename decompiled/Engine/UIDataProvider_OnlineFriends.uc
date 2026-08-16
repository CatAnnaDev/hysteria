class UIDataProvider_OnlineFriends extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlineFriend> FriendsList;
var const localized string NickNameCol;
var const localized string PresenceInfoCol;
var const localized string FriendStateCol;
var const localized string bIsOnlineCol;
var const localized string bIsPlayingCol;
var const localized string bIsPlayingThisGameCol;
var const localized string bIsJoinableCol;
var const localized string bHasVoiceSupportCol;
var const localized string bHaveInvitedCol;
var const localized string bHasInvitedYouCol;
var const localized string OfflineText;
var const localized string OnlineText;
var const localized string AwayText;
var const localized string BusyText;

event RefreshFriendsList()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (Player != none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
                LogInternal("Refreshing friends list");
            }
        }
    }
}

function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    FriendsList.Length = 0;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) && PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
        {
            PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
        }
    }
    NotifyPropertyChanged();
}

function OnFriendsReadComplete(bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (bWasSuccessful == true)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                PlayerInterface.GetFriendsList(byte(Player.ControllerId), FriendsList);
            }
        }
        NotifyPropertyChanged();
    }
    else
    {
        LogInternal("Failed to read friends list", 'DevOnline');
    }
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearReadFriendsCompleteDelegate(byte(Player.ControllerId), OnFriendsReadComplete);
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
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
                PlayerInterface.AddReadFriendsCompleteDelegate(byte(Player.ControllerId), OnFriendsReadComplete);
                PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
            }
        }
    }
}

defaultproperties
{
    NickNameCol="Name"
    PresenceInfoCol="Online Status"
    bIsOnlineCol="Is Online"
    bIsPlayingCol="Is Playing"
    bIsPlayingThisGameCol="Is Playing This Game"
    bIsJoinableCol="Is Joinable"
    bHasVoiceSupportCol="Has Voice Support"
    OfflineText="Offline"
    OnlineText="Online"
    AwayText="Assente"
    BusyText="Occupato"
}
