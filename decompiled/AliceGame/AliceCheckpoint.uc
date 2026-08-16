class AliceCheckpoint extends Object
    native
    notplaceable;

enum EDifficultyLevel
{
    DL_Casual,
    DL_Normal,
    DL_Hardcore,
    DL_Insane,
};

struct native ActorRecord
{
    var string actorName;
    var string ActorClassPath;
    var bool SpawnByArcheType;
    var Actor SpawnArcheType;
    var array<byte> RecordData;
};

struct native LevelRecord
{
    var() name LevelName;
    var() bool bShouldBeLoaded;
    var() bool bShouldBeVisible;
};

struct native CheckpointTime
{
    var int SecondsSinceMidnight;
    var int Day;
    var int Month;
    var int Year;
};

var int SlotIndex;
var string BaseLevelName;
var ChapterNameList Chapter;
var EDifficultyLevel Difficulty;
var CheckpointTime SaveTime;
var Vector CheckpointLocation;
var native Pointer CheckpointWriterArchive;
var array<LevelRecord> LevelRecords;
var array<ActorRecord> ActorRecords;
var array<byte> KismetData;
var const array<class<Actor>> ActorClassesToRecord;
var const array<class<Actor>> ActorClassesToDestroy;
var const array<class<Actor>> ActorClassesNotToDestroy;
var const localized string DisplayName;
var int HasSoundCue;
var string CurrentPlayingSoundName;

event PostSaveCheckpoint()
{
    local AlicePlayerController APC;
    
    APC = GetAlicePlayerController();
    if (APC.bShrinkingModeActive && !AlicePlayerInput(APC.PlayerInput).IsKeyPressed('XboxTypeS_LeftShoulder'))
    {
        APC.UnShrinking();
    }
}

event PreSaveCheckpoint()
{
}

event PostLoadCheckpoint()
{
    local AlicePlayerController APC;
    
    APC = GetAlicePlayerController();
    APC.PlayerCamera.BlendTimeToGo = -1.0;
    APC.MyAlicePawn.FarMoveSetLocation(APC.getSafeTeleportLoc(), true);
}

event PreLoadCheckpoint()
{
}

native function AlicePlayerController GetAlicePlayerController()
{
}

final function bool CheckpointIsNewer(AliceCheckpoint OtherCheckpoint)
{
    local bool bResult;
    
    bResult = true;
    if (OtherCheckpoint != none)
    {
        bResult = CheckpointTimeIsNewer(SaveTime, OtherCheckpoint.SaveTime);
    }
    return bResult;
}

static final function bool CheckpointTimeIsNewer(out const CheckpointTime GameCheckpointTime, out const CheckpointTime OtherCheckpointTime)
{
    local bool bResult;
    
    if (GameCheckpointTime.Year > OtherCheckpointTime.Year)
    {
        bResult = true;
    }
    else if (GameCheckpointTime.Year < OtherCheckpointTime.Year)
    {
        bResult = false;
    }
    else if (GameCheckpointTime.Month > OtherCheckpointTime.Month)
    {
        bResult = true;
    }
    else if (GameCheckpointTime.Month < OtherCheckpointTime.Month)
    {
        bResult = false;
    }
    else if (GameCheckpointTime.Day > OtherCheckpointTime.Day)
    {
        bResult = true;
    }
    else if (GameCheckpointTime.Day < OtherCheckpointTime.Day)
    {
        bResult = false;
    }
    else if (GameCheckpointTime.SecondsSinceMidnight > OtherCheckpointTime.SecondsSinceMidnight)
    {
        bResult = true;
    }
    else if (GameCheckpointTime.SecondsSinceMidnight < OtherCheckpointTime.SecondsSinceMidnight)
    {
        bResult = false;
    }
    return bResult;
}

final event bool CheckpointIsEmpty()
{
    if (SaveTime.SecondsSinceMidnight == 0 && SaveTime.Day == 0 && SaveTime.Month == 0 && SaveTime.Year == 0)
    {
        return true;
    }
    return false;
}

defaultproperties
{
    ActorClassesToRecord(0)="Engine.LevelStreamingVolume"
    ActorClassesToRecord(1)="AlicePlayerController"
    ActorClassesToRecord(2)="Engine.InterpActor"
    ActorClassesToRecord(3)="Engine.Trigger"
    ActorClassesToRecord(4)="Engine.SkeletalMeshActorMAT"
    ActorClassesToRecord(5)="Engine.Emitter"
    ActorClassesToRecord(6)="Engine.DynamicBlockingVolume"
    ActorClassesToRecord(7)="Engine.PhysicsVolume"
    ActorClassesToRecord(8)="MemoryFragmentNormal"
    ActorClassesToRecord(9)="GameBreakableActor"
    ActorClassesToRecord(10)="NoseActorBase"
    ActorClassesToRecord(11)="JumpPadGrowing"
    ActorClassesToRecord(12)="AliceVentActor"
    ActorClassesToRecord(13)="ShrinkFlowerInteractive"
    ActorClassesToRecord(14)="AimSwitchActorBase"
    ActorClassesToRecord(15)="AliceBlockPiece"
    ActorClassesToDestroy(0)="AliceGameKynapsePawn"
    ActorClassesToDestroy(1)="AliceGameKynapseAIController"
    ActorClassesToDestroy(2)="AliceClonePawn"
    ActorClassesToDestroy(3)="AliceHealthPickupFactory"
    ActorClassesToDestroy(4)="AliceXPPickupFactory"
}
