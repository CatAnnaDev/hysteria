class OnlineGameInterface extends Interface
    abstract
    notplaceable;

var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;

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
}

function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
}

delegate OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool EndOnlineGame(name SessionName)
{
}

function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
}

function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
}

delegate OnStartOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool StartOnlineGame(name SessionName)
{
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

function bool GetResolvedConnectString(name SessionName, out string ConnectInfo)
{
}

function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
}

function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
}

delegate OnJoinOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool JoinOnlineGame(byte PlayerNum, name SessionName, out const OnlineGameSearchResult DesiredGame)
{
}

function bool QueryNonAdvertisedData(int StartAt, int NumberToQuery)
{
}

function bool FreeSearchResults(optional OnlineGameSearch Search)
{
}

function OnlineGameSearch GetGameSearch()
{
}

function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80])
{
}

function bool ReadPlatformSpecificSessionInfoBySessionName(name SessionName, out byte PlatformSpecificInfo[80])
{
}

function bool ReadPlatformSpecificSessionInfo(out const OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80])
{
}

function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
}

function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
}

delegate OnCancelFindOnlineGamesComplete(bool bWasSuccessful)
{
}

function bool CancelFindOnlineGames()
{
}

function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
}

function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
}

delegate OnFindOnlineGamesComplete(bool bWasSuccessful)
{
}

function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings)
{
}

function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
}

function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
}

delegate OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool DestroyOnlineGame(name SessionName)
{
}

function OnlineGameSettings GetGameSettings(name SessionName)
{
}

function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
}

function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
}

delegate OnUpdateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool UpdateOnlineGame(name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = false)
{
}

function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
}

function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
}

delegate OnCreateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
}

function bool CreateOnlineGame(byte HostingPlayerNum, name SessionName, OnlineGameSettings NewGameSettings)
{
}

defaultproperties
{
}
