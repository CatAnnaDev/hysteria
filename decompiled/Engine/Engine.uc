class Engine extends Subsystem
    abstract
    native
    notplaceable
    transient
    config(Engine);

enum ETransitionType
{
    TT_None,
    TT_Paused,
    TT_Loading,
    TT_Saving,
    TT_Connecting,
    TT_Precaching,
};

struct native AliceGamePlayerProfileData
{
    var float CompletPercent;
    var float PlayedHours;
    var float PlayedMin;
    var string PlayerName;
};

struct native DropNoteInfo
{
    var Vector Location;
    var Rotator Rotation;
    var string Comment;
};

struct native StatColorMapping
{
    var globalconfig string StatName;
    var globalconfig array<StatColorMapEntry> ColorMap;
    var globalconfig bool DisableBlend;
};

struct native StatColorMapEntry
{
    var globalconfig float In;
    var globalconfig Color Out;
};

var Font TinyFont;
var globalconfig string TinyFontName;
var Font SmallFont;
var globalconfig string SmallFontName;
var Font MediumFont;
var globalconfig string MediumFontName;
var Font LargeFont;
var globalconfig string LargeFontName;
var Font SubtitleFont;
var globalconfig string SubtitleFontName;
var Font LoadingTextFont;
var globalconfig string LoadingTextFontName;
var array<Font> AdditionalFonts;
var globalconfig array<string> AdditionalFontNames;
var class<Console> ConsoleClass;
var globalconfig string ConsoleClassName;
var class<GameViewportClient> GameViewportClientClass;
var globalconfig string GameViewportClientClassName;
var class<DataStoreClient> DataStoreClientClass;
var globalconfig string DataStoreClientClassName;
var class<LocalPlayer> LocalPlayerClass;
var config string LocalPlayerClassName;
var Material DefaultMaterial;
var globalconfig string DefaultMaterialName;
var Material DefaultDecalMaterial;
var globalconfig string DefaultDecalMaterialName;
var Texture DefaultTexture;
var globalconfig string DefaultTextureName;
var Material WireframeMaterial;
var globalconfig string WireframeMaterialName;
var Material EmissiveTexturedMaterial;
var globalconfig string EmissiveTexturedMaterialName;
var Material GeomMaterial;
var globalconfig string GeomMaterialName;
var Material DefaultFogVolumeMaterial;
var globalconfig string DefaultFogVolumeMaterialName;
var Material TickMaterial;
var globalconfig string TickMaterialName;
var Material CrossMaterial;
var globalconfig string CrossMaterialName;
var Material LevelColorationLitMaterial;
var globalconfig string LevelColorationLitMaterialName;
var Material LevelColorationUnlitMaterial;
var globalconfig string LevelColorationUnlitMaterialName;
var Material LightingTexelDensityMaterial;
var globalconfig string LightingTexelDensityName;
var Material ShadedLevelColorationLitMaterial;
var globalconfig string ShadedLevelColorationLitMaterialName;
var Material ShadedLevelColorationUnlitMaterial;
var globalconfig string ShadedLevelColorationUnlitMaterialName;
var Material RemoveSurfaceMaterial;
var globalconfig string RemoveSurfaceMaterialName;
var Material VertexColorMaterial;
var globalconfig string VertexColorMaterialName;
var Material VertexColorViewModeMaterial_ColorOnly;
var globalconfig string VertexColorViewModeMaterialName_ColorOnly;
var Material VertexColorViewModeMaterial_AlphaAsColor;
var globalconfig string VertexColorViewModeMaterialName_AlphaAsColor;
var Material VertexColorViewModeMaterial_RedOnly;
var globalconfig string VertexColorViewModeMaterialName_RedOnly;
var Material VertexColorViewModeMaterial_GreenOnly;
var globalconfig string VertexColorViewModeMaterialName_GreenOnly;
var Material VertexColorViewModeMaterial_BlueOnly;
var globalconfig string VertexColorViewModeMaterialName_BlueOnly;
var Material HeatmapMaterial;
var globalconfig string HeatmapMaterialName;
var Material BoneWeightMaterial;
var globalconfig string BoneWeightMaterialName;
var Material TangentColorMaterial;
var globalconfig string TangentColorMaterialName;
var Material ProcBuildingSimpleMaterial;
var globalconfig string ProcBuildingSimpleMaterialName;
var StaticMesh BuildingQuadStaticMesh;
var globalconfig string BuildingQuadStaticMeshName;
var globalconfig float ProcBuildingLODColorTexelsPerWorldUnit;
var globalconfig float ProcBuildingLODLightingTexelsPerWorldUnit;
var globalconfig int MaxProcBuildingLODColorTextureSize;
var globalconfig int MaxProcBuildingLODLightingTextureSize;
var globalconfig bool UseProcBuildingLODTextureCropping;
var globalconfig bool ForcePowerOfTwoProcBuildingLODTextures;
var globalconfig bool bCombineSimilarMappings;
var globalconfig bool bRenderLightMapDensityGrayscale;
var transient bool bUseSound;
var transient bool bSubtitlesRenderingDisabled;
var bool bConstrainAspectRatio;
var(Settings) config bool bUseTextureStreaming;
var(Settings) config bool bUseBackgroundLevelStreaming;
var(Settings) config bool bSubtitlesEnabled;
var(Settings) config bool bSubtitlesForcedOff;
var config bool bSmoothFrameRate;
var globalconfig bool HACK_UseTickFrequency;
var globalconfig bool bShouldGenerateSimpleLightmaps;
var(Settings) config bool bForceStaticTerrain;
var config bool bForceCPUSkinning;
var config bool bUsePostProcessEffects;
var config bool bOnScreenKismetWarnings;
var config bool bEnableKismetLogging;
var config bool bAllowMatureLanguage;
var config bool bRenderTerrainCollisionAsOverlay;
var config bool bPauseOnLossOfFocus;
var globalconfig bool bCheckParticleRenderSize;
var const globalconfig bool bEnableColorClear;
var transient bool bAreConstraintsDirty;
var transient bool bHasPendingGlobalReattach;
var transient bool bUseMobileEmulation;
var globalconfig bool bEnableOnScreenDebugMessages;
var transient bool bEnableOnScreenDebugMessagesDisplay;
var globalconfig bool bSuppressMapWarnings;
var globalconfig bool bCookSeparateSharedMPGameContent;
var globalconfig float MaxRMSDForCombiningMappings;
var globalconfig LinearColor LightingOnlyBrightness;
var globalconfig array<Color> LightComplexityColors;
var globalconfig array<LinearColor> ShaderComplexityColors;
var globalconfig float MaxPixelShaderAdditiveComplexityCount;
var globalconfig float MinTextureDensity;
var globalconfig float IdealTextureDensity;
var globalconfig float MaxTextureDensity;
var globalconfig float MinLightMapDensity;
var globalconfig float IdealLightMapDensity;
var globalconfig float MaxLightMapDensity;
var globalconfig float RenderLightMapDensityGrayscaleScale;
var globalconfig float RenderLightMapDensityColorScale;
var globalconfig LinearColor LightMapDensityVertexMappedColor;
var globalconfig LinearColor LightMapDensitySelectedColor;
var globalconfig array<StatColorMapping> StatColorMappings;
var Material EditorBrushMaterial;
var globalconfig string EditorBrushMaterialName;
var PhysicalMaterial DefaultPhysMaterial;
var globalconfig string DefaultPhysMaterialName;
var ApexDestructibleDamageParameters ApexDamageParams;
var globalconfig string ApexDamageParamsName;
var Material TerrainErrorMaterial;
var globalconfig string TerrainErrorMaterialName;
var globalconfig int TerrainMaterialMaxTextureCount;
var globalconfig int TerrainTessellationCheckCount;
var globalconfig float TerrainTessellationCheckDistance;
var class<OnlineSubsystem> OnlineSubsystemClass;
var globalconfig string DefaultOnlineSubsystemName;
var PostProcessChain DefaultPostProcess;
var config string DefaultPostProcessName;
var PostProcessChain ThumbnailSkeletalMeshPostProcess;
var config string ThumbnailSkeletalMeshPostProcessName;
var PostProcessChain ThumbnailParticleSystemPostProcess;
var config string ThumbnailParticleSystemPostProcessName;
var PostProcessChain ThumbnailMaterialPostProcess;
var config string ThumbnailMaterialPostProcessName;
var PostProcessChain DefaultUIScenePostProcess;
var config string DefaultUIScenePostProcessName;
var Material DefaultUICaretMaterial;
var globalconfig string DefaultUICaretMaterialName;
var Material SceneCaptureReflectActorMaterial;
var globalconfig string SceneCaptureReflectActorMaterialName;
var Material SceneCaptureCubeActorMaterial;
var globalconfig string SceneCaptureCubeActorMaterialName;
var Texture2D ScreenDoorNoiseTexture;
var globalconfig string ScreenDoorNoiseTextureName;
var Texture2D RandomAngleTexture;
var globalconfig string RandomAngleTextureName;
var Texture2D RandomNormalTexture;
var globalconfig string RandomNormalTextureName;
var Texture WeightMapPlaceholderTexture;
var globalconfig string WeightMapPlaceholderTextureName;
var Texture2D LightMapDensityTexture;
var globalconfig string LightMapDensityTextureName;
var Texture2D LightMapDensityNormal;
var globalconfig string LightMapDensityNormalName;
var SoundNodeWave DefaultSound;
var globalconfig string DefaultSoundName;
var(Settings) config float TimeBetweenPurgingPendingKillObjects;
var const Client Client;
var array<LocalPlayer> GamePlayers;
var const GameViewportClient GameViewport;
var array<string> DeferredCommands;
var int TickCycles;
var int GameCycles;
var int ClientCycles;
var float ConstrainedAspectRatio;
var config float MaxSmoothedFrameRate;
var config float MinSmoothedFrameRate;
var const DebugManager DebugManager;
var native Pointer RemoteControlExec;
var native Pointer MobileMaterialEmulator;
var(Colors) Color C_WorldBox;
var(Colors) Color C_BrushWire;
var(Colors) Color C_AddWire;
var(Colors) Color C_SubtractWire;
var(Colors) Color C_SemiSolidWire;
var(Colors) Color C_NonSolidWire;
var(Colors) Color C_WireBackground;
var(Colors) Color C_ScaleBoxHi;
var(Colors) Color C_VolumeCollision;
var(Colors) Color C_BSPCollision;
var(Colors) Color C_OrthoBackground;
var(Colors) Color C_Volume;
var(Colors) Color C_BrushShape;
var(Settings) float StreamingDistanceFactor;
var const config string ScoutClassName;
var ETransitionType TransitionType;
var string TransitionDescription;
var string TransitionGameType;
var config float MeshLODRange;
var config float CameraRotationThreshold;
var config float CameraTranslationThreshold;
var config float PrimitiveProbablyVisibleTime;
var config float PercentUnoccludedRequeries;
var config float MaxOcclusionPixelsFraction;
var globalconfig int PhysXLevel;
var config int MaxFluidNumVerts;
var config float FluidSimulationTimeLimit;
var config int MaxParticleResize;
var config int MaxParticleResizeWarn;
var config int MaxParticleVertexMemory;
var transient int MaxParticleSpriteCount;
var transient int MaxParticleSubUVCount;
var config int BeginUPTryCount;
var transient array<DropNoteInfo> PendingDroppedNotes;
var globalconfig string DynamicCoverMeshComponentName;
var globalconfig float NetClientTicksPerSecond;
var globalconfig float MaxTrackedOcclusionIncrement;
var globalconfig float TrackedOcclusionStepSize;
var globalconfig LinearColor DefaultSelectedMaterialColor;
var transient LinearColor SelectedMaterialColor;
var transient LinearColor UnselectedMaterialColor;
var globalconfig array<name> IgnoreSimulatedFuncWarnings;
var array<AliceGamePlayerProfileData> PlayerList;
var int CurrentPlayerDataIndex;

