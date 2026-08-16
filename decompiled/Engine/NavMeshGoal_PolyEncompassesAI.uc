class NavMeshGoal_PolyEncompassesAI extends NavMeshPathGoalEvaluator
    native
    notplaceable;

function Recycle()
{
    Recycle();
}

static function bool MakeSureAIFits(NavigationHandle NavHandle)
{
    local NavMeshGoal_PolyEncompassesAI Eval;
    
    if (NavHandle != none)
    {
        Eval = NavMeshGoal_PolyEncompassesAI(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != none)
        {
            NavHandle.AddGoalEvaluator(Eval);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    MaxPathVisits=64
}
