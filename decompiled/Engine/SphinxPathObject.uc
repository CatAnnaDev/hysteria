class SphinxPathObject extends NavigationPoint
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() float EnterPointOffset;
var() float ExitPointOffset;

defaultproperties
{
    CylinderComponent="Default__SphinxPathObject.CollisionCylinder"
    GoodSprite="Default__SphinxPathObject.Sprite"
    BadSprite="Default__SphinxPathObject.Sprite2"
    Components(0)="Default__SphinxPathObject.Sprite"
    Components(1)="Default__SphinxPathObject.Sprite2"
    Components(2)="Default__SphinxPathObject.Arrow"
    Components(3)="Default__SphinxPathObject.CollisionCylinder"
    Components(4)="Default__SphinxPathObject.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__SphinxPathObject.CollisionCylinder"
}