native static final function int GetPhysXLevel()
{
}

native static final function AddOverlayWrapped(Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, float WrapWidth)
{
    Font;
    Text;
    X;
    Y;
    ScaleX;
    ScaleY;
    WrapWidth;
}

native static final function AddOverlay(Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, bool bIsCentered)
{
    Font;
    Text;
    X;
    Y;
    ScaleX;
    ScaleY;
    bIsCentered;
}

native static final function RemoveAllOverlays()
{
}

native static final function StopMovie(bool bDelayStopUntilGameHasRendered)
{
    bDelayStopUntilGameHasRendered;
}

native static final function bool PlayLoadMapMovie(optional string MapName = "")
{
    MapName;
}

native static final function string GetLastMovieName()
{
}

native static final function AudioDevice GetAudioDevice()
{
}

native static final function bool IsSplitScreen()
{
}

native static final function Font GetAdditionalFont(int AdditionalFontIndex)
{
    AdditionalFontIndex;
}

native static final function Font GetLoadingTextFont()
{
}

native static final function Font GetSubtitleFont()
{
}

native static final function Font GetLargeFont()
{
}

native static final function Font GetMediumFont()
{
}

native static final function Font GetSmallFont()
{
}

native static final function Font GetTinyFont()
{
}

native static final function string GetBuildDate()
{
}

