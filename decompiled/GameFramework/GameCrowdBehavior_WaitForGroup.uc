class GameCrowdBehavior_WaitForGroup extends GameCrowdAgentBehavior
    native
    placeable;

function StopBehavior()
{
    StopBehavior();
    MyAgent.StopIdleAnimation();
}

native function bool ShouldEndIdle()
{
}

function string GetBehaviorString()
{
    local string BehaviorString;
    
    BehaviorString = "Behavior: " $ string(self);
    if (bFaceActionTargetFirst)
    {
        BehaviorString = BehaviorString @ "Turning toward " $ string(ActionTarget);
    }
    else
    {
        BehaviorString = BehaviorString @ "Waiting For Group";
    }
    return BehaviorString;
}

function InitBehavior(GameCrowdAgent Agent)
{
    InitBehavior(Agent);
    Agent.PlayIdleAnimation();
}

defaultproperties
{
    bIdleBehavior=True
    bFaceActionTargetFirst=True
}
