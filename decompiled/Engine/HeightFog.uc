class HeightFog extends Info
    placeable
    hidecategories(Navigation,Collision);

var() const export editconst editinline HeightFogComponent Component;
var repnotify bool bEnabled;

replication
{
    if (Role == 3)
        bEnabled;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        Component.SetEnabled(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        Component.SetEnabled(false);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        Component.SetEnabled(!Component.bEnabled);
    }
    bEnabled = Component.bEnabled;
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'HeightFog.bEnabled', bEnabled == default.bEnabled);
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bEnabled')
    {
        Component.SetEnabled(bEnabled);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    bEnabled = Component.bEnabled;
}

defaultproperties
{
    Component="Default__HeightFog.HeightFogComponent0"
    bNoDelete=True
    Components(0)="Default__HeightFog.Sprite"
    Components(1)="Default__HeightFog.HeightFogComponent0"
    TickGroup="TG_DuringAsyncWork"
}
