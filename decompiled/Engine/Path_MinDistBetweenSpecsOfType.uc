class Path_MinDistBetweenSpecsOfType extends PathConstraint
    native
    notplaceable;

var float MinDistBetweenSpecTypes;
var Vector InitLocation;
var class<ReachSpec> ReachSpecClass;

function Recycle()
{
    Recycle();
    MinDistBetweenSpecTypes = default.MinDistBetweenSpecTypes;
    ReachSpecClass = none;
    InitLocation = vect(0.0, 0.0, 0.0);
}

static function bool EnforceMinDist(Pawn P, float InMinDist, class<ReachSpec> InSpecClass, optional Vector LastLocation)
{
    local Path_MinDistBetweenSpecsOfType Con;
    
    if (P != none && P.bCanMantle && InMinDist > 0.0)
    {
        Con = Path_MinDistBetweenSpecsOfType(P.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.MinDistBetweenSpecTypes = InMinDist;
            Con.InitLocation = LastLocation;
            Con.ReachSpecClass = InSpecClass;
            P.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    CacheIdx=10
}
