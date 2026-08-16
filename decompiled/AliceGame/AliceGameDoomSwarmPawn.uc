class AliceGameDoomSwarmPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=1
    LightEnvironment="Default__AliceGameDoomSwarmPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDoomSwarmPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDoomSwarmPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDoomSwarmPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDoomSwarmPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDoomSwarmPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDoomSwarmPawn.Arrow"
    Components(2)="Default__AliceGameDoomSwarmPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDoomSwarmPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDoomSwarmPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDoomSwarmPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDoomSwarmPawn.CollisionCylinder"
}
