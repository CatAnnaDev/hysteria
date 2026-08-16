class WorldInfo extends ZoneInfo
    native
    nativereplication
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision,Actor,Advanced,Display,Events,Object,Attachment,Physics);

const MAX_INSTANCES_PER_CLASS = 5;

enum EConsoleType
{
    CONSOLE_Any,
    CONSOLE_Xbox360,
    CONSOLE_PS3,
    CONSOLE_Mobile,
    CONSOLE_IPhone,
    CONSOLE_Tegra,
};

enum ENetMode
{
    NM_Standalone,
    NM_DedicatedServer,
    NM_ListenServer,
    NM_Client,
};

struct native NavMeshPathGoalEvaluatorCacheDatum
{
    var int ListIdx;
    var NavMeshPathGoalEvaluator List[5];
};

struct native NavMeshPathConstraintCacheDatum
{
    var int ListIdx;
    var NavMeshPathConstraint List[5];
};

struct native LightmassWorldInfoSettings
{
    var(General) float StaticLightingLevelScale;
    var(General) int NumIndirectLightingBounces;
    var(General) Color EnvironmentColor;
    var(General) float EnvironmentIntensity;
    var(General) float EmissiveBoost;
    var(General) float DiffuseBoost;
    var float SpecularBoost;
    var(General) float IndirectNormalInfluenceBoost;
    var(General) float LightEnvironmentIndirectContrastFactor;
    var(Occlusion) bool bUseAmbientOcclusion;
    var(Occlusion) float DirectIlluminationOcclusionFraction;
    var(Occlusion) float IndirectIlluminationOcclusionFraction;
    var(Occlusion) float OcclusionExponent;
    var(Occlusion) float FullyOccludedSamplesFraction;
    var(Occlusion) float MaxOcclusionDistance;
    var(Debug) bool bVisualizeMaterialDiffuse;
    var(Debug) bool bVisualizeAmbientOcclusion;
};

struct native transient ScreenMessageString
{
    var transient QWord Key;
    var transient string ScreenMessage;
    var transient Color DisplayColor;
    var transient float TimeToDisplay;
    var transient float CurrentTimeDisplayed;
};

struct native WorldFractureSettings
{
    var float ChanceOfPhysicsChunkOverride;
    var bool bEnableChanceOfPhysicsChunkOverride;
    var bool bLimitExplosionChunkSize;
    var float MaxExplosionChunkSize;
    var bool bLimitDamageChunkSize;
    var float MaxDamageChunkSize;
    var int MaxNumFacturedChunksToSpawnInAFrame;
    var float FractureExplosionVelScale;
};

struct native PhysXVerticalProperties
{
    var() editinline PhysXEmitterVerticalProperties Emitters;
};

struct native PhysXEmitterVerticalProperties
{
    var() bool bDisableLod;
    var() int ParticlesLodMin;
    var() int ParticlesLodMax;
    var() int PacketsPerPhysXParticleSystemMax;
    var() bool bApplyCylindricalPacketCulling;
    var() float SpawnLodVsFifoBias;
};

struct native ApexModuleDestructibleSettings
{
    var() int MaxChunkIslandCount;
    var int MaxRrbActorCount;
    var() float MaxChunkSeparationLOD;
    var() bool bOverrideMaxChunkSeparationLOD;
};

struct native PhysXSceneProperties
{
    var() editinline PhysXSimulationProperties PrimaryScene;
    var() editinline PhysXSimulationProperties CompartmentRigidBody;
    var() editinline PhysXSimulationProperties CompartmentFluid;
    var() editinline PhysXSimulationProperties CompartmentCloth;
    var() editinline PhysXSimulationProperties CompartmentSoftBody;
};

struct native PhysXSimulationProperties
{
    var() bool bUseHardware;
    var() bool bFixedTimeStep;
    var() float TimeStep;
    var() int MaxSubSteps;
};

struct native CompartmentRunList
{
    var() bool RigidBody;
    var() bool Fluid;
    var() bool Cloth;
    var() bool SoftBody;
};

struct native NetViewer
{
    var PlayerController InViewer;
    var Actor Viewer;
    var Vector ViewLocation;
    var Vector ViewDir;
};

