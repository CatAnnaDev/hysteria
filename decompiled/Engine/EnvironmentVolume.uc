class EnvironmentVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display)
    implements(Interface_NavMeshPathObstacle,Interface_NavMeshPathObject);

var const native noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var const native noexport Pointer VfTable_IInterface_NavMeshPathObject;
var const transient bool bSplitNavMesh;

native final function SetSplitNavMesh(bool bNewValue)
{
    bNewValue;
}

defaultproperties
{
    BrushComponent="Default__EnvironmentVolume.BrushComponent0"
    Components(0)="Default__EnvironmentVolume.BrushComponent0"
    CollisionComponent="Default__EnvironmentVolume.BrushComponent0"
}
