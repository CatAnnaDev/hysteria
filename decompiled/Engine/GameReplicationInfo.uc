class GameReplicationInfo extends ReplicationInfo
    native
    nativereplication
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var repnotify class<GameInfo> GameClass;
var CurrentGameDataStore CurrentGameData;
var repretry bool bStopCountDown;
var repnotify bool bMatchHasBegun;
var repnotify bool bMatchIsOver;
var repretry databinding int RemainingTime;
var repretry databinding int ElapsedTime;
var repretry databinding int RemainingMinute;
var repretry databinding int GoalScore;
var repretry databinding int TimeLimit;
var databinding array<TeamInfo> Teams;
var() globalconfig repretry databinding string ServerName;
var repretry Actor Winner;
var array<PlayerReplicationInfo> PRIArray;
var array<PlayerReplicationInfo> InactivePRIArray;

replication
{
    if (bNetInitial)
        GameClass, RemainingTime, ElapsedTime, GoalScore, TimeLimit, ServerName;
    if (bNetDirty)
        bStopCountDown, bMatchHasBegun, bMatchIsOver, Winner;
    if (!bNetInitial && bNetDirty)
        RemainingMinute;
}

simulated event bool ShouldShowGore()
{
    return true;
}

simulated function bool IsCoopMultiplayerGame()
{
    return false;
}

simulated function bool IsMultiplayerGame()
{
    return WorldInfo.NetMode != 0;
}

simulated function EndGame()
{
    bMatchIsOver = true;
}

simulated function StartMatch()
{
    bMatchHasBegun = true;
}

simulated function CleanupGameDataStore()
{
    LogInternal("(" $ string(Name) $ ") GameReplicationInfo::" $ string(GetStateName()) $ ":" $ string(GetFuncName()), 'DataStore');
    if (CurrentGameData != none)
    {
        CurrentGameData.ClearDataProviders();
    }
    CurrentGameData = none;
}

simulated function InitializeGameDataStore()
{
    local DataStoreClient DataStoreManager;
    
    DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
    if (DataStoreManager != none)
    {
        CurrentGameData = CurrentGameDataStore(DataStoreManager.FindDataStore('CurrentGame'));
        if (CurrentGameData != none)
        {
            CurrentGameData.CreateGameDataProvider(self);
        }
        else
        {
            LogInternal("Primary game data store not found!");
        }
    }
}

simulated event ReplicatedDataBinding(name VarName)
{
    ReplicatedDataBinding(VarName);
    if (CurrentGameData != none)
    {
        CurrentGameData.RefreshSubscribers(VarName, true, CurrentGameData);
    }
}

simulated function SortPRIArray()
{
    local int I, J;
    local PlayerReplicationInfo P1, P2;
    
    for (I = 0; I < PRIArray.Length - 1; I++)
    {
        P1 = PRIArray[I];
        for (J = I + 1; J < PRIArray.Length; J++)
        {
            P2 = PRIArray[J];
            if (!InOrder(P1, P2))
            {
                PRIArray[I] = P2;
                PRIArray[J] = P1;
                P1 = P2;
            }
        }
    }
}

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    local LocalPlayer LP1, LP2;
    
    if (P1.bOnlySpectator)
    {
        return P2.bOnlySpectator;
    }
    else if (P2.bOnlySpectator)
    {
        return true;
    }
    if (P1.Score < P2.Score)
    {
        return false;
    }
    if (P1.Score == P2.Score)
    {
        if (P1.Deaths > P2.Deaths)
        {
            return false;
        }
        if (P1.Deaths == P2.Deaths && PlayerController(P2.Owner) != none)
        {
            LP2 = LocalPlayer(PlayerController(P2.Owner).Player);
            if (LP2 != none)
            {
                if (!class'Engine'.static.IsSplitScreen() || LP2.ViewportClient.Outer.GamePlayers[0] == LP2)
                {
                    return false;
                }
                LP1 = LocalPlayer(PlayerController(P2.Owner).Player);
                return LP1 != none;
            }
        }
    }
    return true;
}

