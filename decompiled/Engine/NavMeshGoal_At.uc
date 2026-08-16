class NavMeshGoal_At extends NavMeshPathGoalEvaluator
    native
    notplaceable;

var Vector Goal;
var float GoalDist;
var bool bKeepPartial;
var native Pointer GoalPoly;
var native Pointer PartialGoal;

function Recycle()
{
    Goal = vect(0.0, 0.0, 0.0);
    GoalDist = default.GoalDist;
    bKeepPartial = default.bKeepPartial;
    RecycleNative();
    Recycle();
}

static function bool AtLocation(NavigationHandle NavHandle, Vector GoalLocation, optional float Dist, optional bool bReturnPartial)
{
    local NavMeshGoal_At Eval;
    
    if (NavHandle != none)
    {
        Eval = NavMeshGoal_At(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != none)
        {
            Eval.Goal = GoalLocation;
            Eval.GoalDist = Dist;
            Eval.bKeepPartial = bReturnPartial;
            NavHandle.AddGoalEvaluator(Eval);
            return true;
        }
    }
    return false;
}

static function bool AtActor(NavigationHandle NavHandle, Actor GoalActor, optional float Dist, optional bool bReturnPartial)
{
    local Controller GoalController, MyController;
    
    if (NavHandle != none)
    {
        GoalController = Controller(GoalActor);
        if (GoalController != none)
        {
            GoalActor = GoalController.Pawn;
        }
        if (GoalActor != none)
        {
            MyController = Controller(NavHandle.Outer);
            return AtLocation(NavHandle, GoalActor.GetDestination(MyController), Dist, bReturnPartial);
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
