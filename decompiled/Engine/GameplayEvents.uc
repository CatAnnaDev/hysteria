class GameplayEvents extends Object
    abstract
    native
    notplaceable
    config(Game);

struct native PawnClassEventData
{
    var string PawnClassName;
};

struct native ProjectileClassEventData
{
    var string ProjectileClassName;
};

struct native DamageClassEventData
{
    var string DamageClassName;
};

struct native WeaponClassEventData
{
    var string WeaponClassName;
};

struct native GameplayEventMetaData
{
    var const int EventID;
    var const name EventName;
    var const EPropertyValueMappingType MappingType;
    var const int MaxValue;
};

struct native PlayerInformationNew
{
    var string ControllerName;
    var string PlayerName;
    var bool bIsBot;
};

struct native TeamInformation
{
    var int TeamIndex;
    var string TeamName;
    var Color TeamColor;
    var int MaxSize;
};

struct native GameSessionInformation
{
    var int AppTitleID;
    var int PlatformType;
    var string Language;
    var const string GameplaySessionTimestamp;
    var const float GameplaySessionStartTime;
    var const float GameplaySessionEndTime;
    var const bool bGameplaySessionInProgress;
    var const string GameplaySessionID;
    var const string GameClassName;
    var const string MapName;
    var const string MapURL;
};

struct native GameplayEventsHeader
{
    var const int EngineVersion;
    var const int StatsWriterVersion;
    var const int StreamOffset;
    var const int FooterOffset;
    var const int TotalStreamSize;
    var const int FileSize;
};

var const native Pointer Archive;
var const string StatsFileName;
var GameplayEventsHeader Header;
var GameSessionInformation CurrentSessionInfo;
var const array<PlayerInformationNew> PlayerList;
var const array<TeamInformation> TeamList;
var array<GameplayEventMetaData> SupportedEvents;
var array<WeaponClassEventData> WeaponClassArray;
var array<DamageClassEventData> DamageClassArray;
var array<ProjectileClassEventData> ProjectileClassArray;
var array<PawnClassEventData> PawnClassArray;
var array<string> ActorArray;
var array<string> SoundCueArray;

function string GetFilename()
{
    return StatsFileName;
}

function CloseStatsFile()
{
}

function bool OpenStatsFile(string Filename)
{
}

defaultproperties
{
    SupportedEvents(0)=(EventID=-1,EventName="UNKNOWN",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(1)=(EventID=0,EventName="MATCH STARTED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(2)=(EventID=1,EventName="MATCH ENDED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(3)=(EventID=2,EventName="ROUND STARTED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(4)=(EventID=3,EventName="ROUND ENDED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(5)=(EventID=4,EventName="MATCH WON",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(6)=(EventID=5,EventName="MATCH LOST",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(7)=(EventID=6,EventName="GAME TYPE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(8)=(EventID=7,EventName="GAME OPTIONS",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(9)=(EventID=8,EventName="MAP NAME",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(10)=(EventID=9,EventName="GAME SCORE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(11)=(EventID=50,EventName="TEAM FORMED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(12)=(EventID=51,EventName="TEAM SCORE UPDATE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(13)=(EventID=100,EventName="PLAYER LOGGED IN",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(14)=(EventID=101,EventName="PLAYER LOGGED OUT",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(15)=(EventID=104,EventName="PLAYER KILLED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(16)=(EventID=106,EventName="PLAYER TEAM CHANGE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(17)=(EventID=102,EventName="PLAYER SPAWNED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(18)=(EventID=105,EventName="PLAYER LOCATIONS",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(19)=(EventID=107,EventName="KILL STREAK",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(20)=(EventID=103,EventName="RECORD PLAYER WIN/LOSS",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(21)=(EventID=150,EventName="WEAPON DAMAGE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(22)=(EventID=151,EventName="MELEE DAMAGE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(23)=(EventID=152,EventName="WEAPON FIRED",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(24)=(EventID=200,EventName="NORMAL KILL",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(25)=(EventID=35,EventName="MEMORY USAGE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(26)=(EventID=37,EventName="NETWORK USAGE IN",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(27)=(EventID=38,EventName="NETWORK USAGE OUT",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(28)=(EventID=39,EventName="Ping",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(29)=(EventID=36,EventName="FRAME RATE",MappingType="PVMT_RawValue",MaxValue=1)
    SupportedEvents(30)=(EventID=202,EventName="AI PATH FAILURE",MappingType="PVMT_RawValue",MaxValue=1)
}
