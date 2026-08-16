class NavMeshPath_WithinTraversalDist extends NavMeshPathConstraint
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

static function bool DontExceedMaxDist(NavigationHandle NavHandle, float InMaxTraversalDist, optional bool bInSoft = true)
{
    local NavMeshPath_WithinTraversalDist Con;
    
    if (NavHandle != none && InMaxTraversalDist > 0.0)
    {
        Con = NavMeshPath_WithinTraversalDist(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.MaxTraversalDist = InMaxTraversalDist;
            Con.bSoft = bInSoft;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    bSoft=True
    SoftStartPenalty=320.0
}
