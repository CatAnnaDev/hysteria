class AliceGameDollGirlPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    MagicAcheivmentIdentify=9
    LightEnvironment="Default__AliceGameDollGirlPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDollGirlPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDollGirlPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDollGirlPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDollGirlPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDollGirlPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDollGirlPawn.Arrow"
    Components(2)="Default__AliceGameDollGirlPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDollGirlPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDollGirlPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDollGirlPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDollGirlPawn.CollisionCylinder"
}
