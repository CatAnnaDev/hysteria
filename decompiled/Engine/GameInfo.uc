class GameInfo extends Info
    native
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum ESpeechPriority
{
    Speech_None,
    Speech_Effort,
    Speech_GUDS,
    Speech_Scripted,
    Speech_Immediate,
};

enum EStandbyType
{
    STDBY_Rx,
    STDBY_Tx,
    STDBY_BadPing,
};

struct native GameTypePrefix
{
    var string Prefix;
    var bool bUsesCommonPackage;
    var string GameType;
    var array<string> AdditionalGameTypes;
    var array<string> ForcedObjects;
};

struct native GameClassShortName
{
    var string ShortName;
    var string GameClassName;
};

var bool bRestartLevel;
var bool bPauseable;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool bAlreadyChanged;
var globalconfig bool bAdminCanPause;
var bool bGameRestarted;
var bool bLevelChange;
var globalconfig bool bKickLiveIdlers;
var bool bUsingArbitration;
var bool bHasArbitratedHandshakeBegun;
var bool bNeedsEndGameHandshake;
var bool bIsEndGameHandshakeComplete;
var bool bHasEndGameHandshakeBegun;
var bool bFixedPlayerStart;
var bool bDoFearCostFallOff;
var bool bCheckpointLoadInProgress;
var bool bUseSeamlessTravel;
var bool bHasNetworkError;
var const bool bRequiresPushToTalk;
var config bool bIsStandbyCheckingEnabled;
var bool bHasStandbyCheatTriggered;
var string CauseEventCommand;
var string BugLocString;
var string BugRotString;
var array<PlayerController> PendingArbitrationPCs;
var array<PlayerController> ArbitrationPCs;
var globalconfig float ArbitrationHandshakeTimeout;
var globalconfig float GameDifficulty;
var globalconfig int GoreLevel;
var float GameSpeed;
var class<Pawn> DefaultPawnClass;
var class<ScoreBoard> ScoreBoardType;
var class<HUD> HUDType;
var globalconfig int MaxSpectators;
var int MaxSpectatorsAllowed;
var int NumSpectators;
var globalconfig int MaxPlayers;
var int MaxPlayersAllowed;
var int NumPlayers;
var int NumBots;
var int NumTravellingPlayers;
var int CurrentID;
var const localized string DefaultPlayerName;
var const localized string GameName;
var float FearCostFallOff;
var config int GoalScore;
var config int MaxLives;
var config int TimeLimit;
var class<LocalMessage> DeathMessageClass;
var class<GameMessage> GameMessageClass;
var Mutator BaseMutator;
var class<AccessControl> AccessControlClass;
var AccessControl AccessControl;
var class<BroadcastHandler> BroadcastHandlerClass;
var BroadcastHandler BroadcastHandler;
var class<AutoTestManager> AutoTestManagerClass;
var AutoTestManager MyAutoTestManager;
var class<CheckPointManager> CheckPointManagerClass;
var CheckPointManager MyCheckPointManager;
var class<PlayerController> PlayerControllerClass;
var class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var() class<GameReplicationInfo> GameReplicationInfoClass;
var GameReplicationInfo GameReplicationInfo;
var globalconfig float MaxIdleTime;
var globalconfig float MaxTimeMargin;
var globalconfig float TimeMarginSlack;
var globalconfig float MinTimeMargin;
var array<PlayerReplicationInfo> InactivePRIArray;
var array<delegate<CanUnpause>> Pausers;
var OnlineSubsystem OnlineSub;
var OnlineGameInterface GameInterface;
var class<OnlineStatsWrite> OnlineStatsWriteClass;
var const int LeaderboardId;
var const int ArbitratedLeaderboardId;
var CoverReplicator CoverReplicatorBase;
var const class<OnlineGameSettings> OnlineGameSettingsClass;
var string ServerOptions;
var int AdjustedNetSpeed;
var float LastNetSpeedUpdateTime;
var globalconfig int TotalNetBandwidth;
var globalconfig int MinDynamicBandwidth;
var globalconfig int MaxDynamicBandwidth;
var config float StandbyRxCheatTime;
var config float StandbyTxCheatTime;
var config int BadPingThreshold;
var config float PercentMissingForRxStandby;
var config float PercentMissingForTxStandby;
var config float PercentForBadPing;
var() const config array<GameClassShortName> GameInfoClassAliases;
var config string DefaultGameType;
var config array<GameTypePrefix> DefaultMapPrefixes;
var config array<GameTypePrefix> CustomMapPrefixes;
var float DebugGameSpeed;
var delegate<CanUnpause> __CanUnpause__Delegate;

event NotifyDialogueStart(Actor Speaker, Actor Addressee, SoundCue Audio, ESpeechPriority PRI)
{
}

event NotifyDialogueFinish(Actor Speaker, SoundCue Sound)
{
}

event StandbyCheatDetected(EStandbyType StandbyType)
{
}

native function EnableStandbyCheatDetection(bool bIsEnabled)
{
    bIsEnabled;
}

simulated exec function BeginBVT(optional coerce string TagDesc)
{
    if (MyAutoTestManager == none)
    {
        MyAutoTestManager = Spawn(AutoTestManagerClass);
    }
    MyAutoTestManager.BeginSentinelRun("BVT", "", TagDesc);
    MyAutoTestManager.SetTimer(3.0, true, 'DoTimeBasedSentinelStatGathering');
}

function bool CheckForSentinelRun()
{
    return MyAutoTestManager != none && MyAutoTestManager.CheckForSentinelRun();
}

function bool ShouldAutoContinueToNextRound()
{
    return MyAutoTestManager != none && MyAutoTestManager.bAutoContinueToNextRound;
}

function bool IsDoingASentinelRun()
{
    return MyAutoTestManager != none && MyAutoTestManager.bDoingASentinelRun;
}

function bool IsCheckingForMemLeaks()
{
    return MyAutoTestManager != none && MyAutoTestManager.bCheckingForMemLeaks;
}

function bool IsCheckingForFragmentation()
{
    return MyAutoTestManager != none && MyAutoTestManager.bCheckingForFragmentation;
}

function bool IsAutomatedPerfTesting()
{
    return MyAutoTestManager != none && MyAutoTestManager.bAutomatedPerfTesting;
}

exec function DoTravelTheWorld()
{
    if (MyAutoTestManager != none)
    {
        GotoState('TravelTheWorld');
        MyAutoTestManager.DoTravelTheWorld();
    }
}

function TellClientsToTravelToSession(name SessionName, class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    local PlayerController PC;
    
    foreach WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
        {
            PC.ClientTravelToSession(SessionName, SearchClass, PlatformSpecificInfo);
        }
    }
}

function TellClientsToReturnToPartyHost()
{
    local PlayerController PC;
    local OnlineGameSettings GameSettings;
    local UniqueNetId RequestingPlayerId;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
            if (GameSettings != none)
            {
                RequestingPlayerId = GameSettings.OwningPlayerId;
            }
            else
            {
                foreach LocalPlayerControllers(class'PlayerController', PC)
                {
                    if (PC.IsPrimaryPlayer() && PC.PlayerReplicationInfo != none)
                    {
                        RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
                        break;
                    }
                }
            }
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (PC.IsPrimaryPlayer())
                {
                    PC.ClientReturnToParty(RequestingPlayerId);
                }
            }
        }
    }
}

function OnServerCreateComplete(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings GameSettings;
    
    GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
    if (bWasSuccessful == false)
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
        if (GameSettings.bIsLanMatch == false)
        {
            WarnInternal("Failed to register game with online service. Registering as a LAN match");
            GameSettings.bIsLanMatch = true;
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
            if (!GameInterface.CreateOnlineGame(0, SessionName, GameSettings))
            {
                GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
            }
        }
        else
        {
            WarnInternal("Failed to register game with online service. Game won't be advertised");
        }
    }
    else
    {
        UpdateGameSettings();
    }
}

function RegisterServer()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineGameSettingsClass != none && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = new OnlineGameSettingsClass;
        GameSettings.UpdateFromURL(ServerOptions, self);
        OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
        if (!OnlineSub.GameInterface.CreateOnlineGame(0, PlayerReplicationInfoClass.default.default.SessionName, GameSettings))
        {
            OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
        }
    }
    else
    {
        WarnInternal("No game settings to register with the online service. Game won't be advertised");
    }
}

function OnLoginChange(byte LocalUserNum)
{
    ClearAutoLoginDelegates();
    RegisterServer();
}

function OnLoginFailed(byte LocalUserNum, EOnlineServerConnectionStatus ErrorCode)
{
    ClearAutoLoginDelegates();
}

