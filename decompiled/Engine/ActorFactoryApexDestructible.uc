class ActorFactoryApexDestructible extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() bool bStartAwake;
var() ERBCollisionChannel RBChannel;
var(Physics) byte RBDominanceGroup;
var() const RBCollisionChannelContainer CollideWithChannels;
var() ApexDestructibleAsset DestructibleAsset;
var() LightingChannelContainer LightingChannels;

defaultproperties
{
    RBChannel="RBCC_EffectPhysics"
    RBDominanceGroup=15
    CollideWithChannels=(Default=True,Nothing=False,Pawn=False,Vehicle=False,Water=False,GameplayPhysics=True,EffectPhysics=True,Untitled1=False,Untitled2=False,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=True,DeadPawn=False,Clothing=False,ClothingCollision=False)
    LightingChannels=(bInitialized=False,BSP=False,Static=False,Dynamic=False,CompositeDynamic=False,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,PhysXLighting_1=True,PhysXLighting_2=True,PhysXLighting_3=True,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=False)
    GameplayActorClass="ApexDestructibleActorSpawnable"
    MenuName="Add ApexDestructibleActor"
    NewActorClass="ApexDestructibleActor"
}
