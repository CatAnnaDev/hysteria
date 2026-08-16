class AliceGameQCannonPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameQCannonPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameQCannonPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameQCannonPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameQCannonPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameQCannonPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameQCannonPawn.CollisionCylinder"
    Components(1)="Default__AliceGameQCannonPawn.Arrow"
    Components(2)="Default__AliceGameQCannonPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameQCannonPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameQCannonPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameQCannonPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameQCannonPawn.CollisionCylinder"
}