function ClearAutoLoginDelegates()
{
    if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        OnlineSub.PlayerInterface.ClearLoginFailedDelegate(0, OnLoginFailed);
    }
}

function bool ProcessServerLogin()
{
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            OnlineSub.PlayerInterface.AddLoginFailedDelegate(0, OnLoginFailed);
            if (OnlineSub.PlayerInterface.AutoLogin() == false)
            {
                ClearAutoLoginDelegates();
                return false;
            }
            return true;
        }
    }
    return false;
}

event MatineeCancelled()
{
}

function RecalculateSkillRating()
{
    local int Index;
    local array<UniqueNetId> Players;
    local UniqueNetId ZeroId;
    
    if (WorldInfo.NetMode != 0 && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
        {
            if (ZeroId != GameReplicationInfo.PRIArray[Index].UniqueId)
            {
                Players[Players.Length] = GameReplicationInfo.PRIArray[Index].UniqueId;
            }
        }
        if (Players.Length > 0)
        {
            OnlineSub.GameInterface.RecalculateSkillRating(PlayerReplicationInfoClass.default.default.SessionName, Players);
        }
    }
}

function UpdateGameplayMuteList(PlayerController PC)
{
    PC.bHasVoiceHandshakeCompleted = true;
    PC.ClientVoiceHandshakeComplete();
}

function NotifyArbitratedMatchEnd()
{
    local PlayerController PC;
    
    foreach WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (PC.IsLocalPlayerController() == false)
        {
            PC.ClientArbitratedMatchEnded();
        }
    }
    foreach WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (PC.IsLocalPlayerController())
        {
            PC.ClientArbitratedMatchEnded();
        }
    }
}

function bool MatchIsInProgress()
{
    return true;
}

function ArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
{
}

function RegisterServerForArbitration()
{
}

function StartArbitratedMatch()
{
}

function StartArbitrationRegistration()
{
}

function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful)
{
}

function UpdateGameSettingsCounts()
{
    local OnlineGameSettings GameSettings;
    
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
        if (GameSettings != none && GameSettings.bIsLanMatch)
        {
            GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - GetNumPlayers();
            if (GameSettings.NumOpenPublicConnections < 0)
            {
                GameSettings.NumOpenPublicConnections = 0;
            }
        }
    }
}

function SetSeamlessTravelViewTarget(PlayerController PC)
{
    PC.SetViewTarget(PC);
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local Rotator StartRotation;
    local NavigationPoint StartSpot;
    local PlayerController PC, NewPC;
    local PlayerReplicationInfo OldPRI;
    
    LogInternal(">> GameInfo::HandleSeamlessTravelPlayer:" @ string(C), 'SeamlessTravel');
    PC = PlayerController(C);
    if (PC != none && PC.Class != PlayerControllerClass)
    {
        if (PC.Player != none)
        {
            NewPC = SpawnPlayerController(PC.Location, PC.Rotation);
            if (NewPC == none)
            {
                WarnInternal("Failed to spawn new PlayerController for" @ PC.GetHumanReadableName() @ "(old class" @ string(PC.Class) $ ")");
                PC.Destroy();
                return;
            }
            else
            {
                PC.CleanUpAudioComponents();
                PC.SeamlessTravelTo(NewPC);
                NewPC.SeamlessTravelFrom(PC);
                SwapPlayerControllers(PC, NewPC);
                PC = NewPC;
                C = NewPC;
            }
        }
        else
        {
            PC.Destroy();
        }
    }
    else
    {
        C.PlayerReplicationInfo.Reset();
        OldPRI = C.PlayerReplicationInfo;
        C.InitPlayerReplicationInfo();
        OldPRI.SeamlessTravelTo(C.PlayerReplicationInfo);
        OldPRI.Destroy();
    }
    if (!bTeamGame && C.PlayerReplicationInfo.Team != none)
    {
        C.PlayerReplicationInfo.Team.Destroy();
        C.PlayerReplicationInfo.Team = none;
    }
    StartSpot = FindPlayerStart(C, C.GetTeamNum());
    if (StartSpot == none)
    {
        WarnInternal(GameMessageClass.default.default.FailedPlaceMessage);
    }
    else
    {
        StartRotation.Yaw = StartSpot.Rotation.Yaw;
        C.SetLocation(StartSpot.Location);
        C.SetRotation(StartRotation);
    }
    C.StartSpot = StartSpot;
    if (PC != none)
    {
        PC.CleanUpAudioComponents();
        PC.ClientInitializeDataStores();
        SetSeamlessTravelViewTarget(PC);
        if (PC.PlayerReplicationInfo.bOnlySpectator)
        {
            PC.GotoState('Spectating');
            PC.PlayerReplicationInfo.bIsSpectator = true;
            PC.PlayerReplicationInfo.bOutOfLives = true;
            NumSpectators++;
        }
        else
        {
            NumPlayers++;
            NumTravellingPlayers--;
            PC.GotoState('PlayerWaiting');
        }
    }
    else
    {
        NumBots++;
        C.GotoState('RoundEnded');
    }
    GenericPlayerInitialization(C);
    LogInternal("<< GameInfo::HandleSeamlessTravelPlayer:" @ string(C), 'SeamlessTravel');
}

function UpdateGameSettings()
{
}

event PostSeamlessTravel()
{
    local Controller C;
    
    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        if (C.bIsPlayer)
        {
            if (PlayerController(C) == none)
            {
                HandleSeamlessTravelPlayer(C);
                continue;
            }
            if (!C.PlayerReplicationInfo.bOnlySpectator)
            {
                NumTravellingPlayers++;
            }
            if (PlayerController(C).HasClientLoadedCurrentWorld())
            {
                HandleSeamlessTravelPlayer(C);
            }
        }
    }
    if (bWaitingToStartMatch && !bDelayedStart && NumPlayers + NumBots > 0)
    {
        StartMatch();
    }
    if (WorldInfo.NetMode == 1)
    {
        UpdateGameSettings();
    }
}

native final function Engine GetGameEngine()
{
}

native final function SwapPlayerControllers(PlayerController OldPC, PlayerController NewPC)
{
    OldPC;
    NewPC;
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    local int I;
    
    for (I = 0; I < WorldInfo.GRI.PRIArray.Length; I++)
    {
        WorldInfo.GRI.PRIArray[I].bFromPreviousLevel = true;
        ActorList[ActorList.Length] = WorldInfo.GRI.PRIArray[I];
    }
    if (bToEntry)
    {
        ActorList[ActorList.Length] = WorldInfo.GRI;
        if (BroadcastHandler != none)
        {
            ActorList[ActorList.Length] = BroadcastHandler;
        }
    }
    if (BaseMutator != none)
    {
        BaseMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
    }
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
    PC.PlayerReplicationInfo.OverrideWith(OldPRI);
}

function bool FindInactivePRI(PlayerController PC)
{
    local string NewNetworkAddress, NewName;
    local int I;
    local PlayerReplicationInfo OldPRI, CurrentPRI;
    local bool bIsConsole;
    
    if (PC.PlayerReplicationInfo.bOnlySpectator)
    {
        return false;
    }
    bIsConsole = WorldInfo.IsConsoleBuild();
    NewNetworkAddress = PC.PlayerReplicationInfo.SavedNetworkAddress;
    NewName = PC.PlayerReplicationInfo.PlayerName;
    for (I = 0; I < InactivePRIArray.Length; I++)
    {
        CurrentPRI = InactivePRIArray[I];
        if (CurrentPRI == none || CurrentPRI.bDeleteMe)
        {
            InactivePRIArray.Remove(I, 1);
            I--;
            continue;
        }
        if (bIsConsole && class'OnlineSubsystem'.static.AreUniqueNetIdsEqual(CurrentPRI.UniqueId, PC.PlayerReplicationInfo.UniqueId) || !bIsConsole && CurrentPRI.SavedNetworkAddress ~= NewNetworkAddress && CurrentPRI.PlayerName ~= NewName)
        {
            OldPRI = PC.PlayerReplicationInfo;
            PC.PlayerReplicationInfo = CurrentPRI;
            PC.PlayerReplicationInfo.SetOwner(PC);
            PC.PlayerReplicationInfo.RemoteRole = 1;
            PC.PlayerReplicationInfo.LifeSpan = 0.0;
            OverridePRI(PC, OldPRI);
            WorldInfo.GRI.AddPRI(PC.PlayerReplicationInfo);
            InactivePRIArray.Remove(I, 1);
            OldPRI.bIsInactive = true;
            OldPRI.Destroy();
            return true;
        }
    }
    return false;
}

