class NavMeshPath_BiasAgainstPolysWithinDistanceOfLocations extends NavMeshPathConstraint
    native
    notplaceable;

var transient Vector Location;
var transient Vector Rotation;
var transient float DistanceToCheck;
var transient array<Vector> LocationsToCheck;

function Recycle()
{
    Recycle();
}

static function bool BiasAgainstPolysWithinDistanceOfLocations(NavigationHandle NavHandle, const Vector InLocation, const Rotator InRotation, const float InDistanceToCheck, const array<Vector> InLocationsToCheck)
{
    local NavMeshPath_BiasAgainstPolysWithinDistanceOfLocations Con;
    
    if (NavHandle != none)
    {
        Con = NavMeshPath_BiasAgainstPolysWithinDistanceOfLocations(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.Location = InLocation;
            Con.Rotation = vector(InRotation);
            Con.DistanceToCheck = InDistanceToCheck;
            Con.LocationsToCheck = InLocationsToCheck;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
}
