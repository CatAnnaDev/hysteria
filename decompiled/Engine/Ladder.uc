class Ladder extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var LadderVolume MyLadder;
var Ladder LadderList;

event bool SuggestMovePreparation(Pawn Other)
{
    if (MyLadder == none)
    {
        return false;
    }
    if (!MyLadder.InUse(Other))
    {
        MyLadder.PendingClimber = Other;
        return false;
    }
    Other.Controller.bPreparingMove = true;
    Other.Acceleration = vect(0.0, 0.0, 0.0);
    return true;
}

defaultproperties
{
    bSpecialMove=True
    bNotBased=True
    CylinderComponent="Default__Ladder.CollisionCylinder"
    GoodSprite="Default__Ladder.Sprite"
    BadSprite="Default__Ladder.Sprite2"
    Components(0)="Default__Ladder.Sprite"
    Components(1)="Default__Ladder.Sprite2"
    Components(2)="Default__Ladder.Arrow"
    Components(3)="Default__Ladder.CollisionCylinder"
    Components(4)="Default__Ladder.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Ladder.CollisionCylinder"
}
