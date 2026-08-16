class MeshComponentFactory extends PrimitiveComponentFactory
    abstract
    native
    notplaceable;

var(Rendering) array<MaterialInterface> Materials;

defaultproperties
{
    CastShadow=True
}
