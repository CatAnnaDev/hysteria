class Terrain extends Info
    native
    placeable
    hidecategories(Navigation);

struct SelectedTerrainVertex
{
    var int X;
    var int Y;
    var int Weight;
};

struct native CachedTerrainMaterialArray
{
    var const native array<Pointer> CachedMaterials;
};

struct TerrainMaterialResource
{
};

struct TerrainDecoLayer
{
    var() string Name;
    var() array<TerrainDecoration> Decorations;
    var int AlphaMapIndex;
};

struct TerrainDecoration
{
    var() editinline PrimitiveComponentFactory Factory;
    var() float MinScale;
    var() float MaxScale;
    var() float Density;
    var() float SlopeRotationBlend;
    var() int RandSeed;
    var array<TerrainDecorationInstance> Instances;
};

struct TerrainDecorationInstance
{
    var export editinline PrimitiveComponent Component;
    var float X;
    var float Y;
    var float Scale;
    var int Yaw;
};

struct AlphaMap
{
};

struct TerrainLayer
{
    var() string Name;
    var() TerrainLayerSetup Setup;
    var int AlphaMapIndex;
    var() bool Highlighted;
    var() bool WireframeHighlighted;
    var() bool Hidden;
    var() Color HighlightColor;
    var() Color WireframeColor;
    var int MinX;
    var int MinY;
    var int MaxX;
    var int MaxY;
};

struct TerrainWeightedMaterial
{
};

struct TerrainInfoData
{
};

struct TerrainHeight
{
};

var const native array<TerrainHeight> Heights;
var const native array<TerrainInfoData> InfoData;
var() const array<TerrainLayer> Layers;
var() int NormalMapLayer;
var() const array<TerrainDecoLayer> DecoLayers;
var const native array<AlphaMap> AlphaMaps;
var const export editinline nontransactional array<TerrainComponent> TerrainComponents;
var const int NumSectionsX;
var const int NumSectionsY;
var const int SectionSize;
var const native array<TerrainWeightedMaterial> WeightedMaterials;
var const native array<TerrainWeightMapTexture> WeightedTextureMaps;
var const native array<byte> CachedDisplacements;
var const native float MaxCollisionDisplacement;
var() int MaxTesselationLevel;
var() int MinTessellationLevel;
var() float TesselationDistanceScale;
var() float TessellationCheckDistance;
var(Collision) int CollisionTesselationLevel;
var const native CachedTerrainMaterialArray CachedTerrainMaterials[2];
var const int NumVerticesX;
var const int NumVerticesY;
var() int NumPatchesX;
var() int NumPatchesY;
var() int MaxComponentSize;
var(Lighting) int StaticLightingResolution;
var(Lighting) bool bIsOverridingLightResolution;
var(Lighting) bool bBilinearFilterLightmapGeneration;
var(Lighting) bool bCastShadow;
var(Lighting) const bool bForceDirectLightMap;
var(Lighting) const bool bCastDynamicShadow;
var(Lighting) bool bEnableSpecular;
var(Collision) const bool bBlockRigidBody;
var(Collision) const bool bAllowRigidBodyUnderneath;
var(Collision) bool CanBlockCamera;
var(Lighting) const bool bAcceptsDynamicLights;
var() bool bMorphingEnabled;
var() bool bMorphingGradientsEnabled;
var bool bLocked;
var bool bHeightmapLocked;
var bool bShowingCollision;
var() bool bUseWorldOriginTextureUVs;
var() bool bShowWireframe;
var(Physics) const PhysicalMaterial TerrainPhysMaterialOverride;
var(Lighting) const LightingChannelContainer LightingChannels;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
var const native Pointer ReleaseResourcesFence;
var() transient int EditorTessellationLevel;
var transient array<SelectedTerrainVertex> SelectedVertices;
var() Color WireframeColor;
var const Guid LightingGuid;

native function GetLayerAlpha(Vector Loc, out array<float> LayerAlphaArray)
{
    Loc;
    LayerAlphaArray;
}

simulated event PostBeginPlay()
{
    local int I;
    
    CalcLayerBounds();
    for (I = 0; I < Layers.Length; I++)
    {
        if (Layers[I].Setup != none)
        {
            Layers[I].Setup.PostBeginPlay();
        }
    }
}

native final function CalcLayerBounds()
{
}

defaultproperties
{
    NormalMapLayer=-1
    MaxTesselationLevel=4
    MinTessellationLevel=1
    TesselationDistanceScale=1.0
    TessellationCheckDistance=-1.0
    CollisionTesselationLevel=1
    NumPatchesX=1
    NumPatchesY=1
    MaxComponentSize=16
    StaticLightingResolution=4
    bBilinearFilterLightmapGeneration=True
    bCastShadow=True
    bForceDirectLightMap=True
    bCastDynamicShadow=True
    bBlockRigidBody=True
    CanBlockCamera=True
    bAcceptsDynamicLights=True
    LightingChannels=(bInitialized=True,BSP=False,Static=True,Dynamic=False,CompositeDynamic=False,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,PhysXLighting_1=False,PhysXLighting_2=False,PhysXLighting_3=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=False)
    LightmassSettings=(bUseTwoSidedLighting=False,bShadowIndirectOnly=False,bUseEmissiveForStaticLighting=False,EmissiveLightFalloffExponent=2.0,EmissiveLightExplicitInfluenceRadius=0.0,EmissiveBoost=1.0,DiffuseBoost=1.0,SpecularBoost=1.0,FullyOccludedSamplesFraction=1.0)
    WireframeColor=(B=255,G=255,R=0,A=0)
    bStatic=True
    bHidden=False
    bNoDelete=True
    bWorldGeometry=True
    bCollideActors=True
    bBlockActors=True
    bEdShouldSnap=True
    Components(0)="Default__Terrain.Sprite"
    DrawScale3D=(X=256.0,Y=256.0,Z=256.0)
}
