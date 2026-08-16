class PathBlockingVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

defaultproperties
{
    BrushComponent="Default__PathBlockingVolume.BrushComponent0"
    bWorldGeometry=True
    bCollideActors=False
    bBlockActors=True
    Components(0)="Default__PathBlockingVolume.BrushComponent0"
    CollisionComponent="Default__PathBlockingVolume.BrushComponent0"
}
