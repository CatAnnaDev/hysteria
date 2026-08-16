class SeqAct_ToggleConstraintDrive extends SequenceAction
    notplaceable
    hidecategories(Object);

var() bool bEnableAngularPositionDrive;
var() bool bEnableAngularVelocityDrive;
var() bool bEnableLinearPositionDrive;
var() bool bEnableLinearvelocityDrive;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Enable Drive",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Disable All Drive",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Toggle Constraint Drive"
    ObjCategory="Physics"
}
