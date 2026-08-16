class AliceGameDeepSeaSnarkPawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameDeepSeaSnarkPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDeepSeaSnarkPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDeepSeaSnarkPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDeepSeaSnarkPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDeepSeaSnarkPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDeepSeaSnarkPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDeepSeaSnarkPawn.Arrow"
    Components(2)="Default__AliceGameDeepSeaSnarkPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDeepSeaSnarkPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDeepSeaSnarkPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDeepSeaSnarkPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDeepSeaSnarkPawn.CollisionCylinder"
}
