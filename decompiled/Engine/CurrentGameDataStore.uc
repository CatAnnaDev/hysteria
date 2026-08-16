class CurrentGameDataStore extends UIDataStore_GameState
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

struct native GameDataProviderTypes
{
    var const class<GameInfoDataProvider> GameDataProviderClass;
    var const class<PlayerDataProvider> PlayerDataProviderClass;
    var const class<TeamDataProvider> TeamDataProviderClass;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const GameDataProviderTypes ProviderTypes;
var GameInfoDataProvider GameData;
var array<PlayerDataProvider> PlayerData;
var array<TeamDataProvider> TeamData;
var transient bool bRefreshPlayerDataProviders;
var transient bool bRefreshTeamDataProviders;
var delegate<OnAddTeamProvider> __OnAddTeamProvider__Delegate;

delegate OnAddTeamProvider(TeamDataProvider Provider)
{
}

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return false;
}

function RefreshTeamDataProviders()
{
    local int I;
    
    for (I = 0; I < TeamData.Length; I++)
    {
        if (TeamData[I] != none)
        {
            TeamData[I].RegeneratePlayerLists(PlayerData);
        }
    }
    bRefreshTeamDataProviders = false;
}

function RefreshPlayerDataProviders()
{
    RefreshSubscribers('Players', true, self);
    bRefreshPlayerDataProviders = false;
}

function NotifyTeamChange()
{
    bRefreshTeamDataProviders = true;
}

function NotifyPlayersChanged()
{
    bRefreshPlayerDataProviders = true;
}

function Timer()
{
    if (bRefreshPlayerDataProviders)
    {
        RefreshPlayerDataProviders();
    }
    if (bRefreshTeamDataProviders)
    {
        RefreshTeamDataProviders();
    }
}

