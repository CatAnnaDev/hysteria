class AliceGameDollMakerHandBoy extends AliceGameKynapseWalkingPawn
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
    WireComponent="Default__AliceGameDollMakerHandBoy.Wire"
    wireBone="Bip01-Head"
    LightEnvironment="Default__AliceGameDollMakerHandBoy.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDollMakerHandBoy.PawnKynapseHandle"
    Mesh="Default__AliceGameDollMakerHandBoy.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDollMakerHandBoy.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDollMakerHandBoy.FaceAudioComponent"
    Components(0)="Default__AliceGameDollMakerHandBoy.CollisionCylinder"
    Components(1)="Default__AliceGameDollMakerHandBoy.Arrow"
    Components(2)="Default__AliceGameDollMakerHandBoy.FaceAudioComponent"
    Components(3)="Default__AliceGameDollMakerHandBoy.MyLightEnvironment"
    Components(4)="Default__AliceGameDollMakerHandBoy.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDollMakerHandBoy.PawnKynapseHandle"
    Components(6)="Default__AliceGameDollMakerHandBoy.Wire"
    CollisionComponent="Default__AliceGameDollMakerHandBoy.CollisionCylinder"
}
