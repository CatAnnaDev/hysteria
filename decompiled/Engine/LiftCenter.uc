class LiftCenter extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var InterpActor MyLift;
var float MaxDist2D;
var Vector LiftOffset;
var bool bJumpLift;
var float CollisionHeight;
var() Trigger LiftTrigger;

function bool ProceedWithMove(Pawn Other)
{
    if (Other.Controller == none)
    {
        return false;
    }
    else if (LiftExit(Other.Controller.MoveTarget) != none && Other.ReachedDestination(self))
    {
        return LiftExit(Other.Controller.MoveTarget).CanBeReachedFromLiftBy(Other);
    }
    else if (Location.Z - CollisionHeight < Other.Location.Z - Other.GetCollisionHeight() + Other.MaxStepHeight + 2.0 && Location.Z - CollisionHeight > Other.Location.Z - Other.GetCollisionHeight() - float(1200) && VSize2D(Location - Other.Location) < MaxDist2D || IsZero(MyLift.Velocity) && Other.ValidAnchor() && LiftExit(Other.Anchor) != none)
    {
        return true;
    }
    if (LiftTrigger != none && !LiftTrigger.bRecentlyTriggered && IsZero(MyLift.Velocity))
    {
        Other.SetMoveTarget(LiftTrigger);
        return true;
    }
    return false;
}

event bool SuggestMovePreparation(Pawn Other)
{
    if (Other.Base == MyLift)
    {
        return false;
    }
    if (Base != MyLift || Location != MyLift.Location + LiftOffset)
    {
        SetLocation(MyLift.Location + LiftOffset);
        SetBase(MyLift);
    }
    if (!IsZero(MyLift.Velocity) || !ProceedWithMove(Other))
    {
        Other.Controller.WaitForMover(MyLift);
        return true;
    }
    return false;
}

event Actor SpecialHandling(Pawn Other)
{
    if (MyLift == none || LiftTrigger == none || LiftTrigger.bRecentlyTriggered)
    {
        return self;
    }
    else
    {
        return LiftTrigger;
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (Base == MyLift && MyLift != none)
    {
        LiftOffset = Location - MyLift.Location;
        MyLift.bIsLift = true;
    }
}

defaultproperties
{
    MaxDist2D=400.0
    CollisionHeight=50.0
    bNeverUseStrafing=True
    bForceNoStrafing=True
    bSpecialMove=True
    bNoAutoConnect=True
    ExtraCost=400
    CylinderComponent="Default__LiftCenter.CollisionCylinder"
    GoodSprite="Default__LiftCenter.Sprite"
    BadSprite="Default__LiftCenter.Sprite2"
    bStatic=False
    Components(0)="Default__LiftCenter.Sprite"
    Components(1)="Default__LiftCenter.Sprite2"
    Components(2)="Default__LiftCenter.Arrow"
    Components(3)="Default__LiftCenter.CollisionCylinder"
    Components(4)="Default__LiftCenter.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__LiftCenter.CollisionCylinder"
}
