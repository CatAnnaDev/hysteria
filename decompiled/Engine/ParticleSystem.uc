class ParticleSystem extends Object
    native
    notplaceable
    hidecategories(Object);

enum EParticleSystemOcclusionBoundsMethod
{
    EPSOBM_None,
    EPSOBM_ParticleBounds,
    EPSOBM_CustomBounds,
};

enum ParticleSystemLODMethod
{
    PARTICLESYSTEMLODMETHOD_Automatic,
    PARTICLESYSTEMLODMETHOD_DirectSet,
    PARTICLESYSTEMLODMETHOD_ActivateAutomatic,
};

enum EParticleSystemUpdateMode
{
    EPSUM_RealTime,
    EPSUM_FixedTime,
};

struct native LODSoloTrack
{
    var transient array<byte> SoloEnableSetting;
};

struct native ParticleSystemLOD
{
    var() bool bLit;
};

var() EParticleSystemUpdateMode SystemUpdateMode;
var(LOD) ParticleSystemLODMethod LODMethod;
var(Occlusion) EParticleSystemOcclusionBoundsMethod OcclusionBoundsMethod;
var() float UpdateTime_FPS;
var float UpdateTime_Delta;
var() float WarmupTime;
var export editinline array<ParticleEmitter> Emitters;
var transient export editinline ParticleSystemComponent PreviewComponent;
var Rotator ThumbnailAngle;
var float ThumbnailDistance;
var(Thumbnail) float ThumbnailWarmup;
var const deprecated bool bLit;
var() bool bOrientZAxisTowardCamera;
var bool bRegenerateLODDuplicate;
var(Bounds) bool bUseFixedRelativeBoundingBox;
var bool bShouldResetPeakCounts;
var transient bool bHasPhysics;
var(Thumbnail) bool bUseRealtimeThumbnail;
var bool ThumbnailImageOutOfDate;
var() bool bSkipSpawnCountCheck;
var(Delay) bool bUseDelayRange;
var(PhysXParticleMutator) bool bLoadIfPhysXLevel0;
var(PhysXParticleMutator) bool bLoadIfPhysXLevel1;
var(PhysXParticleMutator) bool bLoadIfPhysXLevel2;
var export InterpCurveEdSetup CurveEdSetup;
var(LOD) float LODDistanceCheckTime;
var(LOD) editfixedsize array<float> LODDistances;
var int EditorLODSetting;
var(LOD) array<ParticleSystemLOD> LODSettings;
var(Bounds) Box FixedRelativeBoundingBox;
var() float SecondsBeforeInactive;
var editoronly string FloorMesh;
var editoronly Vector FloorPosition;
var editoronly Rotator FloorRotation;
var editoronly float FloorScale;
var editoronly Vector FloorScale3D;
var editoronly Color BackgroundColor;
var editoronly Texture2D ThumbnailImage;
var(Delay) float Delay;
var(Delay) float DelayLow;
var(MacroUV) Vector MacroUVPosition;
var(MacroUV) float MacroUVRadius;
var(Occlusion) Box CustomOcclusionBounds;
var transient array<LODSoloTrack> SoloTracking;
var(PhysXParticleMutator) ParticleSystem PhysxParticleSystemRef;

native function bool SetLODDistance(int LODLevelIndex, float InDistance)
{
    LODLevelIndex;
    InDistance;
}

native function SetCurrentLODMethod(ParticleSystemLODMethod InMethod)
{
    InMethod;
}

native function float GetLODDistance(int LODLevelIndex)
{
    LODLevelIndex;
}

native function int GetLODLevelCount()
{
}

native function ParticleSystemLODMethod GetCurrentLODMethod()
{
}

defaultproperties
{
    UpdateTime_FPS=60.0
    UpdateTime_Delta=1.0
    ThumbnailDistance=200.0
    ThumbnailWarmup=1.0
    ThumbnailImageOutOfDate=True
    LODDistanceCheckTime=0.25
    FixedRelativeBoundingBox=(Min=(X=-1.0,Y=-1.0,Z=-1.0),Max=(X=1.0,Y=1.0,Z=1.0),IsValid=0)
    FloorMesh="EditorMeshes.AnimTreeEd_PreviewFloor"
    FloorScale=1.0
    FloorScale3D=(X=1.0,Y=1.0,Z=1.0)
    MacroUVRadius=200.0
}
