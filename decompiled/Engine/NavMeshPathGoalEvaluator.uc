class NavMeshPathGoalEvaluator extends Object
    native
    notplaceable;

struct native BiasedGoalActor
{
    var Actor Goal;
    var int ExtraCost;
};

var NavMeshPathGoalEvaluator NextEvaluator;
var int MaxPathVisits;
var bool bAlwaysCallEvaluateGoal;
var int NumNodesThrownOut;
var int NumNodesProcessed;

event string GetDumpString()
{
    return string(self);
}

event Recycle()
{
    NumNodesThrownOut = 0;
    NumNodesProcessed = 0;
    NextEvaluator = none;
}

defaultproperties
{
    MaxPathVisits=1024
}
