class SplineActor extends Actor
    native
    placeable
    hidecategories(Navigation);

struct native SplineConnection
{
    var() export editinline SplineComponent SplineComponent;
    var() SplineActor ConnectTo;
};

var array<SplineConnection> Connections;
var() Vector SplineActorTangent;
var() Color SplineColor;
var() bool bDisableDestination;
var transient bool bAlreadyVisited;
var array<SplineActor> LinksFrom;
var transient SplineActor nextOrdered;
var transient SplineActor prevOrdered;
var transient SplineActor previousPath;
var transient int bestPathWeight;
var transient int visitedWeight;
var() editinline InterpCurveFloat SplineVelocityOverTime;

function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bDisableDestination = false;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bDisableDestination = true;
    }
    else
    {
        bDisableDestination = !bDisableDestination;
    }
    UpdateConnectedSplineComponents(true);
}

native function GetAllConnectedSplineActors(out array<SplineActor> OutSet)
{
    OutSet;
}

native function bool FindSplinePathTo(SplineActor Goal, out array<SplineActor> OutRoute)
{
    Goal;
    OutRoute;
}

native function SplineActor GetBestConnectionInDirection(Vector DesiredDir, optional bool bUseLinksFrom)
{
    DesiredDir;
    bUseLinksFrom;
}

native function SplineActor GetRandomConnection(optional bool bUseLinksFrom)
{
    bUseLinksFrom;
}

native function BreakAllConnectionsFrom()
{
}

native function BreakAllConnections()
{
}

native function BreakConnectionTo(SplineActor NextActor)
{
    NextActor;
}

native function SplineActor FindTargetForComponent(SplineComponent SplineComp)
{
    SplineComp;
}

native function SplineComponent FindSplineComponentTo(SplineActor NextActor)
{
    NextActor;
}

native function bool IsConnectedTo(SplineActor NextActor, bool bCheckForDisableDestination)
{
    NextActor;
    bCheckForDisableDestination;
}

native function AddConnectionTo(SplineActor NextActor)
{
    NextActor;
}

native function UpdateConnectedSplineComponents(bool bFinish)
{
    bFinish;
}

native function UpdateSplineComponents(bool bFinish)
{
    bFinish;
}

native function Vector GetWorldSpaceTangent()
{
}

defaultproperties
{
    SplineActorTangent=(X=300.0,Y=0.0,Z=0.0)
    SplineColor=(B=255,G=0,R=255,A=255)
    Components(0)="Default__SplineActor.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
