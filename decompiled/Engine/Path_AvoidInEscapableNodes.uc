class Path_AvoidInEscapableNodes extends PathConstraint
    native
    notplaceable;

var int Radius;
var int Height;
var int MaxFallSpeed;
var int MoveFlags;

function Recycle()
{
    Recycle();
    Radius = 0;
    Height = 0;
    MaxFallSpeed = 0;
    MoveFlags = 0;
}

static function bool DontGetStuck(Pawn P)
{
    local Path_AvoidInEscapableNodes Con;
    
    if (P != none)
    {
        Con = Path_AvoidInEscapableNodes(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.CachePawnReacFlags(P);
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

native private final function CachePawnReacFlags(Pawn P)
{
    P;
}

defaultproperties
{
    CacheIdx=11
}