var() config PostProcessSettings DefaultPostProcessSettings;
var() config bool bPersistPostProcessToNextLevel;
var bool bMapNeedsLightingFullyRebuilt;
var bool bMapHasDLEsOutsideOfImportanceVolume;
var bool bMapHasMultipleDominantLightsAffectingOnePrimitive;
var bool bMapHasPathingErrors;
var bool bRequestedBlockOnAsyncLoading;
var bool bMatineeSlomoSpeedValid;
var bool bDeathSlomoEnable;
var bool bFrameAdvance;
var bool bUpdateCameraInPause;
var bool bOnLevelsProperlyLoaded;
var bool bNPCGodModeOn;
var bool bNPCBlindOn;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bPlayersOnlyPending;
var transient bool bDropDetail;
var transient bool bAggressiveLOD;
var bool bStartup;
var bool bPathsRebuilt;
var bool bHasPathNodes;
var const transient bool bIsMenuLevel;
var transient bool bUseConsoleInput;
var() bool bNoDefaultInventoryForPlayer;
var() bool bNoPathWarnings;
var repretry bool bHighPriorityLoading;
var bool bHighPriorityLoadingLocal;
var(ProcBuildings) bool bUseProcBuildingRulesetOverride;
var(Physics) bool bSupportDoubleBufferedPhysics;
var(Fracture) config bool bEnableChanceOfPhysicsChunkOverride;
var(Fracture) config bool bLimitExplosionChunkSize;
var(Fracture) config bool bLimitDamageChunkSize;
var(Rendering) bool bAllowModulateBetterShadows;
var(Rendering) bool bAllowLightEnvSphericalHarmonicLights;
var(Rendering) bool bIncreaseFogNearPrecision;
var(Lightmass) editoronly bool bUseGlobalIllumination;
var bool bSlomoSoundMode;
var() config float SquintModeKernelSize;
var const transient PostProcessVolume HighestPriorityPostProcessVolume;
var const transient PostProcessVolume CurrentPostProcessVolume;
var const transient HeightFogVolume HighestPriorityHeightFogVolume;
var const transient HeightFogVolume CurrentHeightFogVolume;
var() config ReverbSettings DefaultReverbSettings;
var() config InteriorSettings DefaultAmbientZoneSettings;
var const transient ReverbVolume HighestPriorityReverbVolume;
var const transient array<PortalVolume> PortalVolumes;
var const transient array<EnvironmentVolume> EnvironmentVolumes;
var const transient array<Volume> LedgeVolumes;
var() const editconst editinline array<LevelStreaming> StreamingLevels;
var transient Double LastTimeUnbuiltLightingWasEncountered;
var(Editor) BookMark BookMarks[10];
var(Editor) editinline array<ClipPadEntry> ClipPadEntries;
var repretry float TimeDilation;
var float DemoPlayTimeDilation;
var float TimeSeconds;
var float RealTimeSeconds;
var float AudioTimeSeconds;
var const transient float DeltaSeconds;
var transient float PauseDelay;
var transient float RealTimeToUnPause;
var GameEffectSpeedController GameEffectSpeedSlomoController;
var float MatineeSlomoSpeed;
var repretry PlayerReplicationInfo Pauser;
var string VisibleGroups;
var transient string SelectedGroups;
var Texture2D DefaultTexture;
var Texture2D WireframeTexture;
var Texture2D WhiteSquareTexture;
var Texture2D LargeVertex;
var Texture2D BSPVertex;
var array<string> DeferredExecs;
var transient GameReplicationInfo GRI;
var ENetMode NetMode;
var ETravelType NextTravelType;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var GameInfo Game;
var() float StallZ;
var transient repretry float WorldGravityZ;
var const globalconfig float DefaultGravityZ;
var() float GlobalGravityZ;
var globalconfig float RBPhysicsGravityScaling;
var const transient NavigationPoint NavigationPointList;
var const Controller ControllerList;
var const Pawn PawnList;
var const Pawn PlayerPawn;
var const transient CoverLink CoverList;
var const transient Pylon PylonList;
var transient Projectile ProjectileList;
var float MoveRepSize;
var const array<NetViewer> ReplicationViewers;
var string NextURL;
var float NextSwitchCountdown;
var() int PackedLightAndShadowMapTextureSize;
var() Vector DefaultColorScale;
var() array<class<GameInfo>> GameTypesSupportedOnThisMap;
var() editoronly class<GameInfo> GameTypeForPIE;
var const editconst array<Object> ClientDestroyedActorContent;
var const transient array<name> PreparingLevelNames;
var const transient name CommittedPersistentLevelName;
var ObjectReferencer PersistentMapForcedObjects;
var transient export editinline AudioComponent MusicComp;
var transient MusicTrackStruct CurrentMusicTrack;
var transient repnotify MusicTrackStruct ReplicatedMusicTrack;
var() const localized string Title;
var() string Author;
var() export editinline MapInfo MyMapInfo;
var globalconfig string EmitterPoolClassPath;
var transient EmitterPool MyEmitterPool;
var globalconfig string DecalManagerClassPath;
var transient DecalManager MyDecalManager;
var globalconfig string FractureManagerClassPath;
var transient FractureManager MyFractureManager;
var globalconfig string ParticleEventManagerClassPath;
var transient ParticleEventManager MyParticleEventManager;
var(ProcBuildings) editoronly ProcBuildingRuleset ProcBuildingRulesetOverride;
var(Physics) float MaxPhysicsDeltaTime;
var config int MaxPhysicsSubsteps;
var(Physics) editinline PhysXSceneProperties PhysicsProperties;
var(Physics) array<CompartmentRunList> CompartmentRunFrames;
var(Physics) float DefaultSkinWidth;
var(Physics) float ApexLODResourceBudget;
var(Physics) ApexModuleDestructibleSettings DestructibleSettings;
var PhysicsLODVerticalEmitter EmitterVertical;
var PhysicsLODVerticalDestructible DestructibleVertical;
var(Physics) editinline PhysXVerticalProperties VerticalProperties;
var(Fracture) config float ChanceOfPhysicsChunkOverride;
var(Fracture) config float MaxExplosionChunkSize;
var(Fracture) config float MaxDamageChunkSize;
var(Fracture) config float FractureExplosionVelScale;
var(Fracture) int MaxNumFacturedChunksToSpawnInAFrame;
var transient int NumFacturedChunksSpawnedThisFrame;
var config float FracturedMeshWeaponDamage;
var(Rendering) float CharacterLightingContrastFactor;
var native transient Map_Mirror ScreenMessages;
var native transient array<ScreenMessageString> PriorityScreenMessages;
var editoronly int MaxTrianglesPerLeaf;
var export editinline editoronly deprecated LightmassLevelSettings LMLevelSettings;
var(Lightmass) editoronly LightmassWorldInfoSettings LightmassSettings;
var native map<int, int> NavMeshPathConstraintCache;
var native map<int, int> NavMeshPathGoalEvaluatorCache;
var CrowdPopulationManagerBase PopulationManager;
var string PhysMatLogInfo;

