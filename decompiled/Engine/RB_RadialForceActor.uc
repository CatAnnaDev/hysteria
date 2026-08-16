class RB_RadialForceActor extends RigidBodyBase
    native
    placeable
    hidecategories(Navigation);

enum ERadialForceType
{
    RFT_Force,
    RFT_Impulse,
};

var export editinline DrawSphereComponent RenderComponent;
var() interp float ForceStrength;
var() interp float ForceRadius;
var() interp float SwirlStrength;
var() interp float SpinTorque;
var() export ERadialImpulseFalloff ForceFalloff;
var() ERadialForceType RadialForceMode;
var() repretry bool bForceActive;
var() bool bForceApplyToCloth;
var() bool bForceApplyToFluid;
var() bool bForceApplyToRigidBodies;
var() bool bForceApplyToProjectiles;
var() const RBCollisionChannelContainer CollideWithChannels;

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

defaultproperties
{
    RenderComponent="Default__RB_RadialForceActor.DrawSphere0"
    ForceStrength=10.0
    ForceRadius=200.0
    bForceApplyToCloth=True
    bForceApplyToFluid=True
    bForceApplyToRigidBodies=True
    CollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=True,GameplayPhysics=True,EffectPhysics=True,Untitled1=True,Untitled2=True,Untitled3=True,Untitled4=True,Cloth=True,FluidDrain=True,SoftBody=False,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__RB_RadialForceActor.DrawSphere0"
    Components(1)="Default__RB_RadialForceActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    NetUpdateFrequency=0.1
}
