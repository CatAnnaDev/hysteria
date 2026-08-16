class TestSplittingVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display)
    implements(Interface_NavMeshPathObject);

var const native noexport Pointer VfTable_IInterface_NavMeshPathObject;

defaultproperties
{
    BrushComponent="Default__TestSplittingVolume.BrushComponent0"
    Components(0)="Default__TestSplittingVolume.BrushComponent0"
    CollisionComponent="Default__TestSplittingVolume.BrushComponent0"
}
