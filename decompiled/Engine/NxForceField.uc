class NxForceField extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() int ExcludeChannel;
var() repretry bool bForceActive;
var() const RBCollisionChannelContainer CollideWithChannels;
var() const ERBCollisionChannel RBChannel;
var const native transient Pointer ForceField;
var const native transient array<Pointer> ConvexMeshes;
var const native transient array<Pointer> ExclusionShapes;
var const native transient array<Pointer> ExclusionShapePoses;
var const native transient Pointer U2NRotation;
var const native int SceneIndex;

replication
{
    if (bNetDirty)
        bForceActive;
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bForceActive = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bForceActive = false;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bForceActive = !bForceActive;
    }
    SetForcedInitialReplicatedProperty(BoolProperty'RB_RadialForceActor.bForceActive', bForceActive == default.bForceActive);
}

native function DoInitRBPhys()
{
}

defaultproperties
{
    bForceActive=True
    CollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=True,GameplayPhysics=True,EffectPhysics=True,Untitled1=True,Untitled2=True,Untitled3=True,Untitled4=False,Cloth=True,FluidDrain=True,SoftBody=True,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    RBChannel="RBCC_Nothing"
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=0.1
}
