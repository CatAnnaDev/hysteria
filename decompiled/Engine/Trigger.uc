class Trigger extends Actor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var bool bCollideActors;
    var int TriggerTimes;
    var bool bEnabled;
    var string initMostOutName;
    var string initActorFName;
};

var transient string initMostOutName;
var transient string initActorFName;
var() const export editconst editinline CylinderComponent CylinderComponent;
var bool bRecentlyTriggered;
var() bool bEnabled;
var() float AITriggerDelay;
var int TriggerTimes;

function ContextActorPostApplyCheckPoinat()
{
}

function bool ShouldSaveForCheckpoint()
{
    return bStatic || bNoDelete;
}

simulated function bool StopsProjectile(Projectile P)
{
    return bBlockActors;
}

function UnTrigger()
{
    bRecentlyTriggered = false;
}

function NotifyTriggered()
{
    bRecentlyTriggered = true;
    SetTimer(AITriggerDelay, false, 'UnTrigger');
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (FindEventsOfClass(class'SeqEvent_Touch'))
    {
        NotifyTriggered();
    }
}

event UpdateAfterAcceptPersistentDate()
{
    ContextActorPostApplyCheckPoinat();
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    WorldInfo.Game.MyCheckPointManager.UnRegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
    SetCollision(Record.bCollideActors, bBlockActors, bIgnoreEncroachers);
    TriggerTimes = Record.TriggerTimes;
    bEnabled = Record.bEnabled;
    ContextActorPostApplyCheckPoinat();
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    WorldInfo.Game.MyCheckPointManager.RegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bCollideActors = bCollideActors;
    Record.TriggerTimes = TriggerTimes;
    Record.bEnabled = bEnabled;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    WorldInfo.Game.MyCheckPointManager.RegisterWhenPostBeginPlayCallFromBase(self);
}

defaultproperties
{
    CylinderComponent="Default__Trigger.CollisionCylinder"
    AITriggerDelay=2.0
    bHidden=True
    bNoDelete=True
    bCollideActors=True
    bProjTarget=True
    Components(0)="Default__Trigger.Sprite"
    Components(1)="Default__Trigger.CollisionCylinder"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__Trigger.CollisionCylinder"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_Used"
}
