class PathNode_Dynamic extends PathNode
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

simulated event string GetDebugAbbrev()
{
    return "DynPN";
}

defaultproperties
{
    CylinderComponent="Default__PathNode_Dynamic.CollisionCylinder"
    GoodSprite="Default__PathNode_Dynamic.Sprite"
    BadSprite="Default__PathNode_Dynamic.Sprite2"
    bStatic=False
    Components(0)="Default__PathNode_Dynamic.Sprite"
    Components(1)="Default__PathNode_Dynamic.Sprite2"
    Components(2)="Default__PathNode_Dynamic.Arrow"
    Components(3)="Default__PathNode_Dynamic.CollisionCylinder"
    Components(4)="Default__PathNode_Dynamic.PathRenderer"
    CollisionComponent="Default__PathNode_Dynamic.CollisionCylinder"
}
