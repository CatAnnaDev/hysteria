class OnlineStatsWrite extends OnlineStats
    abstract
    native
    notplaceable;

var const array<StringIdToStringMapping> StatMappings;
var const array<SettingsProperty> Properties;
var array<int> ViewIds;
var array<int> ArbitratedViewIds;
var const int RatingId;
var delegate<OnStatsWriteComplete> __OnStatsWriteComplete__Delegate;

native function DecrementIntStat(int StatId, optional int DecBy = 1)
{
    StatId;
    DecBy;
}

native function DecrementFloatStat(int StatId, optional float DecBy = 1.0)
{
    StatId;
    DecBy;
}

native function IncrementIntStat(int StatId, optional int IncBy = 1)
{
    StatId;
    IncBy;
}

native function IncrementFloatStat(int StatId, optional float IncBy = 1.0)
{
    StatId;
    IncBy;
}

native function SetIntStat(int StatId, int Value)
{
    StatId;
    Value;
}

native function SetFloatStat(int StatId, float Value)
{
    StatId;
    Value;
}

native function name GetStatName(int StatId)
{
    StatId;
}

native function bool GetStatId(name StatName, out int StatId)
{
    StatName;
    StatId;
}

delegate OnStatsWriteComplete()
{
}

defaultproperties
{
}
