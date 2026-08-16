class OnlineRecentPlayersList extends Object
    notplaceable
    config(Engine);

struct CurrentPlayerMet
{
    var int TeamNum;
    var int Skill;
    var UniqueNetId NetId;
};

struct RecentParty
{
    var UniqueNetId PartyLeader;
    var array<UniqueNetId> PartyMembers;
};

var array<UniqueNetId> RecentPlayers;
var array<RecentParty> RecentParties;
var RecentParty LastParty;
var config int MaxRecentPlayers;
var config int MaxRecentParties;
var int RecentPlayersAddIndex;
var int RecentPartiesAddIndex;
var array<CurrentPlayerMet> CurrentPlayers;

function int GetCurrentPlayersListCount()
{
    return CurrentPlayers.Length;
}

function SetCurrentPlayersList(const array<CurrentPlayerMet> Players)
{
    DumpPlayersList(Players);
    CurrentPlayers = Players;
}

function DumpPlayersList(out const array<CurrentPlayerMet> Players)
{
    local OnlineSubsystem OnlineSub;
    local int PlayerIdx;
    local UniqueNetId NetId;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        for (PlayerIdx = 0; PlayerIdx < Players.Length; PlayerIdx++)
        {
            NetId = Players[PlayerIdx].NetId;
            LogInternal("DumpPlayersList: " $ " PlayerIdx=" $ string(PlayerIdx) $ " UniqueId=" $ OnlineSub.UniqueNetIdToString(NetId), 'DevOnline');
        }
    }
}

function bool ShowCurrentPlayersList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    local array<UniqueNetId> Players;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        GetPlayersFromCurrentPlayers(Players);
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
    }
    return false;
}

function bool ShowLastPartyPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, LastParty.PartyMembers, Title, Description);
    }
    return false;
}

function bool ShowRecentPartiesPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    local array<UniqueNetId> Players;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        GetPlayersFromRecentParties(Players);
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
    }
    return false;
}

function bool ShowRecentPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, RecentPlayers, Title, Description);
    }
    return false;
}

function SetLastParty(UniqueNetId PartyLeader, out const array<UniqueNetId> PartyMembers)
{
    LastParty.PartyLeader = PartyLeader;
    LastParty.PartyMembers = PartyMembers;
}

function int GetTeamForCurrentPlayer(UniqueNetId Player)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        if (CurrentPlayers[PlayerIndex].NetId == Player)
        {
            return CurrentPlayers[PlayerIndex].TeamNum;
        }
    }
    return 255;
}

function int GetSkillForCurrentPlayer(UniqueNetId Player)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        if (CurrentPlayers[PlayerIndex].NetId == Player)
        {
            return CurrentPlayers[PlayerIndex].Skill;
        }
    }
    return 0;
}

function GetPlayersFromCurrentPlayers(out array<UniqueNetId> Players)
{
    local int PlayerIndex;
    
    Players.Length = 0;
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        Players.AddItem(CurrentPlayers[PlayerIndex].NetId);
    }
}

function GetPlayersFromRecentParties(out array<UniqueNetId> Players)
{
    local int PartyIndex, MemberIndex, AddMemberAt;
    
    Players.Length = 0;
    AddMemberAt = 0;
    for (PartyIndex = 0; PartyIndex < RecentParties.Length; PartyIndex++)
    {
        for (MemberIndex = 0; MemberIndex < RecentParties[PartyIndex].PartyMembers.Length; MemberIndex++)
        {
            Players.Length = AddMemberAt + 1;
            Players[AddMemberAt] = RecentParties[PartyIndex].PartyMembers[MemberIndex];
        }
    }
}

function ClearRecentParties()
{
    RecentPartiesAddIndex = 0;
    RecentParties.Length = 0;
}

function AddPartyToRecentParties(UniqueNetId PartyLeader, out const array<UniqueNetId> PartyMembers)
{
    local int FindIndex;
    
    FindIndex = RecentParties.Find('PartyLeader', PartyLeader);
    if (FindIndex == -1)
    {
        if (RecentPartiesAddIndex >= MaxRecentParties)
        {
            RecentPartiesAddIndex = 0;
        }
        if (RecentPartiesAddIndex + 1 >= RecentParties.Length)
        {
            RecentParties.Length = RecentPartiesAddIndex + 1;
        }
        RecentParties[RecentPartiesAddIndex].PartyLeader = PartyLeader;
        RecentParties[RecentPartiesAddIndex].PartyMembers = PartyMembers;
        RecentPartiesAddIndex++;
    }
}

function ClearRecentPlayers()
{
    RecentPlayersAddIndex = 0;
    RecentPlayers.Length = 0;
}

function AddPlayerToRecentPlayers(UniqueNetId NewPlayer)
{
    local int FindIndex;
    
    FindIndex = RecentPlayers.Find('Uid', NewPlayer.Uid);
    if (FindIndex == -1)
    {
        if (RecentPlayersAddIndex >= MaxRecentPlayers)
        {
            RecentPlayersAddIndex = 0;
        }
        if (RecentPlayersAddIndex + 1 >= RecentPlayers.Length)
        {
            RecentPlayers.Length = RecentPlayersAddIndex + 1;
        }
        RecentPlayers[RecentPlayersAddIndex] = NewPlayer;
        RecentPlayersAddIndex++;
    }
}

defaultproperties
{
    MaxRecentPlayers=100
    MaxRecentParties=5
}
