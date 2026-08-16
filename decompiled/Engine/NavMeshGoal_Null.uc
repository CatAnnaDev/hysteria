class NavMeshGoal_Null extends NavMeshPathGoalEvaluator
    native
    notplaceable;

var native Pointer PartialGoal;

function Recycle()
{
    Recycle();
    MaxPathVisits = default.MaxPathVisits;
    RecycleNative();
}

native function RecycleNative()
{
}

static function bool GoUntilBust(NavigationHandle NavHandle, optional int InMaxPathVisits = -1)
{
    local NavMeshGoal_Null Eval;
    
    if (NavHandle != none)
    {
        Eval = NavMeshGoal_Null(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != none)
        {
            if (InMaxPathVisits > 0)
            {
                Eval.MaxPathVisits = InMaxPathVisits;
            }
            NavHandle.AddGoalEvaluator(Eval);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    MaxPathVisits=2048
}
