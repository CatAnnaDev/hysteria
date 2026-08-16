class GravityVolume extends PhysicsVolume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() float GravityZ;

defaultproperties
{
    GravityZ=-520.0
    BrushComponent="Default__GravityVolume.BrushComponent0"
    Components(0)="Default__GravityVolume.BrushComponent0"
    CollisionComponent="Default__GravityVolume.BrushComponent0"
}
