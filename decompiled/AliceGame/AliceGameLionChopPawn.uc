class AliceGameLionChopPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameLionChopPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameLionChopPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameLionChopPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameLionChopPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameLionChopPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameLionChopPawn.CollisionCylinder"
    Components(1)="Default__AliceGameLionChopPawn.Arrow"
    Components(2)="Default__AliceGameLionChopPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameLionChopPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameLionChopPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameLionChopPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameLionChopPawn.CollisionCylinder"
}
