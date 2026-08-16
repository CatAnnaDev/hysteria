class NxForceFieldSpawnable extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var() export editinline NxForceFieldComponent ForceFieldComponent;

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ForceFieldComponent.bForceActive = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        ForceFieldComponent.bForceActive = false;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        ForceFieldComponent.bForceActive = !ForceFieldComponent.bForceActive;
    }
}

defaultproperties
{
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=0.1
}