replication
{
    if (bNetDirty && Role == 3)
        bHighPriorityLoading, TimeDilation, Pauser, WorldGravityZ, ReplicatedMusicTrack;
}

native function bool IsPhysXLevelToNotLoad(name LevelName)
{
    LevelName;
}

native function bool IsPhysXLevel(name LevelName)
{
    LevelName;
}

native final function bool ToggleHideDOF()
{
}

function LogPhysMatInfo(string ImpactType, string WeaponName, string PhysMatName)
{
    PhysMatLogInfo = ImpactType $ "," $ WeaponName $ "," $ PhysMatName;
}

native final function Pawn GetLocalPlayerPawn()
{
}

native final function EnvironmentVolume FindEnvironmentVolume(Vector TestLocation)
{
    TestLocation;
}

native static final function WorldInfo GetWorldInfo()
{
}

native final function WorldFractureSettings GetWorldFractureSettings()
{
}

native final function DoMemoryTracking()
{
}

native final function bool GetDemoRewindPoints(out array<int> OutRewindPoints)
{
    OutRewindPoints;
}

native final function GetDemoFrameInfo(optional out int CurrentFrame, optional out int TotalFrames)
{
    CurrentFrame;
    TotalFrames;
}

native final function bool IsPlayingDemo()
{
}

native final function bool IsRecordingDemo()
{
}

