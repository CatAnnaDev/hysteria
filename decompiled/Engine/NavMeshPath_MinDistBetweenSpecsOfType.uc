class NavMeshPath_MinDistBetweenSpecsOfType extends NavMeshPathConstraint
    native
    notplaceable;

var float MinDistBetweenEdgeTypes;
var Vector InitLocation;
var ENavMeshEdgeType EdgeType;

function Recycle()
{
    Recycle();
    MinDistBetweenEdgeTypes = default.MinDistBetweenEdgeTypes;
    EdgeType = 0;
    InitLocation = vect(0.0, 0.0, 0.0);
}

static function bool EnforceMinDist(NavigationHandle NavHandle, float InMinDist, ENavMeshEdgeType InEdgeType, optional Vector LastLocation)
{
    local NavMeshPath_MinDistBetweenSpecsOfType Con;
    
    if (NavHandle != none && InMinDist > 0.0)
    {
        Con = NavMeshPath_MinDistBetweenSpecsOfType(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.MinDistBetweenEdgeTypes = InMinDist;
            Con.InitLocation = LastLocation;
            Con.EdgeType = InEdgeType;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
}
