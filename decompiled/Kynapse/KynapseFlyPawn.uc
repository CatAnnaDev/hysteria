class KynapseFlyPawn extends KynapsePawn
    notplaceable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    KynapseHandle="Default__KynapseFlyPawn.PawnKynapseHandle"
    LightEnvironment="Default__KynapseFlyPawn.MyLightEnvironment"
    bCanFly=True
    Mesh="Default__KynapseFlyPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__KynapseFlyPawn.CollisionCylinder"
    Components(0)="Default__KynapseFlyPawn.CollisionCylinder"
    Components(1)="Default__KynapseFlyPawn.Arrow"
    Components(2)="Default__KynapseFlyPawn.MyLightEnvironment"
    Components(3)="Default__KynapseFlyPawn.DemoPawnSkeletalMeshComponent"
    Components(4)="Default__KynapseFlyPawn.PawnKynapseHandle"
    CollisionComponent="Default__KynapseFlyPawn.CollisionCylinder"
}
