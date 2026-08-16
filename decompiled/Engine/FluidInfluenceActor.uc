class FluidInfluenceActor extends Actor
    native
    placeable
    hidecategories(Navigation);

var export editinline ArrowComponent FlowDirection;
var export editinline SpriteComponent Sprite;
var() const export editconst editinline FluidInfluenceComponent InfluenceComponent;
var repnotify bool bActive;
var repnotify bool bToggled;

replication
{
    if (bNetDirty)
        bActive, bToggled;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bActive')
    {
        InfluenceComponent.bActive = bActive;
    }
    else if (VarName == 'bToggled')
    {
        InfluenceComponent.bIsToggleTriggered = bToggled;
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        InfluenceComponent.bActive = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        InfluenceComponent.bActive = false;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        InfluenceComponent.bActive = !InfluenceComponent.bActive;
        InfluenceComponent.bIsToggleTriggered = true;
    }
    bActive = InfluenceComponent.bActive;
    bToggled = InfluenceComponent.bIsToggleTriggered;
    bForceNetUpdate = true;
}

defaultproperties
{
    FlowDirection="Default__FluidInfluenceActor.NewArrowComponent"
    Sprite="Default__FluidInfluenceActor.NewSprite"
    InfluenceComponent="Default__FluidInfluenceActor.NewInfluenceComponent"
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__FluidInfluenceActor.NewSprite"
    Components(1)="Default__FluidInfluenceActor.NewArrowComponent"
    Components(2)="Default__FluidInfluenceActor.NewInfluenceComponent"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=0.1
}
