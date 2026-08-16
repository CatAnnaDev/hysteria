class DynamicBlockingVolume extends BlockingVolume
    native
    placeable
    hidecategories(Navigation,Object,Display);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var bool bCollideActors;
    var bool bBlockActors;
    var bool bNeedsReplication;
    var string initMostOutName;
    var string initActorFName;
    var bool bEnabled;
    var() ECollisionType CollisionType;
};

var() bool bEnabled;
var transient string initMostOutName;
var transient string initActorFName;

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
    OnToggle(Action);
    WorldInfo.Game.MyCheckPointManager.UpdateRegisterWhenChangeCallFromBase(self, initMostOutName, initActorFName);
}

function OnChangeCollision(SeqAct_ChangeCollision Action)
{
    OnChangeCollision(Action);
    WorldInfo.Game.MyCheckPointManager.UpdateRegisterWhenChangeCallFromBase(self, initMostOutName, initActorFName);
}

event UpdateAfterAcceptPersistentDate()
{
    if (bEnabled)
    {
        SetCollision(bEnabled, bBlockActors);
        CollisionComponent.SetActorCollision(true, true);
        CollisionComponent.SetTraceBlocking(false, true);
        CollisionComponent.SetBlockRigidBody(bCollideActors);
    }
    else
    {
        SetCollision(false, false);
        CollisionComponent.SetActorCollision(false, false);
        CollisionComponent.SetTraceBlocking(false, false);
        CollisionComponent.SetBlockRigidBody(false);
    }
    SetCollisionType(CollisionType);
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    WorldInfo.Game.MyCheckPointManager.UnRegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    if (!bHardAttach)
    {
        SetLocation(Record.Location);
        SetRotation(Record.Rotation);
    }
    bEnabled = Record.bEnabled;
    if (bEnabled)
    {
        SetCollision(bEnabled, Record.bBlockActors);
        CollisionComponent.SetActorCollision(true, true);
        CollisionComponent.SetTraceBlocking(false, true);
        CollisionComponent.SetBlockRigidBody(Record.bCollideActors);
    }
    else
    {
        SetCollision(false, false);
        CollisionComponent.SetActorCollision(false, false);
        CollisionComponent.SetTraceBlocking(false, false);
        CollisionComponent.SetBlockRigidBody(false);
    }
    SetCollisionType(Record.CollisionType);
    WorldInfo.Game.MyCheckPointManager.RegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
    if (Record.bNeedsReplication)
    {
        ForceNetRelevant();
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.bCollideActors = bCollideActors;
    Record.bBlockActors = bBlockActors;
    Record.CollisionType = CollisionType;
    Record.bEnabled = bEnabled;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
    Record.bNeedsReplication = RemoteRole != 0;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetCollision(bEnabled, bBlockActors);
    WorldInfo.Game.MyCheckPointManager.RegisterWhenPostBeginPlayCallFromBase(self);
}

defaultproperties
{
    bEnabled=True
    BrushColor=(B=100,G=255,R=255,A=255)
    BrushComponent="Default__DynamicBlockingVolume.BrushComponent0"
    bStatic=False
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__DynamicBlockingVolume.BrushComponent0"
    Physics="PHYS_Interpolating"
    CollisionComponent="Default__DynamicBlockingVolume.BrushComponent0"
}
