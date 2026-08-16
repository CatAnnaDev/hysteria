class BlockingVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() bool bBlockCamera;
var() bool bBlockCameraOnly;
var() bool bBlockNPCOnly;
var() bool bBlockingDesiredNPC;
var() bool bBlockNPCExtent;

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(false);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(!CollisionComponent.BlockRigidBody);
    }
    OnToggle(Action);
}

defaultproperties
{
    bBlockCamera=True
    BrushComponent="Default__BlockingVolume.BrushComponent0"
    bWorldGeometry=True
    bBlockActors=True
    Components(0)="Default__BlockingVolume.BrushComponent0"
    CollisionComponent="Default__BlockingVolume.BrushComponent0"
}
