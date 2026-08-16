class ClimbableVolume extends PhysicsVolume
    abstract
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var(Info) Rotator WallDir;
var(Info) Vector LookDir;
var(Info) Vector ClimbDir;

defaultproperties
{
    BrushColor=(B=255,G=255,R=100,A=255)
    bColored=True
    BrushComponent="Default__ClimbableVolume.BrushComponent0"
    bStatic=False
    Components(0)="Default__ClimbableVolume.BrushComponent0"
    Physics="PHYS_Interpolating"
    CollisionComponent="Default__ClimbableVolume.BrushComponent0"
}
