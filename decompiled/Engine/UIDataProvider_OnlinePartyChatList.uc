class UIDataProvider_OnlinePartyChatList extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlinePartyMember> PartyMembersList;
var const localized array<string> NatTypes;
var const localized string NickNameCol;
var const localized string NatTypeCol;
var const localized string IsLocalCol;
var const localized string IsInPartyVoiceCol;
var const localized string IsTalkingCol;
var const localized string IsInGameSessionCol;
var const localized string IsPlayingThisGameCol;

event RefreshMembersList()
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
                LogInternal("Refreshing friends list");
            }
        }
    }
}

function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    PartyMembersList.Length = 0;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) && PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
        {
        }
    }
    NotifyPropertyChanged();
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
            }
        }
    }
}

defaultproperties
{
    NatTypes(0)="Unknown"
}
