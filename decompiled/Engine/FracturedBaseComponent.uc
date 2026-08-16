class FracturedBaseComponent extends StaticMeshComponent
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var const native transient Pointer ComponentBaseResources;
var const native transient RenderCommandFence_Mirror ReleaseResourcesFence;
var const transient array<byte> VisibleFragments;
var transient bool bVisibilityHasChanged;
var const transient bool bVisibilityReset;
var const bool bInitialVisibilityValue;
var const bool bUseDynamicIndexBuffer;
var const bool bUseDynamicIBWithHiddenFragments;
var const int NumResourceIndices;
var const int ComponentIndexBufferSize;
var const transient int bResetStaticMesh;

native function int GetNumVisibleFragments()
{
}

native function int GetNumFragments()
{
}

native simulated function bool IsFragmentVisible(int FragmentIndex)
{
    FragmentIndex;
}

native simulated function array<byte> GetVisibleFragments()
{
}

native simulated function bool SetStaticMesh(StaticMesh NewMesh, optional bool bForce)
{
    NewMesh;
    bForce;
}

defaultproperties
{
    bInitialVisibilityValue=True
    bUseDynamicIndexBuffer=True
    ReplacementPrimitive="None"
    bAcceptsStaticDecals=False
}
