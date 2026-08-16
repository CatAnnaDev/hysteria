class FracturedSkinnedMeshComponent extends FracturedBaseComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var const native transient Pointer ComponentSkinResources;
var const transient array<Matrix> FragmentTransforms;
var const transient export editinline array<FracturedStaticMeshComponent> DependentComponents;
var const transient bool bBecameVisible;
var const transient bool bFragmentTransformsChanged;

defaultproperties
{
    bInitialVisibilityValue=False
    ReplacementPrimitive="None"
    bAllowCullDistanceVolume=False
    bAllowApproximateOcclusion=True
    bAcceptsDynamicDecals=False
    bAcceptsFoliage=False
    CastShadow=False
    bCastDynamicShadow=False
    CollideActors=False
    BlockActors=False
    BlockZeroExtent=False
    BlockNonZeroExtent=False
    BlockRigidBody=False
}
