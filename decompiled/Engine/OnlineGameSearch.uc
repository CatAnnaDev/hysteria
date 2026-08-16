class OnlineGameSearch extends Settings
    native
    notplaceable;

enum EOnlineGameSearchSortType
{
    OGSSO_Ascending,
    OGSSO_Descending,
};

enum EOnlineGameSearchComparisonType
{
    OGSCT_Equals,
    OGSCT_NotEquals,
    OGSCT_GreaterThan,
    OGSCT_GreaterThanEquals,
    OGSCT_LessThan,
    OGSCT_LessThanEquals,
};

enum EOnlineGameSearchEntryType
{
    OGSET_Property,
    OGSET_LocalizedSetting,
    OGSET_ObjectProperty,
};

struct native OnlineGameSearchQuery
{
    var array<OnlineGameSearchORClause> OrClauses;
    var array<OnlineGameSearchSortClause> SortClauses;
};

struct native OnlineGameSearchORClause
{
    var array<OnlineGameSearchParameter> OrParams;
};

struct native OnlineGameSearchSortClause
{
    var int EntryId;
    var name ObjectPropertyName;
    var EOnlineGameSearchEntryType EntryType;
    var EOnlineGameSearchSortType SortType;
};

struct native OnlineGameSearchParameter
{
    var int EntryId;
    var name ObjectPropertyName;
    var EOnlineGameSearchEntryType EntryType;
    var EOnlineGameSearchComparisonType ComparisonType;
};

struct native NamedObjectProperty
{
    var name ObjectPropertyName;
    var string ObjectPropertyValue;
};

struct native OverrideSkill
{
    var int LeaderboardId;
    var array<UniqueNetId> Players;
    var array<Double> Mus;
    var array<Double> Sigmas;
};

struct native OnlineGameSearchResult
{
    var const OnlineGameSettings GameSettings;
    var const native Pointer PlatformData;
};

var int MaxSearchResults;
var LocalizedStringSetting Query;
var databinding bool bIsLanQuery;
var databinding bool bUsesArbitration;
var const bool bIsSearchInProgress;
var class<OnlineGameSettings> GameSettingsClass;
var const array<OnlineGameSearchResult> Results;
var OverrideSkill ManualSkillOverride;
var array<NamedObjectProperty> NamedProperties;
var const OnlineGameSearchQuery FilterQuery;
var string AdditionalSearchCriteria;
var int PingBucketSize;

native event SortSearchResults()
{
}

function SetSkillOverride(int LeaderboardId, out const array<UniqueNetId> Players)
{
    ManualSkillOverride.LeaderboardId = LeaderboardId;
    ManualSkillOverride.Players = Players;
    ManualSkillOverride.Mus.Length = 0;
    ManualSkillOverride.Sigmas.Length = 0;
}

defaultproperties
{
    MaxSearchResults=25
    GameSettingsClass="OnlineGameSettings"
    PingBucketSize=50
}
