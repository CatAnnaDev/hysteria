class MantleMarker extends NavigationPoint
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() editconst CoverInfo OwningSlot;

defaultproperties
{
    bSpecialMove=True
    CylinderComponent="Default__MantleMarker.CollisionCylinder"
    GoodSprite="Default__MantleMarker.Sprite"
    BadSprite="Default__MantleMarker.Sprite2"
    bCollideWhenPlacing=False
    Components(0)="Default__MantleMarker.Sprite"
    Components(1)="Default__MantleMarker.Sprite2"
    Components(2)="Default__MantleMarker.CollisionCylinder"
    Components(3)="Default__MantleMarker.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__MantleMarker.CollisionCylinder"
}
