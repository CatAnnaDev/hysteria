class EngineTypes extends Object
    abstract
    native
    notplaceable
    config(Engine);

enum ELightingBuildQuality
{
    Quality_Preview,
    Quality_Medium,
    Quality_High,
    Quality_Production,
};

struct native MaterialReferenceList
{
    var() MaterialInterface TargetMaterial;
    var array<MeshMaterialRef> AffectedMeshMaterialRefs;
    var export editinline array<DecalComponent> AffectedDecalMaterialRefs;
};

struct native MeshMaterialRef
{
    var export editinline MeshComponent MeshComp;
    var int MaterialIndex;
};

struct native RootMotionCurve
{
    var() name AnimName;
    var() InterpCurveVector Curve;
    var() float MaxCurveTime;
};

struct native SwarmDebugOptions
{
    var() bool bDistributionEnabled;
    var() bool bForceContentExport;
    var bool bInitialized;
};

struct native LightmassDebugOptions
{
    var() bool bDebugMode;
    var() bool bStatsEnabled;
    var() bool bGatherBSPSurfacesAcrossComponents;
    var() float CoplanarTolerance;
    var() bool bUseDeterministicLighting;
    var() bool bUseImmediateImport;
    var() bool bImmediateProcessMappings;
    var() bool bSortMappings;
    var() bool bDumpBinaryFiles;
    var() bool bDebugMaterials;
    var() bool bPadMappings;
    var() bool bDebugPaddings;
    var() bool bOnlyCalcDebugTexelMappings;
    var() bool bUseRandomColors;
    var() bool bColorBordersGreen;
    var() bool bColorByExecutionTime;
    var() float ExecutionTimeDivisor;
    var bool bInitialized;
};

struct LightmassPrimitiveSettings
{
    var() bool bUseTwoSidedLighting;
    var() bool bShadowIndirectOnly;
    var() bool bUseEmissiveForStaticLighting;
    var() float EmissiveLightFalloffExponent;
    var() float EmissiveLightExplicitInfluenceRadius;
    var() float EmissiveBoost;
    var() float DiffuseBoost;
    var float SpecularBoost;
    var() float FullyOccludedSamplesFraction;
};

struct native LightmassDirectionalLightSettings extends LightmassLightSettings
{
    var(Directional) float LightSourceAngle;
};

struct native LightmassPointLightSettings extends LightmassLightSettings
{
    var(Point) float LightSourceRadius;
};

struct native LightmassLightSettings
{
    var(General) float IndirectLightingScale;
    var(General) float IndirectLightingSaturation;
    var(General) float ShadowExponent;
};

struct native DominantShadowInfo
{
    var Matrix WorldToLight;
    var Matrix LightToWorld;
    var Box LightSpaceImportanceBounds;
    var int ShadowMapSizeX;
    var int ShadowMapSizeY;
};

struct native LocalizedSubtitle
{
    var string LanguageExt;
    var array<SubtitleCue> Subtitles;
    var bool bMature;
    var bool bManualWordWrap;
};

struct native SubtitleCue
{
    var() const localized string Text;
    var() const localized float Time;
};

defaultproperties
{
}
