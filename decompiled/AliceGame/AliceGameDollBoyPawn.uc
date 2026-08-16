class AliceGameDollBoyPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameDollBoyPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDollBoyPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDollBoyPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDollBoyPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDollBoyPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDollBoyPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDollBoyPawn.Arrow"
    Components(2)="Default__AliceGameDollBoyPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDollBoyPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDollBoyPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDollBoyPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDollBoyPawn.CollisionCylinder"
}
