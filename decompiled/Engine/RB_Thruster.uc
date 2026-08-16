class RB_Thruster extends RigidBodyBase
    native
    placeable
    hidecategories(Navigation);

var() bool bThrustEnabled;
var() interp float ThrustStrength;

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bThrustEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bThrustEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bThrustEnabled = !bThrustEnabled;
    }
}

defaultproperties
{
    ThrustStrength=100.0
    bHardAttach=True
    bEdShouldSnap=True
    Components(0)="Default__RB_Thruster.ArrowComponent0"
    Components(1)="Default__RB_Thruster.Sprite"
}
