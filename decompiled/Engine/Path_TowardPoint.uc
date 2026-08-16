class Path_TowardPoint extends PathConstraint
    native
    notplaceable;

var Vector GoalPoint;

function Recycle()
{
    Recycle();
    GoalPoint = default.GoalPoint;
}

static function bool TowardPoint(Pawn P, Vector Point)
{
    local Path_TowardPoint Con;
    
    if (P != none && Point != vect(0.0, 0.0, 0.0))
    {
        Con = Path_TowardPoint(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.GoalPoint = Point;
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    CacheIdx=2
}
