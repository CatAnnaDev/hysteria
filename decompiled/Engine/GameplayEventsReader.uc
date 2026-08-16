class GameplayEventsReader extends GameplayEvents
    native
    notplaceable
    config(Game);

var config array<int> EventIDFilter;

native function float GetSessionDuration()
{
}

native function float GetSessionEnd()
{
}

native function float GetSessionStart()
{
}

native function string GetSessionTimestamp()
{
}

native function int GetPlatform()
{
}

native function int GetTitleID()
{
}

native function string GetSessionID()
{
}

event bool IsEventFiltered(int EventID)
{
    return EventIDFilter.Find(EventID) != -1;
}

function RemoveFilter(int EventID)
{
    EventIDFilter.RemoveItem(EventID);
}

function AddFilter(int EventID)
{
    if (EventIDFilter.Find(EventID) == -1)
    {
        EventIDFilter.AddItem(EventID);
    }
}

native function ProcessStream()
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

defaultproperties
{
}
