class AliceWaterVolume extends DynamicPhysicsVolume
    placeable
    hidecategories(Navigation,Object,Display);

var(swim) Trigger SwimTargetPoint;

simulated event PawnLeavingVolume(Pawn P)
{
    if (AlicePawn(P) == none)
    {
        return;
    }
    PawnLeavingVolume(P);
}

simulated event PawnEnteredVolume(Pawn P)
{
}

defaultproperties
{
    bWaterVolume=True
    BrushComponent="Default__AliceWaterVolume.BrushComponent0"
    Components(0)="Default__AliceWaterVolume.BrushComponent0"
    CollisionComponent="Default__AliceWaterVolume.BrushComponent0"
}
