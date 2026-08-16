class LiftExit extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() LiftCenter MyLiftCenter;
var() bool bExitOnly;

event bool SuggestMovePreparation(Pawn Other)
{
    local Controller C;
    
    if (MyLiftCenter == none || Other.Controller == none)
    {
        return false;
    }
    if (Other.Physics == 4)
    {
        if (Other.AirSpeed > float(0))
        {
            Other.Controller.MoveTimer = 2.0 + VSize(Location - Other.Location) / Other.AirSpeed;
        }
        return false;
    }
    if (Other.Base == MyLiftCenter.Base || Other.ReachedDestination(MyLiftCenter))
    {
        if (CanBeReachedFromLiftBy(Other))
        {
            return false;
        }
        WaitForLift(Other);
        return true;
    }
    else if (MyLiftCenter != none)
    {
        foreach WorldInfo.AllControllers(class'Controller', C)
        {
            if (C.Pawn != none && C.PendingMover == MyLiftCenter.MyLift && WorldInfo.GRI.OnSameTeam(C, Other.Controller) && C.Pawn.ReachedDestination(self))
            {
                WaitForLift(Other);
                return true;
            }
        }
        Other.Controller.ReadyForLift();
    }
    return false;
}

function WaitForLift(Pawn Other)
{
    if (MyLiftCenter != none)
    {
        Other.SetDesiredRotation(rotator(Location - Other.Location));
        Other.Controller.WaitForMover(MyLiftCenter.MyLift);
    }
}

function bool CanBeReachedFromLiftBy(Pawn Other)
{
    return Location.Z < Other.Location.Z + Other.GetCollisionHeight() && Other.LineOfSightTo(self);
}

defaultproperties
{
    bNeverUseStrafing=True
    bForceNoStrafing=True
    bSpecialMove=True
    CylinderComponent="Default__LiftExit.CollisionCylinder"
    GoodSprite="Default__LiftExit.Sprite"
    BadSprite="Default__LiftExit.Sprite2"
    Components(0)="Default__LiftExit.Sprite"
    Components(1)="Default__LiftExit.Sprite2"
    Components(2)="Default__LiftExit.Arrow"
    Components(3)="Default__LiftExit.CollisionCylinder"
    Components(4)="Default__LiftExit.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__LiftExit.CollisionCylinder"
}
