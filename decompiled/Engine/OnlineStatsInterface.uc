class OnlineStatsInterface extends Interface
    abstract
    notplaceable;

var delegate<OnReadOnlineStatsComplete> __OnReadOnlineStatsComplete__Delegate;
var delegate<OnFlushOnlineStatsComplete> __OnFlushOnlineStatsComplete__Delegate;
var delegate<OnRegisterHostStatGuidComplete> __OnRegisterHostStatGuidComplete__Delegate;

function bool RegisterStatGuid(UniqueNetId PlayerID, out const string ClientStatGuid)
{
}

function string GetClientStatGuid()
{
}

function ClearRegisterHostStatGuidCompleteDelegateDelegate(delegate<OnRegisterHostStatGuidComplete> RegisterHostStatGuidCompleteDelegate)
{
}

function AddRegisterHostStatGuidCompleteDelegate(delegate<OnRegisterHostStatGuidComplete> RegisterHostStatGuidCompleteDelegate)
{
}

delegate OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
}

function bool RegisterHostStatGuid(out const string HostStatGuid)
{
}

function string GetHostStatGuid()
{
}

function bool WriteOnlinePlayerScores(name SessionName, int LeaderboardId, out const array<OnlinePlayerScore> PlayerScores)
{
}

function ClearFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
}

function AddFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
}

delegate OnFlushOnlineStatsComplete(name SessionName, bool bWasSuccessful)
{
}

function bool FlushOnlineStats(name SessionName)
{
}

function bool WriteOnlineStats(name SessionName, UniqueNetId Player, OnlineStatsWrite StatsWrite)
{
}

function FreeStats(OnlineStatsRead StatsRead)
{
}

function ClearReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
}

function AddReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
}

delegate OnReadOnlineStatsComplete(bool bWasSuccessful)
{
}

function bool ReadOnlineStatsByRankAroundPlayer(byte LocalUserNum, OnlineStatsRead StatsRead, optional int NumRows = 10)
{
}

function bool ReadOnlineStatsByRank(OnlineStatsRead StatsRead, optional int StartIndex = 1, optional int NumToRead = 100)
{
}

function bool ReadOnlineStatsForFriends(byte LocalUserNum, OnlineStatsRead StatsRead)
{
}

function bool ReadOnlineStats(out const array<UniqueNetId> Players, OnlineStatsRead StatsRead)
{
}

defaultproperties
{
}
