class AliceGameDollMakerHandGirl extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;
var() export editinline ClothComponent WireComponent;
var() name wireBone;

simulated event PreBeginPlay()
{
    PreBeginPlay();
    Mesh.AttachComponent(WireComponent, wireBone);
}

defaultproperties
{
    WireComponent="Default__AliceGameDollMakerHandGirl.Wire"
    wireBone="Bip01-Head"
    LightEnvironment="Default__AliceGameDollMakerHandGirl.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDollMakerHandGirl.PawnKynapseHandle"
    Mesh="Default__AliceGameDollMakerHandGirl.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDollMakerHandGirl.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDollMakerHandGirl.FaceAudioComponent"
    Components(0)="Default__AliceGameDollMakerHandGirl.CollisionCylinder"
    Components(1)="Default__AliceGameDollMakerHandGirl.Arrow"
    Components(2)="Default__AliceGameDollMakerHandGirl.FaceAudioComponent"
    Components(3)="Default__AliceGameDollMakerHandGirl.MyLightEnvironment"
    Components(4)="Default__AliceGameDollMakerHandGirl.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDollMakerHandGirl.PawnKynapseHandle"
    Components(6)="Default__AliceGameDollMakerHandGirl.Wire"
    CollisionComponent="Default__AliceGameDollMakerHandGirl.CollisionCylinder"
}
