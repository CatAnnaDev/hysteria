class NavMeshPath_EnforceTwoWayEdges extends NavMeshPathConstraint
    native
    notplaceable;

static function bool EnforceTwoWayEdges(NavigationHandle NavHandle)
{
    local NavMeshPath_EnforceTwoWayEdges Con;
    
    if (NavHandle != none)
    {
        Con = NavMeshPath_EnforceTwoWayEdges(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
}
