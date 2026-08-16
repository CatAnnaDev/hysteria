class DoorMarker extends SphinxPathObject
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

enum EDoorType
{
    DOOR_Shoot,
    DOOR_Touch,
};

var() InterpActor MyDoor;
var() InterpActor MyDoor2;
var() const editconst Trigger frontDoorTrigger;
var() const editconst Trigger backDoorTrigger;
var() EDoorType DoorType;
var() Actor DoorTrigger;
var() bool bWaitUntilCompletelyOpened;
var() bool bInitiallyClosed;
var() bool bBlockedWhenClosed;
var bool bDoorOpen;
var const transient bool bTempDisabledCollision;

event bool SuggestMovePreparation(Pawn Other)
{
    if (bDoorOpen || MyDoor == none)
    {
        return false;
    }
    Other.Controller.WaitForMover(MyDoor);
    return true;
}

function bool ProceedWithMove(Pawn Other)
{
    if (bDoorOpen)
    {
        return true;
    }
    return false;
}

event Actor SpecialHandling(Pawn Other)
{
    local Actor TouchActor;
    
    if (bDoorOpen || MyDoor == none || bInitiallyClosed == (bDoorOpen || VSizeSq(MyDoor.Velocity) > 1.0))
    {
        return self;
    }
    else if (DoorType == 1)
    {
        if (DoorTrigger == none)
        {
            return MyDoor;
        }
        else
        {
            TouchActor = DoorTrigger.SpecialHandling(Other);
            if (TouchActor == none)
            {
                TouchActor = DoorTrigger;
            }
            return TouchActor;
        }
    }
    else
    {
        return self;
    }
}

function MoverClosed()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    WorldInfo.Game.NotifyNavigationChanged(self);
}

function MoverOpened()
{
    bBlocked = !bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = bInitiallyClosed;
    WorldInfo.Game.NotifyNavigationChanged(self);
}

event PostBeginPlay()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    PostBeginPlay();
}

defaultproperties
{
    bInitiallyClosed=True
    bSpecialMove=True
    ExtraCost=100
    CylinderComponent="Default__DoorMarker.CollisionCylinder"
    GoodSprite="Default__DoorMarker.Sprite"
    BadSprite="Default__DoorMarker.Sprite2"
    Components(0)="Default__DoorMarker.Sprite"
    Components(1)="Default__DoorMarker.Sprite2"
    Components(2)="Default__DoorMarker.Arrow"
    Components(3)="Default__DoorMarker.CollisionCylinder"
    Components(4)="Default__DoorMarker.PathRenderer"
    CollisionComponent="Default__DoorMarker.CollisionCylinder"
}
