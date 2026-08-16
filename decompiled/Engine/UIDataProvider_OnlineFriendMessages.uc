class UIDataProvider_OnlineFriendMessages extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlineFriendMessage> Messages;
var const localized string SendingPlayerNameCol;
var const localized string bIsFriendInviteCol;
var const localized string bWasAcceptedCol;
var const localized string bWasDeniedCol;
var const localized string MessageCol;
var string LastInviteFrom;

function OnGameInviteReceived(byte LocalUserNum, string InviterName)
{
    LastInviteFrom = InviterName;
    ReadMessages();
}

function OnLoginChange(byte LocalUserNum)
{
    if (int(LocalUserNum) == Player.ControllerId)
    {
        ReadMessages();
    }
}

function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
    ReadMessages();
}

function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
    ReadMessages();
}

function ReadMessages()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Messages.Length = 0;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) && PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
        {
            PlayerInterface.GetFriendMessages(byte(Player.ControllerId), Messages);
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
            PlayerInterface.ClearFriendMessageReceivedDelegate(byte(Player.ControllerId), OnFriendMessageReceived);
            PlayerInterface.ClearFriendInviteReceivedDelegate(byte(Player.ControllerId), OnFriendInviteReceived);
            PlayerInterface.ClearReceivedGameInviteDelegate(byte(Player.ControllerId), OnGameInviteReceived);
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
                PlayerInterface.AddFriendMessageReceivedDelegate(byte(Player.ControllerId), OnFriendMessageReceived);
                PlayerInterface.AddFriendInviteReceivedDelegate(byte(Player.ControllerId), OnFriendInviteReceived);
                PlayerInterface.AddReceivedGameInviteDelegate(byte(Player.ControllerId), OnGameInviteReceived);
                ReadMessages();
            }
        }
    }
}

defaultproperties
{
    SendingPlayerNameCol="Sender's Name"
    bIsFriendInviteCol="Friend Invitation"
    bWasAcceptedCol="Friend Was Accepted"
    bWasDeniedCol="Friend Was Denied"
    MessageCol="Message"
}
