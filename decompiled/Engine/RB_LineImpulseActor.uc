class RB_LineImpulseActor extends RigidBodyBase
    native
    placeable
    hidecategories(Navigation);

var() float ImpulseStrength;
var() float ImpulseRange;
var() bool bVelChange;
var() bool bStopAtFirstHit;
var() bool bCauseFracture;
var export editinline ArrowComponent Arrow;
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
        FireLineImpulse();
    }
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        FireLineImpulse();
        ImpulseCount++;
        bForceNetUpdate = true;
    }
}

native final function FireLineImpulse()
{
}

defaultproperties
{
    ImpulseStrength=900.0
    ImpulseRange=200.0
    Arrow="Default__RB_LineImpulseActor.ArrowComponent0"
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    bEdShouldSnap=True
    Components(0)="Default__RB_LineImpulseActor.ArrowComponent0"
    Components(1)="Default__RB_LineImpulseActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    NetUpdateFrequency=0.1
}