function AddInactivePRI(PlayerReplicationInfo PRI, PlayerController PC)
{
    local int I;
    local PlayerReplicationInfo NewPRI, CurrentPRI;
    local bool bIsConsole;
    
    if (!PRI.bFromPreviousLevel && !PRI.bOnlySpectator)
    {
        NewPRI = PRI.Duplicate();
        WorldInfo.GRI.RemovePRI(NewPRI);
        NewPRI.RemoteRole = 0;
        NewPRI.LifeSpan = 300.0;
        bIsConsole = WorldInfo.IsConsoleBuild();
        for (I = 0; I < InactivePRIArray.Length; I++)
        {
            CurrentPRI = InactivePRIArray[I];
            if (CurrentPRI == none || CurrentPRI.bDeleteMe || !bIsConsole && CurrentPRI.SavedNetworkAddress == NewPRI.SavedNetworkAddress || bIsConsole && class'OnlineSubsystem'.static.AreUniqueNetIdsEqual(CurrentPRI.UniqueId, NewPRI.UniqueId))
            {
                InactivePRIArray.Remove(I, 1);
                I--;
            }
        }
        InactivePRIArray[InactivePRIArray.Length] = NewPRI;
        if (InactivePRIArray.Length > 16)
        {
            InactivePRIArray.Remove(0, InactivePRIArray.Length - 16);
        }
    }
    PRI.Destroy();
    RecalculateSkillRating();
}

event PostCommitMapChange()
{
}

event PreCommitMapChange(string PreviousMapName, string NextMapName)
{
}

function bool AllowPausing(optional PlayerController PC)
{
    return bPauseable || WorldInfo.NetMode == 0 || bAdminCanPause && AccessControl.IsAdmin(PC);
}

function bool AllowCheats(PlayerController P)
{
    return WorldInfo.NetMode == 0;
}

static function bool AllowMutator(string MutatorClassName)
{
    return !class'WorldInfo'.static.IsDemoBuild();
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
    return true;
}

function bool PlayerCanRestartGame(PlayerController aPlayer)
{
    return true;
}

exec function KillBots()
{
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator != none)
    {
        BaseMutator.DriverLeftVehicle(V, P);
    }
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator == none)
    {
        return true;
    }
    return BaseMutator.CanLeaveVehicle(V, P);
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator != none)
    {
        BaseMutator.DriverEnteredVehicle(V, P);
    }
}

function ModifyScoreKill(Controller Killer, Controller Other)
{
    if (BaseMutator != none)
    {
        BaseMutator.ScoreKill(Killer, Other);
    }
}

function ScoreKill(Controller Killer, Controller Other)
{
    if (Killer == Other || Killer == none)
    {
        if (Other != none && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score -= float(1);
            Other.PlayerReplicationInfo.bForceNetUpdate = true;
        }
    }
    else if (Killer.PlayerReplicationInfo != none)
    {
        Killer.PlayerReplicationInfo.Score += float(1);
        Killer.PlayerReplicationInfo.bForceNetUpdate = true;
        Killer.PlayerReplicationInfo.Kills++;
    }
    ModifyScoreKill(Killer, Other);
    if (Killer != none || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return true;
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    AddObjectiveScore(Scorer, Score);
    CheckScore(Scorer);
}

function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
    if (Scorer != none)
    {
        Scorer.Score += float(Score);
    }
    if (BaseMutator != none)
    {
        BaseMutator.ScoreObjective(Scorer, Score);
    }
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Rating;
    
    if (!P.bEnabled)
    {
        return 5.0;
    }
    else
    {
        Rating = 10.0;
        if (P.bPrimaryStart)
        {
            Rating += 10.0;
        }
        if (P.TeamIndex == int(Team))
        {
            Rating += 15.0;
        }
        return Rating;
    }
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart P, BestStart;
    local float BestRating, NewRating;
    local byte Team;
    
    Team = (Player != none && Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.Team != none ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
    foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
    {
        NewRating = RatePlayerStart(P, Team, Player);
        if (NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
    }
    return BestStart;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint N, BestStart;
    local Teleporter Tel;
    
    if (BaseMutator != none)
    {
        N = BaseMutator.FindPlayerStart(Player, InTeam, IncomingName);
        if (N != none)
        {
            return N;
        }
    }
    if (IncomingName != "")
    {
        foreach WorldInfo.AllNavigationPoints(class'Teleporter', Tel)
        {
            if (string(Tel.Tag) ~= IncomingName)
            {
                return Tel;
            }
        }
    }
    if (ShouldSpawnAtStartSpot(Player) && PlayerStart(Player.StartSpot) == none || RatePlayerStart(PlayerStart(Player.StartSpot), InTeam, Player) >= 0.0)
    {
        return Player.StartSpot;
    }
    BestStart = ChoosePlayerStart(Player, InTeam);
    if (BestStart == none && Player == none)
    {
        LogInternal("Warning - PATHS NOT DEFINED or NO PLAYERSTART with positive rating");
        foreach AllActors(class'NavigationPoint', N)
        {
            BestStart = N;
            break;
        }
    }
    return BestStart;
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return WorldInfo.NetMode == 0 && Player != none && Player.StartSpot != none && bWaitingToStartMatch || Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.bWaitingPlayer;
}

function EndLogging(string Reason)
{
}

function EndOnlineGame()
{
    local PlayerController PC;
    
    GameReplicationInfo.EndGame();
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                PC.ClientEndOnlineGame();
            }
        }
        GameInterface.EndOnlineGame(PlayerReplicationInfoClass.default.default.SessionName);
    }
}

function PerformEndGameHandling()
{
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        WriteOnlineStats();
        WriteOnlinePlayerScores();
        EndOnlineGame();
        if (bUsingArbitration)
        {
            PendingArbitrationPCs.Length = 0;
            ArbitrationPCs.Length = 0;
            NotifyArbitratedMatchEnd();
        }
    }
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    if (!CheckEndGame(Winner, Reason))
    {
        bOverTime = true;
        return;
    }
    SetTimer(1.5, false, 'PerformEndGameHandling');
    bGameEnded = true;
    EndLogging(Reason);
}

function WriteOnlinePlayerScores()
{
    local PlayerController PC;
    
    if (bUsingArbitration)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.ClientWriteOnlinePlayerScores(ArbitratedLeaderboardId);
        }
    }
    else
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.IsLocalPlayerController())
            {
                PC.ClientWriteOnlinePlayerScores(LeaderboardId);
                break;
            }
        }
    }
}

function WriteOnlineStats()
{
    local PlayerController PC;
    local OnlineGameSettings CurrentSettings;
    
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        CurrentSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
        if (CurrentSettings != none && CurrentSettings.bUsesStats)
        {
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController() == false)
                {
                    PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
                }
            }
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController())
                {
                    PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
                }
            }
        }
    }
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    
    if (CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    foreach WorldInfo.AllControllers(class'Controller', P)
    {
        P.GameHasEnded();
    }
    return true;
}

function bool CheckModifiedEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return BaseMutator != none && !BaseMutator.CheckEndGame(Winner, Reason);
}

