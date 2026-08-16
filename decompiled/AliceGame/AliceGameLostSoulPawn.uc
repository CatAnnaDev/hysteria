class AliceGameLostSoulPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=3
    LightEnvironment="Default__AliceGameLostSoulPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameLostSoulPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameLostSoulPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameLostSoulPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameLostSoulPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameLostSoulPawn.CollisionCylinder"
    Components(1)="Default__AliceGameLostSoulPawn.Arrow"
    Components(2)="Default__AliceGameLostSoulPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameLostSoulPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameLostSoulPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameLostSoulPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameLostSoulPawn.CollisionCylinder"
}
