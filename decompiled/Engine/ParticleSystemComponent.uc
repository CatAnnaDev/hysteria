class ParticleSystemComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Physics,Collision);

enum EParticleEventType
{
    EPET_Any,
    EPET_Spawn,
    EPET_Death,
    EPET_Collision,
    EPET_Kismet,
};

enum ParticleReplayState
{
    PRS_Disabled,
    PRS_Capturing,
    PRS_Replaying,
};

enum EParticleSysParamType
{
    PSPT_None,
    PSPT_Scalar,
    PSPT_Vector,
    PSPT_Color,
    PSPT_Actor,
    PSPT_Material,
};

struct native ParticleEventKismetData extends ParticleEventData
{
    var bool UsePSysCompLocation;
    var Vector Normal;
};

struct native ParticleEventCollideData extends ParticleEventData
{
    var float ParticleTime;
    var Vector Normal;
    var float Time;
    var int Item;
    var name BoneName;
};

struct native ParticleEventDeathData extends ParticleEventData
{
    var float ParticleTime;
};

struct native ParticleEventSpawnData extends ParticleEventData
{
};

struct native ParticleEventData
{
    var int Type;
    var name EventName;
    var float EmitterTime;
    var Vector Location;
    var Vector Direction;
    var Vector Velocity;
};

struct native ParticleSysParam
{
    var() name Name;
    var() EParticleSysParamType ParamType;
    var() float Scalar;
    var() Vector Vector;
    var() Color Color;
    var() Actor Actor;
    var() MaterialInterface Material;
};

struct native ViewParticleEmitterInstanceMotionBlurInfo
{
    var const native transient Map_Mirror EmitterInstanceMBInfoMap;
};

struct native ParticleEmitterInstanceMotionBlurInfo
{
    var const native transient Map_Mirror ParticleMBInfoMap;
};

struct ParticleEmitterInstance
{
};

var() const ParticleSystem Template;
var class<ParticleLightEnvironmentComponent> LightEnvironmentClass;
var const native transient array<Pointer> EmitterInstances;
var const transient duplicatetransient export editinline array<StaticMeshComponent> SMComponents;
var const transient duplicatetransient array<MaterialInterface> SMMaterialInterfaces;
var const native transient array<ViewParticleEmitterInstanceMotionBlurInfo> ViewMBInfoArray;
var() bool bAutoActivate;
var const bool bWasCompleted;
var const bool bSuppressSpawning;
var const bool bWasDeactivated;
var() bool bResetOnDetach;
var() bool bResetOnFinish;
var transient bool bPendingReset;
var bool bUpdateOnDedicatedServer;
var bool bJustAttached;
var transient bool bIsActive;
var bool bWarmingUp;
var bool bIsCachedInPool;
var(LOD) bool bOverrideLODMethod;
var bool bSkipUpdateDynamicDataDuringTick;
var bool bUpdateComponentInTick;
var bool bDeferredBeamUpdate;
var transient bool bForcedInActive;
var transient bool bIsWarmingUp;
var transient bool bIsViewRelevanceDirty;
var transient bool bRecacheViewRelevance;
var transient bool bLODUpdatePending;
var transient bool bSkipSpawnCountCheck;
var() float ResetInterval;
var transient float PendingResetTime;
var() editinline array<ParticleSysParam> InstanceParameters;
var Vector OldPosition;
var Vector PartSysVelocity;
var float WarmupTime;
var int LODLevel;
var() float SecondsBeforeInactive;
var transient float TimeSinceLastForceUpdateTransform;
var float MaxTimeBeforeForceUpdateTransform;
var int EditorLODLevel;
var transient float AccumTickTime;
var(LOD) ParticleSystemLODMethod LODMethod;
var const transient ParticleReplayState ReplayState;
var const transient array<MaterialViewRelevance> CachedViewRelevanceFlags;
var() const editinline array<ParticleSystemReplay> ReplayClips;
var const transient int ReplayClipIDNumber;
var const transient int ReplayFrameIndex;
var transient float AccumLODDistanceCheckTime;
var transient array<ParticleEventSpawnData> SpawnEvents;
var transient array<ParticleEventDeathData> DeathEvents;
var transient array<ParticleEventCollideData> CollisionEvents;
var transient array<ParticleEventKismetData> KismetEvents;
var const native transient Pointer ReleaseResourcesFence;
var() float CustomTimeDilation;
var transient float EmitterDelay;
var delegate<OnSystemFinished> __OnSystemFinished__Delegate;

native final function SetStopSpawning(int InEmitterIndex, bool bInStopSpawning)
{
    InEmitterIndex;
    bInStopSpawning;
}

native final function ResetToDefaults()
{
}

native final function SetActive(bool bNowActive)
{
    bNowActive;
}

