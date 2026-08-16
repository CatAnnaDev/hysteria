class AliceGameSamuraiWaspPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=8
    LightEnvironment="Default__AliceGameSamuraiWaspPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameSamuraiWaspPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameSamuraiWaspPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameSamuraiWaspPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameSamuraiWaspPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameSamuraiWaspPawn.CollisionCylinder"
    Components(1)="Default__AliceGameSamuraiWaspPawn.Arrow"
    Components(2)="Default__AliceGameSamuraiWaspPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameSamuraiWaspPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameSamuraiWaspPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameSamuraiWaspPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameSamuraiWaspPawn.CollisionCylinder"
}
