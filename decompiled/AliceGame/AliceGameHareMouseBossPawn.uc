class AliceGameHareMouseBossPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;

defaultproperties
{
    LightEnvironment="Default__AliceGameHareMouseBossPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameHareMouseBossPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameHareMouseBossPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameHareMouseBossPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameHareMouseBossPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameHareMouseBossPawn.CollisionCylinder"
    Components(1)="Default__AliceGameHareMouseBossPawn.Arrow"
    Components(2)="Default__AliceGameHareMouseBossPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameHareMouseBossPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameHareMouseBossPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameHareMouseBossPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameHareMouseBossPawn.CollisionCylinder"
}
