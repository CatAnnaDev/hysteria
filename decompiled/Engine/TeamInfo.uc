class TeamInfo extends ReplicationInfo
    native
    nativereplication
    notplaceable
    hidecategories(Navigation,Movement,Collision);

var const localized repretry databinding string TeamName;
var databinding int Size;
var repretry databinding float Score;
var repnotify databinding int TeamIndex;
var databinding Color TeamColor;

replication
{
    if (bNetInitial && Role == 3)
        TeamName, TeamIndex;
    if (bNetDirty && Role == 3)
        Score;
}

native simulated function byte GetTeamNum()
{
}

function Color GetTextColor()
{
    return TeamColor;
}

simulated function Color GetHUDColor()
{
    return TeamColor;
}

simulated function string GetHumanReadableName()
{
    return TeamName;
}

function RemoveFromTeam(Controller Other)
{
    Size--;
    if (Other != none && Other.PlayerReplicationInfo != none)
    {
        Other.PlayerReplicationInfo.SetPlayerTeam(none);
    }
}

function bool AddToTeam(Controller Other)
{
    if (Other == none)
    {
        LogInternal("Added none to team!!!");
        return false;
    }
    if (Other.PlayerReplicationInfo == none)
    {
        WarnInternal(string(Other) @ "is missing PlayerReplicationInfo");
        ScriptTrace();
        return false;
    }
    Size++;
    Other.PlayerReplicationInfo.SetPlayerTeam(self);
    return true;
}

simulated event Destroyed()
{
    local TeamInfo OtherTeam;
    
    Destroyed();
    if (WorldInfo.GRI != none)
    {
        foreach DynamicActors(class'TeamInfo', OtherTeam)
        {
            if (OtherTeam != self && OtherTeam.TeamIndex == TeamIndex)
            {
                WorldInfo.GRI.SetTeam(TeamIndex, OtherTeam);
                break;
            }
        }
    }
    UnbindTeamDataProvider();
}

simulated function UnbindTeamDataProvider()
{
    local CurrentGameDataStore CurrentGameData;
    
    LogInternal(">>" @ string(self) $ "::UnbindTeamDataProvider" @ "(" $ TeamName @ "-" @ string(TeamIndex) $ ")", 'DevDataStore');
    CurrentGameData = GetCurrentGameDS();
    CurrentGameData.RemoveTeamDataProvider(self);
    LogInternal("<<" @ string(self) $ "::UnbindTeamDataProvider" @ "(" $ TeamName @ "-" @ string(TeamIndex) $ ")", 'DevDataStore');
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
            LogInternal("(" $ string(Name) $ ") TeamInfo::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ": CurrentGame data store not found!", 'DevDataStore');
        }
    }
    return Result;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'TeamIndex')
    {
        if (WorldInfo.GRI != none)
        {
            WorldInfo.GRI.SetTeam(TeamIndex, self);
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

defaultproperties
{
    TeamName="Team"
    TeamIndex=-1
    TeamColor=(B=64,G=64,R=255,A=255)
    TickGroup="TG_DuringAsyncWork"
    NetUpdateFrequency=2.0
}
