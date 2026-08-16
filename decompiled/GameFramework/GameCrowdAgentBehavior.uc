class GameCrowdAgentBehavior extends Object
    abstract
    native
    notplaceable;

var() bool bIdleBehavior;
var() bool bFaceActionTargetFirst;
var() bool bIsViralBehavior;
var bool bIsPanicked;
var Actor ActionTarget;
var() float MaxPlayerDistance;
var GameCrowdAgent MyAgent;

function bool AllowBehaviorAt(GameCrowdDestination Destination)
{
    return true;
}

function bool AllowThisDestination(GameCrowdDestination Destination)
{
    return true;
}

event PropagateViralBehaviorTo(GameCrowdAgent OtherAgent)
{
}

function ActivatedBy(Actor NewActionTarget)
{
    ActionTarget = NewActionTarget;
}

function Actor GetDestinationActor()
{
    return MyAgent.CurrentDestination;
}

function ChangingDestination(GameCrowdDestination NewDest)
{
}

function string GetBehaviorString()
{
    return "Behavior: " $ string(self);
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
}

function StopBehavior()
{
}

function InitBehavior(GameCrowdAgent Agent)
{
    MyAgent = Agent;
}

native function bool HandleMovement()
{
}

event FinishedTargetRotation()
{
}

function bool CanBeUsedBy(GameCrowdAgent Agent, Vector cameraLoc)
{
    return VSizeSq(cameraLoc - Agent.Location) < MaxPlayerDistance * MaxPlayerDistance;
}

native function Tick(float DeltaTime)
{
    DeltaTime;
}

native function bool ShouldEndIdle()
{
}

defaultproperties
{
    MaxPlayerDistance=10000.0
}
