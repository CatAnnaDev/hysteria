class InstancedStaticMeshComponent extends StaticMeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native InstancedStaticMeshMappingInfo
{
    var native Pointer Mapping;
    var native Pointer LightMap;
    var Texture2D LightmapTexture;
    var ShadowMap2D ShadowmapTexture;
};

struct native immutable InstancedStaticMeshInstanceData
{
    var Matrix Transform;
    var Vector2D LightmapUVBias;
    var Vector2D ShadowmapUVBias;
};

var deprecated array<InstancedStaticMeshInstanceData> PerInstanceData;
var native array<InstancedStaticMeshInstanceData> PerInstanceSMData;
var transient int NumPendingLightmaps;
var int ComponentJoinKey;
var transient array<InstancedStaticMeshMappingInfo> CachedMappings;
var() int InstancingRandomSeed;

defaultproperties
{
    ReplacementPrimitive="None"
}
