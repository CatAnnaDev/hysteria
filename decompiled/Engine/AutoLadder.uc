class AutoLadder extends Ladder
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    CylinderComponent="Default__AutoLadder.CollisionCylinder"
    GoodSprite="Default__AutoLadder.Sprite"
    BadSprite="Default__AutoLadder.Sprite2"
    bCollideWhenPlacing=False
    Components(0)="Default__AutoLadder.Sprite"
    Components(1)="Default__AutoLadder.Sprite2"
    Components(2)="Default__AutoLadder.Arrow"
    Components(3)="Default__AutoLadder.CollisionCylinder"
    Components(4)="Default__AutoLadder.PathRenderer"
    CollisionComponent="Default__AutoLadder.CollisionCylinder"
}
