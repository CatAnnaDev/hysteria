class AliceSlideVolume extends PhysicsVolume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() bool bCanControl;
var() bool bCanJump;
var() bool bOneWayOnly;

simulated event PawnLeavingVolume(Pawn P)
{
}

simulated event PawnEnteredVolume(Pawn P)
{
}

defaultproperties
{
    BrushComponent="Default__AliceSlideVolume.BrushComponent0"
    Components(0)="Default__AliceSlideVolume.BrushComponent0"
    CollisionComponent="Default__AliceSlideVolume.BrushComponent0"
}
