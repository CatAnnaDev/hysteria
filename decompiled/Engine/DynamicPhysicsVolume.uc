class DynamicPhysicsVolume extends PhysicsVolume
    placeable
    hidecategories(Navigation,Object,Display);

var() bool bEnabled;

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetCollision(bEnabled, bBlockActors);
}

defaultproperties
{
    bEnabled=True
    BrushColor=(B=255,G=255,R=100,A=255)
    bColored=True
    BrushComponent="Default__DynamicPhysicsVolume.BrushComponent0"
    bStatic=False
    Components(0)="Default__DynamicPhysicsVolume.BrushComponent0"
    Physics="PHYS_Interpolating"
    CollisionComponent="Default__DynamicPhysicsVolume.BrushComponent0"
}
