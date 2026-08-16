class DynamicGameCrowdDestination extends GameCrowdDestination
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

defaultproperties
{
    CylinderComponent="Default__DynamicGameCrowdDestination.CollisionCylinder"
    bStatic=False
    Components(0)="Default__DynamicGameCrowdDestination.CollisionCylinder"
    Components(1)="Default__DynamicGameCrowdDestination.Sprite"
    Components(2)="Default__DynamicGameCrowdDestination.ConnectionRenderer"
    CollisionComponent="Default__DynamicGameCrowdDestination.CollisionCylinder"
}
