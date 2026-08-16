class GameCrowdBehavior_RunFromPanic extends GameCrowdAgentBehavior
    native
    placeable;

var Actor PanicFocus;

function string GetBehaviorString()
{
    return "Run from PANIC " @ string(PanicFocus);
}

function bool AllowBehaviorAt(GameCrowdDestination Destination)
{
    return !Destination.bSkipBehaviorIfPanicked && !Destination.bAvoidWhenPanicked;
}

function bool AllowThisDestination(GameCrowdDestination Destination)
{
    return !Destination.bAvoidWhenPanicked && !Destination.AtCapacity() && Destination.bFleeDestination || PanicFocus == none || (Destination.Location - MyAgent.Location) Dot (MyAgent.Location - PanicFocus.Location) > 0.0;
}

event PropagateViralBehaviorTo(GameCrowdAgent OtherAgent)
{
    if (!OtherAgent.IsPanicked())
    {
        OtherAgent.SetPanic(PanicFocus, true);
    }
}

function StopBehavior()
{
    StopBehavior();
    MyAgent.bIsPanicked = false;
    MyAgent.SetMaxSpeed();
}

function InitBehavior(GameCrowdAgent Agent)
{
    InitBehavior(Agent);
    MyAgent.bIsPanicked = true;
    MyAgent.SetMaxSpeed();
}

function ActivatedBy(Actor NewActionTarget)
{
    local GameCrowdDestination TempDest, PrevDest;
    
    PanicFocus = NewActionTarget;
    PrevDest = MyAgent.PreviousDestination;
    if (MyAgent.CurrentDestination != none && AllowThisDestination(MyAgent.CurrentDestination))
    {
        return;
    }
    else if (PrevDest != none && PrevDest.AllowableDestinationFor(MyAgent))
    {
        TempDest = MyAgent.CurrentDestination;
        MyAgent.CurrentDestination.DecrementCustomerCount(MyAgent);
        MyAgent.SetCurrentDestination(MyAgent.PreviousDestination);
        MyAgent.PreviousDestination = TempDest;
        MyAgent.UpdateIntermediatePoint();
    }
}

defaultproperties
{
    bIsViralBehavior=True
    bIsPanicked=True
    MaxPlayerDistance=20000.0
}
