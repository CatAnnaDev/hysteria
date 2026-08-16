class MaterialInterface extends Surface
    abstract
    native
    notplaceable;

enum EMaterialUsage
{
    MATUSAGE_SkeletalMesh,
    MATUSAGE_FracturedMeshes,
    MATUSAGE_ParticleSprites,
    MATUSAGE_BeamTrails,
    MATUSAGE_ParticleSubUV,
    MATUSAGE_Foliage,
    MATUSAGE_SpeedTree,
    MATUSAGE_StaticLighting,
    MATUSAGE_GammaCorrection,
    MATUSAGE_LensFlare,
    MATUSAGE_InstancedMeshParticles,
    MATUSAGE_FluidSurface,
    MATUSAGE_Decals,
    MATUSAGE_MaterialEffect,
    MATUSAGE_MorphTargets,
    MATUSAGE_FogVolumes,
    MATUSAGE_RadialBlur,
    MATUSAGE_InstancedMeshes,
    MATUSAGE_SplineMesh,
    MATUSAGE_VertexDisturbance,
    MATUSAGE_ScreenDoorFade,
    MATUSAGE_APEXMesh,
    MATUSAGE_SPHFluid,
    MATUSAGE_Hair,
};

struct native LightmassMaterialInterfaceSettings
{
    var(Material) float EmissiveBoost;
    var(Material) float DiffuseBoost;
    var float SpecularBoost;
    var(Material) float ExportResolutionScale;
    var(Material) float DistanceFieldPenumbraScale;
    var bool bOverrideEmissiveBoost;
    var bool bOverrideDiffuseBoost;
    var bool bOverrideSpecularBoost;
    var bool bOverrideExportResolutionScale;
    var bool bOverrideDistanceFieldPenumbraScale;
};

var const native transient RenderCommandFence_Mirror ParentRefFence;
var(Lightmass) LightmassMaterialInterfaceSettings LightmassSettings;
var() editoronly string PreviewMesh;
var const Guid LightingGuid;
var(Mobile) Texture FlattenedTexture;

native function SetForceMipLevelsToBeResident(bool OverrideForceMiplevelsToBeResident, bool bForceMiplevelsToBeResidentValue, float ForceDuration, optional int CinematicTextureGroups = 0)
{
    OverrideForceMiplevelsToBeResident;
    bForceMiplevelsToBeResidentValue;
    ForceDuration;
    CinematicTextureGroups;
}

native function bool GetVectorCurveParameterValue(name ParameterName, out InterpCurveVector OutValue)
{
    ParameterName;
    OutValue;
}

native function bool GetVectorParameterValue(name ParameterName, out LinearColor OutValue)
{
    ParameterName;
    OutValue;
}

native function bool GetTextureParameterValue(name ParameterName, out Texture OutValue)
{
    ParameterName;
    OutValue;
}

native function bool GetScalarCurveParameterValue(name ParameterName, out InterpCurveFloat OutValue)
{
    ParameterName;
    OutValue;
}

native function bool GetScalarParameterValue(name ParameterName, out float OutValue)
{
    ParameterName;
    OutValue;
}

native function bool GetFontParameterValue(name ParameterName, out Font OutFontValue, out int OutFontPage)
{
    ParameterName;
    OutFontValue;
    OutFontPage;
}

native final function PhysicalMaterial GetPhysicalMaterial()
{
}

native final function Material GetMaterial()
{
}

defaultproperties
{
    LightmassSettings=(EmissiveBoost=1.0,DiffuseBoost=1.0,SpecularBoost=1.0,ExportResolutionScale=1.0,DistanceFieldPenumbraScale=1.0,bOverrideEmissiveBoost=False,bOverrideDiffuseBoost=False,bOverrideSpecularBoost=False,bOverrideExportResolutionScale=False,bOverrideDistanceFieldPenumbraScale=False)
}
