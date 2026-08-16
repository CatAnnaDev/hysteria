class AliceGameEmpressWaspWalkingBossPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameEmpressWaspWalkingBossPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameEmpressWaspWalkingBossPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameEmpressWaspWalkingBossPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameEmpressWaspWalkingBossPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameEmpressWaspWalkingBossPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameEmpressWaspWalkingBossPawn.CollisionCylinder"
    Components(1)="Default__AliceGameEmpressWaspWalkingBossPawn.Arrow"
    Components(2)="Default__AliceGameEmpressWaspWalkingBossPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameEmpressWaspWalkingBossPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameEmpressWaspWalkingBossPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameEmpressWaspWalkingBossPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameEmpressWaspWalkingBossPawn.CollisionCylinder"
}
