class PlayerReplicationInfo extends ReplicationInfo
    native
    nativereplication
    notplaceable
    hidecategories(Navigation,Movement,Collision);

struct native AutomatedTestingDatum
{
    var int NumberOfMatchesPlayed;
    var int NumMapListCyclesDone;
};

var repnotify databinding float Score;
var repretry databinding int Deaths;
var repretry byte Ping;
var transient ETTSSpeaker TTSSpeaker;
var repretry Actor PlayerLocationHint;
var int NumLives;
var repnotify databinding string PlayerName;
var string OldName;
var repretry int PlayerID;
var repnotify TeamInfo Team;
var repretry int SplitscreenIndex;
var repretry bool bAdmin;
var repretry bool bIsFemale;
var repretry bool bIsSpectator;
var repretry bool bOnlySpectator;
var repretry bool bWaitingPlayer;
var repretry bool bReadyToPlay;
var repretry bool bOutOfLives;
var repretry bool bBot;
var repretry bool bHasFlag;
var bool bHasBeenWelcomed;
var repnotify bool bIsInactive;
var bool bFromPreviousLevel;
var repretry int StartTime;
var const localized string StringSpectating;
var const localized string StringUnknown;
var databinding int Kills;
var class<GameMessage> GameMessageClass;
var float ExactPing;
var string SavedNetworkAddress;
var repnotify databinding UniqueNetId UniqueId;
var const name SessionName;
var AutomatedTestingDatum AutomatedTestingData;
var int StatConnectionCounts;
var int StatPingTotals;
var int StatPingMin;
var int StatPingMax;
var int StatPKLTotal;
var int StatPKLMin;
var int StatPKLMax;
var int StatMaxInBPS;
var int StatAvgInBPS;
var int StatMaxOutBPS;
var int StatAvgOutBPS;
var transient Texture2D Avatar;

replication
{
    if (bNetDirty && Role == 3)
        Score, Deaths, PlayerLocationHint, PlayerName, Team, bAdmin, bIsFemale, bIsSpectator, bOnlySpectator, bWaitingPlayer, bReadyToPlay, bOutOfLives, bHasFlag, StartTime, UniqueId;
    if (bNetDirty && Role == 3 && !bNetOwner)
        Ping, SplitscreenIndex;
    if (bNetInitial && Role == 3)
        PlayerID, bBot, bIsInactive;
}

simulated function UnregisterPlayerFromSession()
{
    local OnlineSubsystem OnlineSub;
    local UniqueNetId ZeroId;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (SessionName != 'None' && WorldInfo.NetMode == 3 && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && OnlineSub.GameInterface.GetGameSettings(SessionName) != none && UniqueId != ZeroId)
    {
        OnlineSub.GameInterface.UnregisterPlayer(SessionName, UniqueId);
    }
}

simulated function RegisterPlayerWithSession()
{
    local OnlineSubsystem Online;
    local OnlineRecentPlayersList PlayersList;
    
    Online = class'GameEngine'.static.GetOnlineSubsystem();
    if (Online != none && NotEqual_InterfaceInterface(Online.GameInterface, OnlineGameInterface(none)) && SessionName != 'None' && Online.GameInterface.GetGameSettings(SessionName) != none)
    {
        Online.GameInterface.RegisterPlayer(SessionName, UniqueId, false);
        if (!bNetOwner)
        {
            PlayersList = OnlineRecentPlayersList(Online.GetNamedInterface('RecentPlayersList'));
            if (PlayersList != none)
            {
                PlayersList.AddPlayerToRecentPlayers(UniqueId);
            }
        }
    }
}