event BroadcastLocalizedTeam(int TeamIndex, Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    BroadcastHandler.AllowBroadcastLocalizedTeam(TeamIndex, Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

event BroadcastLocalized(Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    BroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    BroadcastHandler.BroadcastTeam(Sender, msg, Type);
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    BroadcastHandler.Broadcast(Sender, msg, Type);
}

function RestartGame()
{
    local string NextMap, TransitionMapCmdLine, URLString;
    local int URLMapLen, MapNameLen;
    
    if (bUsingArbitration)
    {
        if (bIsEndGameHandshakeComplete)
        {
            NotifyArbitratedMatchEnd();
        }
        return;
    }
    if (BaseMutator != none && BaseMutator.HandleRestartGame())
    {
        return;
    }
    if (bGameRestarted)
    {
        return;
    }
    bGameRestarted = true;
    if (bChangeLevels && !bAlreadyChanged)
    {
        bAlreadyChanged = true;
        if (MyAutoTestManager != none && MyAutoTestManager.bUsingAutomatedTestingMapList)
        {
            NextMap = MyAutoTestManager.GetNextAutomatedTestingMap();
        }
        else
        {
            NextMap = GetNextMap();
        }
        if (NextMap != "")
        {
            if (MyAutoTestManager == none || !MyAutoTestManager.bUsingAutomatedTestingMapList)
            {
                WorldInfo.ServerTravel(NextMap, GetTravelType());
            }
            else if (!MyAutoTestManager.bAutomatedTestingWithOpen)
            {
                URLString = WorldInfo.GetLocalURL();
                URLMapLen = Len(URLString);
                MapNameLen = InStr(URLString, "?");
                if (MapNameLen != -1)
                {
                    URLString = Right(URLString, URLMapLen - MapNameLen);
                }
                TransitionMapCmdLine = NextMap $ URLString $ "?AutomatedTestingMapIndex=" $ string(MyAutoTestManager.AutomatedTestingMapIndex);
                LogInternal(">>> Issuing server travel on " $ TransitionMapCmdLine);
                WorldInfo.ServerTravel(TransitionMapCmdLine, GetTravelType());
            }
            else
            {
                TransitionMapCmdLine = "?AutomatedTestingMapIndex=" $ string(MyAutoTestManager.AutomatedTestingMapIndex) $ "?NumberOfMatchesPlayed=" $ string(MyAutoTestManager.NumberOfMatchesPlayed) $ "?NumMapListCyclesDone=" $ string(MyAutoTestManager.NumMapListCyclesDone);
                LogInternal(">>> Issuing open command on " $ NextMap $ TransitionMapCmdLine);
                ConsoleCommand("open " $ NextMap $ TransitionMapCmdLine);
            }
            return;
        }
    }
    WorldInfo.ServerTravel("?Restart", GetTravelType());
}

function bool GetTravelType()
{
    return false;
}

function string GetNextMap()
{
}

function SendPlayer(PlayerController aPlayer, string URL)
{
    aPlayer.ClientTravel(URL, 2);
}

function byte PickTeam(byte Current, Controller C)
{
    return Current;
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    return true;
}

function ChangeName(Controller Other, coerce string S, bool bNameChange)
{
    if (S == "")
    {
        return;
    }
    Other.PlayerReplicationInfo.SetPlayerName(S);
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
    if (Other.InvManager != none)
    {
        Other.InvManager.DiscardInventory();
    }
}

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
    local byte bAllowPickup;
    
    if (BaseMutator != none && BaseMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup))
    {
        return bool(bAllowPickup);
    }
    if (Other.InvManager == none)
    {
        return false;
    }
    else
    {
        return Other.InvManager.HandlePickupQuery(ItemClass, Pickup);
    }
}

function bool ShouldRespawn(PickupFactory Other)
{
    return WorldInfo.NetMode != 0;
}

function bool CheckRelevance(Actor Other)
{
    if (!Other.bLoadIfPhysXLevel0)
    {
        if (GetGameEngine().PhysXLevel == 0)
        {
            return false;
        }
    }
    if (!Other.bLoadIfPhysXLevel1)
    {
        if (GetGameEngine().PhysXLevel == 1)
        {
            return false;
        }
    }
    if (!Other.bLoadIfPhysXLevel2)
    {
        if (GetGameEngine().PhysXLevel == 2)
        {
            return false;
        }
    }
    if (BaseMutator == none)
    {
        return true;
    }
    return BaseMutator.CheckRelevance(Other);
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    local int OriginalDamage;
    
    OriginalDamage = Damage;
    if (injured.PhysicsVolume.bNeutralZone || injured.InGodMode())
    {
        Damage = 0;
        return;
    }
    else if (Damage > 0 && injured.InvManager != none)
    {
        injured.InvManager.ModifyDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    if (BaseMutator != none)
    {
        BaseMutator.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    }
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    return true;
}

function KickBan(string S)
{
    if (AccessControl != none)
    {
        AccessControl.KickBan(S);
    }
}

function Kick(string S)
{
    if (AccessControl != none)
    {
        AccessControl.Kick(S);
    }
}

static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage)
{
    return Repl(Repl(DeathMessage, "`k", KillerName), "`o", VictimName);
}

function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType)
{
    if (Killer == Other || Killer == none)
    {
        BroadcastLocalized(self, DeathMessageClass, 1, none, Other.PlayerReplicationInfo, DamageType);
    }
    else
    {
        BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
    }
}

function bool PreventDeath(Pawn KilledPawn, Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    if (BaseMutator == none)
    {
        return false;
    }
    return BaseMutator.PreventDeath(KilledPawn, Killer, DamageType, HitLocation);
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    if (KilledPlayer != none && KilledPlayer.bIsPlayer)
    {
        KilledPlayer.PlayerReplicationInfo.IncrementDeaths();
        KilledPlayer.PlayerReplicationInfo.SetNetUpdateTime(FMin(KilledPlayer.PlayerReplicationInfo.NetUpdateTime, WorldInfo.TimeSeconds + 0.3 * FRand()));
        BroadcastDeathMessage(Killer, KilledPlayer, DamageType);
    }
    if (KilledPlayer != none)
    {
        ScoreKill(Killer, KilledPlayer);
    }
    DiscardInventory(KilledPawn, Killer);
    NotifyKilled(Killer, KilledPlayer, KilledPawn);
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local Controller C;
    
    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        C.NotifyKilled(Killer, Killed, KilledPawn);
    }
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
    PlayerPawn.AirControl = PlayerPawn.default.AirControl;
    PlayerPawn.GroundSpeed = PlayerPawn.default.GroundSpeed;
    PlayerPawn.WaterSpeed = PlayerPawn.default.WaterSpeed;
    PlayerPawn.AirSpeed = PlayerPawn.default.AirSpeed;
    PlayerPawn.Acceleration = PlayerPawn.default.Acceleration;
    PlayerPawn.AccelRate = PlayerPawn.default.AccelRate;
    PlayerPawn.JumpZ = PlayerPawn.default.JumpZ;
    if (BaseMutator != none)
    {
        BaseMutator.ModifyPlayer(PlayerPawn);
    }
    PlayerPawn.PhysicsVolume.ModifyPlayer(PlayerPawn);
}

function Mutate(string MutateString, PlayerController Sender)
{
    if (BaseMutator != none)
    {
        BaseMutator.Mutate(MutateString, Sender);
    }
}

event AddDefaultInventory(Pawn P)
{
    P.AddDefaultInventory();
    if (P.InvManager == none)
    {
        WarnInternal("GameInfo::AddDefaultInventory - P.InvManager == None");
    }
}

event AcceptInventory(Pawn PlayerPawn)
{
}

function UnregisterPlayer(PlayerController PC)
{
    if (WorldInfo.NetMode != 0 && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)) && GameInterface.GetGameSettings(PC.PlayerReplicationInfo.SessionName) != none)
    {
        GameInterface.UnregisterPlayer(PC.PlayerReplicationInfo.SessionName, PC.PlayerReplicationInfo.UniqueId);
    }
}

function Logout(Controller Exiting)
{
    local PlayerController PC;
    local int PCIndex;
    
    PC = PlayerController(Exiting);
    if (PC != none)
    {
        if (AccessControl != none && AccessControl.AdminLogout(PlayerController(Exiting)))
        {
            AccessControl.AdminExited(PlayerController(Exiting));
        }
        if (PC.PlayerReplicationInfo.bOnlySpectator)
        {
            NumSpectators--;
        }
        else
        {
            if (WorldInfo.IsInSeamlessTravel() || PC.HasClientLoadedCurrentWorld())
            {
                NumPlayers--;
            }
            else
            {
                NumTravellingPlayers--;
            }
            UpdateGameSettingsCounts();
        }
        if (bUsingArbitration && bHasArbitratedHandshakeBegun && !bHasEndGameHandshakeBegun)
        {
            LogInternal("Player " $ PC.PlayerReplicationInfo.PlayerName $ " has dropped");
        }
        UnregisterPlayer(PC);
        if (bUsingArbitration)
        {
            PCIndex = ArbitrationPCs.Find(PC);
            if (PCIndex != -1)
            {
                ArbitrationPCs.Remove(PCIndex, 1);
            }
        }
    }
    if (BaseMutator != none)
    {
        BaseMutator.NotifyLogout(Exiting);
    }
    UpdateNetSpeeds();
}

event PreExit()
{
}

function int CalculatedNetSpeed()
{
    return Clamp(TotalNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
}

function UpdateNetSpeeds()
{
    local int NewNetSpeed;
    local PlayerController PC;
    local OnlineGameSettings GameSettings;
    
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
    }
    if (WorldInfo.NetMode == 1 || WorldInfo.NetMode == 0 || GameSettings != none && GameSettings.bIsLanMatch)
    {
        return;
    }
    if (WorldInfo.TimeSeconds - LastNetSpeedUpdateTime < 1.0)
    {
        SetTimer(1.0, false, 'UpdateNetSpeeds');
        return;
    }
    LastNetSpeedUpdateTime = WorldInfo.TimeSeconds;
    NewNetSpeed = CalculatedNetSpeed();
    LogInternal("New Dynamic NetSpeed " $ string(NewNetSpeed) $ " vs old " $ string(AdjustedNetSpeed));
    if (AdjustedNetSpeed != NewNetSpeed)
    {
        AdjustedNetSpeed = NewNetSpeed;
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.SetNetSpeed(AdjustedNetSpeed);
        }
    }
}

