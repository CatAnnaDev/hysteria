class OnlineStats extends Object
    abstract
    native
    notplaceable;

var const array<StringIdToStringMapping> ViewIdMappings;

native function name GetViewName(int ViewId)
{
    ViewId;
}

native function bool GetViewId(name ViewName, out int ViewId)
{
    ViewName;
    ViewId;
}

defaultproperties
{
}
