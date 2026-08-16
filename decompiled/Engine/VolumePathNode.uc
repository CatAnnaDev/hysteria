class VolumePathNode extends PathNode
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() float StartingRadius;
var() float StartingHeight;

defaultproperties
{
    StartingRadius=2000.0
    StartingHeight=2000.0
    bNoAutoConnect=True
    bNotBased=True
    bFlyingPreferred=True
    bVehicleDestination=True
    bBuildLongPaths=False
    CylinderComponent="Default__VolumePathNode.CollisionCylinder"
    GoodSprite="Default__VolumePathNode.Sprite"
    BadSprite="Default__VolumePathNode.Sprite2"
    Components(0)="Default__VolumePathNode.Sprite"
    Components(1)="Default__VolumePathNode.Sprite2"
    Components(2)="Default__VolumePathNode.Arrow"
    Components(3)="Default__VolumePathNode.CollisionCylinder"
    Components(4)="Default__VolumePathNode.PathRenderer"
    CollisionComponent="Default__VolumePathNode.CollisionCylinder"
}
