class ActorFactoryApexClothing extends ActorFactorySkeletalMesh
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object,Object);

var() array<ApexClothingAsset> ClothingAssets;
var() const ERBCollisionChannel ClothingRBChannel;
var() const RBCollisionChannelContainer ClothingRBCollideWithChannels;

defaultproperties
{
    ClothingRBChannel="RBCC_Clothing"
    ClothingRBCollideWithChannels=(Default=True,Nothing=False,Pawn=False,Vehicle=False,Water=False,GameplayPhysics=True,EffectPhysics=True,Untitled1=False,Untitled2=False,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=True,DeadPawn=False,Clothing=False,ClothingCollision=True)
    MenuName="Add Clothing"
}
