class Goal_Null extends PathGoalEvaluator
    native
    notplaceable;

function Recycle()
{
    Recycle();
    MaxPathVisits = default.MaxPathVisits;
}

static function bool GoUntilBust(Pawn P, optional int InMaxPathVisits = -1)
{
    local Goal_Null Eval;
    
    if (P != none)
    {
        Eval = Goal_Null(P.CreatePathGoalEvaluator(default.Class));
        if (Eval != none)
        {
            if (InMaxPathVisits > 0)
            {
                Eval.MaxPathVisits = InMaxPathVisits;
            }
            P.AddGoalEvaluator(Eval);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    MaxPathVisits=2048
    CacheIdx=5
}
