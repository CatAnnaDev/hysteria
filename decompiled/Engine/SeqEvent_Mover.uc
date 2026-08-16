class SeqEvent_Mover extends SequenceEvent
    native
    notplaceable
    hidecategories(Object,SequenceEvent);

var() float StayOpenTime;

function NotifyFinishedOpen()
{
    local array<int> ActivateIndices;
    
    ActivateIndices[0] = 2;
    CheckActivate(Originator, Instigator, false, ActivateIndices);
}

function NotifyDetached(Actor Other)
{
    local Pawn P;
    local array<int> ActivateIndices;
    
    if (Originator == none)
    {
        WarnInternal("Originator mover missing");
    }
    else if (Pawn(Other) != none)
    {
        foreach Originator.BasedActors(class'Pawn', P)
        {
            return;
        }
        ActivateIndices[0] = 1;
        CheckActivate(Originator, Instigator, false, ActivateIndices);
    }
}

function NotifyAttached(Actor Other)
{
    local array<int> ActivateIndices;
    
    if (Pawn(Other) != none && IsZero(Originator.Velocity))
    {
        ActivateIndices[0] = 0;
        CheckActivate(Originator, Other, false, ActivateIndices);
    }
}

function NotifyEncroachingOn(Actor Hit)
{
    local SeqVar_Object ObjVar;
    local array<int> ActivateIndices;
    
    ActivateIndices[0] = 3;
    if (CheckActivate(Originator, Instigator, false, ActivateIndices, true))
    {
        foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Actor Hit")
        {
            ObjVar.SetObjectValue(Hit);
        }
    }
}

event RegisterEvent()
{
    local InterpActor Mover;
    
    Mover = InterpActor(Originator);
    if (Mover != none)
    {
        Mover.StayOpenTime = StayOpenTime;
    }
}

defaultproperties
{
    StayOpenTime=1.5
    MaxTriggerCount=0
    bPlayerOnly=False
    OutputLinks(0)=(Links=(),LinkDesc="Pawn Attached",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Pawn Detached",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Open Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(3)=(Links=(),LinkDesc="Hit Actor",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Actor Hit",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Mover"
    ObjCategory="Physics"
}