simulated function GetPRIArray(out array<PlayerReplicationInfo> pris)
{
    local int I, Num;
    
    pris.Remove(0, pris.Length);
    for (I = 0; I < PRIArray.Length; I++)
    {
        if (PRIArray[I] != none)
        {
            pris[Num++] = PRIArray[I];
        }
    }
}

simulated function SetTeam(int Index, TeamInfo TI)
{
    if (Index >= 0)
    {
        if (CurrentGameData == none)
        {
            InitializeGameDataStore();
        }
        if (CurrentGameData != none)
        {
            if (Index < Teams.Length && Teams[Index] != none)
            {
                CurrentGameData.RemoveTeamDataProvider(Teams[Index]);
            }
            if (TI != none)
            {
                CurrentGameData.AddTeamDataProvider(TI);
            }
        }
        Teams[Index] = TI;
    }
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
    local int I;
    
    for (I = 0; I < PRIArray.Length; I++)
    {
        if (PRIArray[I] == PRI)
        {
            if (CurrentGameData != none)
            {
                CurrentGameData.RemovePlayerDataProvider(PRI);
            }
            PRIArray.Remove(I, 1);
            return;
        }
    }
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    local int I;
    
    if (!PRI.bIsInactive)
    {
        for (I = 0; I < PRIArray.Length; I++)
        {
            if (PRIArray[I] == PRI)
            {
                return;
            }
        }
        PRIArray[PRIArray.Length] = PRI;
    }
    else if (InactivePRIArray.Find(PRI) == -1)
    {
        InactivePRIArray[InactivePRIArray.Length] = PRI;
    }
    if (CurrentGameData == none)
    {
        InitializeGameDataStore();
    }
    if (CurrentGameData != none)
    {
        CurrentGameData.AddPlayerDataProvider(PRI);
    }
}

simulated function PlayerReplicationInfo FindPlayerByID(int PlayerID)
{
    local int I;
    
    for (I = 0; I < PRIArray.Length; I++)
    {
        if (PRIArray[I].PlayerID == PlayerID)
        {
            return PRIArray[I];
        }
    }
    return none;
}

native simulated function bool OnSameTeam(Actor A, Actor B)
{
    A;
    B;
}

simulated event Timer()
{
    if (WorldInfo.Game == none || WorldInfo.Game.MatchIsInProgress())
    {
        ElapsedTime++;
    }
    if (WorldInfo.NetMode == 3)
    {
        if (RemainingMinute != 0)
        {
            RemainingTime = RemainingMinute;
            RemainingMinute = 0;
        }
    }
    if (RemainingTime > 0 && !bStopCountDown)
    {
        RemainingTime--;
        if (WorldInfo.NetMode != 3)
        {
            if (RemainingTime % 60 == 0)
            {
                RemainingMinute = RemainingTime;
            }
        }
    }
    if (CurrentGameData != none)
    {
        CurrentGameData.Timer();
    }
    SetTimer(WorldInfo.TimeDilation, true);
}

simulated event Destroyed()
{
    Destroyed();
    CleanupGameDataStore();
}

function Reset()
{
    Reset();
    Winner = none;
}

simulated function ReceivedGameClass()
{
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bMatchHasBegun')
    {
        if (bMatchHasBegun)
        {
            WorldInfo.NotifyMatchStarted();
        }
    }
    else if (VarName == 'bMatchIsOver')
    {
        if (bMatchIsOver)
        {
            EndGame();
        }
    }
    else if (VarName == 'GameClass')
    {
        ReceivedGameClass();
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event PostBeginPlay()
{
    local PlayerReplicationInfo PRI;
    local TeamInfo TI;
    
    if (WorldInfo.NetMode == 3)
    {
        ServerName = "";
    }
    SetTimer(WorldInfo.TimeDilation, true);
    WorldInfo.GRI = self;
    InitializeGameDataStore();
    foreach DynamicActors(class'PlayerReplicationInfo', PRI)
    {
        AddPRI(PRI);
    }
    foreach DynamicActors(class'TeamInfo', TI)
    {
        if (TI.TeamIndex >= 0)
        {
            SetTeam(TI.TeamIndex, TI);
        }
    }
}

defaultproperties
{
    bStopCountDown=True
    TickGroup="TG_DuringAsyncWork"
}
