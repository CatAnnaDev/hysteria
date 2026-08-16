class NavMeshGoal_OutOfViewFrom extends NavMeshPathGoalEvaluator
    native
    notplaceable;

var native Pointer GoalPoly;
var Vector OutOfViewLocation;
var bool bShowDebug;

function Recycle()
{
    RecycleNative();
    Recycle();
}

static function bool MustBeHiddenFromThisPoint(NavigationHandle NavHandle, Vector InOutOfViewLocation)
{
    local NavMeshGoal_OutOfViewFrom Eval;
    
    if (NavHandle != none)
    {
        Eval = NavMeshGoal_OutOfViewFrom(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != none)
        {
            Eval.OutOfViewLocation = InOutOfViewLocation;
            NavHandle.AddGoalEvaluator(Eval);
            return true;
        }
    }
    return false;
}

native function RecycleNative()
{
}

defaultproperties
{
}
