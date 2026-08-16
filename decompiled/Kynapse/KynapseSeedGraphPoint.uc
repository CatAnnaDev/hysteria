class KynapseSeedGraphPoint extends Actor
    native
    placeable
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object);

var() KynapseTag DataTag;

defaultproperties
{
    Components(0)="Default__KynapseSeedGraphPoint.Sprite"
    Components(1)="Default__KynapseSeedGraphPoint.CollisionCylinder"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__KynapseSeedGraphPoint.CollisionCylinder"
}
