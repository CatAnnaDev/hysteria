class RB_RadialImpulseActor extends RigidBodyBase
    native
    placeable
    hidecategories(Navigation);

var export editinline DrawSphereComponent RenderComponent;
var() const export editconst editinline RB_RadialImpulseComponent ImpulseComponent;
var repnotify byte ImpulseCount;

replication
{
    if (bNetDirty)
        ImpulseCount;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ImpulseCount')
    {
        ImpulseComponent.FireImpulse(Location);
    }
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ImpulseComponent.FireImpulse(Location);
        ImpulseCount++;
        bForceNetUpdate = true;
    }
}

defaultproperties
{
    RenderComponent="Default__RB_RadialImpulseActor.DrawSphere0"
    ImpulseComponent="Default__RB_RadialImpulseActor.ImpulseComponent0"
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    bEdShouldSnap=True
    Components(0)="Default__RB_RadialImpulseActor.DrawSphere0"
    Components(1)="Default__RB_RadialImpulseActor.ImpulseComponent0"
    Components(2)="Default__RB_RadialImpulseActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    NetUpdateFrequency=0.1
}
