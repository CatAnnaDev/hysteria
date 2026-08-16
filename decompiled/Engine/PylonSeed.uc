class PylonSeed extends Actor
    native
    placeable
    hidecategories(Navigation)
    implements(Interface_NavMeshPathObject);

var const native noexport Pointer VfTable_IInterface_NavMeshPathObject;

defaultproperties
{
    Components(0)="Default__PylonSeed.CollisionCylinder"
    Components(1)="Default__PylonSeed.Sprite"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__PylonSeed.CollisionCylinder"
}
