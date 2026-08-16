class PathTargetPoint extends Keypoint
    native
    placeable
    hidecategories(Navigation);

defaultproperties
{
    SpriteComp="Default__PathTargetPoint.Sprite"
    bStatic=False
    bHidden=False
    bNoDelete=True
    Components(0)="Default__PathTargetPoint.Sprite"
    Components(1)="Default__PathTargetPoint.Arrow"
    Components(2)="Default__PathTargetPoint.CollisionCylinder"
    CollisionComponent="Default__PathTargetPoint.CollisionCylinder"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_AIReachedRouteActor"
}
