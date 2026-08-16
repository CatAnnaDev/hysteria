class PathGoalEvaluator extends Object
    native
    notplaceable;

var PathGoalEvaluator NextEvaluator;
var NavigationPoint GeneratedGoal;
var int MaxPathVisits;
var const int CacheIdx;

event string GetDumpString()
{
    return string(self);
}

event Recycle()
{
    GeneratedGoal = none;
    NextEvaluator = none;
}

defaultproperties
{
    MaxPathVisits=1024
    CacheIdx=-1
}
