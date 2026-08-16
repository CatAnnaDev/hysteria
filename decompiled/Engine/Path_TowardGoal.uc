class Path_TowardGoal extends PathConstraint
    native
    notplaceable;

var Actor GoalActor;

function Recycle()
{
    Recycle();
    GoalActor = none;
}

static function bool TowardGoal(Pawn P, Actor Goal)
{
    local Path_TowardGoal Con;
    
    if (P != none && Goal != none)
    {
        Con = Path_TowardGoal(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.GoalActor = Goal;
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    CacheIdx=1
}
