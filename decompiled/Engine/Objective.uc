class Objective extends NavigationPoint
    abstract
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    bMustBeReachable=True
    CylinderComponent="Default__Objective.CollisionCylinder"
    GoodSprite="Default__Objective.Sprite"
    BadSprite="Default__Objective.Sprite2"
    Components(0)="Default__Objective.Sprite"
    Components(1)="Default__Objective.Sprite2"
    Components(2)="Default__Objective.Arrow"
    Components(3)="Default__Objective.CollisionCylinder"
    Components(4)="Default__Objective.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Objective.CollisionCylinder"
}
