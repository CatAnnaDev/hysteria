class AliceGameDollMakerBossPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var(AISphinxAnimIndex) int NockdownIndex;
var() export editinline array<ClothComponent> WireComponents;
var() array<name> wireBones;

simulated event PreBeginPlay()
{
    PreBeginPlay();
    Mesh.AttachComponent(WireComponents[0], wireBones[0]);
    Mesh.AttachComponent(WireComponents[1], wireBones[1]);
}

defaultproperties
{
    WireComponents(0)="Default__AliceGameDollMakerBossPawn.Wire0"
    WireComponents(1)="Default__AliceGameDollMakerBossPawn.Wire1"
    wireBones(0)="Bip01-L-Clavicle"
    wireBones(1)="Bip01-R-Clavicle"
    MagicAcheivmentIdentify=7
    LightEnvironment="Default__AliceGameDollMakerBossPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDollMakerBossPawn.PawnKynapseHandle"
    Mesh="Default__AliceGameDollMakerBossPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDollMakerBossPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDollMakerBossPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDollMakerBossPawn.CollisionCylinder"
    Components(1)="Default__AliceGameDollMakerBossPawn.Arrow"
    Components(2)="Default__AliceGameDollMakerBossPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDollMakerBossPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDollMakerBossPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDollMakerBossPawn.PawnKynapseHandle"
    Components(6)="Default__AliceGameDollMakerBossPawn.Wire0"
    Components(7)="Default__AliceGameDollMakerBossPawn.Wire1"
    CollisionComponent="Default__AliceGameDollMakerBossPawn.CollisionCylinder"
}
