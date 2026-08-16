class SeqAct_ToggleCinematicMode extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bDisableMovement;
var() bool bDisableTurning;
var() bool bHidePlayer;
var() bool bDisableInput;
var() bool bHideHUD;
var() bool bDeadBodies;
var() bool bDroppedPickups;
var() bool bHideCurrentWeapon;
var() bool bFreezeNPCs;
var() bool bPauseClockBomb;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

event Activated()
{
    local Actor A;
    
    foreach GetWorldInfo().DynamicActors(class'Actor', A)
    {
        if (bDeadBodies && A.IsA('GamePawn') && A.bTearOff || bDroppedPickups && A.IsA('DroppedPickup'))
        {
            A.Destroy();
        }
    }
}

defaultproperties
{
    bDisableMovement=True
    bDisableTurning=True
    bHidePlayer=True
    bDisableInput=True
    bDeadBodies=True
    bDroppedPickups=True
    bHideCurrentWeapon=True
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Disable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Toggle",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="ExceptNPCs",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Toggle Cinematic Mode"
    ObjCategory="Toggle"
}
