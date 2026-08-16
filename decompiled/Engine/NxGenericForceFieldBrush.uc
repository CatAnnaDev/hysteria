class NxGenericForceFieldBrush extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

enum FFB_ForceFieldCoordinates
{
    FFB_CARTESIAN,
    FFB_SPHERICAL,
    FFB_CYLINDRICAL,
    FFB_TOROIDAL,
};

var() int ExcludeChannel;
var() RBCollisionChannelContainer CollideWithChannels;
var() const ERBCollisionChannel RBChannel;
var() FFB_ForceFieldCoordinates Coordinates;
var() Vector Constant;
var() Vector PositionMultiplierX;
var() Vector PositionMultiplierY;
var() Vector PositionMultiplierZ;
var() Vector PositionTarget;
var() Vector VelocityMultiplierX;
var() Vector VelocityMultiplierY;
var() Vector VelocityMultiplierZ;
var() Vector VelocityTarget;
var() Vector Noise;
var() Vector FalloffLinear;
var() Vector FalloffQuadratic;
var() float TorusRadius;
var const native transient Pointer ForceField;
var const native transient array<Pointer> ConvexMeshes;
var const native transient array<Pointer> ExclusionShapes;
var const native transient array<Pointer> ExclusionShapePoses;
var const native transient Pointer LinearKernel;

simulated function bool StopsProjectile(Projectile P)
{
    return false;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (BrushComponent != none)
    {
        bProjTarget = BrushComponent.BlockZeroExtent;
    }
}

defaultproperties
{
    ExcludeChannel=1
    CollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=True,GameplayPhysics=True,EffectPhysics=True,Untitled1=True,Untitled2=True,Untitled3=True,Untitled4=False,Cloth=True,FluidDrain=True,SoftBody=True,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
    RBChannel="RBCC_Untitled1"
    TorusRadius=1.0
    BrushColor=(B=100,G=255,R=100,A=255)
    bColored=True
    BrushComponent="Default__NxGenericForceFieldBrush.BrushComponent0"
    bStatic=False
    bProjTarget=True
    Components(0)="Default__NxGenericForceFieldBrush.BrushComponent0"
    CollisionComponent="Default__NxGenericForceFieldBrush.BrushComponent0"
}
