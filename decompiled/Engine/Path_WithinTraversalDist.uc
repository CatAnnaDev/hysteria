class Path_WithinTraversalDist extends PathConstraint
    native
    notplaceable;

var() float MaxTraversalDist;
var() bool bSoft;
var() float SoftStartPenalty;

function Recycle()
{
    Recycle();
    MaxTraversalDist = default.MaxTraversalDist;
    bSoft = default.bSoft;
    SoftStartPenalty = default.SoftStartPenalty;
}

static function bool DontExceedMaxDist(Pawn P, float InMaxTraversalDist, optional bool bInSoft = true)
{
    local Path_WithinTraversalDist Con;
    
    if (P != none && InMaxTraversalDist > 0.0)
    {
        Con = Path_WithinTraversalDist(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.MaxTraversalDist = InMaxTraversalDist;
            Con.bSoft = bInSoft;
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    bSoft=True
    SoftStartPenalty=320.0
    CacheIdx=4
}
