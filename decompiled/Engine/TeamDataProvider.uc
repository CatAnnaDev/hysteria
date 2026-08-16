class TeamDataProvider extends UIDynamicDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const name PlayerListFieldName;
var array<PlayerDataProvider> Players;

function RegeneratePlayerLists(array<PlayerDataProvider> AllPlayers)
{
    local int PlayerIdx;
    local PlayerReplicationInfo PRI;
    
    Players.Length = 0;
    for (PlayerIdx = 0; PlayerIdx < AllPlayers.Length; PlayerIdx++)
    {
        PRI = PlayerReplicationInfo(AllPlayers[PlayerIdx].GetDataSource());
        if (PRI != none && PRI.Team != none && PRI.Team == DataSource)
        {
            Players[Players.Length] = AllPlayers[PlayerIdx];
        }
    }
    NotifyPropertyChanged(PlayerListFieldName);
}

defaultproperties
{
    PlayerListFieldName="Players"
    DataClass="TeamInfo"
}
