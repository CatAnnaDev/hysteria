class AliceGameDoomTankPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    MagicAcheivmentIdentify=1
    LightEnvironment="Default__AliceGameDoomTankPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDoomTankPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDoomTankPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDoomTankPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDoomTankPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDoomTankPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDoomTankPawn.Arrow"
    Components(2)="Default__AliceGameDoomTankPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDoomTankPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDoomTankPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDoomTankPawn.PawnKynapseHandle"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__AliceGameDoomTankPawn.CollisionCylinder"
}
