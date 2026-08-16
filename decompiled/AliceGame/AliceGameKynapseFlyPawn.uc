class AliceGameKynapseFlyPawn extends AliceGameKynapsePawn
    notplaceable
    config(Game)
    hidecategories(Navigation);

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector Dir;
    
    Dir = Normal(WorldInfo.GetLocalPlayerPawn().Location - Location);
    return rotator(Dir);
}

function PostBeginPlay()
{
    PostBeginPlay();
    SetMovementPhysics();
    if (bCanFly == true)
    {
        SetPhysics(4);
    }
}

defaultproperties
{
    LightEnvironment="Default__AliceGameKynapseFlyPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameKynapseFlyPawn.PawnKynapseHandle"
    bCanFly=True
    BasicFlyHeight=600.0
    FlyOffsetRange=200.0
    Mesh="Default__AliceGameKynapseFlyPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameKynapseFlyPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameKynapseFlyPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameKynapseFlyPawn.CollisionCylinder"
    Components(1)="Default__AliceGameKynapseFlyPawn.Arrow"
    Components(2)="Default__AliceGameKynapseFlyPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameKynapseFlyPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameKynapseFlyPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameKynapseFlyPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameKynapseFlyPawn.CollisionCylinder"
}
