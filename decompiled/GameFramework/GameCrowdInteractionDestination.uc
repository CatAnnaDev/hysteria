class GameCrowdInteractionDestination extends GameCrowdDestination
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

defaultproperties
{
    bAvoidWhenPanicked=True
    bMustReachExactly=True
    bAllowsSpawning=False
    Capacity=1
    CylinderComponent="Default__GameCrowdInteractionDestination.CollisionCylinder"
    Components(0)="Default__GameCrowdInteractionDestination.CollisionCylinder"
    Components(1)="Default__GameCrowdInteractionDestination.Sprite"
    Components(2)="Default__GameCrowdInteractionDestination.ConnectionRenderer"
    CollisionComponent="Default__GameCrowdInteractionDestination.CollisionCylinder"
}
