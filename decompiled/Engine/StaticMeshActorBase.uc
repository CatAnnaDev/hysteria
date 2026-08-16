class StaticMeshActorBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    bStatic=True
    bWorldGeometry=True
    bRouteBeginPlayEvenIfStatic=False
    bGameRelevant=True
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    bEdShouldSnap=True
    CollisionType="COLLIDE_CustomDefault"
}
