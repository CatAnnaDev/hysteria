class NavMeshPath_AlongLine extends NavMeshPathConstraint
    native
    notplaceable;

var Vector Direction;

function Recycle()
{
    Recycle();
    Direction = vect(0.0, 0.0, 0.0);
}

static function bool AlongLine(NavigationHandle NavHandle, Vector Dir)
{
    local NavMeshPath_AlongLine Con;
    
    if (NavHandle != none && !IsZero(Dir))
    {
        Con = NavMeshPath_AlongLine(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.Direction = Dir;
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
}
