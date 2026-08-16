class SeqEvent_Touch extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var(TouchTypes) array<class<Actor>> ClassProximityTypes;
var(TouchTypes) array<class<Actor>> IgnoredClassProximityTypes;
var() bool bForceOverlapping;
var() bool bUseInstigator;
var() bool bAllowDeadPawns;
var array<Actor> TouchedList;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

function NotifyTouchingPawnDied(Pawn P)
{
    if (!bAllowDeadPawns)
    {
        CheckUnTouchActivate(Originator, P);
    }
}

event Toggled()
{
    local int Idx;
    
    if (bEnabled)
    {
        if (Originator != none)
        {
            for (Idx = 0; Idx < Originator.Touching.Length; Idx++)
            {
                CheckTouchActivate(Originator, Originator.Touching[Idx]);
            }
        }
    }
    else
    {
        TouchedList.Length = 0;
    }
}

native final function bool CheckUnTouchActivate(Actor InOriginator, Actor InInstigator, optional bool bTest)
{
    InOriginator;
    InInstigator;
    bTest;
}

native final function bool CheckTouchActivate(Actor InOriginator, Actor InInstigator, optional bool bTest)
{
    InOriginator;
    InInstigator;
    bTest;
}

defaultproperties
{
    ClassProximityTypes(0)="Pawn"
    ClassProximityTypes(1)="ApexDestructibleActor"
    bForceOverlapping=True
    OutputLinks(0)=(Links=(),LinkDesc="Touched",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="UnTouched",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Empty",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Touch"
    ObjCategory="Physics"
}
