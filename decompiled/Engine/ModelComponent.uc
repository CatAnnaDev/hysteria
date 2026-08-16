class ModelComponent extends PrimitiveComponent
    native
    noexport
    notplaceable;

var const native transient noexport Object Model;
var const native transient noexport int ZoneIndex;
var const native transient noexport int ComponentIndex;
var const native transient noexport array<Pointer> Nodes;
var const native transient noexport array<Pointer> Elements;

defaultproperties
{
    ReplacementPrimitive="None"
    bUseAsOccluder=True
    bAcceptsStaticDecals=True
    CastShadow=True
    bAcceptsLights=True
    bUsePrecomputedShadows=True
    bCullModulatedShadowOnBackfaces=True
    bCullModulatedShadowOnEmissive=True
    LightingChannels=(bInitialized=True,BSP=True)
}
