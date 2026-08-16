class RB_ConstraintActor extends RigidBodyBase
    abstract
    native
    placeable
    hidecategories(Navigation);

var() Actor ConstraintActor1;
var() Actor ConstraintActor2;
var() export editinline noclear RB_ConstraintSetup ConstraintSetup;
var() export editinline noclear RB_ConstraintInstance ConstraintInstance;
var() const bool bDisableCollision;
var() bool bUpdateActor1RefFrame;
var() bool bUpdateActor2RefFrame;
var(Pulley) Actor PulleyPivotActor1;
var(Pulley) Actor PulleyPivotActor2;

simulated function OnToggleConstraintDrive(SeqAct_ToggleConstraintDrive Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (Action.bEnableLinearPositionDrive)
        {
            ConstraintInstance.SetLinearPositionDrive(true, true, true);
        }
        if (Action.bEnableLinearvelocityDrive)
        {
            ConstraintInstance.SetLinearVelocityDrive(true, true, true);
        }
        if (Action.bEnableAngularPositionDrive)
        {
            ConstraintInstance.SetAngularPositionDrive(true, true);
        }
        if (Action.bEnableAngularVelocityDrive)
        {
            ConstraintInstance.SetAngularVelocityDrive(true, true);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ConstraintInstance.SetLinearPositionDrive(false, false, false);
        ConstraintInstance.SetLinearVelocityDrive(false, false, false);
        ConstraintInstance.SetAngularPositionDrive(false, false);
        ConstraintInstance.SetAngularVelocityDrive(false, false);
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (Physics != 10)
        {
            SetPhysics(10);
            InitConstraint(ConstraintActor1, ConstraintActor2, ConstraintSetup.ConstraintBone1, ConstraintSetup.ConstraintBone2);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (Physics != 0)
        {
            SetPhysics(0);
            TermConstraint();
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (Physics != 0)
        {
            SetPhysics(0);
            TermConstraint();
        }
        else
        {
            SetPhysics(10);
            InitConstraint(ConstraintActor1, ConstraintActor2, ConstraintSetup.ConstraintBone1, ConstraintSetup.ConstraintBone2);
        }
    }
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
    TermConstraint();
}

native final function TermConstraint()
{
}

native final function InitConstraint(Actor Actor1, Actor Actor2, optional name Actor1Bone, optional name Actor2Bone, optional float BreakThreshold)
{
    Actor1;
    Actor2;
    Actor1Bone;
    Actor2Bone;
    BreakThreshold;
}

native final function SetDisableCollision(bool NewDisableCollision)
{
    NewDisableCollision;
}

defaultproperties
{
    ConstraintInstance="Default__RB_ConstraintActor.MyConstraintInstance"
    bUpdateActor1RefFrame=True
    bUpdateActor2RefFrame=True
    bHidden=True
    bNoDelete=True
    bEdShouldSnap=True
    Components(0)="Default__RB_ConstraintActor.Sprite"
    Components(1)="Default__RB_ConstraintActor.MyConDrawComponent"
    DrawScale=0.5
    Physics="PHYS_RigidBody"
    TickGroup="TG_PostAsyncWork"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_ConstraintBroken"
}