native final function EDetailMode GetDetailMode()
{
}

native final function string GetMapName(optional bool bIncludePrefix)
{
    bIncludePrefix;
}

native final function SetMapInfo(MapInfo NewMapInfo)
{
    NewMapInfo;
}

native final function MapInfo GetMapInfo()
{
}

native final function SetSeamlessTravelMidpointPause(bool bNowPaused)
{
    bNowPaused;
}

native final function bool IsInSeamlessTravel()
{
}

native final function SeamlessTravel(string URL, optional bool bAbsolute, optional Guid MapPackageGuid)
{
    URL;
    bAbsolute;
    MapPackageGuid;
}

native final function CommitMapChange()
{
}

native final function CancelPendingMapChange()
{
}

native final function bool IsMapChangeReady()
{
}

native final function bool IsPreparingMapChange()
{
}

native final function PrepareMapChange(out const array<name> LevelNames)
{
    LevelNames;
}

native final function NotifyMatchStarted(optional bool bShouldActivateLevelStartupEvents = true, optional bool bShouldActivateLevelBeginningEvents = true, optional bool bShouldActivateLevelLoadedEvents = false)
{
    bShouldActivateLevelStartupEvents;
    bShouldActivateLevelBeginningEvents;
    bShouldActivateLevelLoadedEvents;
}

native final iterator function AllPawns(class<Pawn> BaseClass, out Pawn P, optional Vector TestLocation, optional float TestRadius)
{
    BaseClass;
    P;
    TestLocation;
    TestRadius;
}

native final iterator function AllControllers(class<Controller> BaseClass, out Controller C)
{
    BaseClass;
    C;
}

native final function NavigationPointCheck(Vector Point, Vector Extent, optional out array<NavigationPoint> Navs, optional out array<ReachSpec> Specs)
{
    Point;
    Extent;
    Navs;
    Specs;
}

native final iterator function RadiusNavigationPoints(class<NavigationPoint> BaseClass, out NavigationPoint N, Vector Point, float Radius)
{
    BaseClass;
    N;
    Point;
    Radius;
}

native final iterator function AllNavigationPoints(class<NavigationPoint> BaseClass, out NavigationPoint N)
{
    BaseClass;
    N;
}

function Reset()
{
    Reset();
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    if (IsConsoleBuild())
    {
        bUseConsoleInput = true;
    }
    GameEffectSpeedSlomoController.QueueReset();
    MatineeSlomoSpeed = 1.0;
    bMatineeSlomoSpeedValid = false;
    bDeathSlomoEnable = false;
}

