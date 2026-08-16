class UIDataStore_OnlineStats extends UIDataStore_Remote
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

enum EStatsFetchType
{
    SFT_Player,
    SFT_CenteredOnPlayer,
    SFT_Friends,
    SFT_TopRankings,
};

struct native RankMetaData
{
    var const name RankName;
    var const localized string RankColumnName;
};

struct native PlayerNickMetaData
{
    var const name PlayerNickName;
    var const localized string PlayerNickColumnName;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<class<OnlineStatsRead>> StatsReadClasses;
var const name StatsReadName;
var const PlayerNickMetaData PlayerNickData;
var const RankMetaData RankNameMetaData;
var const name TotalRowsName;
var array<OnlineStatsRead> StatsReadObjects;
var OnlineStatsRead StatsRead;
var EStatsFetchType CurrentReadType;
var OnlineStatsInterface StatsInterface;
var OnlinePlayerInterface PlayerInterface;

native function SortResultsByRank()
{
}

function OnReadComplete(bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        SortResultsByRank();
    }
    NotifyPropertyChanged();
    RefreshSubscribers();
}

event bool ShowGamercard(byte ConrollerIndex, int ListIndex)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerExt;
    local UniqueNetId PlayerID;
    
    if (ListIndex >= 0 && ListIndex < StatsRead.Rows.Length)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerExt = OnlineSub.PlayerInterfaceEx;
            if (NotEqual_InterfaceInterface(PlayerExt, OnlinePlayerInterfaceEx(none)))
            {
                PlayerID = StatsRead.Rows[ListIndex].PlayerID;
                return PlayerExt.ShowGamerCardUI(ConrollerIndex, PlayerID);
            }
            else
            {
                WarnInternal("OnlineSubsystem does not support the extended player interface. Can't show gamercard");
            }
        }
        else
        {
            WarnInternal("No OnlineSubsystem present. Can't show gamercard");
        }
    }
    else
    {
        WarnInternal("Invalid index (" $ string(ListIndex) $ ") specified for online game to show the gamercard of");
    }
}

event bool RefreshStats(byte ControllerIndex)
{
    local array<UniqueNetId> Players;
    local UniqueNetId PlayerID;
    
    SetStatsReadInfo();
    StatsInterface.FreeStats(StatsRead);
    OnReadComplete(true);
    switch (CurrentReadType)
    {
        case 0:
            PlayerInterface.GetUniquePlayerId(ControllerIndex, PlayerID);
            Players[0] = PlayerID;
            if (StatsInterface.ReadOnlineStats(Players, StatsRead) == false)
            {
                WarnInternal("Querying Player failed.");
                return false;
            }
            return true;
        case 1:
            if (StatsInterface.ReadOnlineStatsByRankAroundPlayer(ControllerIndex, StatsRead, 10) == false)
            {
                WarnInternal("Querying CenteredOnPlayer failed.");
                return false;
            }
            return true;
        case 2:
            if (StatsInterface.ReadOnlineStatsForFriends(ControllerIndex, StatsRead) == false)
            {
                WarnInternal("Querying Friends failed.");
                return false;
            }
            return true;
        case 3:
            if (StatsInterface.ReadOnlineStatsByRank(StatsRead) == false)
            {
                LogInternal("Querying Top Rankings failed.");
                return false;
            }
            return true;
        default:
    }
}

function SetStatsReadInfo()
{
    StatsRead = StatsReadObjects[0];
    CurrentReadType = 0;
}

event Init()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        StatsInterface = OnlineSub.StatsInterface;
        PlayerInterface = OnlineSub.PlayerInterface;
        StatsInterface.AddReadOnlineStatsCompleteDelegate(OnReadComplete);
    }
}

defaultproperties
{
    StatsReadName="StatsReadResults"
    PlayerNickData=(PlayerNickName="Player Nick",PlayerNickColumnName="Nome Giocatore")
    RankNameMetaData=(RankName="Rank",RankColumnName="Classificata")
    TotalRowsName="TotalRows"
    Tag="OnlineStats"
}
