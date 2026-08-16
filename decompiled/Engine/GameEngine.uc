class GameEngine extends Engine
    native
    notplaceable
    transient
    config(Engine);

enum EFullyLoadPackageType
{
    FULLYLOAD_Map,
    FULLYLOAD_Game_PreLoadClass,
    FULLYLOAD_Game_PostLoadClass,
    FULLYLOAD_Always,
    FULLYLOAD_Mutator,
};

enum ECheckpointActionFlag
{
    CheckpointFlag_ALL,
    CheckpointFlag_CheckPointAndPersistentData,
    CheckpointFlag_ConfigAndPersistentData,
    CheckpointFlag_CheckPoint,
    CheckpointFlag_PersistentData,
    CheckpointFlag_Config,
};

enum ECheckpointAction
{
    Checkpoint_Default,
    Checkpoint_Load,
    Checkpoint_Loading,
    Checkpoint_SavePrepare,
    Checkpoint_Save,
    Checkpoint_Saving,
    Checkpoint_DeleteAll,
};

struct native NamedNetDriver
{
    var name NetDriverName;
    var const native Pointer NetDriver;
};

struct native FullyLoadedPackagesInfo
{
    var EFullyLoadPackageType FullyLoadType;
    var string Tag;
    var array<name> PackagesToLoad;
    var array<Object> LoadedObjects;
};

struct native LevelStreamingStatus
{
    var name PackageName;
    var bool bShouldBeLoaded;
    var bool bShouldBeVisible;
};

struct native transient URL
{
    var string Protocol;
    var string Host;
    var int Port;
    var string Map;
    var array<string> Op;
    var string Portal;
    var int Valid;
};

var PendingLevel GPendingLevel;
var config string PendingLevelPlayerControllerClassName;
var URL LastURL;
var URL LastRemoteURL;
var config array<string> ServerActors;
var string TravelURL;
var byte TravelType;
var ChapterNameList LoadingChapterName;
var const transient bool bWorldWasLoadedThisTick;
var const bool bShouldCommitPendingMapChange;
var config bool bClearAnimSetLinkupCachesOnLoadMap;
var bool IsLoadChapterReserve;
var OnlineSubsystem OnlineSubsystem;
var const array<name> LevelsToLoadForPendingMapChange;
var const array<Level> LoadedLevelsForPendingMapChange;
var const string PendingMapChangeFailureDescription;
var config float MaxDeltaTime;
var const array<LevelStreamingStatus> PendingLevelStreamingStatusUpdates;
var const array<ObjectReferencer> ObjectReferencers;
var array<FullyLoadedPackagesInfo> PackagesToFullyLoad;
var const transient array<NamedNetDriver> NamedNetDrivers;

native static final function OnlineSubsystem GetOnlineSubsystem()
{
}

native final function DestroyNamedNetDriver(name NetDriverName)
{
    NetDriverName;
}

native final function bool CreateNamedNetDriver(name NetDriverName)
{
    NetDriverName;
}

defaultproperties
{
    LastURL=(Protocol="",Host="",Port=0,Map="",Op=(),Portal="",Valid=1)
    LastRemoteURL=(Protocol="",Host="",Port=0,Map="",Op=(),Portal="",Valid=1)
}
