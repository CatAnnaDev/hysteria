class GameCrowdDestinationQueuePoint extends GameCrowdInteractionPoint
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

var() GameCrowdDestinationQueuePoint NextQueuePosition;
var GameCrowdInteractionPoint PreviousQueuePosition;
var GameCrowdAgent QueuedAgent;
var transient GameCrowdDestination QueueDestination;
var bool bClearingQueue;
var bool bPendingAdvance;
var() float AverageReactionTime;
var class<GameCrowdBehavior_WaitInQueue> QueueBehaviorClass;

simulated function bool HasCustomer()
{
    return QueuedAgent != none;
}

simulated function ClearQueue(GameCrowdAgent OldCustomer)
{
    if (!bClearingQueue)
    {
        bClearingQueue = true;
        if (OldCustomer == QueuedAgent)
        {
            QueuedAgent.StopBehavior();
            QueuedAgent = none;
            if (NextQueuePosition != none)
            {
                NextQueuePosition.AdvanceCustomerTo(self);
            }
        }
        else
        {
            WarnInternal("Attempted to clear " $ string(OldCustomer) $ " from queue position with customer " $ string(QueuedAgent));
        }
        bClearingQueue = false;
    }
}

simulated function AddCustomer(GameCrowdAgent NewCustomer, GameCrowdInteractionPoint PreviousPosition)
{
    if (PreviousPosition != none)
    {
        PreviousQueuePosition = PreviousPosition;
    }
    if (QueuedAgent == none)
    {
        QueuedAgent = NewCustomer;
        NewCustomer.ActivateInstancedBehavior(new(NewCustomer) QueueBehaviorClass);
        GameCrowdBehavior_WaitInQueue(NewCustomer.CurrentBehavior).QueuePosition = self;
        GameCrowdBehavior_WaitInQueue(NewCustomer.CurrentBehavior).ActionTarget = PreviousQueuePosition;
    }
    else if (NextQueuePosition != none)
    {
        NextQueuePosition.AddCustomer(NewCustomer, self);
    }
    else
    {
        WarnInternal(string(self) $ " Attempted to add customer " $ string(NewCustomer) $ " beyond end of queue");
    }
}

private final simulated function ActuallyAdvance()
{
    local GameCrowdDestinationQueuePoint FrontQueuePosition;
    local GameCrowdDestination QueueFront;
    local GameCrowdAgent TempAgent;
    
    bPendingAdvance = false;
    if (QueuedAgent != none)
    {
        TempAgent = QueuedAgent;
        bClearingQueue = true;
        QueuedAgent.StopBehavior();
        bClearingQueue = false;
        QueuedAgent = none;
        FrontQueuePosition = GameCrowdDestinationQueuePoint(PreviousQueuePosition);
        if (FrontQueuePosition != none)
        {
            FrontQueuePosition.AddCustomer(TempAgent, none);
        }
        else
        {
            QueueFront = GameCrowdDestination(PreviousQueuePosition);
            if (QueueFront == none)
            {
                WarnInternal("Illegal front position for queue " $ string(self));
                return;
            }
            QueueFront.IncrementCustomerCount(TempAgent);
        }
        if (QueuedAgent != none)
        {
            WarnInternal(string(self) $ " GOT QUEUED AGENT BACK - Head " $ string(PreviousQueuePosition) $ " Tail " $ string(NextQueuePosition));
        }
        else if (NextQueuePosition != none)
        {
            NextQueuePosition.AdvanceCustomerTo(self);
        }
    }
}

simulated function AdvanceCustomerTo(GameCrowdInteractionPoint FrontPosition)
{
    PreviousQueuePosition = FrontPosition;
    bPendingAdvance = true;
    SetTimer(AverageReactionTime, false, 'ActuallyAdvance');
}

simulated event ReachedDestination(GameCrowdAgent Agent)
{
    local GameCrowdDestinationQueuePoint QueuePoint;
    
    QueuePoint = Agent.CurrentDestination.QueueHead;
    while (QueuePoint != none)
    {
        if (QueuePoint.NextQueuePosition == self)
        {
            if (QueuePoint.QueuedAgent == none)
            {
                WarnInternal(string(Agent) $ "in queue behind empty spot at " $ string(self));
            }
            else if (!QueuePoint.QueueReachedBy(QueuePoint.QueuedAgent, QueuePoint.QueuedAgent.Location) && VSizeSq(QueuePoint.Location - Agent.Location) < VSizeSq(QueuePoint.Location - QueuePoint.QueuedAgent.Location))
            {
                QueuedAgent = QueuePoint.QueuedAgent;
                QueuePoint.QueuedAgent = Agent;
                GameCrowdBehavior_WaitInQueue(QueuedAgent.CurrentBehavior).QueuePosition = self;
                GameCrowdBehavior_WaitInQueue(QueuePoint.QueuedAgent.CurrentBehavior).QueuePosition = QueuePoint;
                return;
            }
        }
        QueuePoint = QueuePoint.NextQueuePosition;
    }
    GameCrowdBehavior_WaitInQueue(QueuedAgent.CurrentBehavior).bIdleBehavior = true;
    QueuedAgent.PlayIdleAnimation();
}

simulated function bool HasSpace()
{
    if (QueuedAgent == none && NextQueuePosition == none || !NextQueuePosition.bPendingAdvance || NextQueuePosition.QueuedAgent == none)
    {
        return true;
    }
    if (NextQueuePosition == none)
    {
        return false;
    }
    return NextQueuePosition.HasSpace();
}

native function bool QueueReachedBy(GameCrowdAgent Agent, Vector TestPosition)
{
    Agent;
    TestPosition;
}

defaultproperties
{
    AverageReactionTime=0.7
    QueueBehaviorClass="GameCrowdBehavior_WaitInQueue"
    CylinderComponent="Default__GameCrowdDestinationQueuePoint.CollisionCylinder"
    Components(0)="Default__GameCrowdDestinationQueuePoint.CollisionCylinder"
    Components(1)="Default__GameCrowdDestinationQueuePoint.Sprite"
    CollisionComponent="Default__GameCrowdDestinationQueuePoint.CollisionCylinder"
}
