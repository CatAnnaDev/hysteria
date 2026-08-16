class GameCrowdBehavior_Surrounder extends GameCrowdAgentBehavior
    native
    placeable;

var GameCrowdDestination SurroundDes;
var() int MaxSurrounding;
var() int AgentDamage;
var() int SlowFactor;
var() int SurroundRadius;
var name Anim;
var AlicePlayerController SurroundApc;

event BehaviorUpdate(Vector TargetLoc)
{
    local float dis;
    local Vector ToIntermediatePoint;
    
    if (SurroundApc == none)
    {
        return;
    }
    if (SurroundApc.bCinematicMode)
    {
        GameCrowdAgentSkeletal(MyAgent).FullBodySlot.StopCustomAnim(0.2);
        GameCrowdAgentSkeletal(MyAgent).SetRootMotion(false);
        bIdleBehavior = true;
        return;
    }
    else
    {
        bIdleBehavior = false;
    }
    ToIntermediatePoint = MyAgent.Location - TargetLoc;
    dis = VSize(ToIntermediatePoint);
    if (dis > float(800) || SurroundApc.bCinematicMode)
    {
        StopBehavior();
        return;
    }
    if (SurroundApc.MyAlicePawn.bRepulsor && dis < float(600))
    {
        AliceGameCrowdAgent(MyAgent).FullBodySlot.StopCustomAnim(0.2);
        AliceGameCrowdAgent(MyAgent).SpeedBlendNode.SetBlendTarget(1.0, 0.2);
        AliceGameCrowdAgent(MyAgent).IntermediatePoint = MyAgent.Location + Normal(ToIntermediatePoint) * float(500);
        return;
    }
    if (dis < float(SurroundRadius))
    {
        MyAgent.CurrentBehavior.bIdleBehavior = true;
        if (SurroundApc.MyAlicePawn.Health > 0)
        {
            AliceGameCrowdAgent(MyAgent).PlayAttackAnimation();
        }
        else
        {
            MyAgent.CurrentBehavior.bIdleBehavior = false;
            AliceGameCrowdAgent(MyAgent).CurrentDestination.ReachedDestination(AliceGameCrowdAgent(MyAgent));
        }
    }
    else
    {
        AliceGameCrowdAgent(MyAgent).FullBodySlot.StopCustomAnim(0.2);
        AliceGameCrowdAgent(MyAgent).SpeedBlendNode.SetBlendTarget(1.0, 0.2);
        MyAgent.CurrentBehavior.bIdleBehavior = false;
    }
}

function StopBehavior()
{
    if (SurroundApc != none)
    {
        SurroundApc.CrowdAgentsCount--;
    }
    StopBehavior();
}

function InitBehavior(GameCrowdAgent Agent)
{
    local PlayerController PC;
    
    InitBehavior(Agent);
    PC = Agent.GetALocalPlayerController();
    SurroundApc = AlicePlayerController(PC);
    if (SurroundApc != none)
    {
        SurroundApc.CrowdAgentsCount++;
        SurroundApc.SlowFactor = SlowFactor;
    }
    AliceGameCrowdAgent(MyAgent).AgentDamage = AgentDamage;
    AliceGameCrowdAgent(MyAgent).SlowFactor = SlowFactor;
}

native function Tick(float DeltaTime)
{
    DeltaTime;
}

native function bool ShouldEndIdle()
{
}

native function bool HandleMovement()
{
}

defaultproperties
{
    MaxSurrounding=5
    AgentDamage=1
    SlowFactor=2
    SurroundRadius=120
    bFaceActionTargetFirst=True
}