event PostLogin(PlayerController NewPlayer)
{
    local string Address, StatGuid;
    local int pos, I;
    local Sequence GameSeq;
    local array<SequenceObject> AllInterpActions;
    
    if (NewPlayer.PlayerReplicationInfo.bOnlySpectator)
    {
        NumSpectators++;
    }
    else if (WorldInfo.IsInSeamlessTravel() || NewPlayer.HasClientLoadedCurrentWorld())
    {
        NumPlayers++;
    }
    else
    {
        NumTravellingPlayers++;
    }
    UpdateGameSettingsCounts();
    Address = NewPlayer.GetPlayerNetworkAddress();
    pos = InStr(Address, ":");
    NewPlayer.PlayerReplicationInfo.SavedNetworkAddress = (pos > 0 ? Left(Address, pos) : Address);
    FindInactivePRI(NewPlayer);
    if (!bDelayedStart)
    {
        bRestartLevel = false;
        if (bWaitingToStartMatch)
        {
            StartMatch();
        }
        else
        {
            RestartPlayer(NewPlayer);
        }
        bRestartLevel = default.bRestartLevel;
    }
    if (NewPlayer.Pawn != none)
    {
        NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
    }
    NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
    UpdateNetSpeeds();
    GenericPlayerInitialization(NewPlayer);
    if (GameReplicationInfo.bMatchHasBegun && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
        if (StatGuid != "")
        {
            NewPlayer.ClientRegisterHostStatGuid(StatGuid);
        }
    }
    if (bRequiresPushToTalk)
    {
        NewPlayer.ClientStopNetworkedVoice();
    }
    else
    {
        NewPlayer.ClientStartNetworkedVoice();
    }
    if (NewPlayer.PlayerReplicationInfo.bOnlySpectator)
    {
        NewPlayer.ClientGotoState('Spectating');
    }
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, AllInterpActions);
        for (I = 0; I < AllInterpActions.Length; I++)
        {
            SeqAct_Interp(AllInterpActions[I]).AddPlayerToDirectorTracks(NewPlayer);
        }
    }
}

function GenericPlayerInitialization(Controller C)
{
    local PlayerController PC;
    
    PC = PlayerController(C);
    if (PC != none)
    {
        UpdateGameplayMuteList(PC);
        PC.ClientSetHUD(HUDType, ScoreBoardType);
        ReplicateStreamingStatus(PC);
        if (CoverReplicatorBase != none)
        {
            PC.SpawnCoverReplicator();
        }
        PC.ClientSetOnlineStatus();
    }
    if (BaseMutator != none)
    {
        BaseMutator.NotifyLogin(C);
    }
}

function ReplicateStreamingStatus(PlayerController PC)
{
    local int LevelIndex;
    local LevelStreaming TheLevel;
    
    if (LocalPlayer(PC.Player) == none && ChildConnection(PC.Player) == none)
    {
        if (WorldInfo.CommittedPersistentLevelName != 'None')
        {
            PC.ClientPrepareMapChange(WorldInfo.CommittedPersistentLevelName, true, true);
            PC.ClientCommitMapChange();
        }
        if (WorldInfo.StreamingLevels.Length > 0)
        {
            for (LevelIndex = 0; LevelIndex < WorldInfo.StreamingLevels.Length; LevelIndex++)
            {
                TheLevel = WorldInfo.StreamingLevels[LevelIndex];
                if (TheLevel != none)
                {
                    LogInternal("levelStatus: " $ string(TheLevel.PackageName) $ " " $ string(TheLevel.bShouldBeVisible) $ " " $ string(TheLevel.bIsVisible) $ " " $ string(TheLevel.bShouldBeLoaded) $ " " $ string(TheLevel.LoadedLevel) $ " " $ string(TheLevel.bHasLoadRequestPending) $ " ");
                    PC.ClientUpdateLevelStreamingStatus(TheLevel.PackageName, TheLevel.bShouldBeLoaded, TheLevel.bShouldBeVisible, TheLevel.bShouldBlockOnLoad);
                }
            }
            PC.ClientFlushLevelStreaming();
        }
        if (WorldInfo.PreparingLevelNames.Length > 0)
        {
            for (LevelIndex = 0; LevelIndex < WorldInfo.PreparingLevelNames.Length; LevelIndex++)
            {
                PC.ClientPrepareMapChange(WorldInfo.PreparingLevelNames[LevelIndex], LevelIndex == 0, LevelIndex == WorldInfo.PreparingLevelNames.Length - 1);
            }
        }
    }
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    return DefaultPawnClass;
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;
    
    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rotation.Yaw;
    ResultPawn = Spawn(DefaultPlayerClass, , , StartSpot.Location, StartRotation);
    if (ResultPawn == none)
    {
        LogInternal("Couldn't spawn player of type " $ string(DefaultPlayerClass) $ " at " $ string(StartSpot));
    }
    return ResultPawn;
}

function RestartPlayer(Controller NewPlayer)
{
    local NavigationPoint StartSpot;
    local int TeamNum, Idx;
    local array<SequenceObject> Events;
    local SeqEvent_PlayerSpawned SpawnedEvent;
    
    if (bRestartLevel && WorldInfo.NetMode != 1 && WorldInfo.NetMode != 2)
    {
        WarnInternal("bRestartLevel && !server, abort from RestartPlayer" @ string(WorldInfo.NetMode));
        return;
    }
    TeamNum = (NewPlayer.PlayerReplicationInfo == none || NewPlayer.PlayerReplicationInfo.Team == none ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex);
    StartSpot = FindPlayerStart(NewPlayer, byte(TeamNum));
    if (StartSpot == none)
    {
        if (NewPlayer.StartSpot != none)
        {
            StartSpot = NewPlayer.StartSpot;
            WarnInternal("Player start not found, using last start spot");
        }
        else
        {
            WarnInternal("Player start not found, failed to restart player");
            return;
        }
    }
    if (NewPlayer.Pawn == none)
    {
        NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
    }
    if (NewPlayer.Pawn == none)
    {
        LogInternal("failed to spawn player at " $ string(StartSpot));
        NewPlayer.GotoState('Dead');
        if (PlayerController(NewPlayer) != none)
        {
            PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
        }
    }
    else
    {
        NewPlayer.Pawn.SetAnchor(StartSpot);
        if (PlayerController(NewPlayer) != none)
        {
            PlayerController(NewPlayer).TimeMargin = -0.1;
            StartSpot.AnchoredPawn = none;
        }
        NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
        NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
        NewPlayer.Possess(NewPlayer.Pawn, false);
        NewPlayer.Pawn.PlayTeleportEffect(true, true);
        NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation, true);
        if (!WorldInfo.bNoDefaultInventoryForPlayer)
        {
            AddDefaultInventory(NewPlayer.Pawn);
        }
        SetPlayerDefaults(NewPlayer.Pawn);
        if (WorldInfo.GetGameSequence() != none)
        {
            WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_PlayerSpawned', true, Events);
            for (Idx = 0; Idx < Events.Length; Idx++)
            {
                SpawnedEvent = SeqEvent_PlayerSpawned(Events[Idx]);
                if (SpawnedEvent != none && SpawnedEvent.CheckActivate(NewPlayer, NewPlayer))
                {
                    SpawnedEvent.SpawnPoint = StartSpot;
                    SpawnedEvent.PopulateLinkedVariableValues();
                }
            }
        }
    }
}

function StartBots()
{
    local Controller P;
    
    foreach WorldInfo.AllControllers(class'Controller', P)
    {
        if (P.bIsPlayer && !P.IsA('PlayerController'))
        {
            if (WorldInfo.NetMode == 0)
            {
                RestartPlayer(P);
                continue;
            }
            P.GotoState('Dead', 'MPStart');
        }
    }
}

function StartHumans()
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        if (P.Pawn == none)
        {
            if (bGameEnded)
            {
                return;
                continue;
            }
            if (P.CanRestartPlayer())
            {
                RestartPlayer(P);
            }
        }
    }
}

function OnStartOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
    local PlayerController PC;
    local string StatGuid;
    
    GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
    if (bWasSuccessful && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
        if (StatGuid != "")
        {
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController() == false)
                {
                    PC.ClientRegisterHostStatGuid(StatGuid);
                }
            }
        }
    }
    GameReplicationInfo.StartMatch();
}

