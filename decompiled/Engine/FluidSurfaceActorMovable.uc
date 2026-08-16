class FluidSurfaceActorMovable extends FluidSurfaceActor
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(FluidSurfaceActor,FluidSurfaceComponent);

defaultproperties
{
    FluidComponent="Default__FluidSurfaceActorMovable.NewFluidComponent"
    bMovable=True
    Components(0)="Default__FluidSurfaceActorMovable.NewFluidComponent"
    Physics="PHYS_Interpolating"
}
