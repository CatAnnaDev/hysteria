class WalkInWaterVolume extends PhysicsVolume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var(WaterWalk) Trigger LandTargetPoint;

simulated event PawnLeavingVolume(Pawn P)
{
    AlicePawn(P).SetNormalWalkParameters();
}

simulated event PawnEnteredVolume(Pawn P)
{
    AlicePawn(P).SetWaterWalkParameters();
}

defaultproperties
{
    BrushComponent="Default__WalkInWaterVolume.BrushComponent0"
    Components(0)="Default__WalkInWaterVolume.BrushComponent0"
    CollisionComponent="Default__WalkInWaterVolume.BrushComponent0"
}