function StartOnlineGame()
{
    local PlayerController PC;
    
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                PC.ClientStartOnlineGame();
            }
        }
        GameInterface.AddStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
        GameInterface.StartOnlineGame(PlayerReplicationInfoClass.default.default.SessionName);
    }
    else
    {
        GameReplicationInfo.StartMatch();
    }
}

function StartMatch()
{
    local Actor A;
    
    if (MyAutoTestManager != none)
    {
        MyAutoTestManager.StartMatch();
    }
    foreach AllActors(class'Actor', A)
    {
        A.MatchStarting();
    }
    StartHumans();
    StartBots();
    bWaitingToStartMatch = false;
    StartOnlineGame();
    WorldInfo.NotifyMatchStarted();
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local NavigationPoint StartSpot;
    local PlayerController NewPlayer;
    local string InName, inCharacter, InPassword;
    local byte InTeam;
    local bool bSpectator, bAdmin, bPerfTesting;
    local Rotator SpawnRotation;
    local OnlineGameSettings GameSettings;
    local UniqueNetId ZeroId;
    
    bAdmin = false;
    if (bUsingArbitration && bHasArbitratedHandshakeBegun)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
        return none;
    }
    if (BaseMutator != none)
    {
        BaseMutator.ModifyLogin(Portal, Options);
    }
    bPerfTesting = ParseOption(Options, "AutomatedPerfTesting") ~= "1";
    bSpectator = bPerfTesting || ParseOption(Options, "SpectatorOnly") ~= "1";
    InName = Left(ParseOption(Options, "Name"), 20);
    InTeam = byte(GetIntOption(Options, "Team", 255));
    InPassword = ParseOption(Options, "Password");
    if (AccessControl != none)
    {
        bAdmin = AccessControl.ParseAdminOptions(Options);
    }
    if (!bAdmin && AtCapacity(bSpectator))
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";
        return none;
    }
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
    }
    if (WorldInfo.Game.AccessControl != none && WorldInfo.Game.AccessControl.IsIDBanned(UniqueId))
    {
        LogInternal(InName @ "is banned, rejecting...");
        ErrorMessage = "Engine.AccessControl.SessionBanned";
        return none;
    }
    else if (WorldInfo.IsConsoleBuild() && GameSettings != none && !GameSettings.bIsLanMatch && UniqueId == ZeroId)
    {
        LogInternal(InName @ "is not validated/signed in, rejecting...");
        ErrorMessage = "Engine.AccessControl.SessionBanned";
        return none;
    }
    if (bAdmin && AtCapacity(false))
    {
        bSpectator = true;
    }
    InTeam = PickTeam(InTeam, none);
    StartSpot = FindPlayerStart(none, InTeam, Portal);
    if (StartSpot == none)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedPlaceMessage";
        return none;
    }
    SpawnRotation.Yaw = StartSpot.Rotation.Yaw;
    NewPlayer = SpawnPlayerController(StartSpot.Location, SpawnRotation);
    if (NewPlayer == none)
    {
        LogInternal("Couldn't spawn player controller of class " $ string(PlayerControllerClass));
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedSpawnMessage";
        return none;
    }
    NewPlayer.StartSpot = StartSpot;
    NewPlayer.PlayerReplicationInfo.PlayerID = GetNextPlayerID();
    NewPlayer.PlayerReplicationInfo.SetUniqueId(UniqueId);
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        WorldInfo.Game.OnlineSub.GameInterface.RegisterPlayer(PlayerReplicationInfoClass.default.default.SessionName, UniqueId, HasOption(Options, "bIsFromInvite"));
    }
    RecalculateSkillRating();
    if (InName == "")
    {
        InName = DefaultPlayerName $ string(NewPlayer.PlayerReplicationInfo.PlayerID);
    }
    ChangeName(NewPlayer, InName, false);
    inCharacter = ParseOption(Options, "Character");
    NewPlayer.SetCharacter(inCharacter);
    if (bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator || !ChangeTeam(NewPlayer, int(InTeam), false))
    {
        NewPlayer.GotoState('Spectating');
        NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
        NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
        NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
        return NewPlayer;
    }
    if (AccessControl != none && AccessControl.AdminLogin(NewPlayer, InPassword))
    {
        AccessControl.AdminEntered(NewPlayer);
    }
    if (bDelayedStart)
    {
        NewPlayer.GotoState('PlayerWaiting');
        return NewPlayer;
    }
    return NewPlayer;
}

function PlayerController SpawnPlayerController(Vector SpawnLocation, Rotator SpawnRotation)
{
    return Spawn(PlayerControllerClass, , , SpawnLocation, SpawnRotation);
}

native final function int GetNextPlayerID()
{
}

function bool AtCapacity(bool bSpectator)
{
    if (WorldInfo.NetMode == 0)
    {
        return false;
    }
    if (bSpectator)
    {
        return NumSpectators >= MaxSpectators && WorldInfo.NetMode != 2 || NumPlayers > 0;
    }
    else
    {
        return MaxPlayers > 0 && GetNumPlayers() >= MaxPlayers;
    }
}

event PreLogin(string Options, string Address, out string ErrorMessage)
{
    local bool bSpectator, bPerfTesting;
    
    if (WorldInfo.NetMode != 0 && bUsingArbitration && bHasArbitratedHandshakeBegun)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
        return;
    }
    bPerfTesting = ParseOption(Options, "AutomatedPerfTesting") ~= "1";
    bSpectator = bPerfTesting || ParseOption(Options, "SpectatorOnly") ~= "1";
    if (AccessControl != none)
    {
        AccessControl.PreLogin(Options, Address, ErrorMessage, bSpectator);
    }
}

function bool RequiresPassword()
{
    return AccessControl != none && AccessControl.RequiresPassword();
}

function PlayerController ProcessClientTravel(out string URL, Guid NextMapGuid, bool bSeamless, bool bAbsolute)
{
    local PlayerController P, LP;
    
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        if (NetConnection(P.Player) != none)
        {
            P.ClientTravel(URL, 2, bSeamless, NextMapGuid);
            continue;
        }
        LP = P;
        P.PreClientTravel(URL, bAbsolute ? 0 : 2, bSeamless);
    }
    return LP;
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
    local PlayerController LocalPlayer;
    local bool bSeamless;
    local string NextMap;
    local Guid NextMapGuid;
    local int OptionStart;
    
    bLevelChange = true;
    EndLogging("mapchange");
    bSeamless = bUseSeamlessTravel && WorldInfo.TimeSeconds < 172800.0;
    if (InStr(Caps(URL), "?RESTART") != -1)
    {
        NextMap = string(WorldInfo.GetPackageName());
    }
    else
    {
        OptionStart = InStr(URL, "?");
        if (OptionStart == -1)
        {
            NextMap = URL;
        }
        else
        {
            NextMap = Left(URL, OptionStart);
        }
    }
    NextMapGuid = GetPackageGuid(name(NextMap));
    LocalPlayer = ProcessClientTravel(URL, NextMapGuid, bSeamless, bAbsolute);
    LogInternal("ProcessServerTravel:" @ URL);
    WorldInfo.NextURL = URL;
    if (WorldInfo.NetMode == 2 && LocalPlayer != none)
    {
        WorldInfo.NextURL $= "?Team=" $ LocalPlayer.GetDefaultURL("Team") $ "?Name=" $ LocalPlayer.GetDefaultURL("Name") $ "?Class=" $ LocalPlayer.GetDefaultURL("Class") $ "?Character=" $ LocalPlayer.GetDefaultURL("Character");
    }
    if (bSeamless)
    {
        WorldInfo.SeamlessTravel(WorldInfo.NextURL, bAbsolute);
        WorldInfo.NextURL = "";
    }
    else if (WorldInfo.NetMode != 1 && WorldInfo.NetMode != 2)
    {
        WorldInfo.NextSwitchCountdown = 0.0;
    }
}

function RemoveMutator(Mutator MutatorToRemove)
{
    local Mutator M;
    
    if (BaseMutator == MutatorToRemove)
    {
        BaseMutator = MutatorToRemove.NextMutator;
    }
    else if (BaseMutator != none)
    {
        M = BaseMutator;
        while (M != none)
        {
            if (M.NextMutator == MutatorToRemove)
            {
                M.NextMutator = MutatorToRemove.NextMutator;
                break;
            }
            M = M.NextMutator;
        }
    }
}

