class DynamicAnchor extends NavigationPoint
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var Controller CurrentUser;

defaultproperties
{
    CylinderComponent="Default__DynamicAnchor.CollisionCylinder"
    GoodSprite="Default__DynamicAnchor.Sprite"
    BadSprite="Default__DynamicAnchor.Sprite2"
    bStatic=False
    bNoDelete=False
    bCollideWhenPlacing=False
    Components(0)="Default__DynamicAnchor.Sprite"
    Components(1)="Default__DynamicAnchor.Sprite2"
    Components(2)="Default__DynamicAnchor.Arrow"
    Components(3)="Default__DynamicAnchor.CollisionCylinder"
    Components(4)="Default__DynamicAnchor.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__DynamicAnchor.CollisionCylinder"
}
