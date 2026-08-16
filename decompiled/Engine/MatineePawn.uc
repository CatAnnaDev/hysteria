class MatineePawn extends Pawn
    native
    placeable
    config(Game)
    hidecategories(Navigation);

var() editoronly SkeletalMesh PreviewMesh;

defaultproperties
{
    Mesh="Default__MatineePawn.PawnMesh"
    CylinderComponent="Default__MatineePawn.CollisionCylinder"
    Components(0)="Default__MatineePawn.Sprite"
    Components(1)="Default__MatineePawn.CollisionCylinder"
    Components(2)="Default__MatineePawn.Arrow"
    Components(3)="Default__MatineePawn.PawnMesh"
    Physics="PHYS_Falling"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__MatineePawn.CollisionCylinder"
}