function AddMutator(string mutname, optional bool bUserAdded)
{
    local class<Mutator> mutClass;
    local Mutator mut;
    local int I;
    
    if (!AllowMutator(mutname))
    {
        return;
    }
    mutClass = class<Mutator>(DynamicLoadObject(mutname, class'Core.Class'));
    if (mutClass == none)
    {
        return;
    }
    if (mutClass.default.default.GroupNames.Length > 0 && BaseMutator != none)
    {
        mut = BaseMutator;
        while (mut != none)
        {
            for (I = 0; I < mut.GroupNames.Length; I++)
            {
                if (mutClass.default.default.GroupNames.Find(mut.GroupNames[I]) != -1)
                {
                    LogInternal("Not adding " $ string(mutClass) $ " because already have a mutator in the same group - " $ string(mut));
                    return;
                }
            }
            mut = mut.NextMutator;
        }
    }
    mut = BaseMutator;
    while (mut != none)
    {
        if (mut.Class == mutClass)
        {
            LogInternal("Not adding " $ string(mutClass) $ " because this mutator is already added - " $ string(mut));
            return;
        }
        mut = mut.NextMutator;
    }
    mut = Spawn(mutClass);
    if (mut == none)
    {
        return;
    }
    mut.bUserAdded = bUserAdded;
    if (BaseMutator == none)
    {
        BaseMutator = mut;
    }
    else
    {
        BaseMutator.AddMutator(mut);
    }
}

event NotifyPendingConnectionLost()
{
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt, LeftOpt;
    local int pos;
    local class<AccessControl> ACClass;
    local OnlineGameSettings GameSettings;
    
    MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, MaxPlayersAllowed);
    MaxSpectators = Clamp(GetIntOption(Options, "MaxSpectators", MaxSpectators), 0, MaxSpectatorsAllowed);
    GameDifficulty = FMax(0.0, float(GetIntOption(Options, "Difficulty", int(GameDifficulty))));
    InOpt = ParseOption(Options, "GameSpeed");
    if (InOpt != "")
    {
        LogInternal("GameSpeed" @ InOpt);
        SetGameSpeed(float(InOpt));
    }
    TimeLimit = Max(0, GetIntOption(Options, "TimeLimit", TimeLimit));
    BroadcastHandler = Spawn(BroadcastHandlerClass);
    InOpt = ParseOption(Options, "AccessControl");
    if (InOpt != "")
    {
        ACClass = class<AccessControl>(DynamicLoadObject(InOpt, class'Core.Class'));
    }
    if (ACClass == none)
    {
        ACClass = AccessControlClass;
    }
    LeftOpt = ParseOption(Options, "AdminName");
    InOpt = ParseOption(Options, "AdminPassword");
    if (WorldInfo.NetMode == 2 || WorldInfo.NetMode == 1)
    {
        AccessControl = Spawn(ACClass);
        if (AccessControl != none && InOpt != "")
        {
            AccessControl.SetAdminPassword(InOpt);
        }
    }
    InOpt = ParseOption(Options, "Mutator");
    if (InOpt != "")
    {
        LogInternal("Mutators" @ InOpt);
        while (InOpt != "")
        {
            pos = InStr(InOpt, ",");
            if (pos > 0)
            {
                LeftOpt = Left(InOpt, pos);
                InOpt = Right(InOpt, Len(InOpt) - pos - 1);
            }
            else
            {
                LeftOpt = InOpt;
                InOpt = "";
            }
            AddMutator(LeftOpt, true);
        }
    }
    InOpt = ParseOption(Options, "GamePassword");
    if (InOpt != "" && AccessControl != none)
    {
        AccessControl.SetGamePassword(InOpt);
        LogInternal("GamePassword" @ InOpt);
    }
    bFixedPlayerStart = ParseOption(Options, "FixedPlayerStart") ~= "1";
    CauseEventCommand = ParseOption(Options, "causeevent");
    if (ParseOption(Options, "AutoTests") ~= "1")
    {
        if (MyAutoTestManager == none)
        {
            MyAutoTestManager = Spawn(AutoTestManagerClass);
        }
        MyAutoTestManager.InitializeOptions(Options);
    }
    if (MyCheckPointManager == none)
    {
        MyCheckPointManager = Spawn(CheckPointManagerClass, self);
    }
    BugLocString = ParseOption(Options, "BugLoc");
    BugRotString = ParseOption(Options, "BugRot");
    if (BaseMutator != none)
    {
        BaseMutator.InitMutator(Options, ErrorMessage);
    }
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
            if (GameSettings != none)
            {
                bUsingArbitration = GameSettings.bUsesArbitration;
            }
        }
    }
    if (WorldInfo.IsConsoleBuild(0) == false && WorldInfo.NetMode != 0 && GameSettings == none)
    {
        ServerOptions = Options;
        if (ProcessServerLogin() == false)
        {
            RegisterServer();
        }
    }
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.Class;
}

static event string GetDefaultGameClassPath(string MapName, string Options, string Portal)
{
    return PathName(default.Class);
}

static function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
    local string InOpt;
    
    InOpt = ParseOption(Options, ParseString);
    if (InOpt != "")
    {
        return int(InOpt);
    }
    return CurrentValue;
}

static function bool HasOption(string Options, string InKey)
{
    local string Pair, Key, Value;
    
    while (GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        if (Key ~= InKey)
        {
            return true;
        }
    }
    return false;
}

static function string ParseOption(string Options, string InKey)
{
    local string Pair, Key, Value;
    
    while (GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        if (Key ~= InKey)
        {
            return Value;
        }
    }
    return "";
}

static function GetKeyValue(string Pair, out string Key, out string Value)
{
    if (InStr(Pair, "=") >= 0)
    {
        Key = Left(Pair, InStr(Pair, "="));
        Value = Mid(Pair, InStr(Pair, "=") + 1);
    }
    else
    {
        Key = Pair;
        Value = "";
    }
}

static function bool GrabOption(out string Options, out string Result)
{
    if (Left(Options, 1) == "?")
    {
        Result = Mid(Options, 1);
        if (InStr(Result, "?") >= 0)
        {
            Result = Left(Result, InStr(Result, "?"));
        }
        Options = Mid(Options, 1);
        if (InStr(Options, "?") >= 0)
        {
            Options = Mid(Options, InStr(Options, "?"));
        }
        else
        {
            Options = "";
        }
        return true;
    }
    else
    {
        return false;
    }
}

event SetGameSpeedEx(float T)
{
    SetGameSpeed(T);
}

function SetGameSpeed(float T)
{
    GameSpeed = FMax(T, 0.1);
    WorldInfo.TimeDilation = GameSpeed;
    SetTimer(WorldInfo.TimeDilation, true);
}

function DebugPause()
{
    local int Index;
    local delegate<CanUnpause> CanUnpauseCriteriaMet;
    
    for (Index = 0; Index < Pausers.Length; Index++)
    {
        CanUnpauseCriteriaMet = Pausers[Index];
        if (CanUnpause())
        {
            LogInternal("Pauser in index " $ string(Index) $ " thinks it's ok to unpause:" @ string(CanUnpauseCriteriaMet));
            continue;
        }
        LogInternal("Pauser in index " $ string(Index) $ " thinks the game should remain paused:" @ string(CanUnpauseCriteriaMet));
    }
}

native final function ForceClearUnpauseDelegates(Actor PauseActor)
{
    PauseActor;
}

event ClearPause()
{
    local int Index;
    local delegate<CanUnpause> CanUnpauseCriteriaMet;
    
    if (!AllowPausing() && Pausers.Length > 0)
    {
        LogInternal("Clearing list of UnPause delegates for" @ string(Name) @ "because game type is not pauseable");
        Pausers.Length = 0;
    }
    for (Index = 0; Index < Pausers.Length; Index++)
    {
        CanUnpauseCriteriaMet = Pausers[Index];
        if (CanUnpause())
        {
            Pausers.Remove(Index--, 1);
        }
    }
    if (Pausers.Length == 0)
    {
        WorldInfo.Pauser = none;
    }
}

function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local int FoundIndex;
    
    if (AllowPausing(PC))
    {
        FoundIndex = Pausers.Find(CanUnpauseDelegate);
        if (FoundIndex == -1)
        {
            FoundIndex = Pausers.Length;
            Pausers.Length = FoundIndex + 1;
            Pausers[FoundIndex] = CanUnpauseDelegate;
        }
        if (WorldInfo.Pauser == none)
        {
            WorldInfo.Pauser = PC.PlayerReplicationInfo;
        }
        return true;
    }
    return false;
}

delegate bool CanUnpause()
{
    return true;
}

function int GetServerPort()
{
    local string S;
    local int I;
    
    S = WorldInfo.GetAddressURL();
    I = InStr(S, ":");
    assert(I >= 0);
    return int(Mid(S, I + 1));
}

