class GameplayEventsWriter extends GameplayEvents
    native
    notplaceable
    config(Game);

const GAMEEVENT_MAX_EVENTID = 0x0000FFFF;
const GAMEEVENT_GAME_SPECIFIC = 1000;
const GAMEEVENT_GENERIC_PARAM_LIST_END = 300;
const GAMEEVENT_GENERIC_PARAM_LIST_START = 201;
const GAMEEVENT_PLAYER_KILL_NORMAL = 200;
const GAMEEVENT_WEAPON_FIRED = 152;
const GAMEEVENT_WEAPON_DAMAGE_MELEE = 151;
const GAMEEVENT_WEAPON_DAMAGE = 150;
const GAMEEVENT_PLAYER_KILL_STREAK = 107;
const GAMEEVENT_PLAYER_TEAMCHANGE = 106;
const GAMEEVENT_PLAYER_LOCATION_POLL = 105;
const GAMEEVENT_PLAYER_KILL = 104;
const GAMEEVENT_PLAYER_MATCH_WON = 103;
const GAMEEVENT_PLAYER_SPAWN = 102;
const GAMEEVENT_PLAYER_LOGOUT = 101;
const GAMEEVENT_PLAYER_LOGIN = 100;
const GAMEEVENT_TEAM_GAME_SCORE = 51;
const GAMEEVENT_TEAM_CREATED = 50;
const GAMEEVENT_PING_POLL = 39;
const GAMEEVENT_NETWORKUSAGEOUT_POLL = 38;
const GAMEEVENT_NETWORKUSAGEIN_POLL = 37;
const GAMEEVENT_FRAMERATE_POLL = 36;
const GAMEEVENT_MEMORYUSAGE_POLL = 35;
const GAMEEVENT_GAME_SCORE = 9;
const GAMEEVENT_GAME_MAPNAME = 8;
const GAMEEVENT_GAME_OPTION_URL = 7;
const GAMEEVENT_GAME_CLASS = 6;
const GAMEEVENT_ROUND_WON = 5;
const GAMEEVENT_MATCH_WON = 4;
const GAMEEVENT_ROUND_ENDED = 3;
const GAMEEVENT_ROUND_STARTED = 2;
const GAMEEVENT_MATCH_ENDED = 1;
const GAMEEVENT_MATCH_STARTED = 0;

var const GameInfo Game;

function RecordAIPathFail(Controller AI, coerce string Reason, Vector Dest)
{
    local GenericParamListStatEntry PLE;
    
    PLE = GetGenericParamListEntry();
    PLE.AddInt('EventID', 202);
    PLE.AddString('Name', string(AI.Name));
    PLE.AddVector('BaseLocation', AI.Pawn.Location);
    PLE.AddString('Sprite', "Texture2D'EditorResources.BadPylon'");
    PLE.AddString('Text', Reason);
    PLE.AddVector('LineStart', AI.Pawn.Location);
    PLE.AddVector('LineEnd', Dest);
    PLE.AddVector('BoxLoc', Dest);
    PLE.AddVector('BoxExtent', vect(5.0, 5.0, 5.0));
    PLE.AddInt('PlayerIndex', ResolvePlayerIndex(AI));
    PLE.CommitToDisk();
}

native function GenericParamListStatEntry GetGenericParamListEntry()
{
}

native function LogSystemPollEvents()
{
}

native function LogProjectileIntEvent(int EventID, Controller Player, class<Projectile> Proj, int Value)
{
    EventID;
    Player;
    Proj;
    Value;
}

native function LogDamageEvent(int EventID, Controller Player, class<DamageType> dmgType, Controller Target, int Amount)
{
    EventID;
    Player;
    dmgType;
    Target;
    Amount;
}

native function LogWeaponIntEvent(int EventID, Controller Player, class<Weapon> WeaponClass, int Value)
{
    EventID;
    Player;
    WeaponClass;
    Value;
}

native function LogPlayerPlayerEvent(int EventID, Controller Player, Controller Target)
{
    EventID;
    Player;
    Target;
}

native function LogPlayerKillDeath(int EventID, int KillType, Controller Killer, class<DamageType> dmgType, Controller Dead)
{
    EventID;
    KillType;
    Killer;
    dmgType;
    Dead;
}

native function LogAllPlayerPositionsEvent(int EventID)
{
    EventID;
}

native function LogPlayerLoginChange(int EventID, Controller Player, string PlayerName, UniqueNetId PlayerID, bool bSplitScreen)
{
    EventID;
    Player;
    PlayerName;
    PlayerID;
    bSplitScreen;
}

native function LogPlayerSpawnEvent(int EventID, Controller Player, class<Pawn> PawnClass, int TeamID)
{
    EventID;
    Player;
    PawnClass;
    TeamID;
}

native function LogPlayerStringEvent(int EventID, Controller Player, string EventString)
{
    EventID;
    Player;
    EventString;
}

native function LogPlayerFloatEvent(int EventID, Controller Player, float Value)
{
    EventID;
    Player;
    Value;
}

native function LogPlayerIntEvent(int EventID, Controller Player, int Value)
{
    EventID;
    Player;
    Value;
}

native function LogTeamIntEvent(int EventID, TeamInfo Team, int Value)
{
    EventID;
    Team;
    Value;
}

native function LogGameStringEvent(int EventID, string Value)
{
    EventID;
    Value;
}

native function LogGameIntEvent(int EventID, int Value)
{
    EventID;
    Value;
}

function Poll()
{
    if (Game != none && !Game.bWaitingToStartMatch)
    {
        LogAllPlayerPositionsEvent(105);
    }
    LogSystemPollEvents();
}

native protected function bool SerializeFooter()
{
}

native protected function bool SerializeHeader()
{
}

native function CloseStatsFile()
{
}

native function bool OpenStatsFile(string Filename)
{
    Filename;
}

function bool IsSessionInProgress()
{
    return CurrentSessionInfo.bGameplaySessionInProgress;
}

native function EndLogging()
{
}

native function StartLogging(optional float HeartbeatDelta)
{
    HeartbeatDelta;
}

native function int ResolvePlayerIndex(Controller Player)
{
    Player;
}

defaultproperties
{
}
