class NavMeshPath_Toward extends NavMeshPathConstraint
    native
    notplaceable;

var Actor GoalActor;
var Vector GoalPoint;

function Recycle()
{
    Recycle();
    GoalActor = none;
    GoalPoint = default.GoalPoint;
}

static function bool TowardPoint(NavigationHandle NavHandle, Vector Point)
{
    local NavMeshPath_Toward Con;
    
    if (NavHandle != none && Point != vect(0.0, 0.0, 0.0))
    {
        Con = NavMeshPath_Toward(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.GoalPoint = Point;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

static function bool TowardGoal(NavigationHandle NavHandle, Actor Goal)
{
    local NavMeshPath_Toward Con;
    
    if (NavHandle != none && Goal != none)
    {
        Con = NavMeshPath_Toward(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.GoalActor = Goal;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
}