function int GetNumPlayers()
{
    return NumPlayers + NumTravellingPlayers;
}

native function string GetNetworkNumber()
{
}

function InitGameReplicationInfo()
{
    GameReplicationInfo.GameClass = Class;
    GameReplicationInfo.ReceivedGameClass();
}

event ForceKickPlayer(PlayerController PC, string KickReason)
{
    LogInternal("Force kicking player " $ PC.PlayerReplicationInfo.GetPlayerAlias());
    AccessControl.ForceKickPlayer(PC, KickReason);
}

event KickIdler(PlayerController PC)
{
    LogInternal("Kicking idle player " $ PC.PlayerReplicationInfo.PlayerName);
    AccessControl.KickPlayer(PC, AccessControl.IdleKickReason);
}

event GameEnding()
{
    EndLogging("serverquit");
}

function NotifyNavigationChanged(NavigationPoint N)
{
}

native final function DoNavFearCostFallOff()
{
}

event Timer()
{
    BroadcastHandler.UpdateSentText();
    if (bDoFearCostFallOff)
    {
        DoNavFearCostFallOff();
    }
}

function ResetLevel()
{
    local Controller C;
    local Actor A;
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;
    local array<int> ActivateIndices;
    local int I;
    
    LogInternal("Reset" @ string(self));
    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        if (PlayerController(C) != none)
        {
            PlayerController(C).ClientReset();
        }
        C.Reset();
    }
    foreach AllActors(class'Actor', A)
    {
        if (A != self && !A.IsA('Controller') && ShouldReset(A))
        {
            A.Reset();
        }
    }
    Reset();
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none)
    {
        GameSeq.Reset();
        GameSeq.FindSeqObjectsByClass(class'SeqEvent_LevelLoaded', true, AllSeqEvents);
        ActivateIndices[0] = 2;
        for (I = 0; I < AllSeqEvents.Length; I++)
        {
            SeqEvent_LevelLoaded(AllSeqEvents[I]).CheckActivate(WorldInfo, none, false, ActivateIndices);
        }
    }
}

function bool ShouldReset(Actor ActorToReset)
{
    return true;
}

function Reset()
{
    Reset();
    bGameEnded = false;
    bOverTime = false;
    InitGameReplicationInfo();
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Game:" $ GameName);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (WorldInfo.PopulationManager != none)
    {
        WorldInfo.PopulationManager.DisplayDebug(HUD, out_YL, out_YPos);
    }
}

event PostBeginPlay()
{
    if (MaxIdleTime > float(0))
    {
        MaxIdleTime = FMax(MaxIdleTime, 20.0);
    }
    if (WorldInfo.NetMode == 1)
    {
        UpdateGameSettings();
    }
}

function CoverReplicator GetCoverReplicator()
{
    if (CoverReplicatorBase == none && WorldInfo.NetMode != 0)
    {
        CoverReplicatorBase = Spawn(class'CoverReplicator');
    }
    return CoverReplicatorBase;
}

static function bool UseLowGore(WorldInfo WI)
{
    return default.GoreLevel > 0 && WI.NetMode != 1;
}

function string FindPlayerByID(int PlayerID)
{
    local PlayerReplicationInfo PRI;
    
    PRI = GameReplicationInfo.FindPlayerByID(PlayerID);
    if (PRI != none)
    {
        return PRI.PlayerName;
    }
    return "";
}

event PreBeginPlay()
{
    AdjustedNetSpeed = MaxDynamicBandwidth;
    SetGameSpeed(GameSpeed);
    GameReplicationInfo = Spawn(GameReplicationInfoClass);
    WorldInfo.GRI = GameReplicationInfo;
    InitGameReplicationInfo();
}

event ChangeDressCompleted()
{
}

event ToggleCritical(bool Actived)
{
}

native function ResumeAllNpcTick()
{
}

native function PauseAllNpcTick(array<Object> ExceptNpcs)
{
    ExceptNpcs;
}

native function bool GetMapCommonPackageName(out const string InFilename, out string OutCommonPackageName)
{
    InFilename;
    OutCommonPackageName;
}

native function bool GetSupportedGameTypes(out const string InFilename, out GameTypePrefix OutGameType, optional bool bCheckExt = false)
{
    InFilename;
    OutGameType;
    bCheckExt;
}

state TravelTheWorld
{
    Stop;
}

auto state PendingMatch
{
    event EndState(name NextStateName)
    {
        SetTimer(0.0, false, 'ArbitrationTimeout');
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
        }
    }
    
    function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful)
    {
        local int FoundIndex;
        
        FoundIndex = PendingArbitrationPCs.Find(PC);
        if (FoundIndex != -1)
        {
            PendingArbitrationPCs.Remove(FoundIndex, 1);
            if (bWasSuccessful)
            {
                ArbitrationPCs[ArbitrationPCs.Length] = PC;
            }
            else
            {
                AccessControl.KickPlayer(PC, GameMessageClass.default.default.MaxedOutMessage);
            }
        }
        if (PendingArbitrationPCs.Length == 0)
        {
            SetTimer(0.0, false, 'ArbitrationTimeout');
            RegisterServerForArbitration();
        }
    }
    
    function StartArbitratedMatch()
    {
        bNeedsEndGameHandshake = true;
        Global.StartMatch();
    }
    
    function ArbitrationTimeout()
    {
        local int Index;
        
        for (Index = 0; Index < PendingArbitrationPCs.Length; Index++)
        {
            AccessControl.KickPlayer(PendingArbitrationPCs[Index], GameMessageClass.default.default.MaxedOutMessage);
        }
        PendingArbitrationPCs.Length = 0;
        RegisterServerForArbitration();
    }
    
    function ArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
    {
        GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
        if (bWasSuccessful)
        {
            StartArbitratedMatch();
        }
        else
        {
            ConsoleCommand("Disconnect");
        }
    }
    
    function RegisterServerForArbitration()
    {
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.AddArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
            GameInterface.RegisterForArbitration(PlayerReplicationInfoClass.default.default.SessionName);
        }
        else
        {
            ArbitrationRegistrationComplete(PlayerReplicationInfoClass.default.default.SessionName, true);
        }
    }
    
    function StartArbitrationRegistration()
    {
        local PlayerController PC;
        local UniqueNetId HostId;
        local OnlineGameSettings GameSettings;
        
        if (!bHasArbitratedHandshakeBegun)
        {
            bHasArbitratedHandshakeBegun = true;
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.default.SessionName);
            HostId = GameSettings.OwningPlayerId;
            PendingArbitrationPCs.Length = 0;
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (!PC.IsLocalPlayerController())
                {
                    PC.ClientSetHostUniqueId(HostId);
                    PC.ClientRegisterForArbitration();
                    PendingArbitrationPCs[PendingArbitrationPCs.Length] = PC;
                    continue;
                }
                ArbitrationPCs[ArbitrationPCs.Length] = PC;
            }
            SetTimer(ArbitrationHandshakeTimeout, false, 'ArbitrationTimeout');
        }
    }
    
    function StartMatch()
    {
        if (bUsingArbitration)
        {
            StartArbitrationRegistration();
        }
        else
        {
            Global.StartMatch();
        }
    }
    
    function bool MatchIsInProgress()
    {
        return false;
    }
    
    Stop;
}

defaultproperties
{
    bRestartLevel=True
    bPauseable=True
    bDelayedStart=True
    bChangeLevels=True
    GameDifficulty=1.0
    GameSpeed=1.0
    HUDType="HUD"
    MaxSpectators=2
    MaxSpectatorsAllowed=32
    MaxPlayers=16
    MaxPlayersAllowed=32
    CurrentID=1
    DefaultPlayerName="Giocatore"
    GameName="Game"
    FearCostFallOff=0.95
    DeathMessageClass="LocalMessage"
    GameMessageClass="GameMessage"
    AccessControlClass="AccessControl"
    BroadcastHandlerClass="BroadcastHandler"
    AutoTestManagerClass="AutoTestManager"
    PlayerControllerClass="PlayerController"
    PlayerReplicationInfoClass="PlayerReplicationInfo"
    GameReplicationInfoClass="GameReplicationInfo"
    TimeMarginSlack=1.35
    MinTimeMargin=-1.0
    LeaderboardId=-131072
    ArbitratedLeaderboardId=-65536
    TotalNetBandwidth=32000
    MinDynamicBandwidth=4000
    MaxDynamicBandwidth=7000
    DefaultGameType="AliceGame.AliceGameInfo"
    DebugGameSpeed=1.0
}
