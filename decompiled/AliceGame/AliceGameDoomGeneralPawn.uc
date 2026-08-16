class AliceGameDoomGeneralPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=1
    LightEnvironment="Default__AliceGameDoomGeneralPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDoomGeneralPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDoomGeneralPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDoomGeneralPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDoomGeneralPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDoomGeneralPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDoomGeneralPawn.Arrow"
    Components(2)="Default__AliceGameDoomGeneralPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDoomGeneralPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDoomGeneralPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDoomGeneralPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDoomGeneralPawn.CollisionCylinder"
}
