class Path_AlongLine extends PathConstraint
    native
    notplaceable;

var Vector Direction;

function Recycle()
{
    Recycle();
    Direction = vect(0.0, 0.0, 0.0);
}

static function bool AlongLine(Pawn P, Vector Dir)
{
    local Path_AlongLine Con;
    
    if (P != none && !IsZero(Dir))
    {
        Con = Path_AlongLine(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.Direction = Dir;
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    CacheIdx=0
}
