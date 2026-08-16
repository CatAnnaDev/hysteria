class KynapseAIController extends AIController
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var transient Actor hideAndShootTarget;
var transient Actor shootTarget;
var transient Actor followTarget;
var transient Pawn tmpPawn;
var transient export editinline KynapseHandle myKynapseHandle;
var Pointer KynapseEntity;
var float activityTimer;
var bool pathComputed;
var transient bool newLatentAction;
var float taskDuration;
var Actor DangerousNode;
var transient Actor DangerousEntity;
var array<Actor> FleeDangerousNodes;
var array<Actor> FleeDangerousEntities;
var array<Actor> HideDangerousNodes;
var array<Actor> HideDangerousEntities;
var transient Vector latentDestination;
var transient Actor latentTarget;
var transient float latentDuration;

function OnAIFollow(SeqAct_AIFollow Action)
{
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIFollow', true, Action);
    taskDuration = Action.Duration;
    if (!IsInState('AIFollow'))
    {
        PushState('AIFollow');
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Follow Target")
    {
        followTarget = Actor(ObjVar.GetObjectValue());
    }
}

function OnAIShoot(SeqAct_AIShoot Action)
{
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIShoot', true, Action);
    taskDuration = Action.Duration;
    if (!IsInState('AIShoot'))
    {
        PushState('AIShoot');
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Shoot Target")
    {
        LogInternal(string(Name) $ " Enemy found");
        shootTarget = Actor(ObjVar.GetObjectValue());
    }
}

function OnAIHide(SeqAct_AIHide Action)
{
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIHide', true, Action);
    taskDuration = Action.Duration;
    if (!IsInState('AIHide'))
    {
        PushState('AIHide');
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Dangerous Point")
    {
        DangerousNode = none;
        DangerousNode = PathNode(ObjVar.GetObjectValue());
        if (DangerousNode != none)
        {
            HideDangerousNodes.AddItem(DangerousNode);
            LogInternal(string(Name) $ " DangerousNode found");
        }
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Dangerous Entities")
    {
        DangerousEntity = Actor(ObjVar.GetObjectValue());
        if (DangerousEntity != none)
        {
            HideDangerousEntities.AddItem(DangerousEntity);
            LogInternal(string(Name) $ " DangerousEntity found");
        }
    }
}

function OnAIFlee(SeqAct_AIFlee Action)
{
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIFlee', true, Action);
    taskDuration = Action.Duration;
    if (!IsInState('AIFlee'))
    {
        PushState('AIFlee');
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Dangerous Point")
    {
        DangerousNode = none;
        DangerousNode = Actor(ObjVar.GetObjectValue());
        if (DangerousNode != none)
        {
            FleeDangerousNodes.AddItem(DangerousNode);
            LogInternal(string(Name) $ " DangerousNode found");
        }
    }
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Dangerous Entities")
    {
        DangerousEntity = Actor(ObjVar.GetObjectValue());
        if (DangerousEntity != none)
        {
            FleeDangerousEntities.AddItem(DangerousEntity);
            LogInternal(string(Name) $ " DangerousEntity found");
        }
    }
}

function OnAIWander(SeqAct_AIWander Action)
{
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIWander', true, Action);
    taskDuration = Action.Duration;
    if (!IsInState('AIWander'))
    {
        PushState('AIWander');
    }
    ScriptedFocus = none;
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Look At")
    {
        ScriptedFocus = Actor(ObjVar.GetObjectValue());
        if (ScriptedFocus != none)
        {
            break;
        }
    }
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    Possess(aPawn, bVehicleTransition);
    pathComputed = false;
}

native latent function bool KynapseFollow(Actor TargetEntity, float Duration)
{
    TargetEntity;
    Duration;
}

native latent function bool KynapseShoot(Actor TargetEntity, float Duration)
{
    TargetEntity;
    Duration;
}

native latent function bool KynapseHide(float Duration)
{
    Duration;
}

native latent function bool KynapseFlee(float Duration)
{
    Duration;
}

native latent function bool KynapseWander(float Duration)
{
    Duration;
}

native latent function bool KynapseGoTo(Vector KynapseDestination)
{
    KynapseDestination;
}

native final function SetBrainState(int Set)
{
    Set;
}

native final function int GetBrainState()
{
}

native final function ActivateKynapseBrain(bool Activate)
{
    Activate;
}

native final function bool KynapseHasArrived(Vector Dest)
{
    Dest;
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    HearNoise(Loudness, NoiseMaker, NoiseType);
}

state Follow
{
    Begin:
    followTarget = none;
    do
    {
        foreach AllActors(class'Engine.Pawn', tmpPawn)
        {
            if (tmpPawn.Controller != none && PlayerController(tmpPawn.Controller) != none)
            {
                foreach tmpPawn.AllOwnedComponents(class'KynapseHandle', myKynapseHandle)
                {
                    followTarget = tmpPawn;
                    break;
                }
            }
            if (followTarget != none)
            {
                break;
            }
        }
        if (followTarget == none)
        {
            Sleep(0.01);
        }
    } until (followTarget != none);
    KeepOn:
    if (KynapseFollow(followTarget, 1.0))
    {
        goto 'KeepOn';
    }
    LogInternal(string(Name) $ " cannot Follow");
    Stop;
}

state Shoot
{
    Begin:
    shootTarget = none;
    do
    {
        foreach AllActors(class'Engine.Pawn', tmpPawn)
        {
            if (tmpPawn.Controller != none && PlayerController(tmpPawn.Controller) != none)
            {
                foreach tmpPawn.AllOwnedComponents(class'KynapseHandle', myKynapseHandle)
                {
                    shootTarget = tmpPawn;
                    break;
                }
            }
            if (shootTarget != none)
            {
                break;
            }
        }
        if (shootTarget == none)
        {
            Sleep(0.01);
        }
    } until (shootTarget != none);
    KeepOn:
    if (KynapseShoot(shootTarget, 1.0))
    {
        goto 'KeepOn';
    }
    LogInternal(string(Name) $ " cannot Shoot");
    Stop;
}

state Hide
{
    Begin:
    if (KynapseHide(1000.0))
    {
        goto 'Begin';
    }
    LogInternal(string(Name) $ " cannot Hide");
    Stop;
}

state Flee
{
    Begin:
    if (KynapseFlee(1000.0))
    {
        goto 'Begin';
    }
    LogInternal(string(Name) $ " cannot Flee");
    Stop;
}

state HideAndShoot
{
    Stop;
}

state Wander
{
    Begin:
    if (KynapseWander(1000.0))
    {
        goto 'Begin';
    }
    LogInternal(string(Name) $ " cannot Wander");
    Stop;
}

state AIFollow
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
            if (Pawn.bCanFly == true)
            {
                Pawn.SetPhysics(4);
            }
        }
    }
    
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIFollow', false);
        LogInternal(string(Name) $ " Finished following");
    }
    
    Begin:
    LogInternal(string(Name) $ " Following through Kismet");
    if (Pawn != none)
    {
        KynapseFollow(followTarget, taskDuration);
    }
    PopState();
    Stop;
}

state AIShoot
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
            if (Pawn.bCanFly == true)
            {
                Pawn.SetPhysics(4);
            }
        }
    }
    
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIShoot', false);
        LogInternal(string(Name) $ " Finished Shooting");
    }
    
    Begin:
    LogInternal(string(Name) $ " Shooting through Kismet");
    if (Pawn != none)
    {
        KynapseShoot(shootTarget, taskDuration);
    }
    PopState();
    Stop;
}

