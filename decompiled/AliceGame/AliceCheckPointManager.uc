class AliceCheckPointManager extends CheckPointManager
    native
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var native Pointer PersistentSaveData;
var native Pointer PersistentWriterArchive;
var native Pointer ConfigSaveData;
var native Pointer ConfigWriterArchive;

function UpdateRegisterWhenChangeCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
    UpdateRegisterWhenChange(RegisterActor, OutName, ActorFName);
}

function UnRegisterWhenApplyRecordCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
    UnRegisterWhenApplyRecord(RegisterActor, OutName, ActorFName);
}

function RegisterWhenApplyRecordCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
    RegisterWhenApplyRecord(RegisterActor, OutName, ActorFName);
}

function RegisterWhenPostBeginPlayCallFromBase(Actor RegisterActor)
{
    RegisterWhenPostBeginPlay(RegisterActor);
}

native function UpdateRegisterWhenChange(Actor RegisterActor, string OutName, string ActorFName)
{
    RegisterActor;
    OutName;
    ActorFName;
}

native function UnRegisterWhenApplyRecord(Actor RegisterActor, string OutName, string ActorFName)
{
    RegisterActor;
    OutName;
    ActorFName;
}

native function RegisterWhenApplyRecord(Actor RegisterActor, string OutName, string ActorFName)
{
    RegisterActor;
    OutName;
    ActorFName;
}

native function RegisterWhenPostBeginPlay(Actor RegisterActor)
{
    RegisterActor;
}

defaultproperties
{
}