simulated function bool IsInvalidName()
{
    local LocalPlayer LocPlayer;
    local PlayerController PC;
    local string ProfileName;
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PC = PlayerController(Owner);
        if (PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            if (LocPlayer != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                if (OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId)) == 2)
                {
                    ProfileName = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
                    if (ProfileName != PlayerName)
                    {
                        PC.SetName(ProfileName);
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

native simulated function byte GetTeamNum()
{
}

simulated function SetUniqueId(UniqueNetId PlayerUniqueId)
{
    UniqueId = PlayerUniqueId;
}

reliable server function ServerSetSplitscreenIndex(byte PlayerIndex)
{
    SplitscreenIndex = int(PlayerIndex);
}

simulated function SetSplitscreenIndex(byte PlayerIndex)
{
    SplitscreenIndex = int(PlayerIndex);
    ServerSetSplitscreenIndex(PlayerIndex);
}

simulated function bool IsLocalPlayerPRI()
{
    local PlayerController PC;
    local LocalPlayer LP;
    
    PC = PlayerController(Owner);
    if (PC != none)
    {
        LP = LocalPlayer(PC.Player);
        return LP != none;
    }
    return false;
}

simulated function BindPlayerOwnerDataProvider()
{
    local PlayerController PlayerOwner;
    local LocalPlayer LP;
    local CurrentGameDataStore CurrentGameData;
    local PlayerDataProvider DataProvider;
    
    LogInternal(">>" @ string(self) $ "::BindPlayerOwnerDataProvider" @ "(" $ PlayerName $ ")", 'DevDataStore');
    PlayerOwner = PlayerController(Owner);
    if (PlayerOwner != none)
    {
        LP = LocalPlayer(PlayerOwner.Player);
        if (LP != none)
        {
            CurrentGameData = GetCurrentGameDS();
            if (CurrentGameData != none)
            {
                DataProvider = CurrentGameData.GetPlayerDataProvider(self);
                if (DataProvider != none)
                {
                    PlayerOwner.SetPlayerDataProvider(DataProvider);
                }
                else
                {
                    LogInternal("No player data provider registered for player " $ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
                }
            }
            else
            {
                LogInternal("'CurrentGame' data store not found!", 'DevDataStore');
            }
        }
        else
        {
            LogInternal("Non local player:" @ string(PlayerOwner.Player), 'DevDataStore');
        }
    }
    else
    {
        LogInternal("Invalid owner:" @ string(Owner), 'DevDataStore');
    }
    LogInternal("<<" @ string(self) $ "::BindPlayerOwnerDataProvider" @ "(" $ PlayerName $ ")", 'DevDataStore');
}

simulated function NotifyLocalPlayerTeamReceived()
{
    NotifyLocalPlayerTeamReceived();
    UpdateTeamDataProvider();
}

simulated function UpdateTeamDataProvider()
{
    local CurrentGameDataStore CurrentGameData;
    
    LogInternal("(" $ string(Name) $ ") PlayerReplicationInfo::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "PlayerName:'" $ PlayerName $ "'" @ "Team:" $ (Team != none ? string(Team.Name) : "None"), 'DevDataStore');
    CurrentGameData = GetCurrentGameDS();
    if (CurrentGameData != none)
    {
        CurrentGameData.NotifyTeamChange();
    }
}

simulated function UpdatePlayerDataProvider(optional name PropertyName)
{
    local CurrentGameDataStore CurrentGameData;
    local PlayerDataProvider DataProvider;
    local TeamDataProvider TeamProvider;
    
    LogInternal("(" $ string(Name) $ ") PlayerReplicationInfo::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "PropertyName:'" $ string(PropertyName) $ "'" @ "PlayerName:'" $ PlayerName $ "'", 'DevDataStore');
    CurrentGameData = GetCurrentGameDS();
    if (CurrentGameData != none)
    {
        DataProvider = CurrentGameData.GetPlayerDataProvider(self);
        if (DataProvider != none)
        {
            DataProvider.NotifyPropertyChanged(PropertyName);
            if (Team != none)
            {
                TeamProvider = CurrentGameData.GetTeamDataProvider(Team);
                if (TeamProvider != none && TeamProvider.Players.Find(DataProvider) != -1)
                {
                    TeamProvider.NotifyPropertyChanged(TeamProvider.PlayerListFieldName);
                }
            }
        }
    }
}

simulated function CurrentGameDataStore GetCurrentGameDS()
{
    local DataStoreClient DSClient;
    local CurrentGameDataStore Result;
    
    DSClient = class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != none)
    {
        Result = CurrentGameDataStore(DSClient.FindDataStore('CurrentGame'));
        if (Result == none)
        {
            LogInternal("(" $ string(Name) $ ") PlayerReplicationInfo::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ": CurrentGame data store not found!", 'DevDataStore');
        }
    }
    return Result;
}

function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
    CopyProperties(NewPRI);
    NewPRI.bOnlySpectator = bOnlySpectator;
}

function IncrementDeaths(optional int Amt = 1)
{
    Deaths += Amt;
}

function CopyProperties(PlayerReplicationInfo PRI)
{
    PRI.Score = Score;
    PRI.Deaths = Deaths;
    PRI.Ping = Ping;
    PRI.NumLives = NumLives;
    PRI.PlayerName = PlayerName;
    PRI.PlayerID = PlayerID;
    PRI.StartTime = StartTime;
    PRI.Kills = Kills;
    PRI.bOutOfLives = bOutOfLives;
    PRI.SavedNetworkAddress = SavedNetworkAddress;
    PRI.Team = Team;
    PRI.UniqueId = UniqueId;
    PRI.AutomatedTestingData = AutomatedTestingData;
}

function OverrideWith(PlayerReplicationInfo PRI)
{
    bIsSpectator = PRI.bIsSpectator;
    bOnlySpectator = PRI.bOnlySpectator;
    bWaitingPlayer = PRI.bWaitingPlayer;
    bReadyToPlay = PRI.bReadyToPlay;
    bOutOfLives = PRI.bOutOfLives || bOutOfLives;
    Team = PRI.Team;
}

function PlayerReplicationInfo Duplicate()
{
    local PlayerReplicationInfo NewPRI;
    
    NewPRI = Spawn(Class);
    CopyProperties(NewPRI);
    return NewPRI;
}

function SetWaitingPlayer(bool B)
{
    bIsSpectator = B;
    bWaitingPlayer = B;
    bForceNetUpdate = true;
}

event SetPlayerName(string S)
{
    PlayerName = S;
    if (WorldInfo.NetMode == 0 || WorldInfo.NetMode == 2)
    {
        ReplicatedEvent('PlayerName');
        ReplicatedDataBinding('PlayerName');
    }
    OldName = PlayerName;
    bForceNetUpdate = true;
}

event Timer()
{
    UpdatePlayerLocation();
    SetTimer(1.5 + FRand(), true);
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    local float XS, YS;
    
    if (Team == none)
    {
        HUD.Canvas.SetDrawColor(255, 255, 0);
    }
    else if (Team.TeamIndex == 0)
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
    }
    else
    {
        HUD.Canvas.SetDrawColor(64, 64, 255);
    }
    HUD.Canvas.SetPos(4.0, YPos);
    HUD.Canvas.Font = class'Engine'.static.GetSmallFont();
    HUD.Canvas.StrLen(PlayerName, XS, YS);
    HUD.Canvas.DrawText(PlayerName);
    HUD.Canvas.SetPos(4.0 + XS, YPos);
    HUD.Canvas.Font = class'Engine'.static.GetTinyFont();
    HUD.Canvas.SetDrawColor(255, 255, 0);
    if (bHasFlag)
    {
        HUD.Canvas.DrawText("   has flag ");
    }
    YPos += YS;
    HUD.Canvas.SetPos(4.0, YPos);
    if (!bBot && PlayerController(HUD.Owner).ViewTarget != PlayerController(HUD.Owner).Pawn)
    {
        HUD.Canvas.SetDrawColor(128, 128, 255);
        HUD.Canvas.DrawText("      bIsSpec:" @ string(bIsSpectator) @ "OnlySpec:" $ string(bOnlySpectator) @ "Waiting:" $ string(bWaitingPlayer) @ "Ready:" $ string(bReadyToPlay) @ "OutOfLives:" $ string(bOutOfLives));
        YPos += YL;
        HUD.Canvas.SetPos(4.0, YPos);
    }
}

function UpdatePlayerLocation()
{
    local Volume V, Best;
    local Pawn P;
    
    if (Controller(Owner) != none)
    {
        P = Controller(Owner).Pawn;
    }
    if (P == none)
    {
        PlayerLocationHint = none;
        return;
    }
    foreach P.TouchingActors(class'Volume', V)
    {
        if (V.LocationName == "")
        {
            break;
        }
        if (Best != none && V.LocationPriority <= Best.LocationPriority)
        {
            break;
        }
        if (V.Encompasses(P))
        {
            Best = V;
        }
    }
    PlayerLocationHint = (Best != none ? Best : P.WorldInfo);
}

simulated function string GetLocationName()
{
    local string LocationString;
    
    if (PlayerLocationHint == none)
    {
        return StringSpectating;
    }
    LocationString = PlayerLocationHint.GetLocationStringFor(self);
    return LocationString == "" ? StringUnknown : LocationString;
}

simulated function string GetHumanReadableName()
{
    return PlayerName;
}

function Reset()
{
    Reset();
    Score = 0.0;
    Kills = 0;
    Deaths = 0;
    bReadyToPlay = false;
    NumLives = 0;
    bOutOfLives = false;
    bForceNetUpdate = true;
}

simulated event Destroyed()
{
    local PlayerController PC;
    
    if (WorldInfo.GRI != none)
    {
        WorldInfo.GRI.RemovePRI(self);
    }
    if (ShouldBroadCastWelcomeMessage(true))
    {
        foreach LocalPlayerControllers(class'PlayerController', PC)
        {
            PC.ReceiveLocalizedMessage(GameMessageClass, 4, self);
        }
    }
    UnregisterPlayerFromSession();
    Destroyed();
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
    return !bIsInactive && WorldInfo.NetMode != 0;
}

native final function UpdatePing(float TimeStamp)
{
    TimeStamp;
}

simulated event ReplicatedDataBinding(name VarName)
{
    ReplicatedDataBinding(VarName);
    if (VarName == 'Team')
    {
        UpdateTeamDataProvider();
    }
    else
    {
        if (VarName == 'PlayerName' && IsInvalidName())
        {
            return;
        }
        UpdatePlayerDataProvider(VarName);
    }
}

simulated event ReplicatedEvent(name VarName)
{
    local Pawn P;
    local PlayerController PC;
    local int WelcomeMessageNum;
    local Actor A;
    
    if (VarName == 'Team')
    {
        foreach DynamicActors(class'Pawn', P)
        {
            if (P.PlayerReplicationInfo == self)
            {
                P.NotifyTeamChanged();
                break;
            }
        }
        foreach LocalPlayerControllers(class'PlayerController', PC)
        {
            if (PC.PlayerReplicationInfo == self)
            {
                foreach AllActors(class'Actor', A)
                {
                    A.NotifyLocalPlayerTeamReceived();
                }
                break;
            }
        }
        ReplicatedDataBinding('Team');
    }
    else if (VarName == 'PlayerName')
    {
        if (IsInvalidName())
        {
            return;
        }
        if (WorldInfo.TimeSeconds < float(2))
        {
            bHasBeenWelcomed = true;
            OldName = PlayerName;
            return;
        }
        if (bHasBeenWelcomed)
        {
            if (ShouldBroadCastWelcomeMessage())
            {
                foreach LocalPlayerControllers(class'PlayerController', PC)
                {
                    PC.ReceiveLocalizedMessage(GameMessageClass, 2, self);
                }
            }
        }
        else
        {
            if (bOnlySpectator)
            {
                WelcomeMessageNum = 16;
            }
            else
            {
                WelcomeMessageNum = 1;
            }
            bHasBeenWelcomed = true;
            if (ShouldBroadCastWelcomeMessage())
            {
                foreach LocalPlayerControllers(class'PlayerController', PC)
                {
                    PC.ReceiveLocalizedMessage(GameMessageClass, WelcomeMessageNum, self);
                }
            }
        }
        OldName = PlayerName;
    }
    else if (VarName == 'UniqueId')
    {
        RegisterPlayerWithSession();
    }
    else if (VarName == 'bIsInactive')
    {
        WorldInfo.GRI.RemovePRI(self);
        WorldInfo.GRI.AddPRI(self);
    }
}

function SetPlayerTeam(TeamInfo NewTeam)
{
    bForceNetUpdate = Team != NewTeam;
    Team = NewTeam;
    UpdateTeamDataProvider();
}

simulated function ClientInitialize(Controller C)
{
    local Actor A;
    local PlayerController PlayerOwner, FirstPlayer;
    local LocalPlayer LP;
    
    SetOwner(C);
    PlayerOwner = PlayerController(C);
    if (PlayerOwner != none)
    {
        if (PlayerOwner.IsSplitscreenPlayer())
        {
            if (PlayerOwner.NetPlayerIndex != 0)
            {
                LP = LocalPlayer(PlayerOwner.Player);
                FirstPlayer = LP.ViewportClient.Outer.GamePlayers[0].Actor;
                assert(FirstPlayer != PlayerOwner);
                FirstPlayer.PlayerReplicationInfo.SetSplitscreenIndex(0);
            }
            SetSplitscreenIndex(PlayerOwner.NetPlayerIndex);
        }
        BindPlayerOwnerDataProvider();
        if (Team != default.Team)
        {
            foreach AllActors(class'Actor', A)
            {
                A.NotifyLocalPlayerTeamReceived();
            }
        }
    }
}

simulated event PostBeginPlay()
{
    if (WorldInfo.GRI != none)
    {
        WorldInfo.GRI.AddPRI(self);
    }
    if (Role < 3)
    {
        return;
    }
    if (AIController(Owner) != none)
    {
        bBot = true;
    }
    StartTime = WorldInfo.GRI.ElapsedTime;
    Timer();
    SetTimer(1.5 + FRand(), true);
}

native function string GetPlayerAlias()
{
}

defaultproperties
{
    SplitscreenIndex=-1
    StringSpectating="Spettatore"
    StringUnknown="Sconosciuto"
    GameMessageClass="GameMessage"
    SessionName="Game"
    TickGroup="TG_DuringAsyncWork"
    NetUpdateFrequency=1.0
}
