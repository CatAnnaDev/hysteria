class UIDataProvider_OnlinePlayers extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;

function OnPlayersReadComplete()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
        }
    }
}

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnRegister(InPlayer);
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (Player != none)
    {
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
            }
        }
    }
}

defaultproperties
{
}
