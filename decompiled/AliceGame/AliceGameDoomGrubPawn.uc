class AliceGameDoomGrubPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=1
    LightEnvironment="Default__AliceGameDoomGrubPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDoomGrubPawn.PawnKynapseHandle"
    MaxStepHeight=15.0
    Mesh="Default__AliceGameDoomGrubPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDoomGrubPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDoomGrubPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDoomGrubPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDoomGrubPawn.Arrow"
    Components(2)="Default__AliceGameDoomGrubPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDoomGrubPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDoomGrubPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDoomGrubPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDoomGrubPawn.CollisionCylinder"
}
