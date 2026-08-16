class ActorFactoryRigidBody extends ActorFactoryDynamicSM
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object,Object);

var() bool bStartAwake;
var() bool bDamageAppliesImpulse;
var() bool bLocalSpaceInitialVelocity;
var() bool bEnableStayUprightSpring;
var() Vector InitialVelocity;
var() export editinline DistributionVector AdditionalVelocity;
var() export editinline DistributionVector InitialAngularVelocity;
var() ERBCollisionChannel RBChannel;
var() float StayUprightTorqueFactor;
var() float StayUprightMaxTorque;

defaultproperties
{
    bStartAwake=True
    bDamageAppliesImpulse=True
    RBChannel="RBCC_GameplayPhysics"
    StayUprightTorqueFactor=1000.0
    StayUprightMaxTorque=1500.0
    bNoEncroachCheck=True
    bBlockRigidBody=True
    CollisionType="COLLIDE_BlockAll"
    GameplayActorClass="KActorSpawnable"
    MenuName="Add RigidBody"
    MenuPriority=15
    NewActorClass="KActor"
}
