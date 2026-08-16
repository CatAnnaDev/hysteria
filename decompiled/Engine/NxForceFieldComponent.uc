class NxForceFieldComponent extends PrimitiveComponent
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Collision,Lighting,Physics,Rendering,Object);

var() editinline ForceFieldShape Shape;
var export editinline ActorComponent DrawComponent;
var() int ExcludeChannel;
var() bool bForceActive;
var() bool bDestroyWhenInactive;
var() const RBCollisionChannelContainer CollideWithChannels;
var() float Duration;
var const native transient Pointer ForceField;
var const native transient array<Pointer> ConvexMeshes;
var const native transient array<Pointer> ExclusionShapes;
var const native transient array<Pointer> ExclusionShapePoses;
var native Pointer RBPhysScene;
var const native int SceneIndex;
var float ElapsedTime;
var export editinline PrimitiveComponent RenderComponent;

native function DoInitRBPhys()
{
}

defaultproperties
{
    bForceActive=True
    bDestroyWhenInactive=True
    CollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=True,GameplayPhysics=True,EffectPhysics=True,Untitled1=True,Untitled2=True,Untitled3=True,Untitled4=False,Cloth=True,FluidDrain=True,SoftBody=False,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    ReplacementPrimitive="None"
    RBChannel="RBCC_Nothing"
    TickGroup="TG_PreAsyncWork"
}
