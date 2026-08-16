class AliceGameExecutionerPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameExecutionerPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameExecutionerPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameExecutionerPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameExecutionerPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameExecutionerPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameExecutionerPawn.CollisionCylinder"
    Components(1)="Default__AliceGameExecutionerPawn.Arrow"
    Components(2)="Default__AliceGameExecutionerPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameExecutionerPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameExecutionerPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameExecutionerPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameExecutionerPawn.CollisionCylinder"
}
