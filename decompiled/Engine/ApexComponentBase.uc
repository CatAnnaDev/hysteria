class ApexComponentBase extends MeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var const native transient Pointer ComponentBaseResources;
var const native transient RenderCommandFence_Mirror ReleaseResourcesFence;
var() const ApexAsset Asset;
var() Color WireframeColor;
var const bool bAssetChanged;

defaultproperties
{
    WireframeColor=(B=64,G=128,R=255,A=255)
    ReplacementPrimitive="None"
    CollideActors=True
    BlockActors=True
    BlockZeroExtent=True
    BlockNonZeroExtent=True
    BlockRigidBody=True
    TickGroup="TG_PreAsyncWork"
}
