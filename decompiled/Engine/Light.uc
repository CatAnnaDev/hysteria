class Light extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var() const export editconst editinline LightComponent LightComponent;
var repnotify bool bEnabled;

replication
{
    if (Role == 3)
        bEnabled;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (!bStatic)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            LightComponent.SetEnabled(true);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            LightComponent.SetEnabled(false);
        }
        else if (Action.InputLinks[2].bHasImpulse)
        {
            LightComponent.SetEnabled(!LightComponent.bEnabled);
        }
        bEnabled = LightComponent.bEnabled;
        ForceNetRelevant();
        SetForcedInitialReplicatedProperty(BoolProperty'Light.bEnabled', bEnabled == default.bEnabled);
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bEnabled')
    {
        LightComponent.SetEnabled(bEnabled);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

defaultproperties
{
    bStatic=True
    bHidden=True
    bNoDelete=True
    bRouteBeginPlayEvenIfStatic=False
    bMovable=False
    Components(0)="Default__Light.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
