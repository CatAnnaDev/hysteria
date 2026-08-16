class PathNode extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

simulated event string GetDebugAbbrev()
{
    return "PN";
}

defaultproperties
{
    CylinderComponent="Default__PathNode.CollisionCylinder"
    GoodSprite="Default__PathNode.Sprite"
    BadSprite="Default__PathNode.Sprite2"
    Components(0)="Default__PathNode.Sprite"
    Components(1)="Default__PathNode.Sprite2"
    Components(2)="Default__PathNode.Arrow"
    Components(3)="Default__PathNode.CollisionCylinder"
    Components(4)="Default__PathNode.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__PathNode.CollisionCylinder"
}
