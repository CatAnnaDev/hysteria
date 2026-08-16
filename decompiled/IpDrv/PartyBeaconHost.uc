class PartyBeaconHost extends PartyBeacon
    native
    notplaceable
    config(Engine);

struct native ClientBeaconConnection
{
    var UniqueNetId PartyLeader;
    var float ElapsedHeartbeatTime;
    var native transient Pointer Socket;
};

var const array<ClientBeaconConnection> Clients;
var const int NumTeams;
var const int NumPlayersPerTeam;
var const int NumReservations;
var const int NumConsumedReservations;
var const array<PartyReservation> Reservations;
var name OnlineSessionName;
var config int ConnectionBacklog;
var const int ReservedHostTeamNum;
var bool bBestFitTeamAssignment;
var delegate<OnReservationChange> __OnReservationChange__Delegate;
var delegate<OnReservationsFull> __OnReservationsFull__Delegate;
var delegate<OnClientCancellationReceived> __OnClientCancellationReceived__Delegate;

function DumpReservations()
{
    local int PartyIndex, MemberIndex;
    local UniqueNetId NetId;
    local PlayerReservation PlayerRes;
    
    LogInternal("Session that reservations are for: " $ string(OnlineSessionName));
    LogInternal("Number of teams: " $ string(NumTeams));
    LogInternal("Number players per team: " $ string(NumPlayersPerTeam));
    LogInternal("Number total reservations: " $ string(NumReservations));
    LogInternal("Number consumed reservations: " $ string(NumConsumedReservations));
    LogInternal("Number of party reservations: " $ string(Reservations.Length));
    LogInternal("Reserved host team: " $ string(ReservedHostTeamNum));
    for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
    {
        NetId = Reservations[PartyIndex].PartyLeader;
        LogInternal("  Party leader: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
        LogInternal("  Party team: " $ string(Reservations[PartyIndex].TeamNum));
        LogInternal("  Party size: " $ string(Reservations[PartyIndex].PartyMembers.Length));
        for (MemberIndex = 0; MemberIndex < Reservations[PartyIndex].PartyMembers.Length; MemberIndex++)
        {
            PlayerRes = Reservations[PartyIndex].PartyMembers[MemberIndex];
            LogInternal("  Party member: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PlayerRes.NetId) $ " skill: " $ string(PlayerRes.Skill) $ " xp: " $ string(PlayerRes.XpLevel));
        }
    }
}

native function int GetMaxAvailableTeamSize()
{
}

function GetPartyLeaders(out array<UniqueNetId> PartyLeaders)
{
    local int PartyIndex;
    
    for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
    {
        PartyLeaders.AddItem(Reservations[PartyIndex].PartyLeader);
    }
}

function GetPlayers(out array<UniqueNetId> Players)
{
    local int PlayerIndex, PartyIndex;
    local PlayerReservation PlayerRes;
    
    for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
    {
        for (PlayerIndex = 0; PlayerIndex < Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
        {
            PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
            Players.AddItem(PlayerRes.NetId);
        }
    }
}

native function AppendReservationSkillsToSearch(OnlineGameSearch Search)
{
    Search;
}

event UnregisterParty(UniqueNetId PartyLeader)
{
    local int PlayerIndex, PartyIndex;
    local OnlineSubsystem OnlineSub;
    local PlayerReservation PlayerRes;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            if (Reservations[PartyIndex].PartyLeader == PartyLeader)
            {
                for (PlayerIndex = 0; PlayerIndex < Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
                {
                    PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
                    OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
                }
            }
        }
    }
}

event UnregisterPartyMembers()
{
    local int Index, PartyIndex;
    local OnlineSubsystem OnlineSub;
    local PlayerReservation PlayerRes;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            for (Index = 0; Index < Reservations[PartyIndex].PartyMembers.Length; Index++)
            {
                PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
                OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
            }
        }
    }
}

event RegisterPartyMembers()
{
    local int Index, PartyIndex;
    local OnlineSubsystem OnlineSub;
    local OnlineRecentPlayersList PlayersList;
    local array<UniqueNetId> Members;
    local PlayerReservation PlayerRes;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            for (Index = 0; Index < Reservations[PartyIndex].PartyMembers.Length; Index++)
            {
                PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
                OnlineSub.GameInterface.RegisterPlayer(OnlineSessionName, PlayerRes.NetId, false);
                Members.AddItem(PlayerRes.NetId);
            }
            PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
            if (PlayersList != none)
            {
                PlayersList.AddPartyToRecentParties(Reservations[PartyIndex].PartyLeader, Members);
            }
        }
    }
}

function bool AreReservationsFull()
{
    return NumConsumedReservations == NumReservations;
}

native function TellClientsHostHasCancelled()
{
}

native function TellClientsHostIsReady()
{
}

native function TellClientsToTravel(name SessionName, class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    SessionName;
    SearchClass;
    PlatformSpecificInfo;
}

native event DestroyBeacon()
{
}

delegate OnClientCancellationReceived(UniqueNetId PartyLeader)
{
}

delegate OnReservationsFull()
{
}

delegate OnReservationChange()
{
}

native function HandlePlayerLogout(UniqueNetId PlayerID, bool bMaintainParty)
{
    PlayerID;
    bMaintainParty;
}

native function EPartyReservationResult UpdatePartyReservationEntry(UniqueNetId PartyLeader, out const array<PlayerReservation> PlayerMembers)
{
    PartyLeader;
    PlayerMembers;
}

native function EPartyReservationResult AddPartyReservationEntry(UniqueNetId PartyLeader, out const array<PlayerReservation> PlayerMembers, int TeamNum, bool bIsHost)
{
    PartyLeader;
    PlayerMembers;
    TeamNum;
    bIsHost;
}

native function bool InitHostBeacon(int InNumTeams, int InNumPlayersPerTeam, int InNumReservations, name InSessionName)
{
    InNumTeams;
    InNumPlayersPerTeam;
    InNumReservations;
    InSessionName;
}

defaultproperties
{
}
