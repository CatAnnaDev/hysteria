class AliceGameCommonNPCPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    LightEnvironment="Default__AliceGameCommonNPCPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameCommonNPCPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameCommonNPCPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameCommonNPCPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameCommonNPCPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameCommonNPCPawn.CollisionCylinder"
    Components(1)="Default__AliceGameCommonNPCPawn.Arrow"
    Components(2)="Default__AliceGameCommonNPCPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameCommonNPCPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameCommonNPCPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameCommonNPCPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameCommonNPCPawn.CollisionCylinder"
}
