class NavMeshGoal_ClosestActorInList extends NavMeshPathGoalEvaluator
    native
    notplaceable;

var array<BiasedGoalActor> GoalList;
var const native transient MultiMap_Mirror PolyToGoalActorMap;
var native Pointer CachedAnchorPoly;

native function RecycleInternal()
{
}

event Recycle()
{
    Recycle();
    GoalList.Length = 0;
    RecycleInternal();
}

static function NavMeshGoal_ClosestActorInList ClosestActorInList(NavigationHandle NavHandle, out const array<BiasedGoalActor> InGoalList)
{
    local NavMeshGoal_ClosestActorInList Eval;
    
    Eval = NavMeshGoal_ClosestActorInList(NavHandle.CreatePathGoalEvaluator(default.Class));
    Eval.GoalList = InGoalList;
    NavHandle.AddGoalEvaluator(Eval);
    return Eval;
}

defaultproperties
{
    MaxPathVisits=3000
}
