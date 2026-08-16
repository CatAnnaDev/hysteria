class FracturedStaticMeshComponent extends FracturedBaseComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native FragmentGroup
{
    var array<int> FragmentIndices;
    var bool bGroupIsRooted;
};

var const transient array<byte> FragmentNeighborsVisible;
var const Box VisibleBox;
var const bool bUseSkinnedRendering;
var bool bUseVisibleVertsForBounds;
var() bool bTopFragmentsRootNonDestroyable;
var() bool bBottomFragmentsRootNonDestroyable;
var() float TopBottomFragmentDistThreshold;
var() MaterialInterface LoseChunkOutsideMaterialOverride;
var float FragmentBoundsMaxZ;
var float FragmentBoundsMinZ;
var transient export editinline FracturedSkinnedMeshComponent SkinnedComponent;

native final function PhysicalMaterial GetFracturedMeshPhysMaterial()
{
}

native final function RecreatePhysState()
{
}

native final function array<int> GetBoundaryHiddenFragments(array<int> AdditionalVisibleFragments)
{
    AdditionalVisibleFragments;
}

native final function array<FragmentGroup> GetFragmentGroups(array<int> IgnoreFragments, float MinConnectionArea)
{
    IgnoreFragments;
    MinConnectionArea;
}

native final function int GetCoreFragmentIndex()
{
}

native final function Vector GetFragmentAverageExteriorNormal(int FragmentIndex)
{
    FragmentIndex;
}

native final function Box GetFragmentBox(int FragmentIndex)
{
    FragmentIndex;
}

native final function bool IsNoPhysFragment(int FragmentIndex)
{
    FragmentIndex;
}

native final function bool IsRootFragment(int FragmentIndex)
{
    FragmentIndex;
}

native final function bool IsFragmentDestroyable(int FragmentIndex)
{
    FragmentIndex;
}

native final function SetVisibleFragments(array<byte> VisibilityFactors)
{
    VisibilityFactors;
}

defaultproperties
{
    TopBottomFragmentDistThreshold=0.1
    ReplacementPrimitive="None"
    bUsePrecomputedShadows=True
}