native static final function WorldInfo GetCurrentWorldInfo()
{
}

native static final function bool IsGame()
{
}

native static final function bool IsEditor()
{
}

native final function AddNewPlayerToPlayerProfileList(optional string PlayerName = "SphinxAlice", optional int IndexedRBState = -1)
{
    PlayerName;
    IndexedRBState;
}

native final function DeleteFromPlayerProfileList(int Index)
{
    Index;
}

native final function GetPlayerProfileList(out array<AliceGamePlayerProfileData> outputProfileData)
{
    outputProfileData;
}

native final function int GetCurrentPlayDataIndex()
{
}

native final function SetCurrentPlayDataIndex(int Index)
{
    Index;
}

native final function GetPlayerListParentFolder(out string outputFolderName)
{
    outputFolderName;
}

native final function SavePlayerList()
{
}

native final function LoadPlayerList()
{
}

defaultproperties
{
    TinyFontName="EngineFonts.TinyFont"
    SmallFontName="EngineFonts.SmallFont"
    MediumFontName="EngineFonts.SmallFont"
    LargeFontName="EngineFonts.SmallFont"
    SubtitleFontName="WarfareFonts.Fonts.WarfareFonts_Chrom20"
    LoadingTextFontName="WarfareFonts.Fonts.WarfareFonts_Chrom20"
    ConsoleClassName="Engine.Console"
    GameViewportClientClassName="GFxUI.GFxGameViewportClient"
    DataStoreClientClassName="Engine.DataStoreClient"
    LocalPlayerClassName="Engine.LocalPlayer"
    DefaultMaterialName="EngineMaterials.DefaultMaterial"
    DefaultDecalMaterialName="EngineMaterials.DefaultDecalMaterial"
    DefaultTextureName="EngineMaterials.DefaultDiffuse"
    WireframeMaterialName="EngineDebugMaterials.WireframeMaterial"
    EmissiveTexturedMaterialName="EngineMaterials.EmissiveTexturedMaterial"
    GeomMaterialName="EngineDebugMaterials.GeomMaterial"
    DefaultFogVolumeMaterialName="EngineMaterials.FogVolumeMaterial"
    TickMaterialName="EditorMaterials.Tick_Mat"
    CrossMaterialName="EditorMaterials.Cross_Mat"
    LevelColorationLitMaterialName="EngineDebugMaterials.LevelColorationLitMaterial"
    LevelColorationUnlitMaterialName="EngineDebugMaterials.LevelColorationUnlitMaterial"
    LightingTexelDensityName="EngineDebugMaterials.MAT_LevelColorationLitLightmapUVs"
    ShadedLevelColorationLitMaterialName="EngineDebugMaterials.ShadedLevelColorationLitMaterial"
    ShadedLevelColorationUnlitMaterialName="EngineDebugMaterials.ShadedLevelColorationUnlitMaterial"
    RemoveSurfaceMaterialName="EngineMaterials.RemoveSurfaceMaterial"
    VertexColorMaterialName="EngineDebugMaterials.VertexColorMaterial"
    VertexColorViewModeMaterialName_ColorOnly="EngineDebugMaterials.VertexColorViewMode_ColorOnly"
    VertexColorViewModeMaterialName_AlphaAsColor="EngineDebugMaterials.VertexColorViewMode_AlphaAsColor"
    VertexColorViewModeMaterialName_RedOnly="EngineDebugMaterials.VertexColorViewMode_RedOnly"
    VertexColorViewModeMaterialName_GreenOnly="EngineDebugMaterials.VertexColorViewMode_GreenOnly"
    VertexColorViewModeMaterialName_BlueOnly="EngineDebugMaterials.VertexColorViewMode_BlueOnly"
    HeatmapMaterialName="EngineDebugMaterials.HeatmapMaterial"
    BoneWeightMaterialName="EngineDebugMaterials.BoneWeightMaterial"
    TangentColorMaterialName="EngineDebugMaterials.TangentColorMaterial"
    ProcBuildingSimpleMaterialName="EngineBuildings.ProcBuildingSimpleMaterial"
    BuildingQuadStaticMeshName="EngineBuildings.BuildingQuadMesh"
    ProcBuildingLODColorTexelsPerWorldUnit=0.075
    ProcBuildingLODLightingTexelsPerWorldUnit=0.015
    MaxProcBuildingLODColorTextureSize=1024
    MaxProcBuildingLODLightingTextureSize=256
    UseProcBuildingLODTextureCropping=True
    ForcePowerOfTwoProcBuildingLODTextures=True
    bCombineSimilarMappings=True
    bRenderLightMapDensityGrayscale=True
    bUseSound=True
    bConstrainAspectRatio=True
    bUseTextureStreaming=True
    bUseBackgroundLevelStreaming=True
    bSubtitlesEnabled=True
    bSmoothFrameRate=True
    bShouldGenerateSimpleLightmaps=True
    bOnScreenKismetWarnings=True
    bCheckParticleRenderSize=True
    bEnableColorClear=True
    bEnableOnScreenDebugMessages=True
    bSuppressMapWarnings=True
    MaxRMSDForCombiningMappings=10.0
    LightingOnlyBrightness=(R=0.5,G=0.5,B=0.5,A=1.0)
    LightComplexityColors(0)=(B=0,G=0,R=0,A=1)
    LightComplexityColors(1)=(B=0,G=255,R=0,A=1)
    LightComplexityColors(2)=(B=0,G=191,R=63,A=1)
    LightComplexityColors(3)=(B=0,G=127,R=127,A=1)
    LightComplexityColors(4)=(B=0,G=63,R=191,A=1)
    LightComplexityColors(5)=(B=0,G=0,R=255,A=1)
    ShaderComplexityColors(0)=(R=0.0,G=1.0,B=0.127,A=1.0)
    ShaderComplexityColors(1)=(R=0.0,G=1.0,B=0.0,A=1.0)
    ShaderComplexityColors(2)=(R=0.046,G=0.52,B=0.0,A=1.0)
    ShaderComplexityColors(3)=(R=0.215,G=0.215,B=0.0,A=1.0)
    ShaderComplexityColors(4)=(R=0.52,G=0.046,B=0.0,A=1.0)
    ShaderComplexityColors(5)=(R=0.7,G=0.0,B=0.0,A=1.0)
    ShaderComplexityColors(6)=(R=1.0,G=0.0,B=0.0,A=1.0)
    ShaderComplexityColors(7)=(R=1.0,G=0.0,B=0.5,A=1.0)
    ShaderComplexityColors(8)=(R=1.0,G=0.9,B=0.9,A=1.0)
    MaxPixelShaderAdditiveComplexityCount=900.0
    IdealTextureDensity=13.0
    MaxTextureDensity=55.0
    IdealLightMapDensity=1.0
    MaxLightMapDensity=3.0
    RenderLightMapDensityGrayscaleScale=1.0
    RenderLightMapDensityColorScale=1.0
    LightMapDensityVertexMappedColor=(R=0.65,G=0.65,B=0.25,A=1.0)
    LightMapDensitySelectedColor=(R=1.0,G=0.2,B=1.0,A=1.0)
    StatColorMappings(0)=(StatName="AverageFPS",ColorMap=((In=15.0,Out=(B=0,G=0,R=255,A=0)),(In=30.0,Out=(B=0,G=255,R=255,A=0)),(In=45.0,Out=(B=0,G=255,R=0,A=0))),DisableBlend=False)
    StatColorMappings(1)=(StatName="Frametime",ColorMap=((In=1.0,Out=(B=0,G=255,R=0,A=0)),(In=25.0,Out=(B=0,G=255,R=0,A=0)),(In=29.0,Out=(B=0,G=255,R=255,A=0)),(In=33.0,Out=(B=0,G=0,R=255,A=0))),DisableBlend=False)
    StatColorMappings(2)=(StatName="Streaming fudge factor",ColorMap=((In=0.0,Out=(B=0,G=255,R=0,A=0)),(In=1.0,Out=(B=0,G=255,R=0,A=0)),(In=2.5,Out=(B=0,G=255,R=255,A=0)),(In=5.0,Out=(B=0,G=0,R=255,A=0)),(In=10.0,Out=(B=0,G=0,R=255,A=0))),DisableBlend=False)
    EditorBrushMaterialName="EngineMaterials.EditorBrushMaterial"
    DefaultPhysMaterialName="EngineMaterials.DefaultPhysicalMaterial"
    ApexDamageParamsName="Nv_ApexDamageMap.AliceDamageMap"
    TerrainErrorMaterialName="EngineDebugMaterials.MaterialError_Mat"
    TerrainMaterialMaxTextureCount=16
    TerrainTessellationCheckCount=6
    TerrainTessellationCheckDistance=4096.0
    DefaultPostProcessName="PostProcesses.PostProcess_Default"
    ThumbnailSkeletalMeshPostProcessName="EngineMaterials.DefaultThumbnailPostProcess"
    ThumbnailParticleSystemPostProcessName="EngineMaterials.DefaultThumbnailPostProcess"
    ThumbnailMaterialPostProcessName="EngineMaterials.DefaultThumbnailPostProcess"
    DefaultUIScenePostProcessName="EngineMaterials.DefaultUIPostProcess"
    DefaultUICaretMaterialName="EngineMaterials.BlinkingCaret"
    SceneCaptureReflectActorMaterialName="EngineMaterials.ScreenMaterial"
    SceneCaptureCubeActorMaterialName="EngineMaterials.CubeMaterial"
    ScreenDoorNoiseTextureName="EngineMaterials.ScreenDoorNoiseTexture"
    RandomAngleTextureName="EngineMaterials.RandomAngles"
    RandomNormalTextureName="EngineMaterials.RandomNormal2"
    WeightMapPlaceholderTextureName="EngineMaterials.WeightMapPlaceholderTexture"
    LightMapDensityTextureName="EngineMaterials.DefaultWhiteGrid"
    LightMapDensityNormalName="EngineMaterials.DefaultNormal"
    DefaultSoundName="EngineSounds.WhiteNoise"
    TimeBetweenPurgingPendingKillObjects=60.0
    ConstrainedAspectRatio=1.7777778
    MaxSmoothedFrameRate=31.0
    MinSmoothedFrameRate=22.0
    C_WorldBox=(B=40,G=0,R=0,A=255)
    C_BrushWire=(B=0,G=0,R=192,A=255)
    C_AddWire=(B=255,G=127,R=127,A=255)
    C_SubtractWire=(B=63,G=192,R=255,A=255)
    C_SemiSolidWire=(B=0,G=255,R=127,A=255)
    C_NonSolidWire=(B=32,G=192,R=63,A=255)
    C_WireBackground=(B=0,G=0,R=0,A=255)
    C_ScaleBoxHi=(B=157,G=149,R=223,A=255)
    C_VolumeCollision=(B=157,G=223,R=149,A=255)
    C_BSPCollision=(B=223,G=157,R=149,A=255)
    C_OrthoBackground=(B=163,G=163,R=163,A=255)
    C_Volume=(B=255,G=196,R=255,A=255)
    C_BrushShape=(B=128,G=255,R=128,A=255)
    ScoutClassName="Engine.Scout"
    CameraRotationThreshold=45.0
    CameraTranslationThreshold=10000.0
    PrimitiveProbablyVisibleTime=8.0
    PercentUnoccludedRequeries=0.125
    MaxOcclusionPixelsFraction=0.001
    MaxFluidNumVerts=1048576
    FluidSimulationTimeLimit=30.0
    MaxParticleVertexMemory=131972
    BeginUPTryCount=200000
    NetClientTicksPerSecond=200.0
    MaxTrackedOcclusionIncrement=0.1
    TrackedOcclusionStepSize=0.1
    DefaultSelectedMaterialColor=(R=0.04,G=0.02,B=0.24,A=1.0)
    SelectedMaterialColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    UnselectedMaterialColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    IgnoreSimulatedFuncWarnings(0)="Tick"
}
