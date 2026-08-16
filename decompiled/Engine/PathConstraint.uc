class PathConstraint extends Object
    native
    notplaceable;

var const int CacheIdx;
var PathConstraint NextConstraint;

event string GetDumpString()
{
    return string(self);
}

event Recycle()
{
    NextConstraint = none;
}

defaultproperties
{
    CacheIdx=-1
}
