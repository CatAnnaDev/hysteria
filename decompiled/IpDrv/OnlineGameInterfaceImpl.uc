class OnlineGameInterfaceImpl extends Object
    native
    notplaceable
    config(Engine)
    within OnlineSubsystemCommonImpl
    implements(OnlineGameInterface);

var OnlineSubsystemCommonImpl OwningSubsystem;
var const OnlineGameSettings GameSettings;
var const OnlineGameSearch GameSearch;
var const EOnlineGameState CurrentGameState;
var const ELanBeaconState LanBeaconState;
var const byte LanNonce[8];
var array<delegate<OnCreateOnlineGameComplete>> CreateOnlineGameCompleteDelegates;
var array<delegate<OnUpdateOnlineGameComplete>> UpdateOnlineGameCompleteDelegates;
var array<delegate<OnDestroyOnlineGameComplete>> DestroyOnlineGameCompleteDelegates;
var array<delegate<OnJoinOnlineGameComplete>> JoinOnlineGameCompleteDelegates;
var array<delegate<OnStartOnlineGameComplete>> StartOnlineGameCompleteDelegates;
var array<delegate<OnEndOnlineGameComplete>> EndOnlineGameCompleteDelegates;
var array<delegate<OnFindOnlineGamesComplete>> FindOnlineGamesCompleteDelegates;
var array<delegate<OnCancelFindOnlineGamesComplete>> CancelFindOnlineGamesCompleteDelegates;
var const config int LanAnnouncePort;
var const config int LanGameUniqueId;
var const config int LanPacketPlatformMask;
var float LanQueryTimeLeft;
var config float LanQueryTimeout;
var const native transient Pointer LanBeacon;
var const native transient Pointer SessionInfo;
var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;

native function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80])
{
    SearchingPlayerNum;
    SearchSettings;
    PlatformSpecificInfo;
}

function bool ReadPlatformSpecificSessionInfoBySessionName(name SessionName, out byte PlatformSpecificInfo[80])
{
}

native function bool ReadPlatformSpecificSessionInfo(out const OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80])
{
    DesiredGame;
    PlatformSpecificInfo;
}

function bool QueryNonAdvertisedData(int StartAt, int NumberToQuery)
{
}

function bool RecalculateSkillRating(name SessionName, out const array<UniqueNetId> Players)
{
}

function bool AcceptGameInvite(byte LocalUserNum, name SessionName)
{
}

function ClearGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
}

function AddGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
}

delegate OnGameInviteAccepted(out const OnlineGameSearchResult InviteResult)
{
}

function array<OnlineArbitrationRegistrant> GetArbitratedPlayers(name SessionName)
{
}

function ClearArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate)
{
}

function AddArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate)
{
}

delegate OnArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
{
}

function bool RegisterForArbitration(name SessionName)
{
}

function ClearEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        EndOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    if (EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate) == -1)
    {
        EndOnlineGameCompleteDelegates[EndOnlineGameCompleteDelegates.Length] = EndOnlineGameCompleteDelegate;
    }
}

delegate OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

native function bool EndOnlineGame(name SessionName)
{
    SessionName;
}

function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        StartOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
    if (StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate) == -1)
    {
        StartOnlineGameCompleteDelegates[StartOnlineGameCompleteDelegates.Length] = StartOnlineGameCompleteDelegate;
    }
}

delegate OnStartOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

native function bool StartOnlineGame(name SessionName)
{
    SessionName;
}

function ClearUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate)
{
}

function AddUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate)
{
}

delegate OnUnregisterPlayerComplete(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
}

function bool UnregisterPlayer(name SessionName, UniqueNetId PlayerID)
{
}

function ClearRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate)
{
}

function AddRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate)
{
}

delegate OnRegisterPlayerComplete(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
}

function bool RegisterPlayer(name SessionName, UniqueNetId PlayerID, bool bWasInvited)
{
}

native function bool GetResolvedConnectString(name SessionName, out string ConnectInfo)
{
    SessionName;
    ConnectInfo;
}

function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        JoinOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    if (JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate) == -1)
    {
        JoinOnlineGameCompleteDelegates[JoinOnlineGameCompleteDelegates.Length] = JoinOnlineGameCompleteDelegate;
    }
}

delegate OnJoinOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

native function bool JoinOnlineGame(byte PlayerNum, name SessionName, out const OnlineGameSearchResult DesiredGame)
{
    PlayerNum;
    SessionName;
    DesiredGame;
}

native function bool FreeSearchResults(OnlineGameSearch Search)
{
    Search;
}

function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate);
    if (RemoveIndex != -1)
    {
        CancelFindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
    if (CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate) == -1)
    {
        CancelFindOnlineGamesCompleteDelegates[CancelFindOnlineGamesCompleteDelegates.Length] = CancelFindOnlineGamesCompleteDelegate;
    }
}

delegate OnCancelFindOnlineGamesComplete(bool bWasSuccessful)
{
}

native function bool CancelFindOnlineGames()
{
}

function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate);
    if (RemoveIndex != -1)
    {
        FindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    if (FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate) == -1)
    {
        FindOnlineGamesCompleteDelegates[FindOnlineGamesCompleteDelegates.Length] = FindOnlineGamesCompleteDelegate;
    }
}

native function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings)
{
    SearchingPlayerNum;
    SearchSettings;
}

function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        DestroyOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    if (DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate) == -1)
    {
        DestroyOnlineGameCompleteDelegates[DestroyOnlineGameCompleteDelegates.Length] = DestroyOnlineGameCompleteDelegate;
    }
}

delegate OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

native function bool DestroyOnlineGame(name SessionName)
{
    SessionName;
}

function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        UpdateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    if (UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate) == -1)
    {
        UpdateOnlineGameCompleteDelegates[UpdateOnlineGameCompleteDelegates.Length] = UpdateOnlineGameCompleteDelegate;
    }
}

delegate OnUpdateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool UpdateOnlineGame(name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = false)
{
}

function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        CreateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    if (CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate) == -1)
    {
        CreateOnlineGameCompleteDelegates[CreateOnlineGameCompleteDelegates.Length] = CreateOnlineGameCompleteDelegate;
    }
}

delegate OnCreateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

native function bool CreateOnlineGame(byte HostingPlayerNum, name SessionName, OnlineGameSettings NewGameSettings)
{
    HostingPlayerNum;
    SessionName;
    NewGameSettings;
}

function OnlineGameSearch GetGameSearch()
{
    return GameSearch;
}

function OnlineGameSettings GetGameSettings(name SessionName)
{
    return GameSettings;
}

delegate OnFindOnlineGamesComplete(bool bWasSuccessful)
{
}

defaultproperties
{
    LanAnnouncePort=14001
    LanQueryTimeout=5.0
}