state AIHide
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
            if (Pawn.bCanFly == true)
            {
                Pawn.SetPhysics(4);
            }
        }
    }
    
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIHide', false);
        LogInternal(string(Name) $ " Finished Hiding");
    }
    
    Begin:
    LogInternal(string(Name) $ " Hiding through Kismet");
    if (Pawn != none)
    {
        KynapseHide(taskDuration);
    }
    PopState();
    Stop;
}

state AIFlee
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
            if (Pawn.bCanFly == true)
            {
                Pawn.SetPhysics(4);
            }
        }
    }
    
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIFlee', false);
        LogInternal(string(Name) $ " Finished Fleeing");
    }
    
    Begin:
    LogInternal(string(Name) $ " Fleeing through Kismet");
    if (Pawn != none)
    {
        KynapseFlee(taskDuration);
    }
    PopState();
    Stop;
}

state AIHideAndShoot
{
    Stop;
}

state AIWander
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
            if (Pawn.bCanFly == true)
            {
                Pawn.SetPhysics(4);
            }
        }
    }
    
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIWander', false);
        LogInternal(string(Name) $ " Finished Wandering");
    }
    
    Begin:
    LogInternal(string(Name) $ " Wandering through Kismet");
    if (Pawn != none)
    {
        KynapseWander(taskDuration);
    }
    PopState();
    Stop;
}

defaultproperties
{
}
