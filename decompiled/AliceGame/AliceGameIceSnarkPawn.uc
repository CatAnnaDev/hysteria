class AliceGameIceSnarkPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameIceSnarkPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameIceSnarkPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameIceSnarkPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameIceSnarkPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameIceSnarkPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameIceSnarkPawn.CollisionCylinder"
    Components(1)="Default__AliceGameIceSnarkPawn.Arrow"
    Components(2)="Default__AliceGameIceSnarkPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameIceSnarkPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameIceSnarkPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameIceSnarkPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameIceSnarkPawn.CollisionCylinder"
}
