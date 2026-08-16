class TriggeredPath extends NavigationPoint
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() bool bOpen;
var() Actor MyTrigger;

event bool SuggestMovePreparation(Pawn Other)
{
    if (bOpen)
    {
        return false;
    }
    else if (MyTrigger != none && Other.Controller.ActorReachable(MyTrigger))
    {
        if (Other.Controller.Focus == Other.Controller.MoveTarget)
        {
            Other.Controller.Focus = MyTrigger;
        }
        Other.Controller.MoveTarget = MyTrigger;
        Other.Controller.CurrentPath = none;
        Other.Controller.NextRoutePath = none;
        return false;
    }
    else
    {
        Other.Controller.MoveTimer = 1.0;
        Other.Controller.bPreparingMove = true;
        Other.Velocity = vect(0.0, 0.0, 0.0);
        Other.Acceleration = vect(0.0, 0.0, 0.0);
        return true;
    }
}

event Actor SpecialHandling(Pawn Other)
{
    local Actor TouchActor;
    
    if (bOpen || MyTrigger == none)
    {
        return self;
    }
    else
    {
        TouchActor = MyTrigger.SpecialHandling(Other);
        if (TouchActor == none)
        {
            TouchActor = MyTrigger;
        }
        return TouchActor;
    }
}

function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bOpen = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bOpen = false;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bOpen = !bOpen;
    }
    WorldInfo.Game.NotifyNavigationChanged(self);
}

defaultproperties
{
    bSpecialMove=True
    ExtraCost=100
    CylinderComponent="Default__TriggeredPath.CollisionCylinder"
    GoodSprite="Default__TriggeredPath.Sprite"
    BadSprite="Default__TriggeredPath.Sprite2"
    Components(0)="Default__TriggeredPath.Sprite"
    Components(1)="Default__TriggeredPath.Sprite2"
    Components(2)="Default__TriggeredPath.Arrow"
    Components(3)="Default__TriggeredPath.CollisionCylinder"
    Components(4)="Default__TriggeredPath.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__TriggeredPath.CollisionCylinder"
}
