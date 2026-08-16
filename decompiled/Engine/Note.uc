class Note extends Actor
    native
    placeable
    hidecategories(Navigation);

var() string Text;

defaultproperties
{
    bStatic=True
    bHidden=True
    bNoDelete=True
    bMovable=False
    Components(0)="Default__Note.Arrow"
    Components(1)="Default__Note.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
