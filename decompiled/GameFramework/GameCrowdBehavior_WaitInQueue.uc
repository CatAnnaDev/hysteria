class GameCrowdBehavior_WaitInQueue extends GameCrowdAgentBehavior
    native
    notplaceable;

var bool bStoppingBehavior;
var GameCrowdDestinationQueuePoint QueuePosition;

function StopBehavior()
{
    if (!bStoppingBehavior)
    {
        bStoppingBehavior = true;
        StopBehavior();
        if (QueuePosition != none)
        {
            QueuePosition.ClearQueue(MyAgent);
        }
        QueuePosition = none;
        MyAgent.StopIdleAnimation();
        bStoppingBehavior = false;
    }
}

native function bool ShouldEndIdle()
{
}

function string GetBehaviorString()
{
    if (QueuePosition != none)
    {
        return string(self) $ " Waiting in line at " $ string(QueuePosition);
    }
    else
    {
        return string(self) $ " Queue Behavior with NO QUEUEPOSITION!";
    }
}

function Actor GetDestinationActor()
{
    return QueuePosition;
}

function ChangingDestination(GameCrowdDestination NewDest)
{
    if (QueuePosition == none)
    {
        WarnInternal(string(MyAgent) $ " should never have no QueuePosition");
    }
    MyAgent.StopBehavior();
}

native function bool HandleMovement()
{
}

defaultproperties
{
    bIdleBehavior=True
}
