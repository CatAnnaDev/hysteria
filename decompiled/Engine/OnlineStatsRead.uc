class OnlineStatsRead extends OnlineStats
    abstract
    native
    notplaceable;

struct native ColumnMetaData
{
    var const int Id;
    var const name Name;
    var const localized string ColumnName;
};

struct native OnlineStatsRow
{
    var const UniqueNetId PlayerID;
    var const SettingsData Rank;
    var const string NickName;
    var array<OnlineStatsColumn> Columns;
};

struct native OnlineStatsColumn
{
    var int ColumnNo;
    var SettingsData StatValue;
};

var int ViewId;
var const int SortColumnId;
var const array<int> ColumnIds;
var const int TotalRowsInView;
var array<OnlineStatsRow> Rows;
var const array<ColumnMetaData> ColumnMappings;
var const string ViewName;
var const int TitleId;

native function int GetRankForPlayer(UniqueNetId PlayerID)
{
    PlayerID;
}

native function AddPlayer(string PlayerName, UniqueNetId PlayerID)
{
    PlayerName;
    PlayerID;
}

native function bool SetFloatStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, float StatValue)
{
    PlayerID;
    StatColumnNo;
    StatValue;
}

native function bool GetFloatStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, out float StatValue)
{
    PlayerID;
    StatColumnNo;
    StatValue;
}

native function bool SetIntStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, int StatValue)
{
    PlayerID;
    StatColumnNo;
    StatValue;
}

native function bool GetIntStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, out int StatValue)
{
    PlayerID;
    StatColumnNo;
    StatValue;
}

event OnReadComplete()
{
}

defaultproperties
{
}
