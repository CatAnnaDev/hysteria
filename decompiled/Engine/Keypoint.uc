class Keypoint extends Actor
    abstract
    native
    placeable
    hidecategories(Navigation);

var export editinline SpriteComponent SpriteComp;

defaultproperties
{
    SpriteComp="Default__Keypoint.Sprite"
    bStatic=True
    bHidden=True
    Components(0)="Default__Keypoint.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