function TeamDataProviderPropertyChange(UIDataProvider SourceProvider, optional name PropTag)
{
    local int TeamArrayIndex, CollectionIndex;
    local EUIDataProviderFieldType ProviderFieldType;
    local bool bInvalidateListItems;
    
    LogInternal(">>" @ "(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "PropTag:'" $ string(PropTag) $ "'" @ "SourceProvider:'" $ string(SourceProvider) $ "'", 'DevDataStore');
    for (TeamArrayIndex = TeamData.Length - 1; TeamArrayIndex >= 0; TeamArrayIndex--)
    {
        if (SourceProvider == TeamData[TeamArrayIndex])
        {
            break;
        }
    }
    CollectionIndex = TeamArrayIndex;
    if (TeamArrayIndex != -1)
    {
        if (PropTag != 'None')
        {
            if (SourceProvider.GetProviderFieldType(string(PropTag), ProviderFieldType) && SourceProvider.IsCollectionDataType(ProviderFieldType))
            {
                CollectionIndex = SourceProvider.ParseTagArrayDelimiter(PropTag);
                if (CollectionIndex == -1)
                {
                    bInvalidateListItems = true;
                }
                PropTag = name("Teams;" $ string(TeamArrayIndex) $ "." $ string(PropTag));
            }
            else
            {
                PropTag = name("Teams." $ string(PropTag));
            }
        }
        else
        {
            bInvalidateListItems = true;
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "CALLED BUT NO MATCHING TEAMDATAPROVIDER FOUND!  " $ "SourceProvider:" $ (SourceProvider != none ? string(SourceProvider.Name) : "None") @ "PropTag:'" $ string(PropTag) $ "'", 'ERROR_DataStore');
    }
    RefreshSubscribers(PropTag, bInvalidateListItems, SourceProvider, CollectionIndex);
    LogInternal("<<" @ "(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "PropTag:'" $ string(PropTag) $ "'" @ "bInvalidateListItems:'" $ string(bInvalidateListItems) $ "'" @ "CollectionIndex:'" $ string(CollectionIndex) $ "'" @ "TeamArrayIndex:'" $ string(TeamArrayIndex) $ "'" @ "SourceProvider:" $ (SourceProvider != none ? string(SourceProvider.Name) : "None"), 'DevDataStore');
}

function PlayerDataProviderPropertyChange(UIDataProvider SourceProvider, optional name PropTag)
{
    local int PlayerArrayIndex, CollectionIndex;
    local EUIDataProviderFieldType ProviderFieldType;
    local bool bInvalidateListItems;
    
    LogInternal(">>" @ "(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "PropTag:'" $ string(PropTag) $ "'" @ "SourceProvider:'" $ string(SourceProvider) $ "'", 'DevDataStore');
    for (PlayerArrayIndex = PlayerData.Length - 1; PlayerArrayIndex >= 0; PlayerArrayIndex--)
    {
        if (SourceProvider == PlayerData[PlayerArrayIndex])
        {
            break;
        }
    }
    CollectionIndex = PlayerArrayIndex;
    if (PlayerArrayIndex != -1)
    {
        if (PropTag != 'None')
        {
            if (SourceProvider.GetProviderFieldType(string(PropTag), ProviderFieldType) && SourceProvider.IsCollectionDataType(ProviderFieldType))
            {
                CollectionIndex = SourceProvider.ParseTagArrayDelimiter(PropTag);
                if (CollectionIndex == -1)
                {
                    bInvalidateListItems = true;
                }
                PropTag = name("Players;" $ string(PlayerArrayIndex) $ "." $ string(PropTag));
            }
            else
            {
                PropTag = name("Players." $ string(PropTag));
            }
        }
        else
        {
            bInvalidateListItems = true;
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "CALLED BUT NO MATCHING PLAYERDATAPROVIDER FOUND!  " $ "SourceProvider:" $ (SourceProvider != none ? string(SourceProvider.Name) : "None") @ "PropTag:'" $ string(PropTag) $ "'", 'ERROR_DataStore');
    }
    RefreshSubscribers(PropTag, bInvalidateListItems, SourceProvider, CollectionIndex);
    LogInternal("<<" @ "PropTag:'" $ string(PropTag) $ "'" @ "bInvalidateListItems:'" $ string(bInvalidateListItems) $ "'" @ "CollectionIndex:'" $ string(CollectionIndex) $ "'" @ "PlayerArrayIndex:'" $ string(PlayerArrayIndex) $ "'" @ "SourceProvider:" $ (SourceProvider != none ? string(SourceProvider.Name) : "None"), 'DevDataStore');
}

final function ClearDataProviders()
{
    local int I;
    
    LogInternal(">>" @ "(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
    if (GameData != none)
    {
        GameData.CleanupDataProvider();
    }
    for (I = 0; I < PlayerData.Length; I++)
    {
        PlayerData[I].CleanupDataProvider();
    }
    for (I = 0; I < TeamData.Length; I++)
    {
        if (TeamData[I] != none)
        {
            TeamData[I].CleanupDataProvider();
        }
    }
    GameData = none;
    PlayerData.Length = 0;
    TeamData.Length = 0;
    LogInternal("<<" @ "(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DevDataStore');
}

final function TeamDataProvider GetTeamDataProvider(TeamInfo TI)
{
    local int Index;
    local TeamDataProvider Provider;
    
    Index = FindTeamDataProviderIndex(TI);
    if (Index != -1)
    {
        Provider = TeamData[Index];
    }
    return Provider;
}

final function PlayerDataProvider GetPlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int Index;
    local PlayerDataProvider Provider;
    
    Index = FindPlayerDataProviderIndex(PRI);
    if (Index != -1)
    {
        Provider = PlayerData[Index];
    }
    return Provider;
}

final function int FindTeamDataProviderIndex(TeamInfo TI)
{
    local int I, Result;
    
    Result = -1;
    for (I = 0; I < TeamData.Length; I++)
    {
        if (TeamData[I] != none && TeamData[I].GetDataSource() == TI)
        {
            Result = I;
            break;
        }
    }
    return Result;
}

final function int FindPlayerDataProviderIndex(PlayerReplicationInfo PRI)
{
    local int I, Result;
    
    Result = -1;
    for (I = 0; I < PlayerData.Length; I++)
    {
        if (PlayerData[I].GetDataSource() == PRI)
        {
            Result = I;
            break;
        }
    }
    return Result;
}

final function RemoveTeamDataProvider(TeamInfo TI)
{
    local int ExistingIndex;
    
    if (TI != none)
    {
        ExistingIndex = FindTeamDataProviderIndex(TI);
        if (ExistingIndex != -1)
        {
            if (TeamData[ExistingIndex].CleanupDataProvider())
            {
                TeamData[ExistingIndex].RemovePropertyNotificationChangeRequest(TeamDataProviderPropertyChange);
                TeamData.Remove(ExistingIndex, 1);
            }
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NULL TeamInfo specified!" @ "TeamCount:'" $ string(TeamData.Length) $ "'", 'DevDataStore');
    }
}

final function AddTeamDataProvider(TeamInfo TI)
{
    local int ExistingIndex;
    local TeamDataProvider DataProvider;
    local string TeamName;
    
    TeamName = (TI != none ? TI.TeamName : "None");
    LogInternal(">> CurrentGameDataStore::AddTeamDataProvider -" @ string(TI) @ "(" $ TeamName $ ")", 'DevDataStore');
    if (TI != none)
    {
        if (GameData != none)
        {
            ExistingIndex = FindTeamDataProviderIndex(TI);
            if (ExistingIndex == -1)
            {
                DataProvider = new ProviderTypes.TeamDataProviderClass;
                if (!DataProvider.BindProviderInstance(TI))
                {
                    LogInternal("Failed to bind TeamInfo to TeamDataProvider in 'CurrentGame' data store:" @ string(DataProvider) @ "for team" @ TeamName, 'DevDataStore');
                }
                else
                {
                    TeamData[TI.TeamIndex] = DataProvider;
                    DataProvider.AddPropertyNotificationChangeRequest(TeamDataProviderPropertyChange);
                    NotifyTeamChange();
                    OnAddTeamProvider(DataProvider);
                }
            }
            else
            {
                LogInternal("TeamDataProvider already registered in 'CurrentGame' data store for" @ TeamName @ "TeamData[ExistingIndex]:" $ (TeamData[ExistingIndex] != none ? string(TeamData[ExistingIndex].Name) : "None"), 'DevDataStore');
            }
        }
    }
    else
    {
        LogInternal("NULL TeamInfo specified - current number of team data providers:" @ string(TeamData.Length), 'DevDataStore');
    }
}

final function RemovePlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int ExistingIndex;
    
    if (PRI != none)
    {
        ExistingIndex = FindPlayerDataProviderIndex(PRI);
        if (ExistingIndex != -1)
        {
            if (PlayerData[ExistingIndex].CleanupDataProvider())
            {
                PlayerData[ExistingIndex].RemovePropertyNotificationChangeRequest(PlayerDataProviderPropertyChange);
                PlayerData.Remove(ExistingIndex, 1);
                RefreshSubscribers('Players', true, self);
                NotifyTeamChange();
            }
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NULL PRI specified!" @ "PlayerData.Length:'" $ string(PlayerData.Length) $ "'", 'DevDataStore');
    }
}

final function AddPlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int ExistingIndex;
    local PlayerDataProvider DataProvider;
    local string PlayerName;
    
    PlayerName = (PRI != none ? PRI.PlayerName : "None");
    LogInternal(">> CurrentGameDataStore::AddPlayerDataProvider -" @ string(PRI) @ "(" $ PlayerName $ ")", 'DevDataStore');
    if (PRI != none)
    {
        if (GameData != none)
        {
            ExistingIndex = FindPlayerDataProviderIndex(PRI);
            if (ExistingIndex == -1)
            {
                DataProvider = new ProviderTypes.PlayerDataProviderClass;
                if (!DataProvider.BindProviderInstance(PRI))
                {
                    LogInternal("Failed to bind PRI to PlayerDataProvider:" @ string(DataProvider) @ "for player" @ PlayerName, 'DevDataStore');
                }
                else
                {
                    DataProvider.AddPropertyNotificationChangeRequest(PlayerDataProviderPropertyChange);
                    PlayerData[PlayerData.Length] = DataProvider;
                    RefreshSubscribers('Players', true, self);
                    NotifyTeamChange();
                }
            }
            else
            {
                LogInternal("PlayerDataProvider already registered in 'CurrentGame' data store for" @ PlayerName @ "PlayerData[ExistingIndex]:" $ (PlayerData[ExistingIndex] != none ? string(PlayerData[ExistingIndex].Name) : "None"), 'DevDataStore');
            }
        }
        else
        {
            LogInternal("CurrentGame data provider not yet created!", 'DevDataStore');
        }
    }
    else
    {
        LogInternal("NULL PRI specified - current number of player data provider:" @ string(PlayerData.Length), 'DevDataStore');
    }
    LogInternal("<< CurrentGameDataStore::AddPlayerDataProvider -" @ string(PRI) @ "(" $ PlayerName $ ")", 'DevDataStore');
}

final function CreateGameDataProvider(GameReplicationInfo GRI)
{
    if (GRI != none)
    {
        GameData = new ProviderTypes.GameDataProviderClass;
        if (!GameData.BindProviderInstance(GRI))
        {
            LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Failed to bind GameReplicationInfo to game data store:" @ "GRI:" $ (GRI != none ? string(GRI.Name) : "None"), 'DevDataStore');
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") CurrentGameDataStore::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NULL GRI specified!" @ "GameData:" $ (GameData != none ? string(GameData.Name) : "None"), 'DevDataStore');
    }
}

defaultproperties
{
    ProviderTypes=(GameDataProviderClass="GameInfoDataProvider",PlayerDataProviderClass="PlayerDataProvider",TeamDataProviderClass="TeamDataProvider")
    Tag="CurrentGame"
}
