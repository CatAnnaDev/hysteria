class AliceGameCannonCrabPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameCannonCrabPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameCannonCrabPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameCannonCrabPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameCannonCrabPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameCannonCrabPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameCannonCrabPawn.CollisionCylinder"
    Components(1)="Default__AliceGameCannonCrabPawn.Arrow"
    Components(2)="Default__AliceGameCannonCrabPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameCannonCrabPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameCannonCrabPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameCannonCrabPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameCannonCrabPawn.CollisionCylinder"
}