native final function ClearParameter(name ParameterName, optional EParticleSysParamType ParameterType)
{
    ParameterName;
    ParameterType;
}

native function bool GetMaterialParameter(const name InName, out MaterialInterface OutMaterial)
{
    InName;
    OutMaterial;
}

native function bool GetActorParameter(const name InName, out Actor OutActor)
{
    InName;
    OutActor;
}

native function bool GetColorParameter(const name InName, out Color OutColor)
{
    InName;
    OutColor;
}

native function bool GetVectorParameter(const name InName, out Vector OutVector)
{
    InName;
    OutVector;
}

native function bool GetFloatParameter(const name InName, out float OutFloat)
{
    InName;
    OutFloat;
}

native final function SetMaterialParameter(name ParameterName, MaterialInterface Param)
{
    ParameterName;
    Param;
}

native final function SetActorParameter(name ParameterName, Actor Param)
{
    ParameterName;
    Param;
}

native final function SetColorParameter(name ParameterName, Color Param)
{
    ParameterName;
    Param;
}

native final function SetVectorParameter(name ParameterName, Vector Param)
{
    ParameterName;
    Param;
}

native final function SetFloatParameter(name ParameterName, float Param)
{
    ParameterName;
    Param;
}

native final function int GetEditorLODLevel()
{
}

native final function int GetLODLevel()
{
}

native final function SetEditorLODLevel(int InLODLevel)
{
    InLODLevel;
}

native final function SetLODLevel(int InLODLevel)
{
    InLODLevel;
}

native function int DetermineLODLevelForLocation(Vector EffectLocation)
{
    EffectLocation;
}

native function SetBeamTargetStrength(int EmitterIndex, float NewTargetStrength, int TargetIndex)
{
    EmitterIndex;
    NewTargetStrength;
    TargetIndex;
}

native function SetBeamTargetTangent(int EmitterIndex, Vector NewTangentPoint, int TargetIndex)
{
    EmitterIndex;
    NewTangentPoint;
    TargetIndex;
}

native function SetBeamTargetPoint(int EmitterIndex, Vector NewTargetPoint, int TargetIndex)
{
    EmitterIndex;
    NewTargetPoint;
    TargetIndex;
}

native function SetBeamSourceStrength(int EmitterIndex, float NewSourceStrength, int SourceIndex)
{
    EmitterIndex;
    NewSourceStrength;
    SourceIndex;
}

native function SetBeamSourceTangent(int EmitterIndex, Vector NewTangentPoint, int SourceIndex)
{
    EmitterIndex;
    NewTangentPoint;
    SourceIndex;
}

native function SetBeamSourcePoint(int EmitterIndex, Vector NewSourcePoint, int SourceIndex)
{
    EmitterIndex;
    NewSourcePoint;
    SourceIndex;
}

native function SetBeamDistance(int EmitterIndex, float Distance)
{
    EmitterIndex;
    Distance;
}

native function SetBeamEndPoint(int EmitterIndex, Vector NewEndPoint)
{
    EmitterIndex;
    NewEndPoint;
}

native function SetBeamTessellationFactor(int EmitterIndex, float NewFactor)
{
    EmitterIndex;
    NewFactor;
}

native function SetBeamType(int EmitterIndex, int NewMethod)
{
    EmitterIndex;
    NewMethod;
}

native function RewindEmitterInstances()
{
}

native function RewindEmitterInstance(int EmitterIndex)
{
    EmitterIndex;
}

native function SetKillOnCompleted(int EmitterIndex, bool bKill)
{
    EmitterIndex;
    bKill;
}

native function SetKillOnDeactivate(int EmitterIndex, bool bKill)
{
    EmitterIndex;
    bKill;
}

native final function bool GetSkipUpdateDynamicDataDuringTick()
{
}

native final function SetSkipUpdateDynamicDataDuringTick(bool bInSkipUpdateDynamicDataDuringTick)
{
    bInSkipUpdateDynamicDataDuringTick;
}

native final function KillParticlesForced()
{
}

native final function DeactivateSystem()
{
}

native final function ActivateSystem(optional bool bFlagAsJustAttached = false)
{
    bFlagAsJustAttached;
}

native final function SetTemplate(ParticleSystem NewTemplate)
{
    NewTemplate;
}

delegate OnSystemFinished(ParticleSystemComponent PSystem)
{
}

defaultproperties
{
    LightEnvironmentClass="ParticleLightEnvironmentComponent"
    bAutoActivate=True
    bIsViewRelevanceDirty=True
    ResetInterval=0.5
    SecondsBeforeInactive=1.0
    MaxTimeBeforeForceUpdateTransform=5.0
    CustomTimeDilation=1.0
    ReplacementPrimitive="None"
    bTickInEditor=True
}
