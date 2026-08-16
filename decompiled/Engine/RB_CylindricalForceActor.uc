class RB_CylindricalForceActor extends RigidBodyBase
    native
    placeable
    hidecategories(Navigation);

var() export editinline DrawCylinderComponent RenderComponent;
var() interp float RadialStrength;
var() interp float RotationalStrength;
var() interp float LiftStrength;
var() interp float LiftFalloffHeight;
var() interp float EscapeVelocity;
var() interp float ForceRadius;
var() interp float ForceTopRadius;
var() interp float ForceHeight;
var() interp float HeightOffset;
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
    SetForcedInitialReplicatedProperty(BoolProperty'RB_CylindricalForceActor.bForceActive', bForceActive == default.bForceActive);
}

defaultproperties
{
    RenderComponent="Default__RB_CylindricalForceActor.DrawCylinder0"
    EscapeVelocity=10000.0
    ForceRadius=200.0
    ForceTopRadius=200.0
    ForceHeight=200.0
    bForceApplyToCloth=True
    bForceApplyToFluid=True
    bForceApplyToRigidBodies=True
    CollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=True,GameplayPhysics=True,EffectPhysics=True,Untitled1=True,Untitled2=True,Untitled3=True,Untitled4=False,Cloth=True,FluidDrain=True,SoftBody=False,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__RB_CylindricalForceActor.DrawCylinder0"
    Components(1)="Default__RB_CylindricalForceActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    NetUpdateFrequency=0.1
}