simulated function PreBeginPlay()
{
    local class<EmitterPool> PoolClass;
    local class<DecalManager> DecalManagerClass;
    local class<FractureManager> FractureManagerClass;
    local class<ParticleEventManager> ParticleEventManagerClass;
    
    PreBeginPlay();
    if (WorldInfo.NetMode != 1 && IsInPersistentLevel())
    {
        if (EmitterPoolClassPath != "")
        {
            PoolClass = class<EmitterPool>(DynamicLoadObject(EmitterPoolClassPath, class'Core.Class'));
            if (PoolClass != none)
            {
                MyEmitterPool = Spawn(PoolClass, self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (DecalManagerClassPath != "")
        {
            DecalManagerClass = class<DecalManager>(DynamicLoadObject(DecalManagerClassPath, class'Core.Class'));
            if (DecalManagerClass != none)
            {
                MyDecalManager = Spawn(DecalManagerClass, self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (FractureManagerClassPath != "")
        {
            FractureManagerClass = class<FractureManager>(DynamicLoadObject(FractureManagerClassPath, class'Core.Class'));
            if (FractureManagerClass != none)
            {
                MyFractureManager = Spawn(FractureManagerClass, self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (ParticleEventManagerClassPath != "")
        {
            ParticleEventManagerClass = class<ParticleEventManager>(DynamicLoadObject(ParticleEventManagerClassPath, class'Core.Class'));
            if (ParticleEventManagerClass != none)
            {
                MyParticleEventManager = Spawn(ParticleEventManagerClass, self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
    }
}

function ThisIsNeverExecuted(DefaultPhysicsVolume P)
{
    P = none;
}

simulated event ServerTravel(string URL, optional bool bAbsolute, optional bool bShouldSkipGameNotify)
{
    if (InStr(URL, "%") >= 0)
    {
        LogInternal("URL Contains illegal character '%'.");
        return;
    }
    if (InStr(URL, ":") >= 0 || InStr(URL, "/") >= 0 || InStr(URL, "\\") >= 0)
    {
        LogInternal("URL blocked");
        return;
    }
    if (Game != none && Game.bHasNetworkError)
    {
        LogInternal("Not traveling because of network error");
        return;
    }
    NextTravelType = (bAbsolute ? 0 : 2);
    if (NextURL == "" && !IsInSeamlessTravel() || bShouldSkipGameNotify)
    {
        NextURL = URL;
        if (Game != none)
        {
            if (!bShouldSkipGameNotify)
            {
                Game.ProcessServerTravel(URL, bAbsolute);
            }
        }
        else
        {
            NextSwitchCountdown = 0.0;
        }
    }
}

simulated function class<GameInfo> GetGameClass()
{
    if (WorldInfo.Game != none)
    {
        return WorldInfo.Game.Class;
    }
    if (GRI != none && GRI.GameClass != none)
    {
        return GRI.GameClass;
    }
    return none;
}

native simulated function string GetAddressURL()
{
}

native final simulated function VerifyNavList()
{
}

native final simulated function ForceGarbageCollection(optional bool bFullPurge)
{
    bFullPurge;
}

native static final simulated function bool IsPlayInEditor()
{
}

native static final simulated function bool IsConsoleBuild(optional EConsoleType ConsoleType)
{
    ConsoleType;
}

native static final simulated function bool IsDemoBuild()
{
}

native simulated function string GetLocalURL()
{
}

native final function SetLevelRBGravity(Vector NewGrav)
{
    NewGrav;
}

native final simulated function array<Sequence> GetAllRootSequences()
{
}

native final simulated function Sequence GetGameSequence()
{
}

native function float GetGravityZ()
{
}

native final function UpdateMusicTrack(MusicTrackStruct NewMusicTrack)
{
    NewMusicTrack;
}

native static final function bool IsMenuLevel(optional string MapName)
{
    MapName;
}

native final function AddOnScreenDebugMessage(int Key, float TimeToDisplay, Color DisplayColor, string DebugMessage)
{
    Key;
    TimeToDisplay;
    DisplayColor;
    DebugMessage;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ReplicatedMusicTrack')
    {
        UpdateMusicTrack(ReplicatedMusicTrack);
    }
    ReplicatedEvent(VarName);
}

native function NavMeshPathGoalEvaluator GetNavMeshPathGoalEvaluatorFromCache(class<NavMeshPathGoalEvaluator> GoalEvalClass, NavigationHandle Requestor)
{
    GoalEvalClass;
    Requestor;
}

native function NavMeshPathConstraint GetNavMeshPathConstraintFromCache(class<NavMeshPathConstraint> ConstraintClass, NavigationHandle Requestor)
{
    ConstraintClass;
    Requestor;
}

native function ReleaseCachedConstraintsAndEvaluators()
{
}

defaultproperties
{
    DefaultPostProcessSettings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    bPersistPostProcessToNextLevel=True
    bAllowModulateBetterShadows=True
    bAllowLightEnvSphericalHarmonicLights=True
    bIncreaseFogNearPrecision=True
    bUseGlobalIllumination=True
    SquintModeKernelSize=128.0
    DefaultReverbSettings=(bApplyReverb=True,ReverbType="REVERB_Default",Volume=0.5,FadeTime=2.0)
    DefaultAmbientZoneSettings=(bIsWorldInfo=True,ExteriorVolume=1.0,ExteriorTime=0.5,ExteriorLPF=1.0,ExteriorLPFTime=0.5,InteriorVolume=1.0,InteriorTime=0.5,InteriorLPF=1.0,InteriorLPFTime=0.5)
    TimeDilation=1.0
    DemoPlayTimeDilation=1.0
    GameEffectSpeedSlomoController="Default__WorldInfo.SlomoSpeedController"
    MatineeSlomoSpeed=1.0
    VisibleGroups="None"
    DefaultTexture="EngineResources.DefaultTexture"
    WhiteSquareTexture="EngineResources.WhiteSquareTexture"
    LargeVertex="EditorResources.LargeVertex"
    BSPVertex="EditorResources.BSPVertex"
    NextTravelType="TRAVEL_Relative"
    StallZ=1000000.0
    DefaultGravityZ=-750.0
    RBPhysicsGravityScaling=1.0
    MoveRepSize=42.0
    PackedLightAndShadowMapTextureSize=1024
    DefaultColorScale=(X=1.0,Y=1.0,Z=1.0)
    CurrentMusicTrack=(TheSoundCue="None",bAutoPlay=False,bPersistentAcrossLevels=False,FadeInTime=5.0,FadeInVolumeLevel=1.0,FadeOutTime=5.0,FadeOutVolumeLevel=0.0)
    ReplicatedMusicTrack=(TheSoundCue="None",bAutoPlay=False,bPersistentAcrossLevels=False,FadeInTime=5.0,FadeInVolumeLevel=1.0,FadeOutTime=5.0,FadeOutVolumeLevel=0.0)
    EmitterPoolClassPath="AliceGame.AliceGameEmitterPool"
    DecalManagerClassPath="Engine.DecalManager"
    FractureManagerClassPath="Engine.FractureManager"
    MaxPhysicsDeltaTime=0.4
    MaxPhysicsSubsteps=10
    PhysicsProperties=(PrimaryScene=(bUseHardware=False,bFixedTimeStep=False,TimeStep=0.02,MaxSubSteps=5),CompartmentRigidBody=(bUseHardware=False,bFixedTimeStep=False,TimeStep=0.02,MaxSubSteps=2),CompartmentFluid=(bUseHardware=True,bFixedTimeStep=False,TimeStep=0.02,MaxSubSteps=2),CompartmentCloth=(bUseHardware=True,bFixedTimeStep=True,TimeStep=0.02,MaxSubSteps=2),CompartmentSoftBody=(bUseHardware=True,bFixedTimeStep=True,TimeStep=0.02,MaxSubSteps=2))
    DefaultSkinWidth=0.025
    ApexLODResourceBudget=-1.0
    DestructibleSettings=(MaxChunkIslandCount=-1,MaxRrbActorCount=-1,MaxChunkSeparationLOD=1.0,bOverrideMaxChunkSeparationLOD=False)
    EmitterVertical="Default__WorldInfo.PhysicsLODVerticalEmitter0"
    DestructibleVertical="Default__WorldInfo.PhysicsLODVerticalDestructible0"
    VerticalProperties=(Emitters=(bDisableLod=True,ParticlesLodMin=0,ParticlesLodMax=15000,PacketsPerPhysXParticleSystemMax=500,bApplyCylindricalPacketCulling=True,SpawnLodVsFifoBias=1.0))
    ChanceOfPhysicsChunkOverride=1.0
    FractureExplosionVelScale=1.0
    MaxNumFacturedChunksToSpawnInAFrame=12
    FracturedMeshWeaponDamage=1.0
    CharacterLightingContrastFactor=1.5
    MaxTrianglesPerLeaf=4
    LightmassSettings=(StaticLightingLevelScale=1.0,NumIndirectLightingBounces=3,EnvironmentColor=(B=0,G=0,R=0,A=0),EnvironmentIntensity=1.0,EmissiveBoost=1.0,DiffuseBoost=5.0,SpecularBoost=1.0,IndirectNormalInfluenceBoost=0.3,LightEnvironmentIndirectContrastFactor=4.0,bUseAmbientOcclusion=False,DirectIlluminationOcclusionFraction=0.5,IndirectIlluminationOcclusionFraction=1.0,OcclusionExponent=1.0,FullyOccludedSamplesFraction=1.0,MaxOcclusionDistance=200.0,bVisualizeMaterialDiffuse=False,bVisualizeAmbientOcclusion=False)
    PhysMatLogInfo="=== PhysMat Info ==="
    bWorldGeometry=True
    bAlwaysRelevant=True
    bMovable=False
    bBlockActors=True
    bHiddenEd=True
    bCanBeAutoClimbedUp=True
    RemoteRole="ROLE_SimulatedProxy"
}
